-- ============================================================================
-- SEED 04: Assessments — 1 psychometric behavioral profile + 2 security
-- knowledge quizzes, with questions.
--
-- All scoped to the demo tenant (Al Falah Holdings).
-- ============================================================================

insert into public.assessments (id, tenant_id, title, title_ar, description, description_ar, type, passing_score, duration_minutes, is_published) values
  ('50000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001',
   'Cybersecurity Behavioral Profile', 'الملف السلوكي للأمن السيبراني',
   'A psychometric assessment measuring your compliance, curiosity, stress tolerance, and susceptibility to social engineering.',
   'تقييم نفسي يقيس مدى التزامك وفضولك وتحملك للضغط وقابليتك للتأثر بالهندسة الاجتماعية.',
   'psychometric', 0, 15, true),

  ('50000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001',
   'Security Awareness Knowledge Check', 'اختبار الوعي الأمني',
   'A general knowledge quiz covering passwords, malware, social engineering, and data handling.',
   'اختبار معرفة عام يغطي كلمات المرور والبرمجيات الخبيثة والهندسة الاجتماعية والتعامل مع البيانات.',
   'security_knowledge', 70, 15, true),

  ('50000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001',
   'Phishing Identification Quiz', 'اختبار التعرف على التصيد الاحتيالي',
   'Test your ability to spot phishing attempts across email, SMS, and messaging apps.',
   'اختبر قدرتك على اكتشاف محاولات التصيد الاحتيالي عبر البريد الإلكتروني والرسائل النصية وتطبيقات المراسلة.',
   'security_knowledge', 70, 10, true);

