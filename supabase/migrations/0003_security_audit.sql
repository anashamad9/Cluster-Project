-- ============================================================================
-- 0003: Security & Audit — login attempts/lockout, audit log, rate limiting
-- ============================================================================

-- ----------------------------------------------------------------------------
-- login_attempts: every login attempt, used for the 5-fail / 15-min lockout
-- ----------------------------------------------------------------------------
create table public.login_attempts (
  id bigint generated always as identity primary key,
  email text not null,
  tenant_id uuid references public.tenants(id) on delete set null,
  success boolean not null,
  ip_address text,
  user_agent text,
  created_at timestamptz not null default now()
);

create index login_attempts_email_created_idx on public.login_attempts(email, created_at desc);

-- ----------------------------------------------------------------------------
-- is_account_locked: true if 5+ failed attempts in the last 15 minutes
-- with no successful login since the most recent failure streak began.
-- ----------------------------------------------------------------------------
create or replace function public.is_account_locked(p_email text)
returns table(locked boolean, locked_until timestamptz, failed_count integer)
language sql
stable
security definer
set search_path = public
as $$
  with recent as (
    select success, created_at
    from public.login_attempts
    where email = p_email
      and created_at > now() - interval '15 minutes'
    order by created_at desc
  ),
  consecutive_fails as (
    select count(*) as cnt, min(created_at) as first_fail, max(created_at) as last_fail
    from (
      select success, created_at,
             sum(case when success then 1 else 0 end)
               over (order by created_at desc rows unbounded preceding) as success_marker
      from recent
    ) ranked
    where success_marker = 0 and success = false
  )
  select
    coalesce(cnt, 0) >= 5 as locked,
    case when coalesce(cnt, 0) >= 5 then last_fail + interval '15 minutes' else null end as locked_until,
    coalesce(cnt, 0)::integer as failed_count
  from consecutive_fails;
$$;

-- ----------------------------------------------------------------------------
-- record_login_attempt: insert an attempt row (called from server actions)
-- ----------------------------------------------------------------------------
create or replace function public.record_login_attempt(
  p_email text,
  p_success boolean,
  p_tenant_id uuid default null,
  p_ip_address text default null,
  p_user_agent text default null
)
returns void
language sql
security definer
set search_path = public
as $$
  insert into public.login_attempts (email, tenant_id, success, ip_address, user_agent)
  values (p_email, p_tenant_id, p_success, p_ip_address, p_user_agent);
$$;

-- ----------------------------------------------------------------------------
-- audit_logs: tamper-evident-ish audit trail of every notable action
-- ----------------------------------------------------------------------------
create table public.audit_logs (
  id bigint generated always as identity primary key,
  tenant_id uuid references public.tenants(id) on delete set null,
  actor_id uuid references public.profiles(id) on delete set null,
  actor_email text,
  action text not null,
  target_type text,
  target_id text,
  metadata jsonb not null default '{}'::jsonb,
  ip_address text,
  user_agent text,
  created_at timestamptz not null default now()
);

create index audit_logs_tenant_created_idx on public.audit_logs(tenant_id, created_at desc);
create index audit_logs_actor_idx on public.audit_logs(actor_id);
create index audit_logs_action_idx on public.audit_logs(action);

comment on table public.audit_logs is 'Append-only audit trail of authentication and platform actions.';

-- ----------------------------------------------------------------------------
-- api_rate_limits: simple fixed-window counter, no external Redis required
-- ----------------------------------------------------------------------------
create table public.api_rate_limits (
  key text primary key,
  window_start timestamptz not null default now(),
  request_count integer not null default 0
);

-- ----------------------------------------------------------------------------
-- check_rate_limit: returns true if the request is allowed, false if the
-- caller has exceeded p_max_requests within p_window_seconds.
-- ----------------------------------------------------------------------------
create or replace function public.check_rate_limit(
  p_key text,
  p_max_requests integer,
  p_window_seconds integer
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_window_start timestamptz;
  v_count integer;
begin
  select window_start, request_count into v_window_start, v_count
  from public.api_rate_limits
  where key = p_key
  for update;

  if not found then
    insert into public.api_rate_limits (key, window_start, request_count)
    values (p_key, now(), 1);
    return true;
  end if;

  if now() - v_window_start > make_interval(secs => p_window_seconds) then
    update public.api_rate_limits
    set window_start = now(), request_count = 1
    where key = p_key;
    return true;
  end if;

  if v_count >= p_max_requests then
    return false;
  end if;

  update public.api_rate_limits
  set request_count = request_count + 1
  where key = p_key;
  return true;
end;
$$;
