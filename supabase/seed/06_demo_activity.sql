-- ============================================================================
-- SEED 06: Demo activity data
--
-- Generates 12-week risk score history, behavioral profiles, predictive
-- risk intelligence, financial risk exposure, course enrollments,
-- assessment attempts, XP/achievements, phishing campaigns + results, and
-- notifications for the demo tenant (Al Falah Holdings).
--
-- Run AFTER seed files 01-05.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. risk_scores (12-week history) + behavioral_dimensions (current snapshot)
--    per profile in the demo tenant.
-- ----------------------------------------------------------------------------
do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_profile record;
  v_week int;
  v_base_hrs numeric;
  v_base_cci numeric;
  v_hrs numeric;
  v_cci numeric;
begin
  for v_profile in select id from public.profiles where tenant_id = v_tenant loop
    -- each user gets a baseline risk posture; trends improve slightly over time
    v_base_hrs := 25 + random() * 45; -- 25-70
    v_base_cci := 100 - v_base_hrs + (random() * 10 - 5);

    for v_week in 0..11 loop
      v_hrs := greatest(5, least(95, v_base_hrs - v_week * (random() * 1.5) + (random() * 6 - 3)));
      v_cci := greatest(5, least(95, v_base_cci + v_week * (random() * 1.2) + (random() * 6 - 3)));

      insert into public.risk_scores (profile_id, tenant_id, hrs, cci, recorded_at)
      values (v_profile.id, v_tenant, round(v_hrs, 2), round(v_cci, 2), current_date - ((11 - v_week) * 7))
      on conflict (profile_id, recorded_at) do nothing;
    end loop;

    insert into public.behavioral_dimensions (
      profile_id, tenant_id, compliance, curiosity, stress_tolerance,
      social_engineering_susceptibility, recorded_at
    ) values (
      v_profile.id, v_tenant,
      round((45 + random() * 50)::numeric, 2),
      round((15 + random() * 70)::numeric, 2),
      round((35 + random() * 55)::numeric, 2),
      round((10 + random() * 65)::numeric, 2),
      current_date
    )
    on conflict (profile_id, recorded_at) do nothing;
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 2. predictive_risk_indicators — org-level (profile_id = null) 12-week
--    history, with an AI summary on the most recent record.
-- ----------------------------------------------------------------------------
do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_week int;
begin
  for v_week in 0..11 loop
    insert into public.predictive_risk_indicators (
      profile_id, tenant_id, phishing_susceptibility, human_error_probability,
      insider_threat_likelihood, security_fatigue, reporting_likelihood,
      ai_summary, ai_summary_ar, recorded_at
    ) values (
      null, v_tenant,
      greatest(0, least(100, round((38 - v_week * 1.1 + (random() * 6 - 3))::numeric, 2))),
      greatest(0, least(100, round((42 - v_week * 0.9 + (random() * 6 - 3))::numeric, 2))),
      greatest(0, least(100, round((16 + (random() * 6 - 3))::numeric, 2))),
      greatest(0, least(100, round((52 - v_week * 1.3 + (random() * 6 - 3))::numeric, 2))),
      greatest(0, least(100, round((44 + v_week * 1.6 + (random() * 6 - 3))::numeric, 2))),
      case when v_week = 11 then
        'Phishing susceptibility and security fatigue continue to trend downward across the organization, while incident reporting likelihood is improving steadily. Insider threat likelihood remains stable and low. Recent training and phishing simulation campaigns appear to be having a measurable positive effect on overall human risk posture.'
      else null end,
      case when v_week = 11 then
        'تستمر قابلية التأثر بالتصيد الاحتيالي والإرهاق الأمني في الانخفاض على مستوى المؤسسة، بينما يتحسن احتمال الإبلاغ عن الحوادث بشكل مطرد. يظل احتمال التهديد الداخلي مستقرًا ومنخفضًا. يبدو أن حملات التدريب ومحاكاة التصيد الاحتيالي الأخيرة لها تأثير إيجابي ملموس على وضع المخاطر البشرية بشكل عام.'
      else null end,
      current_date - ((11 - v_week) * 7)
    );
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 3. financial_risk_exposure — 12-week history at tenant level
-- ----------------------------------------------------------------------------
do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_week int;
  v_value numeric;
