-- ============================================================================
-- 0001: Extensions & Enums
-- CyberCultX — Human Risk Intelligence Platform
-- ============================================================================

create extension if not exists "pgcrypto";

-- ----------------------------------------------------------------------------
-- Enums
-- ----------------------------------------------------------------------------

create type public.user_role as enum (
  'employee',
  'executive',
  'hr',
  'admin',
  'superadmin'
);

create type public.user_status as enum (
  'active',
  'invited',
  'suspended'
);

create type public.tenant_status as enum (
  'trial',
  'active',
  'suspended',
  'cancelled'
);

create type public.course_difficulty as enum (
  'beginner',
  'intermediate',
  'advanced'
);

create type public.course_language as enum (
  'en',
  'ar',
  'both'
);

create type public.enrollment_status as enum (
  'not_started',
  'in_progress',
  'completed'
);

create type public.assessment_type as enum (
  'psychometric',
  'security_knowledge'
);

create type public.phishing_category as enum (
  'banking',
  'government',
  'hr_payroll',
  'invoice_fraud',
  'delivery',
  'whatsapp',
  'qr_code'
);

create type public.phishing_language as enum (
  'en',
  'ar'
);

create type public.phishing_difficulty as enum (
  'easy',
  'medium',
  'hard'
);

create type public.campaign_status as enum (
  'draft',
  'scheduled',
  'running',
  'completed'
);

create type public.campaign_target_status as enum (
  'pending',
  'sent',
  'opened',
  'clicked',
  'reported',
  'ignored'
);

create type public.notification_target as enum (
  'all',
  'role',
  'department',
  'user'
);

create type public.chat_role as enum (
  'user',
  'assistant'
);
