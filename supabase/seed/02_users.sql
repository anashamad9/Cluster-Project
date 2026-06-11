-- ============================================================================
-- SEED 02: Demo users
--
-- Creates 5 named demo accounts (one per role) plus ~25 additional employee
-- accounts spread across departments so the HR roster, leaderboard and
-- department heatmap have realistic data.
--
-- All demo accounts share the password:  CyberCultX@2026
--
-- This inserts directly into auth.users / auth.identities (requires running
-- as the postgres role, e.g. via the Supabase SQL editor). The
-- on_auth_user_created trigger (migration 0002) automatically creates the
-- matching public.profiles row from raw_user_meta_data.
-- ============================================================================

do $$
declare
  v_password text := 'CyberCultX@2026';
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_dept_it uuid := '10000000-0000-0000-0000-000000000101';
  v_dept_hr uuid := '10000000-0000-0000-0000-000000000103';
  v_dept_exec uuid := '10000000-0000-0000-0000-000000000108';
  v_dept_sales uuid := '10000000-0000-0000-0000-000000000105';
begin
  -- 1. SuperAdmin (platform operator, no tenant)
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, reauthentication_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    '20000000-0000-0000-0000-000000000001',
    'authenticated', 'authenticated',
    'superadmin@cybercultx.com',
    crypt(v_password, gen_salt('bf')),
    now(), '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object(
      'full_name', 'Omar Al Sayed',
      'full_name_ar', 'عمر السيد',
      'role', 'superadmin',
      'locale_pref', 'en'
    ),
    now(), now()
  );

  -- 2. Admin (IT & Security)
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, reauthentication_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    '20000000-0000-0000-0000-000000000002',
    'authenticated', 'authenticated',
    'admin@alfalah.demo',
    crypt(v_password, gen_salt('bf')),
    now(), '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object(
      'tenant_id', v_tenant,
      'full_name', 'Khalid Al Mazrouei',
      'full_name_ar', 'خالد المزروعي',
      'role', 'admin',
      'department_id', v_dept_it,
      'job_title', 'IT Security Manager',
      'job_title_ar', 'مدير أمن المعلومات',
      'locale_pref', 'en'
    ),
    now(), now()
  );

  -- 3. HR
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, reauthentication_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    '20000000-0000-0000-0000-000000000003',
    'authenticated', 'authenticated',
    'hr@alfalah.demo',
    crypt(v_password, gen_salt('bf')),
    now(), '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object(
      'tenant_id', v_tenant,
      'full_name', 'Maha Al Suwaidi',
      'full_name_ar', 'مها السويدي',
      'role', 'hr',
      'department_id', v_dept_hr,
      'job_title', 'HR Director',
      'job_title_ar', 'مديرة الموارد البشرية',
      'locale_pref', 'en'
    ),
    now(), now()
  );

  -- 4. Executive
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, reauthentication_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    '20000000-0000-0000-0000-000000000004',
    'authenticated', 'authenticated',
    'exec@alfalah.demo',
    crypt(v_password, gen_salt('bf')),
    now(), '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object(
      'tenant_id', v_tenant,
      'full_name', 'Saeed Al Nahyan',
      'full_name_ar', 'سعيد آل نهيان',
      'role', 'executive',
      'department_id', v_dept_exec,
      'job_title', 'Chief Executive Officer',
      'job_title_ar', 'الرئيس التنفيذي',
      'locale_pref', 'en'
    ),
    now(), now()
  );

  -- 5. Employee
  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
    confirmation_token, recovery_token, email_change_token_new, email_change,
    email_change_token_current, reauthentication_token,
    raw_app_meta_data, raw_user_meta_data, created_at, updated_at
  ) values (
    '00000000-0000-0000-0000-000000000000',
    '20000000-0000-0000-0000-000000000005',
    'authenticated', 'authenticated',
    'employee@alfalah.demo',
    crypt(v_password, gen_salt('bf')),
    now(), '', '', '', '', '', '',
    '{"provider":"email","providers":["email"]}',
    jsonb_build_object(
      'tenant_id', v_tenant,
      'full_name', 'Fatima Al Zaabi',
      'full_name_ar', 'فاطمة الزعابي',
      'role', 'employee',
      'department_id', v_dept_sales,
      'job_title', 'Marketing Specialist',
      'job_title_ar', 'أخصائية تسويق',
      'locale_pref', 'en'
    ),
    now(), now()
  );

  -- auth.identities rows so email/password sign-in works
  insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  select gen_random_uuid(), u.id, u.id::text,
         jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
         'email', now(), now(), now()
  from auth.users u
  where u.id in (
    '20000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000002',
    '20000000-0000-0000-0000-000000000003',
    '20000000-0000-0000-0000-000000000004',
    '20000000-0000-0000-0000-000000000005'
  );
