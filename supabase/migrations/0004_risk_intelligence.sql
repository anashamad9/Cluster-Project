-- ============================================================================
-- 0004: Risk Intelligence — CCI/HRS history, behavioral dimensions,
-- predictive risk indicators, financial risk exposure
-- ============================================================================

-- ----------------------------------------------------------------------------
-- risk_scores: weekly HRS/CCI snapshot per employee
-- ----------------------------------------------------------------------------
create table public.risk_scores (
  id bigint generated always as identity primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  hrs numeric(5,2) not null check (hrs between 0 and 100),
  cci numeric(5,2) not null check (cci between 0 and 100),
  recorded_at date not null default current_date,
  created_at timestamptz not null default now(),
  unique (profile_id, recorded_at)
);

create index risk_scores_profile_idx on public.risk_scores(profile_id, recorded_at desc);
create index risk_scores_tenant_idx on public.risk_scores(tenant_id, recorded_at desc);

-- ----------------------------------------------------------------------------
-- behavioral_dimensions: psychometric profile per employee
-- ----------------------------------------------------------------------------
create table public.behavioral_dimensions (
  id bigint generated always as identity primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  compliance numeric(5,2) not null check (compliance between 0 and 100),
  curiosity numeric(5,2) not null check (curiosity between 0 and 100),
  stress_tolerance numeric(5,2) not null check (stress_tolerance between 0 and 100),
  social_engineering_susceptibility numeric(5,2) not null check (social_engineering_susceptibility between 0 and 100),
  recorded_at date not null default current_date,
  created_at timestamptz not null default now(),
  unique (profile_id, recorded_at)
);

create index behavioral_dimensions_profile_idx on public.behavioral_dimensions(profile_id, recorded_at desc);

-- ----------------------------------------------------------------------------
-- predictive_risk_indicators: AI-generated forward-looking indicators.
-- profile_id null => organization-wide (executive) forecast.
-- ----------------------------------------------------------------------------
create table public.predictive_risk_indicators (
  id bigint generated always as identity primary key,
  profile_id uuid references public.profiles(id) on delete cascade,
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  phishing_susceptibility numeric(5,2) not null check (phishing_susceptibility between 0 and 100),
  human_error_probability numeric(5,2) not null check (human_error_probability between 0 and 100),
  insider_threat_likelihood numeric(5,2) not null check (insider_threat_likelihood between 0 and 100),
  security_fatigue numeric(5,2) not null check (security_fatigue between 0 and 100),
  reporting_likelihood numeric(5,2) not null check (reporting_likelihood between 0 and 100),
  ai_summary text,
  ai_summary_ar text,
  recorded_at date not null default current_date,
  created_at timestamptz not null default now()
);

create index predictive_risk_tenant_idx on public.predictive_risk_indicators(tenant_id, recorded_at desc);
create index predictive_risk_profile_idx on public.predictive_risk_indicators(profile_id, recorded_at desc);

-- ----------------------------------------------------------------------------
-- financial_risk_exposure: estimated $ value at risk from human factors
-- ----------------------------------------------------------------------------
create table public.financial_risk_exposure (
  id bigint generated always as identity primary key,
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  estimated_value numeric(14,2) not null,
  currency text not null default 'USD',
  breakdown jsonb not null default '{}'::jsonb,
  recorded_at date not null default current_date,
  created_at timestamptz not null default now(),
  unique (tenant_id, recorded_at)
);

create index financial_risk_tenant_idx on public.financial_risk_exposure(tenant_id, recorded_at desc);

-- ----------------------------------------------------------------------------
-- risk_band: maps an HRS (or generic 0-100 risk score) to a band
-- ----------------------------------------------------------------------------
create or replace function public.risk_band(p_score numeric)
returns text
language sql
immutable
as $$
  select case
    when p_score >= 75 then 'critical'
    when p_score >= 50 then 'high'
    when p_score >= 25 then 'medium'
    else 'low'
  end;
$$;
