-- ============================================================================
-- SEED 01: Core — demo tenant, departments, AI config, achievements,
-- course categories, feature flags
--
-- Run AFTER all migrations in supabase/migrations/ have been applied.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Demo tenant: "Al Falah Holdings"
-- ----------------------------------------------------------------------------
insert into public.tenants (id, name, name_ar, slug, status, plan, primary_color, industry, country, employee_count)
values (
  '10000000-0000-0000-0000-000000000001',
  'Al Falah Holdings',
  'مجموعة الفلاح القابضة',
  'al-falah-holdings',
  'active',
  'enterprise',
  '#DC2626',
  'Financial Services',
  'AE',
  32
);

-- ----------------------------------------------------------------------------
-- Departments
-- ----------------------------------------------------------------------------
insert into public.departments (id, tenant_id, name, name_ar) values
  ('10000000-0000-0000-0000-000000000101', '10000000-0000-0000-0000-000000000001', 'Information Technology', 'تقنية المعلومات'),
  ('10000000-0000-0000-0000-000000000102', '10000000-0000-0000-0000-000000000001', 'Finance', 'المالية'),
  ('10000000-0000-0000-0000-000000000103', '10000000-0000-0000-0000-000000000001', 'Human Resources', 'الموارد البشرية'),
  ('10000000-0000-0000-0000-000000000104', '10000000-0000-0000-0000-000000000001', 'Operations', 'العمليات'),
  ('10000000-0000-0000-0000-000000000105', '10000000-0000-0000-0000-000000000001', 'Sales & Marketing', 'المبيعات والتسويق'),
  ('10000000-0000-0000-0000-000000000106', '10000000-0000-0000-0000-000000000001', 'Legal & Compliance', 'الشؤون القانونية والامتثال'),
  ('10000000-0000-0000-0000-000000000107', '10000000-0000-0000-0000-000000000001', 'Customer Service', 'خدمة العملاء'),
  ('10000000-0000-0000-0000-000000000108', '10000000-0000-0000-0000-000000000001', 'Executive Office', 'المكتب التنفيذي');

-- ----------------------------------------------------------------------------
-- AI configuration: global default (used as fallback) + tenant override
-- ----------------------------------------------------------------------------
insert into public.ai_config (tenant_id, provider, model, system_prompt, system_prompt_ar, temperature, enabled)
values (
  null,
  'openai',
  'gpt-4o-mini',
  'You are the CyberCultX AI security assistant. You help employees, executives, HR and admins of an enterprise Human Risk Intelligence platform understand cybersecurity concepts, their personal risk scores, phishing simulations, and security best practices. Be concise, accurate, and supportive. Never reveal another user''s data.',
  'أنت مساعد الأمن السيبراني الذكي لمنصة CyberCultX. تساعد الموظفين والتنفيذيين والموارد البشرية والمسؤولين على فهم مفاهيم الأمن السيبراني، ودرجات المخاطر الخاصة بهم، ومحاكاة التصيد الاحتيالي، وأفضل ممارسات الأمان. كن موجزًا ودقيقًا وداعمًا. لا تكشف أبدًا عن بيانات مستخدم آخر.',
  0.4,
  true
);

insert into public.ai_config (tenant_id, provider, model, system_prompt, system_prompt_ar, temperature, enabled)
values (
  '10000000-0000-0000-0000-000000000001',
  'openai',
  'gpt-4o-mini',
  'You are the CyberCultX AI security assistant for Al Falah Holdings. You help employees, executives, HR and admins understand cybersecurity concepts, their personal or organizational risk scores, phishing simulations, and security best practices relevant to the GCC financial services sector. Be concise, accurate, and supportive. Never reveal another user''s data.',
  'أنت مساعد الأمن السيبراني الذكي لمنصة CyberCultX الخاصة بمجموعة الفلاح القابضة. تساعد المستخدمين على فهم مفاهيم الأمن السيبراني ودرجات المخاطر وأفضل الممارسات في قطاع الخدمات المالية الخليجي. كن موجزًا ودقيقًا وداعمًا.',
  0.4,
  true
);

