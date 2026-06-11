-- ============================================================================
-- SEED 03: Course catalog (global library, tenant_id = null) + lessons
--
-- 10 courses across the 6 course_categories seeded in 01_core.sql, each
-- with 3 lessons.
-- ============================================================================

insert into public.courses (id, tenant_id, category_id, title, title_ar, description, description_ar, difficulty, language, duration_minutes, xp_reward, is_published) values
  ('31000000-0000-0000-0000-000000000001', null, '30000000-0000-0000-0000-000000000001',
   'Spotting Phishing Emails', 'التعرف على رسائل التصيد الاحتيالي',
   'Learn to identify the red flags of phishing emails, from suspicious senders to malicious links.',
   'تعلم كيفية التعرف على علامات التصيد الاحتيالي في البريد الإلكتروني، من المرسلين المشبوهين إلى الروابط الضارة.',
   'beginner', 'both', 30, 50, true),

  ('31000000-0000-0000-0000-000000000002', null, '30000000-0000-0000-0000-000000000001',
   'Advanced Phishing & Spear-Phishing Defense', 'الدفاع المتقدم ضد التصيد الموجه',
   'Deep dive into targeted spear-phishing campaigns, business email compromise, and how to verify requests.',
   'تعمق في حملات التصيد الموجه واختراق البريد الإلكتروني للأعمال وكيفية التحقق من الطلبات.',
   'intermediate', 'both', 45, 75, true),

  ('31000000-0000-0000-0000-000000000003', null, '30000000-0000-0000-0000-000000000002',
   'Building Strong Passwords & Password Managers', 'إنشاء كلمات مرور قوية واستخدام مديري كلمات المرور',
   'Best practices for creating strong, unique passwords and using a password manager effectively.',
   'أفضل الممارسات لإنشاء كلمات مرور قوية وفريدة واستخدام مدير كلمات المرور بفعالية.',
   'beginner', 'both', 25, 50, true),

  ('31000000-0000-0000-0000-000000000004', null, '30000000-0000-0000-0000-000000000002',
   'Multi-Factor Authentication Essentials', 'أساسيات المصادقة متعددة العوامل',
   'Understand why MFA matters and how to set it up correctly across your accounts.',
   'فهم أهمية المصادقة متعددة العوامل وكيفية إعدادها بشكل صحيح عبر حساباتك.',
   'beginner', 'both', 20, 40, true),

  ('31000000-0000-0000-0000-000000000005', null, '30000000-0000-0000-0000-000000000003',
   'Data Classification & Handling', 'تصنيف البيانات والتعامل معها',
   'Learn how to classify sensitive company data and handle it according to policy.',
   'تعلم كيفية تصنيف بيانات الشركة الحساسة والتعامل معها وفقًا للسياسات المعتمدة.',
   'intermediate', 'both', 35, 60, true),

  ('31000000-0000-0000-0000-000000000006', null, '30000000-0000-0000-0000-000000000006',
   'GDPR & Regional Privacy Regulations', 'اللائحة العامة لحماية البيانات والأنظمة الإقليمية للخصوصية',
   'An overview of data protection regulations relevant to GCC organizations and your responsibilities.',
   'نظرة عامة على أنظمة حماية البيانات ذات الصلة بمؤسسات دول الخليج ومسؤولياتك تجاهها.',
   'intermediate', 'both', 40, 70, true),

  ('31000000-0000-0000-0000-000000000007', null, '30000000-0000-0000-0000-000000000004',
   'Social Engineering Tactics Unmasked', 'كشف أساليب الهندسة الاجتماعية',
   'Explore the psychology behind social engineering attacks and how attackers manipulate trust.',
   'استكشف علم النفس وراء هجمات الهندسة الاجتماعية وكيفية استغلال المهاجمين للثقة.',
   'intermediate', 'both', 30, 60, true),

  ('31000000-0000-0000-0000-000000000008', null, '30000000-0000-0000-0000-000000000004',
   'Pretexting, Baiting & Tailgating', 'انتحال الهوية والإغراء والتسلل',
   'Recognize physical and pretext-based social engineering attempts in the workplace.',
   'تعرف على محاولات الهندسة الاجتماعية المادية والقائمة على الانتحال في مكان العمل.',
   'advanced', 'both', 35, 80, true),

  ('31000000-0000-0000-0000-000000000009', null, '30000000-0000-0000-0000-000000000005',
   'Securing Mobile Devices & BYOD', 'تأمين الأجهزة المحمولة وسياسة إحضار جهازك الخاص',
   'Practical steps to secure smartphones and tablets used for work, including BYOD policy basics.',
   'خطوات عملية لتأمين الهواتف الذكية والأجهزة اللوحية المستخدمة في العمل، بما في ذلك أساسيات سياسة BYOD.',
   'beginner', 'both', 25, 50, true),

  ('31000000-0000-0000-0000-000000000010', null, '30000000-0000-0000-0000-000000000005',
   'Safe Remote Work Practices', 'ممارسات العمل عن بُعد الآمنة',
   'Stay secure while working from home or on the go: VPNs, public Wi-Fi, and home network hygiene.',
   'حافظ على الأمان أثناء العمل من المنزل أو أثناء التنقل: الشبكات الافتراضية الخاصة والواي فاي العام ونظافة الشبكة المنزلية.',
   'beginner', 'both', 20, 40, true);