begin
  for v_week in 0..11 loop
    v_value := greatest(150000, 620000 - v_week * 9000 + (random() * 60000 - 30000));

    insert into public.financial_risk_exposure (tenant_id, estimated_value, currency, breakdown, recorded_at)
    values (
      v_tenant, round(v_value, 2), 'USD',
      jsonb_build_object(
        'phishing_incidents', round((v_value * 0.35)::numeric, 2),
        'data_breach_potential', round((v_value * 0.30)::numeric, 2),
        'productivity_loss', round((v_value * 0.20)::numeric, 2),
        'compliance_fines', round((v_value * 0.15)::numeric, 2)
      ),
      current_date - ((11 - v_week) * 7)
    )
    on conflict (tenant_id, recorded_at) do nothing;
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 4. course_enrollments — each profile is enrolled in ~70% of the global
--    course catalog with varying progress; completed courses award XP.
-- ----------------------------------------------------------------------------
do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_profile record;
  v_course record;
  v_status public.enrollment_status;
  v_progress int;
begin
  for v_profile in select id from public.profiles where tenant_id = v_tenant loop
    for v_course in select id, xp_reward from public.courses loop
      if random() < 0.7 then
        v_progress := (random() * 100)::int;

        if v_progress >= 95 then
          v_status := 'completed';
          v_progress := 100;
        elsif v_progress > 0 then
          v_status := 'in_progress';
        else
          v_status := 'not_started';
        end if;

        insert into public.course_enrollments (profile_id, course_id, status, progress_pct, started_at, completed_at)
        values (
          v_profile.id, v_course.id, v_status, v_progress,
          case when v_status <> 'not_started' then now() - make_interval(days => (random() * 60)::int) else null end,
          case when v_status = 'completed' then now() - make_interval(days => (random() * 30)::int) else null end
        )
        on conflict (profile_id, course_id) do nothing;

        if v_status = 'completed' then
          perform public.award_xp(v_profile.id, v_course.xp_reward, 'course_completed', 'course', v_course.id::text);
        end if;
      end if;
    end loop;
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 5. assessment_attempts — ~75% of profiles attempt each published
--    assessment for the tenant. Security-knowledge passes award XP.
-- ----------------------------------------------------------------------------
do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_profile record;
  v_assessment record;
  v_score int;
begin
  for v_profile in select id from public.profiles where tenant_id = v_tenant loop
    for v_assessment in select id, passing_score, type from public.assessments where tenant_id = v_tenant loop
      if random() < 0.75 then
        if v_assessment.type = 'psychometric' then
          v_score := 100; -- psychometric attempts are always "complete", not pass/fail
        else
          v_score := 50 + (random() * 50)::int; -- 50-100
        end if;

        insert into public.assessment_attempts (profile_id, assessment_id, score, passed, answers, started_at, completed_at)
        values (
          v_profile.id, v_assessment.id, v_score,
          v_score >= v_assessment.passing_score,
          '{}'::jsonb,
          now() - make_interval(days => (random() * 90)::int),
          now() - make_interval(days => (random() * 90)::int)
        );

        if v_assessment.type = 'security_knowledge' and v_score >= v_assessment.passing_score then
          perform public.award_xp(v_profile.id, 30, 'assessment_passed', 'assessment', v_assessment.id::text);
        end if;
      end if;
    end loop;
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 6. Streaks + achievements
-- ----------------------------------------------------------------------------
update public.profiles
set streak_days = (random() * 40)::int
where tenant_id = '10000000-0000-0000-0000-000000000001';

-- welcome_aboard: everyone
insert into public.user_achievements (profile_id, achievement_id)
select id, '40000000-0000-0000-0000-000000000001'
from public.profiles
where tenant_id = '10000000-0000-0000-0000-000000000001'
on conflict do nothing;

-- streak_7 / streak_30
insert into public.user_achievements (profile_id, achievement_id)
select id, '40000000-0000-0000-0000-000000000005'
from public.profiles
where tenant_id = '10000000-0000-0000-0000-000000000001' and streak_days >= 7
on conflict do nothing;

insert into public.user_achievements (profile_id, achievement_id)
select id, '40000000-0000-0000-0000-000000000006'
from public.profiles
where tenant_id = '10000000-0000-0000-0000-000000000001' and streak_days >= 30
on conflict do nothing;

