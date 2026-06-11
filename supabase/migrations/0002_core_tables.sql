-- ============================================================================
-- 0002: Core tables — tenants, departments, profiles
-- ============================================================================

-- ----------------------------------------------------------------------------
-- tenants
-- ----------------------------------------------------------------------------
create table public.tenants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  name_ar text,
  slug text not null unique,
  status public.tenant_status not null default 'trial',
  plan text not null default 'standard',
  logo_url text,
  primary_color text default '#DC2626',
  industry text,
  country text default 'AE',
  employee_count integer,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.tenants is 'Organizations (multi-tenant) using the platform.';

-- ----------------------------------------------------------------------------
-- departments
-- ----------------------------------------------------------------------------
create table public.departments (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  name text not null,
  name_ar text,
  parent_id uuid references public.departments(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index departments_tenant_id_idx on public.departments(tenant_id);

-- ----------------------------------------------------------------------------
-- profiles (extends auth.users)
-- ----------------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  tenant_id uuid references public.tenants(id) on delete cascade,
  email text not null,
  full_name text not null,
  full_name_ar text,
  role public.user_role not null default 'employee',
  department_id uuid references public.departments(id) on delete set null,
  job_title text,
  job_title_ar text,
  status public.user_status not null default 'active',
  avatar_url text,
  xp integer not null default 0,
  level integer not null default 1,
  streak_days integer not null default 0,
  last_activity_at timestamptz,
  locale_pref text not null default 'en',
  mfa_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index profiles_tenant_id_idx on public.profiles(tenant_id);
create index profiles_department_id_idx on public.profiles(department_id);
create index profiles_role_idx on public.profiles(role);

comment on table public.profiles is 'Application user profile, 1:1 with auth.users.';

-- ----------------------------------------------------------------------------
-- handle_new_user: creates a profile row whenever a new auth user signs up.
-- Tenant/role/department/job-title are sourced from raw_user_meta_data, set
-- by the inviting Admin/SuperAdmin (or defaulted for self-serve signups).
-- ----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id, tenant_id, email, full_name, full_name_ar, role,
    department_id, job_title, job_title_ar, locale_pref
  )
  values (
    new.id,
    nullif(new.raw_user_meta_data->>'tenant_id', '')::uuid,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    new.raw_user_meta_data->>'full_name_ar',
    coalesce((new.raw_user_meta_data->>'role')::public.user_role, 'employee'),
    nullif(new.raw_user_meta_data->>'department_id', '')::uuid,
    new.raw_user_meta_data->>'job_title',
    new.raw_user_meta_data->>'job_title_ar',
    coalesce(new.raw_user_meta_data->>'locale_pref', 'en')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ----------------------------------------------------------------------------
-- updated_at trigger helper, reused across many tables
-- ----------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger set_updated_at before update on public.tenants
  for each row execute function public.set_updated_at();
create trigger set_updated_at before update on public.departments
  for each row execute function public.set_updated_at();
create trigger set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();