-- ----------------------------------------------------------------------------
-- Lessons (3 per course)
-- ----------------------------------------------------------------------------
insert into public.course_lessons (course_id, title, title_ar, content, content_ar, order_index, duration_minutes) values
  -- 1. Spotting Phishing Emails
  ('31000000-0000-0000-0000-000000000001', 'Anatomy of a Phishing Email', 'تشريح رسالة تصيد احتيالي',
   'Phishing emails often impersonate trusted brands or colleagues. Look closely at the sender address, generic greetings, urgency, and mismatched links.',
   'غالبًا ما تنتحل رسائل التصيد الاحتيالي هوية علامات تجارية أو زملاء موثوقين. تحقق من عنوان المرسل والتحيات العامة والإلحاح والروابط غير المتطابقة.',
   1, 10),
  ('31000000-0000-0000-0000-000000000001', 'Hovering, Headers & Hidden Links', 'التمرير والترويسات والروابط المخفية',
   'Hover over links before clicking to reveal the true destination. Inspect email headers when something feels off.',
   'مرر مؤشر الفأرة فوق الروابط قبل النقر للكشف عن الوجهة الحقيقية. افحص ترويسات البريد الإلكتروني عند الشعور بأن شيئًا ما غير صحيح.',
   2, 10),
  ('31000000-0000-0000-0000-000000000001', 'What To Do When You Spot Phishing', 'ماذا تفعل عند اكتشاف رسالة تصيد',
   'Never click, reply, or download attachments. Use the "Report Phishing" button so security teams can act quickly.',
   'لا تنقر أو ترد أو تقم بتنزيل المرفقات أبدًا. استخدم زر "الإبلاغ عن التصيد الاحتيالي" حتى تتمكن فرق الأمان من التصرف بسرعة.',
   3, 10),

  -- 2. Advanced Phishing & Spear-Phishing Defense
  ('31000000-0000-0000-0000-000000000002', 'Targeted Attacks & OSINT', 'الهجمات الموجهة وجمع المعلومات الاستخباراتية مفتوحة المصدر',
   'Attackers research targets via LinkedIn and social media to craft convincing, personalized messages.',
   'يقوم المهاجمون بالبحث عن أهدافهم عبر لينكدإن ووسائل التواصل الاجتماعي لصياغة رسائل مقنعة وشخصية.',
   1, 15),
  ('31000000-0000-0000-0000-000000000002', 'Business Email Compromise (BEC)', 'اختراق البريد الإلكتروني للأعمال',
   'BEC scams impersonate executives to request urgent wire transfers or sensitive data. Always verify via a second channel.',
   'تنتحل عمليات احتيال BEC هوية المسؤولين التنفيذيين لطلب تحويلات مالية عاجلة أو بيانات حساسة. تحقق دائمًا عبر قناة ثانية.',
   2, 15),
  ('31000000-0000-0000-0000-000000000002', 'Verification Workflows', 'إجراءات التحقق',
   'Establish out-of-band verification for any unusual financial or data request, regardless of apparent seniority of the sender.',
   'أنشئ إجراءات تحقق خارج النطاق لأي طلب مالي أو بيانات غير عادي، بغض النظر عن المنصب الظاهري للمرسل.',
   3, 15),

  -- 3. Building Strong Passwords & Password Managers
  ('31000000-0000-0000-0000-000000000003', 'What Makes a Password Strong', 'ما الذي يجعل كلمة المرور قوية',
   'Length matters more than complexity. Use passphrases of 16+ characters and avoid reuse across accounts.',
   'الطول أهم من التعقيد. استخدم عبارات مرور تتكون من 16 حرفًا أو أكثر وتجنب إعادة استخدامها عبر الحسابات.',
   1, 8),
  ('31000000-0000-0000-0000-000000000003', 'Using a Password Manager', 'استخدام مدير كلمات المرور',
   'Password managers generate and store unique credentials for every account, removing the need to memorize them.',
   'تقوم مديرات كلمات المرور بإنشاء وتخزين بيانات اعتماد فريدة لكل حساب، مما يلغي الحاجة لحفظها.',
   2, 8),
  ('31000000-0000-0000-0000-000000000003', 'Recognizing Credential Stuffing', 'التعرف على هجمات حشو بيانات الاعتماد',
   'Reused passwords let attackers break into many accounts using leaked credentials from other breaches.',
   'تتيح كلمات المرور المعاد استخدامها للمهاجمين اختراق العديد من الحسابات باستخدام بيانات اعتماد مسربة من اختراقات أخرى.',
   3, 9),

  -- 4. Multi-Factor Authentication Essentials
  ('31000000-0000-0000-0000-000000000004', 'Why MFA Matters', 'لماذا تهم المصادقة متعددة العوامل',
   'MFA adds a second layer of proof beyond your password, blocking most account takeover attempts even if a password is leaked.',
   'تضيف المصادقة متعددة العوامل طبقة إثبات ثانية إلى جانب كلمة المرور، مما يمنع معظم محاولات الاستيلاء على الحساب حتى لو تم تسريب كلمة المرور.',
   1, 7),
  ('31000000-0000-0000-0000-000000000004', 'Authenticator Apps vs SMS', 'تطبيقات المصادقة مقابل الرسائل النصية',
   'Authenticator apps (TOTP) are more secure than SMS codes, which can be intercepted via SIM swapping.',
   'تطبيقات المصادقة (TOTP) أكثر أمانًا من رموز الرسائل النصية، التي يمكن اعتراضها عبر استبدال شريحة SIM.',
   2, 7),
  ('31000000-0000-0000-0000-000000000004', 'MFA Fatigue Attacks', 'هجمات إرهاق المصادقة متعددة العوامل',
   'Attackers may spam approval requests hoping you accept by mistake. Always deny unexpected MFA prompts and report them.',
   'قد يقوم المهاجمون بإغراق طلبات الموافقة على أمل أن تقبلها عن طريق الخطأ. ارفض دائمًا طلبات المصادقة غير المتوقعة وأبلغ عنها.',
   3, 6),

  -- 5. Data Classification & Handling
  ('31000000-0000-0000-0000-000000000005', 'Classification Levels', 'مستويات التصنيف',
   'Understand the difference between Public, Internal, Confidential, and Restricted data and how to label it.',
   'افهم الفرق بين البيانات العامة والداخلية والسرية والمقيدة وكيفية تصنيفها.',
   1, 12),
  ('31000000-0000-0000-0000-000000000005', 'Sharing & Storage Rules', 'قواعد المشاركة والتخزين',
   'Confidential data must only be shared via approved channels and stored in approved, encrypted locations.',
   'يجب مشاركة البيانات السرية فقط عبر القنوات المعتمدة وتخزينها في مواقع معتمدة ومشفرة.',
   2, 12),
  ('31000000-0000-0000-0000-000000000005', 'Data Retention & Disposal', 'الاحتفاظ بالبيانات والتخلص منها',
   'Dispose of sensitive data securely once it is no longer needed, following retention policy timelines.',
   'تخلص من البيانات الحساسة بشكل آمن بمجرد عدم الحاجة إليها، باتباع الجداول الزمنية لسياسة الاحتفاظ بالبيانات.',
   3, 11),

  -- 6. GDPR & Regional Privacy Regulations
  ('31000000-0000-0000-0000-000000000006', 'Core Privacy Principles', 'مبادئ الخصوصية الأساسية',
   'Lawfulness, purpose limitation, data minimization, and accountability form the foundation of modern privacy law.',
   'تشكل الشرعية وتحديد الغرض وتقليل البيانات والمساءلة أساس قانون الخصوصية الحديث.',
   1, 14),
  ('31000000-0000-0000-0000-000000000006', 'GCC Data Protection Laws', 'قوانين حماية البيانات في دول الخليج',
   'An overview of UAE, Saudi, and other regional data protection frameworks and what they require of employees.',
   'نظرة عامة على أطر حماية البيانات في الإمارات والسعودية ودول أخرى في المنطقة وما تتطلبه من الموظفين.',
   2, 14),
  ('31000000-0000-0000-0000-000000000006', 'Reporting a Data Breach', 'الإبلاغ عن خرق البيانات',
   'Know your obligation to report suspected data breaches immediately to your compliance team.',
   'تعرف على التزامك بالإبلاغ الفوري عن أي خرق محتمل للبيانات إلى فريق الامتثال لديك.',
   3, 12),

  -- 7. Social Engineering Tactics Unmasked
  ('31000000-0000-0000-0000-000000000007', 'The Psychology of Persuasion', 'علم نفس الإقناع',
   'Authority, urgency, scarcity, and social proof are levers attackers pull to bypass your better judgment.',
   'السلطة والإلحاح والندرة والإثبات الاجتماعي هي روافع يستخدمها المهاجمون لتجاوز حكمك السليم.',
   1, 10),
  ('31000000-0000-0000-0000-000000000007', 'Vishing & Smishing', 'التصيد الصوتي والنصي',
   'Phone calls (vishing) and SMS messages (smishing) are increasingly used to harvest credentials and OTPs.',
   'يتم استخدام المكالمات الهاتفية (التصيد الصوتي) والرسائل النصية (التصيد عبر الرسائل القصيرة) بشكل متزايد لجمع بيانات الاعتماد ورموز التحقق.',
   2, 10),
  ('31000000-0000-0000-0000-000000000007', 'Building a Verification Habit', 'بناء عادة التحقق',
   'Pause and verify any unexpected request through an independent, known channel before acting.',
   'توقف وتحقق من أي طلب غير متوقع من خلال قناة مستقلة وموثوقة قبل التصرف.',
   3, 10),

  -- 8. Pretexting, Baiting & Tailgating
  ('31000000-0000-0000-0000-000000000008', 'Pretexting Scenarios', 'سيناريوهات انتحال الهوية',
   'Attackers may pose as IT support, vendors, or auditors to gain access or information.',
   'قد ينتحل المهاجمون صفة الدعم الفني أو الموردين أو المدققين للحصول على الوصول أو المعلومات.',
   1, 12),
  ('31000000-0000-0000-0000-000000000008', 'USB Baiting & Physical Drops', 'الإغراء عبر USB والأجهزة المتروكة',
   'Never plug in unknown USB drives found in parking lots or common areas — report them to security instead.',
   'لا تقم أبدًا بتوصيل أجهزة USB مجهولة المصدر تجدها في مواقف السيارات أو الأماكن العامة - أبلغ عنها للأمن بدلاً من ذلك.',
   2, 11),
  ('31000000-0000-0000-0000-000000000008', 'Tailgating & Badge Security', 'التسلل وأمان البطاقات',
   'Never hold the door for someone without a visible badge. Politely direct them to reception.',
   'لا تقم أبدًا بفتح الباب لشخص بدون بطاقة هوية ظاهرة. وجهه بأدب إلى الاستقبال.',
   3, 12),

  -- 9. Securing Mobile Devices & BYOD
  ('31000000-0000-0000-0000-000000000009', 'Device Encryption & Lock Screens', 'تشفير الجهاز وشاشات القفل',
   'Always enable device encryption, a strong PIN or biometric lock, and automatic screen timeout.',
   'قم دائمًا بتمكين تشفير الجهاز وقفل شاشة قوي بالرقم السري أو البصمة وانتهاء مهلة الشاشة التلقائي.',
   1, 8),
  ('31000000-0000-0000-0000-000000000009', 'App Permissions & Updates', 'أذونات التطبيقات والتحديثات',
   'Review app permissions regularly and keep your operating system and apps updated to patch vulnerabilities.',
   'راجع أذونات التطبيقات بانتظام وحافظ على تحديث نظام التشغيل والتطبيقات لسد الثغرات الأمنية.',
   2, 8),
  ('31000000-0000-0000-0000-000000000009', 'BYOD Policy Basics', 'أساسيات سياسة إحضار جهازك الخاص',
   'Personal devices used for work must meet minimum security standards set by your organization.',
   'يجب أن تستوفي الأجهزة الشخصية المستخدمة في العمل الحد الأدنى من معايير الأمان التي تحددها مؤسستك.',
   3, 9),

  -- 10. Safe Remote Work Practices
  ('31000000-0000-0000-0000-000000000010', 'Securing Your Home Network', 'تأمين شبكتك المنزلية',
   'Change default router passwords, enable WPA3 encryption, and keep router firmware updated.',
   'قم بتغيير كلمات مرور جهاز التوجيه الافتراضية، وتمكين تشفير WPA3، والحفاظ على تحديث برامج جهاز التوجيه.',
   1, 7),
  ('31000000-0000-0000-0000-000000000010', 'Public Wi-Fi Risks', 'مخاطر الواي فاي العام',
   'Avoid accessing sensitive systems on public Wi-Fi without a VPN — traffic can be intercepted by others on the network.',
   'تجنب الوصول إلى الأنظمة الحساسة عبر الواي فاي العام بدون VPN - يمكن اعتراض حركة المرور من قبل آخرين على الشبكة.',
   2, 7),
  ('31000000-0000-0000-0000-000000000010', 'Video Call & Screen Share Hygiene', 'نظافة مكالمات الفيديو ومشاركة الشاشة',
   'Close sensitive documents and notifications before screen sharing, and use waiting rooms for meetings.',
   'أغلق المستندات والإشعارات الحساسة قبل مشاركة الشاشة، واستخدم غرف الانتظار للاجتماعات.',
   3, 6);
