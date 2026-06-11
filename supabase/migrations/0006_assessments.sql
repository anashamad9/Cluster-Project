-- ============================================================================
-- 0006: Assessments — psychometric & security knowledge quizzes
-- ============================================================================

create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  title text not null,
  title_ar text,
  description text,
  description_ar text,
  type public.assessment_type not null default 'security_knowledge',
  passing_score integer not null default 70,
  department_id uuid references public.departments(id) on delete set null,
  duration_minutes integer not null default 15,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index assessments_tenant_idx on public.assessments(tenant_id);

create trigger set_updated_at before update on public.assessments
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- assessment_questions
-- options: jsonb array of { "key": "a", "text": "...", "text_ar": "..." }
-- dimension: for psychometric questions, which behavioral_dimensions column
--            this question contributes to (compliance, curiosity,
--            stress_tolerance, social_engineering_susceptibility), else null
-- ----------------------------------------------------------------------------
create table public.assessment_questions (
  id uuid primary key default gen_random_uuid(),
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  question text not null,
  question_ar text,
  options jsonb not null default '[]'::jsonb,
  correct_answer text,
  dimension text,
  order_index integer not null default 0,
  points integer not null default 1
);

create index assessment_questions_assessment_idx on public.assessment_questions(assessment_id, order_index);

-- ----------------------------------------------------------------------------
-- assessment_attempts
-- ----------------------------------------------------------------------------
create table public.assessment_attempts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  score integer not null default 0,
  passed boolean not null default false,
  answers jsonb not null default '{}'::jsonb,
  started_at timestamptz not null default now(),
  completed_at timestamptz
);

create index assessment_attempts_profile_idx on public.assessment_attempts(profile_id);
create index assessment_attempts_assessment_idx on public.assessment_attempts(assessment_id);
