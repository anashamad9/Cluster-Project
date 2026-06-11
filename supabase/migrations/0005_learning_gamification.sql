-- ============================================================================
-- 0005: Learning & Gamification — courses, lessons, enrollments,
-- achievements, XP transactions
-- ============================================================================

-- ----------------------------------------------------------------------------
-- course_categories
-- ----------------------------------------------------------------------------
create table public.course_categories (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  name text not null,
  name_ar text,
  icon text,
  created_at timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- courses (tenant_id null = global library available to all tenants)
-- ----------------------------------------------------------------------------
create table public.courses (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  category_id uuid references public.course_categories(id) on delete set null,
  title text not null,
  title_ar text,
  description text,
  description_ar text,
  difficulty public.course_difficulty not null default 'beginner',
  language public.course_language not null default 'both',
  duration_minutes integer not null default 30,
  xp_reward integer not null default 50,
  cover_image_url text,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index courses_tenant_idx on public.courses(tenant_id);
create index courses_category_idx on public.courses(category_id);

-- ----------------------------------------------------------------------------
-- course_lessons
-- ----------------------------------------------------------------------------
create table public.course_lessons (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  title text not null,
  title_ar text,
  content text,
  content_ar text,
  video_url text,
  order_index integer not null default 0,
  duration_minutes integer not null default 5
);

create index course_lessons_course_idx on public.course_lessons(course_id, order_index);

-- ----------------------------------------------------------------------------
-- course_enrollments
-- ----------------------------------------------------------------------------
create table public.course_enrollments (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade,
  status public.enrollment_status not null default 'not_started',
  progress_pct integer not null default 0 check (progress_pct between 0 and 100),
  started_at timestamptz,
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (profile_id, course_id)
);

create index course_enrollments_profile_idx on public.course_enrollments(profile_id);
create index course_enrollments_course_idx on public.course_enrollments(course_id);

create trigger set_updated_at before update on public.course_enrollments
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- achievements (tenant_id null = global catalog)
-- ----------------------------------------------------------------------------
create table public.achievements (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  code text not null unique,
  name text not null,
  name_ar text,
  description text,
  description_ar text,
  icon text not null default 'award',
  xp_reward integer not null default 0,
  criteria jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- ----------------------------------------------------------------------------
-- user_achievements
-- ----------------------------------------------------------------------------
create table public.user_achievements (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  achievement_id uuid not null references public.achievements(id) on delete cascade,
  earned_at timestamptz not null default now(),
  unique (profile_id, achievement_id)
);

create index user_achievements_profile_idx on public.user_achievements(profile_id);

-- ----------------------------------------------------------------------------
-- xp_transactions
-- ----------------------------------------------------------------------------
create table public.xp_transactions (
  id bigint generated always as identity primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  amount integer not null,
  reason text not null,
  reference_type text,
  reference_id text,
  created_at timestamptz not null default now()
);

create index xp_transactions_profile_idx on public.xp_transactions(profile_id, created_at desc);

-- ----------------------------------------------------------------------------
-- award_xp: inserts an xp_transaction, bumps profiles.xp/level/streak,
-- and auto-grants any achievements whose criteria are now met.
-- Level formula: level = floor(xp / 500) + 1
-- ----------------------------------------------------------------------------
create or replace function public.award_xp(
  p_profile_id uuid,
  p_amount integer,
  p_reason text,
  p_reference_type text default null,
  p_reference_id text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_new_xp integer;
  v_new_level integer;
begin
  insert into public.xp_transactions (profile_id, amount, reason, reference_type, reference_id)
  values (p_profile_id, p_amount, p_reason, p_reference_type, p_reference_id);

  update public.profiles
  set xp = xp + p_amount,
      last_activity_at = now()
  where id = p_profile_id
  returning xp into v_new_xp;

  v_new_level := floor(v_new_xp / 500.0) + 1;

  update public.profiles
  set level = v_new_level
  where id = p_profile_id and level <> v_new_level;
end;
$$;