-- ----------------------------------------------------------------------------
-- 1. Cybersecurity Behavioral Profile — 12 psychometric questions
--    (3 each: compliance, curiosity, stress_tolerance, social_engineering_susceptibility)
--    5-point Likert scale, no "correct" answer — dimension scoring only.
-- ----------------------------------------------------------------------------
insert into public.assessment_questions (assessment_id, question, question_ar, options, correct_answer, dimension, order_index, points) values
  ('50000000-0000-0000-0000-000000000001',
   'I always follow company security policies, even when they slow down my work.',
   'ألتزم دائمًا بسياسات أمن الشركة حتى عندما تبطئ من سرعة عملي.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'compliance', 1, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I report security incidents and suspicious activity even if I am not sure they matter.',
   'أبلغ عن الحوادث الأمنية والأنشطة المشبوهة حتى لو لم أكن متأكدًا من أهميتها.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'compliance', 2, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I keep my passwords and access credentials confidential, even from coworkers I trust.',
   'أحافظ على سرية كلمات المرور وبيانات الوصول الخاصة بي حتى من زملائي الذين أثق بهم.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'compliance', 3, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I often click on links or attachments out of curiosity, even from unknown senders.',
   'غالبًا ما أنقر على الروابط أو المرفقات بدافع الفضول حتى من مرسلين مجهولين.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'curiosity', 4, 1),

  ('50000000-0000-0000-0000-000000000001',
   'When I see a sensational headline or offer, I want to investigate it immediately.',
   'عندما أرى عنوانًا مثيرًا أو عرضًا مغريًا، أرغب في التحقق منه على الفور.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'curiosity', 5, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I plug in USB drives or connect new devices I find or receive without checking with IT first.',
   'أقوم بتوصيل أجهزة USB أو ربط أجهزة جديدة أجدها أو أستلمها دون التحقق مع تقنية المعلومات أولاً.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'curiosity', 6, 1),

  ('50000000-0000-0000-0000-000000000001',
   'When I am under pressure or rushing to meet a deadline, I am more likely to skip security checks.',
   'عندما أكون تحت ضغط أو أسارع لإنجاز موعد نهائي، أكون أكثر عرضة لتخطي إجراءات الأمان.',
   '[{"key":"a","text":"Strongly Agree","text_ar":"موافق بشدة"},{"key":"b","text":"Agree","text_ar":"موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Disagree","text_ar":"غير موافق"},{"key":"e","text":"Strongly Disagree","text_ar":"غير موافق بشدة"}]',
   null, 'stress_tolerance', 7, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I can stay calm and follow proper procedures even when handling an urgent request from senior management.',
   'يمكنني البقاء هادئًا واتباع الإجراءات الصحيحة حتى عند التعامل مع طلب عاجل من الإدارة العليا.',
   '[{"key":"a","text":"Strongly Disagree","text_ar":"غير موافق بشدة"},{"key":"b","text":"Disagree","text_ar":"غير موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Agree","text_ar":"موافق"},{"key":"e","text":"Strongly Agree","text_ar":"موافق بشدة"}]',
   null, 'stress_tolerance', 8, 1),

  ('50000000-0000-0000-0000-000000000001',
   'High workload makes me more likely to reuse passwords or take security shortcuts.',
   'يجعلني عبء العمل المرتفع أكثر عرضة لإعادة استخدام كلمات المرور أو اتخاذ اختصارات أمنية.',
   '[{"key":"a","text":"Strongly Agree","text_ar":"موافق بشدة"},{"key":"b","text":"Agree","text_ar":"موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Disagree","text_ar":"غير موافق"},{"key":"e","text":"Strongly Disagree","text_ar":"غير موافق بشدة"}]',
   null, 'stress_tolerance', 9, 1),

  ('50000000-0000-0000-0000-000000000001',
   'If someone calls claiming to be from IT support and asks for my password to "fix an issue," I would provide it.',
   'إذا اتصل بي شخص يدعي أنه من الدعم الفني وطلب كلمة المرور الخاصة بي "لإصلاح مشكلة"، فسأقدمها.',
   '[{"key":"a","text":"Strongly Agree","text_ar":"موافق بشدة"},{"key":"b","text":"Agree","text_ar":"موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Disagree","text_ar":"غير موافق"},{"key":"e","text":"Strongly Disagree","text_ar":"غير موافق بشدة"}]',
   null, 'social_engineering_susceptibility', 10, 1),

  ('50000000-0000-0000-0000-000000000001',
   'An email from my "manager" asking me to urgently buy gift cards would make me act immediately without verifying.',
   'رسالة بريد إلكتروني من "مديري" تطلب شراء بطاقات هدايا بشكل عاجل ستجعلني أتصرف فورًا دون التحقق.',
   '[{"key":"a","text":"Strongly Agree","text_ar":"موافق بشدة"},{"key":"b","text":"Agree","text_ar":"موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Disagree","text_ar":"غير موافق"},{"key":"e","text":"Strongly Disagree","text_ar":"غير موافق بشدة"}]',
   null, 'social_engineering_susceptibility', 11, 1),

  ('50000000-0000-0000-0000-000000000001',
   'I would hold the door open for someone in a uniform without checking their badge.',
   'سأقوم بفتح الباب لشخص يرتدي زيًا رسميًا دون التحقق من بطاقته.',
   '[{"key":"a","text":"Strongly Agree","text_ar":"موافق بشدة"},{"key":"b","text":"Agree","text_ar":"موافق"},{"key":"c","text":"Neutral","text_ar":"محايد"},{"key":"d","text":"Disagree","text_ar":"غير موافق"},{"key":"e","text":"Strongly Disagree","text_ar":"غير موافق بشدة"}]',
   null, 'social_engineering_susceptibility', 12, 1);

-- ----------------------------------------------------------------------------
-- 2. Security Awareness Knowledge Check — 10 multiple-choice questions
-- ----------------------------------------------------------------------------
insert into public.assessment_questions (assessment_id, question, question_ar, options, correct_answer, dimension, order_index, points) values
  ('50000000-0000-0000-0000-000000000002',
   'Which of the following is the strongest password?',
   'أي مما يلي هي كلمة المرور الأقوى؟',
   '[{"key":"a","text":"Password123","text_ar":"Password123"},{"key":"b","text":"MyDog2020!","text_ar":"MyDog2020!"},{"key":"c","text":"Tr0ub4dor&3-Sunset-Falcon-92","text_ar":"Tr0ub4dor&3-Sunset-Falcon-92"},{"key":"d","text":"123456","text_ar":"123456"}]',
   'c', null, 1, 1),

  ('50000000-0000-0000-0000-000000000002',
   'What should you do if you receive an email asking you to verify your account by clicking a link?',
   'ماذا يجب أن تفعل إذا تلقيت بريدًا إلكترونيًا يطلب منك التحقق من حسابك بالنقر على رابط؟',
   '[{"key":"a","text":"Click it immediately to avoid account suspension","text_ar":"انقر عليه فورًا لتجنب تعليق الحساب"},{"key":"b","text":"Verify the sender and navigate to the site directly instead of clicking","text_ar":"تحقق من المرسل وانتقل إلى الموقع مباشرة بدلاً من النقر"},{"key":"c","text":"Forward it to a personal email account","text_ar":"أعد توجيهه إلى حساب بريد إلكتروني شخصي"},{"key":"d","text":"Reply with your password to confirm","text_ar":"رد بكلمة المرور للتأكيد"}]',
   'b', null, 2, 1),

  ('50000000-0000-0000-0000-000000000002',
   'What is multi-factor authentication (MFA)?',
   'ما هي المصادقة متعددة العوامل (MFA)؟',
   '[{"key":"a","text":"Using the same password on multiple sites","text_ar":"استخدام نفس كلمة المرور على مواقع متعددة"},{"key":"b","text":"A second verification step beyond your password","text_ar":"خطوة تحقق ثانية بالإضافة إلى كلمة المرور"},{"key":"c","text":"Changing your password every multiple days","text_ar":"تغيير كلمة المرور كل عدة أيام"},{"key":"d","text":"Sharing your login with a manager","text_ar":"مشاركة بيانات الدخول مع المدير"}]',
   'b', null, 3, 1),

  ('50000000-0000-0000-0000-000000000002',
   'Ransomware is a type of malware that:',
   'برامج الفدية هي نوع من البرمجيات الخبيثة التي:',
   '[{"key":"a","text":"Speeds up your computer","text_ar":"تسرّع جهاز الكمبيوتر الخاص بك"},{"key":"b","text":"Encrypts your files and demands payment for access","text_ar":"تقوم بتشفير ملفاتك وتطلب دفعًا مقابل الوصول إليها"},{"key":"c","text":"Improves network security","text_ar":"تحسّن أمان الشبكة"},{"key":"d","text":"Is a type of antivirus software","text_ar":"هي نوع من برامج مكافحة الفيروسات"}]',
   'b', null, 4, 1),

  ('50000000-0000-0000-0000-000000000002',
   'Which of these is considered Personally Identifiable Information (PII)?',
   'أي مما يلي يعتبر معلومات تعريف شخصية (PII)؟',
   '[{"key":"a","text":"A national ID number","text_ar":"رقم الهوية الوطنية"},{"key":"b","text":"The company logo","text_ar":"شعار الشركة"},{"key":"c","text":"A public press release","text_ar":"بيان صحفي عام"},{"key":"d","text":"The office floor plan","text_ar":"مخطط مكاتب الشركة"}]',
   'a', null, 5, 1),

  ('50000000-0000-0000-0000-000000000002',
   'You receive a call from someone claiming to be from "IT" asking for your password to fix an urgent issue. You should:',
   'تلقيت مكالمة من شخص يدعي أنه من "تقنية المعلومات" ويطلب كلمة المرور الخاصة بك لإصلاح مشكلة عاجلة. يجب أن:',
   '[{"key":"a","text":"Provide it since IT needs access","text_ar":"تقدمها لأن تقنية المعلومات تحتاج إلى الوصول"},{"key":"b","text":"Hang up and verify through official IT channels","text_ar":"تنهي المكالمة وتتحقق عبر القنوات الرسمية لتقنية المعلومات"},{"key":"c","text":"Give a slightly different password","text_ar":"تعطيه كلمة مرور مختلفة قليلاً"},{"key":"d","text":"Ask a coworker to give their password instead","text_ar":"تطلب من زميل إعطاء كلمة مروره بدلاً منك"}]',
   'b', null, 6, 1),

  ('50000000-0000-0000-0000-000000000002',
   'What is the safest way to connect to company systems while working from a coffee shop?',
   'ما هي الطريقة الأكثر أمانًا للاتصال بأنظمة الشركة أثناء العمل من مقهى؟',
   '[{"key":"a","text":"Use the coffee shop''s open Wi-Fi directly","text_ar":"استخدام شبكة الواي فاي المفتوحة للمقهى مباشرة"},{"key":"b","text":"Use a company-approved VPN","text_ar":"استخدام شبكة VPN معتمدة من الشركة"},{"key":"c","text":"Ask the barista for the admin Wi-Fi password","text_ar":"طلب كلمة مرور واي فاي المسؤول من النادل"},{"key":"d","text":"Disable your firewall for faster speeds","text_ar":"تعطيل جدار الحماية لزيادة السرعة"}]',
   'b', null, 7, 1),

  ('50000000-0000-0000-0000-000000000002',
   'Which action best protects sensitive documents on a shared printer?',
   'أي إجراء يحمي بشكل أفضل المستندات الحساسة على طابعة مشتركة؟',
   '[{"key":"a","text":"Leave printed documents in the tray for pickup later","text_ar":"ترك المستندات المطبوعة في الدرج لاستلامها لاحقًا"},{"key":"b","text":"Use secure/follow-me printing and collect immediately","text_ar":"استخدام الطباعة الآمنة/اتبعني واستلام المستند فورًا"},{"key":"c","text":"Email the document to the printer's public address","text_ar":"إرسال المستند إلى عنوان البريد العام للطابعة"},{"key":"d","text":"Print extra copies just in case","text_ar":"طباعة نسخ إضافية احتياطًا"}]',
   'b', null, 8, 1),

  ('50000000-0000-0000-0000-000000000002',
   'A coworker asks to borrow your access badge to enter a restricted area because they forgot theirs. You should:',
   'يطلب منك زميل استعارة بطاقة الدخول الخاصة بك للدخول إلى منطقة مقيدة لأنه نسي بطاقته. يجب أن:',
   '[{"key":"a","text":"Lend it, since you trust them","text_ar":"تعيرها له لأنك تثق به"},{"key":"b","text":"Politely decline and direct them to security/reception","text_ar":"ترفض بأدب وتوجهه إلى الأمن/الاستقبال"},{"key":"c","text":"Let them follow closely behind you through the door","text_ar":"تتركه يتبعك عن قرب عبر الباب"},{"key":"d","text":"Give them your PIN code instead","text_ar":"تعطيه رمز PIN الخاص بك بدلاً من ذلك"}]',
   'b', null, 9, 1),

  ('50000000-0000-0000-0000-000000000002',
   'Why should software updates be installed promptly?',
   'لماذا يجب تثبيت تحديثات البرامج على الفور؟',
   '[{"key":"a","text":"They make the interface look different","text_ar":"تجعل الواجهة تبدو مختلفة"},{"key":"b","text":"They patch known security vulnerabilities","text_ar":"تقوم بسد الثغرات الأمنية المعروفة"},{"key":"c","text":"They are required by your internet provider","text_ar":"مطلوبة من قبل مزود خدمة الإنترنت"},{"key":"d","text":"They free up desk space","text_ar":"تخلي مساحة على المكتب"}]',
   'b', null, 10, 1);

-- ----------------------------------------------------------------------------
-- 3. Phishing Identification Quiz — 8 multiple-choice questions
-- ----------------------------------------------------------------------------
insert into public.assessment_questions (assessment_id, question, question_ar, options, correct_answer, dimension, order_index, points) values
  ('50000000-0000-0000-0000-000000000003',
   'An email from "support@yourbank-secure-verify.com" asks you to confirm your account. What stands out as suspicious?',
   'بريد إلكتروني من "support@yourbank-secure-verify.com" يطلب منك تأكيد حسابك. ما الذي يبدو مشبوهًا؟',
   '[{"key":"a","text":"The greeting says your name","text_ar":"التحية تذكر اسمك"},{"key":"b","text":"The domain is not the bank''s official domain","text_ar":"النطاق ليس النطاق الرسمي للبنك"},{"key":"c","text":"It was sent during business hours","text_ar":"تم إرساله خلال ساعات العمل"},{"key":"d","text":"It includes the bank''s logo","text_ar":"يحتوي على شعار البنك"}]',
   'b', null, 1, 1),

  ('50000000-0000-0000-0000-000000000003',
   'A WhatsApp message from an unknown number claims you''ve won a prize and asks you to click a link to claim it. This is most likely:',
   'رسالة واتساب من رقم مجهول تدعي فوزك بجائزة وتطلب منك النقر على رابط للمطالبة بها. هذا على الأرجح:',
   '[{"key":"a","text":"A legitimate promotion","text_ar":"عرض ترويجي حقيقي"},{"key":"b","text":"A phishing/smishing attempt","text_ar":"محاولة تصيد احتيالي عبر الرسائل"},{"key":"c","text":"A message from your bank","text_ar":"رسالة من بنكك"},{"key":"d","text":"A government notice","text_ar":"إشعار حكومي"}]',
   'b', null, 2, 1),

  ('50000000-0000-0000-0000-000000000003',
   'Which sender display name is most likely spoofed?',
   'أي اسم عرض للمرسل من الأرجح أن يكون مزيفًا؟',
   '[{"key":"a","text":"\"HR Department\" <hr@company.com>","text_ar":"\"قسم الموارد البشرية\" <hr@company.com>"},{"key":"b","text":"\"CEO Khalid Al Mazrouei\" <ceo.urgent@gmail.com>","text_ar":"\"الرئيس التنفيذي خالد المزروعي\" <ceo.urgent@gmail.com>"},{"key":"c","text":"\"IT Helpdesk\" <it@company.com>","text_ar":"\"الدعم الفني\" <it@company.com>"},{"key":"d","text":"\"Payroll\" <payroll@company.com>","text_ar":"\"الرواتب\" <payroll@company.com>"}]',
   'b', null, 3, 1),

  ('50000000-0000-0000-0000-000000000003',
   'A QR code on a flyer in the office break room offers a "free gift" if you scan it. The safest action is to:',
   'يعرض رمز QR على ملصق في غرفة الاستراحة "هدية مجانية" عند مسحه. الإجراء الأكثر أمانًا هو:',
   '[{"key":"a","text":"Scan it immediately for the gift","text_ar":"مسحه فورًا للحصول على الهدية"},{"key":"b","text":"Avoid scanning unsolicited QR codes and report the flyer","text_ar":"تجنب مسح رموز QR غير المرغوبة والإبلاغ عن الملصق"},{"key":"c","text":"Scan it but don''t enter any information","text_ar":"مسحه دون إدخال أي معلومات"},{"key":"d","text":"Share the QR code with coworkers","text_ar":"مشاركة رمز QR مع الزملاء"}]',
   'b', null, 4, 1),

  ('50000000-0000-0000-0000-000000000003',
   'An invoice email asks you to update vendor bank details for an upcoming payment. Best practice is to:',
   'يطلب بريد إلكتروني للفاتورة منك تحديث تفاصيل البنك الخاصة بالمورد لدفعة قادمة. أفضل ممارسة هي:',
   '[{"key":"a","text":"Update the details immediately to avoid late payment","text_ar":"تحديث التفاصيل فورًا لتجنب التأخير في الدفع"},{"key":"b","text":"Call the vendor using a known phone number to verify the change","text_ar":"الاتصال بالمورد باستخدام رقم هاتف معروف للتحقق من التغيير"},{"key":"c","text":"Reply to the email confirming the new details","text_ar":"الرد على البريد الإلكتروني بتأكيد التفاصيل الجديدة"},{"key":"d","text":"Forward the email to finance without comment","text_ar":"إعادة توجيه البريد الإلكتروني إلى المالية دون تعليق"}]',
   'b', null, 5, 1),

  ('50000000-0000-0000-0000-000000000003',
   'Which URL is most likely a phishing link impersonating "alfalah-holdings.com"?',
   'أي رابط من المرجح أن يكون رابط تصيد ينتحل صفة "alfalah-holdings.com"؟',
   '[{"key":"a","text":"https://alfalah-holdings.com/login","text_ar":"https://alfalah-holdings.com/login"},{"key":"b","text":"https://alfalah-holdings.com.verify-secure.net/login","text_ar":"https://alfalah-holdings.com.verify-secure.net/login"},{"key":"c","text":"https://portal.alfalah-holdings.com","text_ar":"https://portal.alfalah-holdings.com"},{"key":"d","text":"https://alfalah-holdings.com/hr/payroll","text_ar":"https://alfalah-holdings.com/hr/payroll"}]',
   'b', null, 6, 1),

  ('50000000-0000-0000-0000-000000000003',
   'An email creates urgency by saying "Your account will be suspended in 1 hour unless you act now." This tactic is called:',
   'يخلق بريد إلكتروني شعورًا بالإلحاح بالقول "سيتم تعليق حسابك خلال ساعة ما لم تتصرف الآن." يسمى هذا الأسلوب:',
   '[{"key":"a","text":"Urgency/pressure manipulation","text_ar":"التلاعب بالإلحاح/الضغط"},{"key":"b","text":"Two-factor authentication","text_ar":"المصادقة الثنائية"},{"key":"c","text":"Data encryption","text_ar":"تشفير البيانات"},{"key":"d","text":"Routine maintenance notice","text_ar":"إشعار صيانة روتيني"}]',
   'a', null, 7, 1),

  ('50000000-0000-0000-0000-000000000003',
   'You accidentally clicked a suspicious link but did not enter any information. What should you do next?',
   'نقرت عن طريق الخطأ على رابط مشبوه ولكن لم تدخل أي معلومات. ماذا يجب أن تفعل بعد ذلك؟',
   '[{"key":"a","text":"Ignore it, no harm done","text_ar":"تجاهل الأمر، لا ضرر حدث"},{"key":"b","text":"Report it to security/IT immediately","text_ar":"الإبلاغ عنه للأمن/تقنية المعلومات فورًا"},{"key":"c","text":"Delete the email and tell no one","text_ar":"حذف البريد الإلكتروني وعدم إخبار أحد"},{"key":"d","text":"Forward it to friends as a warning only","text_ar":"إعادة توجيهه للأصدقاء كتحذير فقط"}]',
   'b', null, 8, 1);
