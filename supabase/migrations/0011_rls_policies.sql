-- ============================================================================
-- 0011: Row Level Security policies
--
-- Conventions:
--  - Every tenant-scoped table is isolated by tenant_id = current_tenant_id()
--    unless the caller is_superadmin().
--  - "Management" roles = hr, executive, admin, superadmin.
--  - Tables with no policies below still have RLS enabled, which means they
--    are only reachable via SECURITY DEFINER functions or the service role
--    (login_attempts, api_rate_limits).
-- ============================================================================

-- ----------------------------------------------------------------------------
-- tenants
-- ----------------------------------------------------------------------------
alter table public.tenants enable row level security;

create policy "tenants_select" on public.tenants for select
  using (public.is_superadmin() or id = public.current_tenant_id());

create policy "tenants_modify" on public.tenants for all
  using (public.is_superadmin())
  with check (public.is_superadmin());

-- ----------------------------------------------------------------------------
-- departments
-- ----------------------------------------------------------------------------
alter table public.departments enable row level security;

create policy "departments_select" on public.departments for select
  using (public.is_superadmin() or tenant_id = public.current_tenant_id());

create policy "departments_modify" on public.departments for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- ----------------------------------------------------------------------------
-- profiles
-- ----------------------------------------------------------------------------
alter table public.profiles enable row level security;

create policy "profiles_select" on public.profiles for select
  using (
    public.is_superadmin()
    or id = auth.uid()
    or tenant_id = public.current_tenant_id()
  );

-- Self-service update (column grants below restrict which columns)
create policy "profiles_update_self" on public.profiles for update
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "profiles_update_admin" on public.profiles for update
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "profiles_delete_admin" on public.profiles for delete
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- Restrict which columns a user can change on their own profile row.
revoke update on public.profiles from authenticated;
grant update (full_name, full_name_ar, avatar_url, locale_pref, mfa_enabled, last_activity_at)
  on public.profiles to authenticated;

-- ----------------------------------------------------------------------------
-- login_attempts / api_rate_limits — locked down, only via SECURITY DEFINER fns
-- ----------------------------------------------------------------------------
alter table public.login_attempts enable row level security;
alter table public.api_rate_limits enable row level security;

-- ----------------------------------------------------------------------------
-- audit_logs
-- ----------------------------------------------------------------------------
alter table public.audit_logs enable row level security;

create policy "audit_logs_select" on public.audit_logs for select
  using (
    public.is_superadmin()
    or (public.is_management() and tenant_id = public.current_tenant_id())
  );

create policy "audit_logs_insert" on public.audit_logs for insert
  with check (actor_id = auth.uid() or auth.uid() is null);

-- ----------------------------------------------------------------------------
-- risk_scores
-- ----------------------------------------------------------------------------
alter table public.risk_scores enable row level security;

create policy "risk_scores_select" on public.risk_scores for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and tenant_id = public.current_tenant_id())
  );

create policy "risk_scores_modify" on public.risk_scores for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- ----------------------------------------------------------------------------
-- behavioral_dimensions
-- ----------------------------------------------------------------------------
alter table public.behavioral_dimensions enable row level security;

create policy "behavioral_dimensions_select" on public.behavioral_dimensions for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and tenant_id = public.current_tenant_id())
  );

create policy "behavioral_dimensions_modify" on public.behavioral_dimensions for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- ----------------------------------------------------------------------------
-- predictive_risk_indicators
-- ----------------------------------------------------------------------------
alter table public.predictive_risk_indicators enable row level security;

create policy "predictive_risk_select" on public.predictive_risk_indicators for select
  using (
    public.is_superadmin()
    or (profile_id = auth.uid())
    or (public.is_management() and tenant_id = public.current_tenant_id())
  );

create policy "predictive_risk_modify" on public.predictive_risk_indicators for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- ----------------------------------------------------------------------------
-- financial_risk_exposure
-- ----------------------------------------------------------------------------
alter table public.financial_risk_exposure enable row level security;

create policy "financial_risk_select" on public.financial_risk_exposure for select
  using (
    public.is_superadmin()
    or (public.is_management() and tenant_id = public.current_tenant_id())
  );

create policy "financial_risk_modify" on public.financial_risk_exposure for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

-- ----------------------------------------------------------------------------
-- course_categories / courses / course_lessons
-- ----------------------------------------------------------------------------
alter table public.course_categories enable row level security;
alter table public.courses enable row level security;
alter table public.course_lessons enable row level security;

