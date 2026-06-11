-- ============================================================================
-- 0009: AI Configuration, AI Chat, System Settings, Feature Flags, Licensing
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ai_config (tenant_id null = global default managed by SuperAdmin)
-- ----------------------------------------------------------------------------
create table public.ai_config (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  provider text not null default 'openai',
  model text not null default 'gpt-4o-mini',
  system_prompt text not null default 'You are the CyberCultX AI security assistant. Answer concisely and accurately about cybersecurity awareness, phishing, and the user''s own risk profile.',
  system_prompt_ar text,
  temperature numeric(3,2) not null default 0.4,
  enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (tenant_id)
);

create trigger set_updated_at before update on public.ai_config
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- ai_chat_messages
-- ----------------------------------------------------------------------------
create table public.ai_chat_messages (
  id bigint generated always as identity primary key,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  role public.chat_role not null,
  content text not null,
  created_at timestamptz not null default now()
);

create index ai_chat_messages_profile_idx on public.ai_chat_messages(profile_id, created_at);

-- ----------------------------------------------------------------------------
-- system_settings (tenant_id null = global)
-- ----------------------------------------------------------------------------
create table public.system_settings (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  key text not null,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  unique (tenant_id, key)
);

create trigger set_updated_at before update on public.system_settings
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- feature_flags (tenant_id null = global)
-- ----------------------------------------------------------------------------
create table public.feature_flags (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid references public.tenants(id) on delete cascade,
  key text not null,
  enabled boolean not null default true,
  description text,
  unique (tenant_id, key)
);

-- ----------------------------------------------------------------------------
-- licenses
-- ----------------------------------------------------------------------------
create table public.licenses (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants(id) on delete cascade,
  plan text not null default 'standard',
  seats integer not null default 50,
  starts_at date not null default current_date,
  expires_at date,
  status text not null default 'active' check (status in ('active','expired','cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index licenses_tenant_idx on public.licenses(tenant_id);

create trigger set_updated_at before update on public.licenses
  for each row execute function public.set_updated_at();