-- course_explorer: 5+ completed courses
insert into public.user_achievements (profile_id, achievement_id)
select profile_id, '40000000-0000-0000-0000-000000000004'
from public.course_enrollments
where status = 'completed'
group by profile_id
having count(*) >= 5
on conflict do nothing;

-- assessment_champion: 90%+ on 3+ assessments
insert into public.user_achievements (profile_id, achievement_id)
select profile_id, '40000000-0000-0000-0000-000000000003'
from public.assessment_attempts
where score >= 90
group by profile_id
having count(*) >= 3
on conflict do nothing;

-- level_5: reached level 5 (xp >= 2000) via course/assessment XP awards above
insert into public.user_achievements (profile_id, achievement_id)
select id, '40000000-0000-0000-0000-000000000007'
from public.profiles
where tenant_id = '10000000-0000-0000-0000-000000000001' and level >= 5
on conflict do nothing;

-- security_champion: highest XP earner in the org
insert into public.user_achievements (profile_id, achievement_id)
select id, '40000000-0000-0000-0000-000000000008'
from public.profiles
where tenant_id = '10000000-0000-0000-0000-000000000001'
order by xp desc
limit 1
on conflict do nothing;

-- phishing_defender: showcase on the demo employee account
insert into public.user_achievements (profile_id, achievement_id)
values ('20000000-0000-0000-0000-000000000005', '40000000-0000-0000-0000-000000000002')
on conflict do nothing;

-- ----------------------------------------------------------------------------
-- 7. Phishing campaigns (3 completed, 1 running) + per-recipient results
-- ----------------------------------------------------------------------------
insert into public.phishing_campaigns (id, tenant_id, name, template_id, target_type, status, scheduled_at, started_at, ended_at, created_by) values
  ('70000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001',
   'Q1 Banking Security Awareness Test', '60000000-0000-0000-0000-000000000002',
   'all', 'completed',
   now() - interval '75 days', now() - interval '74 days', now() - interval '67 days',
   '20000000-0000-0000-0000-000000000002'),

  ('70000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001',
   'HR Payroll Update Simulation', '60000000-0000-0000-0000-000000000017',
   'all', 'completed',
   now() - interval '50 days', now() - interval '49 days', now() - interval '42 days',
   '20000000-0000-0000-0000-000000000002'),

  ('70000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001',
   'Delivery Notification Phishing Drill', '60000000-0000-0000-0000-000000000033',
   'all', 'completed',
   now() - interval '21 days', now() - interval '20 days', now() - interval '13 days',
   '20000000-0000-0000-0000-000000000002'),

  ('70000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001',
   'Executive WhatsApp Gift Card Scam', '60000000-0000-0000-0000-000000000048',
   'all', 'running',
   now() - interval '2 days', now() - interval '1 days', null,
   '20000000-0000-0000-0000-000000000002');

do $$
declare
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_campaign record;
  v_profile record;
  v_rand numeric;
  v_status public.campaign_target_status;
  v_sent_at timestamptz;