end $$;

-- ----------------------------------------------------------------------------
-- ~25 additional employees spread across departments for roster/leaderboard/
-- heatmap data. Same shared password.
-- ----------------------------------------------------------------------------
do $$
declare
  v_password text := 'CyberCultX@2026';
  v_tenant uuid := '10000000-0000-0000-0000-000000000001';
  v_names text[][] := array[
    array['Ahmed Al Mansoori','أحمد المنصوري'],
    array['Layla Hassan','ليلى حسن'],
    array['Yousef Al Qassimi','يوسف القاسمي'],
    array['Mariam Al Shamsi','مريم الشامسي'],
    array['Tariq Abdullah','طارق عبدالله'],
    array['Noura Al Falasi','نورة الفلاسي'],
    array['Hamdan Al Marri','حمدان المري'],
    array['Aisha Al Hashimi','عائشة الهاشمي'],
    array['Rashid Al Nuaimi','راشد النعيمي'],
    array['Salma Khan','سلمى خان'],
    array['Faisal Al Otaiba','فيصل العتيبة'],
    array['Hessa Al Dhaheri','حصة الظاهري'],
    array['Majid Al Balushi','ماجد البلوشي'],
    array['Reem Al Kaabi','ريم الكعبي'],
    array['Sultan Al Shehhi','سلطان الشحي'],
    array['Amina Yousif','أمينة يوسف'],
    array['Waleed Saeed','وليد سعيد'],
    array['Dana Al Mheiri','دانة المهيري'],
    array['Khalfan Al Romaithi','خلفان الرميثي'],
    array['Shaikha Al Ameri','شيخة العامري'],
    array['Adel Mahmoud','عادل محمود'],
    array['Hind Al Marzouqi','هند المرزوقي'],
    array['Nasser Al Ketbi','ناصر الكتبي'],
    array['Mona Ibrahim','منى إبراهيم'],
    array['Saif Al Junaibi','سيف الجنيبي']
  ];
  v_jobs text[][] := array[
    array['Software Engineer','مهندس برمجيات','10000000-0000-0000-0000-000000000101'],
    array['Financial Analyst','محلل مالي','10000000-0000-0000-0000-000000000102'],
    array['HR Specialist','أخصائي موارد بشرية','10000000-0000-0000-0000-000000000103'],
    array['Operations Coordinator','منسق عمليات','10000000-0000-0000-0000-000000000104'],
    array['Sales Executive','مدير مبيعات','10000000-0000-0000-0000-000000000105'],
    array['Compliance Officer','مسؤول امتثال','10000000-0000-0000-0000-000000000106'],
    array['Customer Service Agent','وكيل خدمة عملاء','10000000-0000-0000-0000-000000000107'],
    array['Network Administrator','مسؤول شبكات','10000000-0000-0000-0000-000000000101'],
    array['Accountant','محاسب','10000000-0000-0000-0000-000000000102'],
    array['Recruiter','أخصائي توظيف','10000000-0000-0000-0000-000000000103']
  ];
  v_id uuid;
  v_email text;
  v_job text[];
  i int;
begin
  for i in 1 .. array_length(v_names, 1) loop
    v_id := ('20000000-0000-0000-0000-0001' || lpad(i::text, 8, '0'))::uuid;
    v_email := lower(regexp_replace(split_part(v_names[i][1], ' ', 1), '[^a-zA-Z]', '', 'g')) || '.' ||
               lower(regexp_replace(split_part(v_names[i][1] || ' x', ' ', 2), '[^a-zA-Z]', '', 'g')) ||
               i::text || '@alfalah.demo';
    v_job := v_jobs[((i - 1) % array_length(v_jobs, 1)) + 1];

    insert into auth.users (
      instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
      confirmation_token, recovery_token, email_change_token_new, email_change,
      email_change_token_current, reauthentication_token,
      raw_app_meta_data, raw_user_meta_data, created_at, updated_at
    ) values (
      '00000000-0000-0000-0000-000000000000',
      v_id,
      'authenticated', 'authenticated',
      v_email,
      crypt(v_password, gen_salt('bf')),
      now(), '', '', '', '', '', '',
      '{"provider":"email","providers":["email"]}',
      jsonb_build_object(
        'tenant_id', v_tenant,
        'full_name', v_names[i][1],
        'full_name_ar', v_names[i][2],
        'role', 'employee',
        'department_id', v_job[3],
        'job_title', v_job[1],
        'job_title_ar', v_job[2],
        'locale_pref', 'en'
      ),
      now() - (random() * interval '180 days'), now()
    );

    insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    values (gen_random_uuid(), v_id, v_id::text,
            jsonb_build_object('sub', v_id::text, 'email', v_email, 'email_verified', true),
            'email', now(), now(), now());
  end loop;
end $$;