-- ----------------------------------------------------------------------------
-- Global feature flags
-- ----------------------------------------------------------------------------
insert into public.feature_flags (tenant_id, key, enabled, description) values
  (null, 'ai_chat_assistant', true, 'AI-powered chat assistant for all roles'),
  (null, 'predictive_risk_intelligence', true, 'AI-powered predictive risk forecasts for executives'),
  (null, 'phishing_simulations', true, 'Phishing simulation campaign engine'),
  (null, 'pdf_reports', true, 'PDF security intelligence report generation'),
  (null, 'mfa_required', false, 'Require MFA enrollment for all users');

-- ----------------------------------------------------------------------------
-- Achievements (global catalog)
-- ----------------------------------------------------------------------------
insert into public.achievements (id, tenant_id, code, name, name_ar, description, description_ar, icon, xp_reward, criteria) values
  ('40000000-0000-0000-0000-000000000001', null, 'welcome_aboard', 'Welcome Aboard', 'مرحبًا بك',
    'Completed your first login and profile setup.', 'أكملت تسجيل الدخول الأول وإعداد الملف الشخصي.',
    'sparkles', 25, '{"type":"first_login"}'),
  ('40000000-0000-0000-0000-000000000002', null, 'phishing_defender', 'Phishing Defender', 'حامي التصيد الاحتيالي',
    'Reported 5 phishing simulation emails.', 'أبلغت عن 5 رسائل محاكاة تصيد احتيالي.',
    'shield-check', 100, '{"type":"phishing_reports","count":5}'),
  ('40000000-0000-0000-0000-000000000003', null, 'assessment_champion', 'Assessment Champion', 'بطل التقييمات',
    'Scored 90% or higher on 3 assessments.', 'حصلت على 90% أو أكثر في 3 تقييمات.',
    'trophy', 150, '{"type":"assessment_score","threshold":90,"count":3}'),
  ('40000000-0000-0000-0000-000000000004', null, 'course_explorer', 'Course Explorer', 'مستكشف الدورات',
    'Completed 5 security awareness courses.', 'أكملت 5 دورات توعية أمنية.',
    'graduation-cap', 100, '{"type":"courses_completed","count":5}'),
  ('40000000-0000-0000-0000-000000000005', null, 'streak_7', 'Consistent Learner', 'متعلم مثابر',
    'Maintained a 7-day activity streak.', 'حافظت على نشاط متواصل لمدة 7 أيام.',
    'flame', 75, '{"type":"streak","days":7}'),
  ('40000000-0000-0000-0000-000000000006', null, 'streak_30', 'Security Habit', 'عادة أمنية',
    'Maintained a 30-day activity streak.', 'حافظت على نشاط متواصل لمدة 30 يومًا.',
    'flame', 250, '{"type":"streak","days":30}'),
  ('40000000-0000-0000-0000-000000000007', null, 'level_5', 'Rising Defender', 'مدافع صاعد',
    'Reached Level 5.', 'وصلت إلى المستوى 5.',
    'star', 50, '{"type":"level","level":5}'),
  ('40000000-0000-0000-0000-000000000008', null, 'security_champion', 'Security Champion', 'بطل الأمن السيبراني',
    'Reached the top of the organization leaderboard.', 'وصلت إلى صدارة لوحة المتصدرين في المؤسسة.',
    'medal', 200, '{"type":"leaderboard_rank","rank":1}');

-- ----------------------------------------------------------------------------
-- Course categories (global)
-- ----------------------------------------------------------------------------
insert into public.course_categories (id, tenant_id, name, name_ar, icon) values
  ('30000000-0000-0000-0000-000000000001', null, 'Phishing Awareness', 'التوعية بالتصيد الاحتيالي', 'mail-warning'),
  ('30000000-0000-0000-0000-000000000002', null, 'Password & Account Security', 'أمان كلمات المرور والحسابات', 'key-round'),
  ('30000000-0000-0000-0000-000000000003', null, 'Data Protection & Privacy', 'حماية البيانات والخصوصية', 'database'),
  ('30000000-0000-0000-0000-000000000004', null, 'Social Engineering', 'الهندسة الاجتماعية', 'users-round'),
  ('30000000-0000-0000-0000-000000000005', null, 'Mobile & Remote Security', 'أمان الأجهزة المحمولة والعمل عن بُعد', 'smartphone'),
  ('30000000-0000-0000-0000-000000000006', null, 'Compliance & Regulations', 'الامتثال والأنظمة', 'scale');
