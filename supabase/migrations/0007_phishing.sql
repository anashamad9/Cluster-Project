-- ============================================================================
-- 0007: Phishing Simulation Engine — templates, campaigns, results
-- ============================================================================

-- ----------------------------------------------------------------------------
-- phishing_templates (tenant_id null = global library, 50+ seeded templates)
-- ----------------------------------------------------------------------------
create table public.phishing_templates (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  name text not null,
  name_ar text,
  category public.phishing_category not null,
  language public.phishing_language not null default 'en',
  difficulty public.phishing_difficulty not null default 'medium',
  subject text not null,
  subject_ar text,
  sender_name text not null,
  sender_name_ar text,
  sender_email text not null,
  body_html text not null,
  body_html_ar text,
  landing_page_url text,
  created_at timestamptz not null default now()
);

create index phishing_templates_category_idx on public.phishing_templates(category);
create index phishing_templates_language_idx on public.phishing_templates(language);
create index phishing_templates_tenant_idx on public.phishing_templates(tenant_id);

-- ----------------------------------------------------------------------------
-- phishing_campaigns
-- ----------------------------------------------------------------------------
create table public.phishing_campaigns (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  name text not null,
  template_id uuid not null references public.phishing_templates(id),
  target_type text not null default 'all' check (target_type in ('all','department','group')),
  target_department_ids uuid[] not null default '{}',
  target_profile_ids uuid[] not null default '{}',
  status public.campaign_status not null default 'draft',
  scheduled_at timestamptz,
  started_at timestamptz,
  ended_at timestamptz,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index phishing_campaigns_tenant_idx on public.phishing_campaigns(tenant_id);
create index phishing_campaigns_status_idx on public.phishing_campaigns(status);

create trigger set_updated_at before update on public.phishing_campaigns
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- phishing_campaign_targets — one row per recipient, tracks the funnel
-- ----------------------------------------------------------------------------
create table public.phishing_campaign_targets (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.phishing_campaigns(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  status public.campaign_target_status not null default 'pending',
  sent_at timestamptz,
  opened_at timestamptz,
  clicked_at timestamptz,
  reported_at timestamptz,
  unique (campaign_id, profile_id)
);

create index phishing_targets_campaign_idx on public.phishing_campaign_targets(campaign_id);
create index phishing_targets_profile_idx on public.phishing_campaign_targets(profile_id);