create policy "course_categories_select" on public.course_categories for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "course_categories_modify" on public.course_categories for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id() or (tenant_id is null and public.is_superadmin())))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "courses_select" on public.courses for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "courses_modify" on public.courses for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "course_lessons_select" on public.course_lessons for select
  using (
    public.is_superadmin()
    or exists (
      select 1 from public.courses c
      where c.id = course_lessons.course_id
        and (c.tenant_id is null or c.tenant_id = public.current_tenant_id())
    )
  );

create policy "course_lessons_modify" on public.course_lessons for all
  using (
    public.is_admin() and exists (
      select 1 from public.courses c
      where c.id = course_lessons.course_id
        and (c.tenant_id = public.current_tenant_id() or public.is_superadmin())
    )
  )
  with check (
    public.is_admin() and exists (
      select 1 from public.courses c
      where c.id = course_lessons.course_id
        and (c.tenant_id = public.current_tenant_id() or public.is_superadmin())
    )
  );

-- ----------------------------------------------------------------------------
-- course_enrollments
-- ----------------------------------------------------------------------------
alter table public.course_enrollments enable row level security;

create policy "course_enrollments_select" on public.course_enrollments for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.profiles p
      where p.id = course_enrollments.profile_id and p.tenant_id = public.current_tenant_id()
    ))
  );

create policy "course_enrollments_modify_self" on public.course_enrollments for all
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

create policy "course_enrollments_modify_admin" on public.course_enrollments for all
  using (public.is_admin() and exists (
    select 1 from public.profiles p
    where p.id = course_enrollments.profile_id
      and (p.tenant_id = public.current_tenant_id() or public.is_superadmin())
  ))
  with check (public.is_admin());

-- ----------------------------------------------------------------------------
-- achievements / user_achievements / xp_transactions
-- ----------------------------------------------------------------------------
alter table public.achievements enable row level security;
alter table public.user_achievements enable row level security;
alter table public.xp_transactions enable row level security;

create policy "achievements_select" on public.achievements for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "achievements_modify" on public.achievements for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "user_achievements_select" on public.user_achievements for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.profiles p
      where p.id = user_achievements.profile_id and p.tenant_id = public.current_tenant_id()
    ))
  );

create policy "user_achievements_insert" on public.user_achievements for insert
  with check (profile_id = auth.uid() or public.is_admin());

create policy "xp_transactions_select" on public.xp_transactions for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.profiles p
      where p.id = xp_transactions.profile_id and p.tenant_id = public.current_tenant_id()
    ))
  );

create policy "xp_transactions_insert" on public.xp_transactions for insert
  with check (profile_id = auth.uid() or public.is_admin());

-- ----------------------------------------------------------------------------
-- assessments / assessment_questions / assessment_attempts
-- ----------------------------------------------------------------------------
alter table public.assessments enable row level security;
alter table public.assessment_questions enable row level security;
alter table public.assessment_attempts enable row level security;

create policy "assessments_select" on public.assessments for select
  using (public.is_superadmin() or tenant_id = public.current_tenant_id());

create policy "assessments_modify" on public.assessments for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "assessment_questions_select" on public.assessment_questions for select
  using (
    public.is_superadmin()
    or exists (
      select 1 from public.assessments a
      where a.id = assessment_questions.assessment_id
        and a.tenant_id = public.current_tenant_id()
    )
  );

create policy "assessment_questions_modify" on public.assessment_questions for all
  using (
    public.is_admin() and exists (
      select 1 from public.assessments a
      where a.id = assessment_questions.assessment_id
        and (a.tenant_id = public.current_tenant_id() or public.is_superadmin())
    )
  )
  with check (
    public.is_admin() and exists (
      select 1 from public.assessments a
      where a.id = assessment_questions.assessment_id
        and (a.tenant_id = public.current_tenant_id() or public.is_superadmin())
    )
  );

create policy "assessment_attempts_select" on public.assessment_attempts for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.profiles p
      where p.id = assessment_attempts.profile_id and p.tenant_id = public.current_tenant_id()
    ))
  );

create policy "assessment_attempts_modify_self" on public.assessment_attempts for all
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

-- ----------------------------------------------------------------------------
-- phishing_templates / phishing_campaigns / phishing_campaign_targets
-- ----------------------------------------------------------------------------
alter table public.phishing_templates enable row level security;
alter table public.phishing_campaigns enable row level security;
alter table public.phishing_campaign_targets enable row level security;

create policy "phishing_templates_select" on public.phishing_templates for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "phishing_templates_modify" on public.phishing_templates for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "phishing_campaigns_select" on public.phishing_campaigns for select
  using (public.is_superadmin() or (public.is_management() and tenant_id = public.current_tenant_id()));

