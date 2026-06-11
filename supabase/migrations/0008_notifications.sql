-- ============================================================================
-- 0008: Notifications & Announcements
-- ============================================================================

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  title text not null,
  title_ar text,
  body text not null,
  body_ar text,
  sender_id uuid references public.profiles(id) on delete set null,
  target_type public.notification_target not null default 'all',
  target_role public.user_role,
  target_department_id uuid references public.departments(id) on delete set null,
  target_profile_ids uuid[] not null default '{}',
  created_at timestamptz not null default now()
);

create index notifications_tenant_idx on public.notifications(tenant_id, created_at desc);

-- ----------------------------------------------------------------------------
-- notification_recipients: fan-out table, one row per recipient per
-- notification, used to track read state.
-- ----------------------------------------------------------------------------
create table public.notification_recipients (
  id bigint generated always as identity primary key,
  notification_id uuid not null references public.notifications(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  read_at timestamptz,
  unique (notification_id, profile_id)
);

create index notification_recipients_profile_idx on public.notification_recipients(profile_id, read_at);

-- ----------------------------------------------------------------------------
-- fan_out_notification: populates notification_recipients based on the
-- notification's target_type/target_role/target_department_id/target_profile_ids
-- ----------------------------------------------------------------------------
create or replace function public.fan_out_notification(p_notification_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  n public.notifications;
begin
  select * into n from public.notifications where id = p_notification_id;

  if n.target_type = 'all' then
    insert into public.notification_recipients (notification_id, profile_id)
    select p_notification_id, p.id
    from public.profiles p
    where p.tenant_id = n.tenant_id
    on conflict do nothing;
  elsif n.target_type = 'role' then
    insert into public.notification_recipients (notification_id, profile_id)
    select p_notification_id, p.id
    from public.profiles p
    where p.tenant_id = n.tenant_id and p.role = n.target_role
    on conflict do nothing;
  elsif n.target_type = 'department' then
    insert into public.notification_recipients (notification_id, profile_id)
    select p_notification_id, p.id
    from public.profiles p
    where p.tenant_id = n.tenant_id and p.department_id = n.target_department_id
    on conflict do nothing;
  elsif n.target_type = 'user' then
    insert into public.notification_recipients (notification_id, profile_id)
    select p_notification_id, unnest(n.target_profile_ids)
    on conflict do nothing;
  end if;
end;
$$;

create or replace function public.trigger_fan_out_notification()
returns trigger
language plpgsql
as $$
begin
  perform public.fan_out_notification(new.id);
  return new;
end;
$$;

create trigger fan_out_after_insert
  after insert on public.notifications
  for each row execute function public.trigger_fan_out_notification();