begin
  for v_campaign in select id, status, started_at from public.phishing_campaigns where tenant_id = v_tenant loop
    for v_profile in select id from public.profiles where tenant_id = v_tenant loop
      v_sent_at := v_campaign.started_at + interval '1 hour';

      if v_campaign.status = 'running' then
        -- in-flight campaign: most are still pending or just sent
        v_rand := random();
        if v_rand < 0.5 then
          v_status := 'sent';
        elsif v_rand < 0.7 then
          v_status := 'opened';
        elsif v_rand < 0.85 then
          v_status := 'clicked';
        elsif v_rand < 0.95 then
          v_status := 'reported';
        else
          v_status := 'pending';
        end if;
      else
        -- completed campaign: full funnel distribution
        v_rand := random();
        if v_rand < 0.18 then
          v_status := 'reported';
        elsif v_rand < 0.40 then
          v_status := 'clicked';
        elsif v_rand < 0.75 then
          v_status := 'opened';
        else
          v_status := 'sent';
        end if;
      end if;

      insert into public.phishing_campaign_targets (campaign_id, profile_id, status, sent_at, opened_at, clicked_at, reported_at)
      values (
        v_campaign.id, v_profile.id, v_status,
        case when v_status <> 'pending' then v_sent_at else null end,
        case when v_status in ('opened','clicked','reported') then v_sent_at + interval '3 hours' else null end,
        case when v_status in ('clicked','reported') then v_sent_at + interval '4 hours' else null end,
        case when v_status = 'reported' then v_sent_at + interval '2 hours' else null end
      )
      on conflict (campaign_id, profile_id) do nothing;

      if v_status = 'reported' then
        perform public.award_xp(v_profile.id, 20, 'phishing_reported', 'campaign', v_campaign.id::text);
      end if;
    end loop;
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- 8. Notifications (fan-out handled automatically by trigger)
-- ----------------------------------------------------------------------------
insert into public.notifications (tenant_id, title, title_ar, body, body_ar, sender_id, target_type, target_role, target_department_id, target_profile_ids) values
  ('10000000-0000-0000-0000-000000000001',
   'Welcome to CyberCultX', 'مرحبًا بك في CyberCultX',
   'Your organization has launched the CyberCultX Human Risk Intelligence Platform. Explore your personal risk dashboard, complete your first course, and start earning XP.',
   'أطلقت مؤسستك منصة CyberCultX لاستخبارات المخاطر البشرية. استكشف لوحة المخاطر الخاصة بك، وأكمل أول دورة لك، وابدأ في كسب نقاط الخبرة.',
   '20000000-0000-0000-0000-000000000002', 'all', null, null, '{}'),

  ('10000000-0000-0000-0000-000000000001',
   'New Phishing Simulation Campaign Underway', 'حملة محاكاة تصيد احتيالي جديدة قيد التنفيذ',
   'A new phishing simulation campaign is currently running. Stay alert, and remember to use the "Report Phishing" button if you spot a suspicious message.',
   'هناك حملة محاكاة تصيد احتيالي جديدة قيد التنفيذ حاليًا. ابقَ يقظًا، وتذكر استخدام زر "الإبلاغ عن التصيد الاحتيالي" إذا لاحظت رسالة مشبوهة.',
   '20000000-0000-0000-0000-000000000002', 'all', null, null, '{}'),

  ('10000000-0000-0000-0000-000000000001',
   'Mandatory Security Training Assigned', 'تم تعيين تدريب أمني إلزامي',
   'You have been assigned mandatory security awareness courses. Please complete them within the next two weeks to stay compliant.',
   'تم تعيين دورات توعية أمنية إلزامية لك. يرجى إكمالها خلال الأسبوعين القادمين للحفاظ على الامتثال.',
   '20000000-0000-0000-0000-000000000002', 'role', 'employee', null, '{}'),

  ('10000000-0000-0000-0000-000000000001',
   'Updated Employee Risk Roster Available', 'تم تحديث قائمة مخاطر الموظفين',
   'The latest employee risk roster and engagement metrics have been updated and are ready for review.',
   'تم تحديث أحدث قائمة مخاطر الموظفين ومقاييس المشاركة وهي جاهزة للمراجعة.',
   '20000000-0000-0000-0000-000000000002', 'role', 'hr', null, '{}'),

  ('10000000-0000-0000-0000-000000000001',
   'IT Department Security Briefing', 'إحاطة أمنية لقسم تقنية المعلومات',
   'A mandatory security briefing for the IT department will cover recent attack trends and updated incident response procedures.',
   'ستغطي الإحاطة الأمنية الإلزامية لقسم تقنية المعلومات اتجاهات الهجمات الأخيرة وإجراءات الاستجابة للحوادث المحدثة.',
   '20000000-0000-0000-0000-000000000002', 'department', null, '10000000-0000-0000-0000-000000000101', '{}'),

  ('10000000-0000-0000-0000-000000000001',
   'Quarterly Risk Intelligence Report Ready', 'تقرير استخبارات المخاطر الفصلي جاهز',
   'The quarterly Human Risk Intelligence report is now available for download from the Reports section.',
   'تقرير استخبارات المخاطر البشرية الفصلي متاح الآن للتنزيل من قسم التقارير.',
   '20000000-0000-0000-0000-000000000002', 'role', 'executive', null, '{}');