create policy "phishing_campaigns_modify" on public.phishing_campaigns for all
  using (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()))
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "phishing_targets_select" on public.phishing_campaign_targets for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.phishing_campaigns c
      where c.id = phishing_campaign_targets.campaign_id and c.tenant_id = public.current_tenant_id()
    ))
  );

create policy "phishing_targets_update_self" on public.phishing_campaign_targets for update
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

create policy "phishing_targets_modify_admin" on public.phishing_campaign_targets for all
  using (
    public.is_admin() and exists (
      select 1 from public.phishing_campaigns c
      where c.id = phishing_campaign_targets.campaign_id
        and (c.tenant_id = public.current_tenant_id() or public.is_superadmin())
    )
  )
  with check (public.is_admin());

-- ----------------------------------------------------------------------------
-- notifications / notification_recipients
-- ----------------------------------------------------------------------------
alter table public.notifications enable row level security;
alter table public.notification_recipients enable row level security;

create policy "notifications_select" on public.notifications for select
  using (
    public.is_superadmin()
    or (public.is_management() and tenant_id = public.current_tenant_id())
    or exists (
      select 1 from public.notification_recipients nr
      where nr.notification_id = notifications.id and nr.profile_id = auth.uid()
    )
  );

create policy "notifications_insert" on public.notifications for insert
  with check (public.is_admin() and (public.is_superadmin() or tenant_id = public.current_tenant_id()));

create policy "notification_recipients_select" on public.notification_recipients for select
  using (
    public.is_superadmin()
    or profile_id = auth.uid()
    or (public.is_management() and exists (
      select 1 from public.notifications n
      where n.id = notification_recipients.notification_id and n.tenant_id = public.current_tenant_id()
    ))
  );

create policy "notification_recipients_update_self" on public.notification_recipients for update
  using (profile_id = auth.uid())
  with check (profile_id = auth.uid());

-- ----------------------------------------------------------------------------
-- ai_config / ai_chat_messages
-- ----------------------------------------------------------------------------
alter table public.ai_config enable row level security;
alter table public.ai_chat_messages enable row level security;

create policy "ai_config_select" on public.ai_config for select
  using (
    public.is_superadmin()
    or (public.is_admin() and (tenant_id = public.current_tenant_id() or tenant_id is null))
  );

create policy "ai_config_modify_tenant" on public.ai_config for all
  using (public.is_admin() and tenant_id = public.current_tenant_id())
  with check (public.is_admin() and tenant_id = public.current_tenant_id());

create policy "ai_config_modify_global" on public.ai_config for all
  using (public.is_superadmin() and tenant_id is null)
  with check (public.is_superadmin() and tenant_id is null);

create policy "ai_chat_messages_select" on public.ai_chat_messages for select
  using (public.is_superadmin() or profile_id = auth.uid());

create policy "ai_chat_messages_insert" on public.ai_chat_messages for insert
  with check (profile_id = auth.uid() and tenant_id = public.current_tenant_id());

-- ----------------------------------------------------------------------------
-- system_settings / feature_flags / licenses
-- ----------------------------------------------------------------------------
alter table public.system_settings enable row level security;
alter table public.feature_flags enable row level security;
alter table public.licenses enable row level security;

create policy "system_settings_select" on public.system_settings for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "system_settings_modify_tenant" on public.system_settings for all
  using (public.is_admin() and tenant_id = public.current_tenant_id())
  with check (public.is_admin() and tenant_id = public.current_tenant_id());

create policy "system_settings_modify_global" on public.system_settings for all
  using (public.is_superadmin() and tenant_id is null)
  with check (public.is_superadmin() and tenant_id is null);

create policy "feature_flags_select" on public.feature_flags for select
  using (public.is_superadmin() or tenant_id is null or tenant_id = public.current_tenant_id());

create policy "feature_flags_modify_tenant" on public.feature_flags for all
  using (public.is_admin() and tenant_id = public.current_tenant_id())
  with check (public.is_admin() and tenant_id = public.current_tenant_id());

create policy "feature_flags_modify_global" on public.feature_flags for all
  using (public.is_superadmin() and tenant_id is null)
  with check (public.is_superadmin() and tenant_id is null);

create policy "licenses_select" on public.licenses for select
  using (public.is_superadmin() or (public.is_admin() and tenant_id = public.current_tenant_id()));

create policy "licenses_modify" on public.licenses for all
  using (public.is_superadmin())
  with check (public.is_superadmin());
