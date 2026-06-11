-- ============================================================================
-- SEED 05: Phishing simulation template library (global, tenant_id = null)
--
-- 56 bilingual (EN + AR) templates across 7 categories:
-- banking, government, hr_payroll, invoice_fraud, delivery, whatsapp, qr_code
--
-- Each row contains both English and Arabic copy; `language` marks the
-- primary simulated language for the campaign variant.
-- `landing_page_url` points to the in-app simulated landing page that
-- records a "clicked" event.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- BANKING (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000001', null, 'Suspicious Login Attempt', 'محاولة تسجيل دخول مشبوهة', 'banking', 'en', 'easy',
 'Security Alert: New sign-in to your account', 'تنبيه أمني: تسجيل دخول جديد إلى حسابك',
 'Al Falah Bank Security', 'أمن بنك الفلاح', 'security@al-falah-bank-secure-alerts.com',
 '<p>Dear Customer,</p><p>We detected a new sign-in to your online banking account from an unrecognized device. If this was not you, please verify your identity immediately to secure your account.</p><p><a href="{{link}}">Verify My Account</a></p><p>Al Falah Bank Security Team</p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>لاحظنا تسجيل دخول جديد إلى حسابك المصرفي عبر الإنترنت من جهاز غير معروف. إذا لم تكن أنت من قام بذلك، يرجى التحقق من هويتك فورًا لتأمين حسابك.</p><p><a href="{{link}}">تحقق من حسابي</a></p><p>فريق أمن بنك الفلاح</p></div>',
 '/phishing-landing/banking-login-alert'),

('60000000-0000-0000-0000-000000000002', null, 'Account Verification Required', 'مطلوب التحقق من الحساب', 'banking', 'en', 'medium',
 'Action Required: Verify your account within 24 hours', 'إجراء مطلوب: تحقق من حسابك خلال 24 ساعة',
 'Al Falah Bank', 'بنك الفلاح', 'noreply@alfalahbank-verify.com',
 '<p>Dear Valued Customer,</p><p>As part of our routine security upgrade, we require all customers to re-verify their account details. Failure to do so within 24 hours may result in temporary suspension of your account.</p><p><a href="{{link}}">Verify Now</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>كجزء من تحديث الأمان الروتيني، نطلب من جميع العملاء إعادة التحقق من بيانات حساباتهم. عدم القيام بذلك خلال 24 ساعة قد يؤدي إلى تعليق حسابك مؤقتًا.</p><p><a href="{{link}}">تحقق الآن</a></p></div>',
 '/phishing-landing/banking-verify-account'),

('60000000-0000-0000-0000-000000000003', null, 'Unusual Transaction Detected', 'تم اكتشاف معاملة غير عادية', 'banking', 'en', 'medium',
 'We blocked a suspicious transaction on your card', 'لقد قمنا بحظر معاملة مشبوهة على بطاقتك',
 'Al Falah Bank Fraud Team', 'فريق مكافحة الاحتيال - بنك الفلاح', 'fraud-alerts@al-falahbank.net',
 '<p>Dear Customer,</p><p>A transaction of AED 4,250.00 was attempted on your debit card and has been temporarily blocked. If you do not recognize this transaction, click below to dispute it and unlock your card.</p><p><a href="{{link}}">Review Transaction</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>تمت محاولة إجراء معاملة بقيمة 4,250.00 درهم على بطاقتك وتم حظرها مؤقتًا. إذا كنت لا تتعرف على هذه المعاملة، انقر أدناه للاعتراض عليها وإلغاء قفل بطاقتك.</p><p><a href="{{link}}">مراجعة المعاملة</a></p></div>',
 '/phishing-landing/banking-transaction-alert'),

('60000000-0000-0000-0000-000000000004', null, 'Your Card Has Been Locked', 'تم قفل بطاقتك', 'banking', 'en', 'hard',
 'Your debit card has been locked for your protection', 'تم قفل بطاقة الخصم الخاصة بك لحمايتك',
 'Al Falah Bank Customer Care', 'خدمة عملاء بنك الفلاح', 'cards@alfalah-cardservices.com',
 '<p>Dear Customer,</p><p>Your debit card ending in 4471 has been temporarily locked due to multiple failed PIN attempts. To restore access, please confirm your card details and identity through our secure portal.</p><p><a href="{{link}}">Unlock My Card</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>تم قفل بطاقة الخصم الخاصة بك المنتهية بالرقم 4471 مؤقتًا بسبب محاولات متعددة فاشلة لإدخال الرقم السري. لاستعادة الوصول، يرجى تأكيد بيانات بطاقتك وهويتك عبر بوابتنا الآمنة.</p><p><a href="{{link}}">إلغاء قفل بطاقتي</a></p></div>',
 '/phishing-landing/banking-card-locked'),

('60000000-0000-0000-0000-000000000005', null, 'Reward Points Expiring', 'نقاط المكافآت على وشك الانتهاء', 'banking', 'ar', 'easy',
 'Your reward points are about to expire', 'نقاط مكافآتك على وشك الانتهاء - استبدلها الآن',
 'Al Falah Bank Rewards', 'مكافآت بنك الفلاح', 'rewards@al-falah-rewards.com',
 '<p>Dear Customer,</p><p>You have 12,500 reward points expiring in 48 hours. Redeem them now before they are lost permanently.</p><p><a href="{{link}}">Redeem Points</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>لديك 12,500 نقطة مكافآت ستنتهي صلاحيتها خلال 48 ساعة. استبدلها الآن قبل أن تفقدها نهائيًا.</p><p><a href="{{link}}">استبدال النقاط</a></p></div>',
 '/phishing-landing/banking-rewards-expiring'),

('60000000-0000-0000-0000-000000000006', null, 'Mobile Banking App Update', 'تحديث تطبيق الخدمات المصرفية عبر الهاتف', 'banking', 'ar', 'medium',
 'Important: Update your mobile banking app now', 'هام: قم بتحديث تطبيق الخدمات المصرفية الآن',
 'Al Falah Digital Banking', 'الخدمات المصرفية الرقمية - بنك الفلاح', 'updates@alfalah-digitalapp.com',
 '<p>Dear Customer,</p><p>A critical security update is available for your mobile banking app. Older versions will stop working after this week. Update now to avoid losing access to your account.</p><p><a href="{{link}}">Update App</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>يتوفر تحديث أمني هام لتطبيق الخدمات المصرفية عبر الهاتف. ستتوقف الإصدارات القديمة عن العمل بعد هذا الأسبوع. قم بالتحديث الآن لتجنب فقدان الوصول إلى حسابك.</p><p><a href="{{link}}">تحديث التطبيق</a></p></div>',
 '/phishing-landing/banking-app-update'),

('60000000-0000-0000-0000-000000000007', null, 'IBAN Update Confirmation', 'تأكيد تحديث رقم الآيبان', 'banking', 'ar', 'hard',
 'Confirm your updated IBAN details', 'يرجى تأكيد بيانات رقم الآيبان المحدثة',
 'Al Falah Bank Operations', 'عمليات بنك الفلاح', 'operations@al-falahbank-ops.com',
 '<p>Dear Customer,</p><p>Due to a system migration, your IBAN requires re-confirmation to continue receiving transfers without interruption. Please confirm your details within 48 hours.</p><p><a href="{{link}}">Confirm IBAN</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>بسبب عملية ترحيل النظام، يتطلب رقم الآيبان الخاص بك إعادة تأكيد لمواصلة استلام التحويلات دون انقطاع. يرجى تأكيد بياناتك خلال 48 ساعة.</p><p><a href="{{link}}">تأكيد رقم الآيبان</a></p></div>',
 '/phishing-landing/banking-iban-confirm'),

('60000000-0000-0000-0000-000000000008', null, 'Suspicious Wire Transfer Hold', 'إيقاف تحويل مالي مشبوه', 'banking', 'ar', 'hard',
 'A wire transfer from your account is on hold', 'تم إيقاف تحويل مالي من حسابك مؤقتًا',
 'Al Falah Bank Compliance', 'الامتثال - بنك الفلاح', 'compliance@al-falah-compliance.net',
 '<p>Dear Customer,</p><p>A wire transfer of AED 18,000 from your account is on hold pending compliance review. Please verify the transaction details to release the hold.</p><p><a href="{{link}}">Verify Transfer</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>تم إيقاف تحويل مالي بقيمة 18,000 درهم من حسابك بانتظار مراجعة الامتثال. يرجى التحقق من تفاصيل المعاملة لإلغاء الإيقاف.</p><p><a href="{{link}}">التحقق من التحويل</a></p></div>',
 '/phishing-landing/banking-wire-hold');

-- ----------------------------------------------------------------------------
-- GOVERNMENT (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000009', null, 'Tax Refund Notification', 'إشعار استرداد ضريبي', 'government', 'en', 'medium',
 'You are eligible for a tax refund', 'أنت مؤهل لاسترداد ضريبي',
 'Federal Tax Authority', 'الهيئة الاتحادية للضرائب', 'refunds@fta-gov-uae.com',
 '<p>Dear Taxpayer,</p><p>Our records show you are eligible for a refund of AED 1,180. To process your refund, please confirm your bank account details via the secure portal below.</p><p><a href="{{link}}">Claim Refund</a></p>',
 '<div dir="rtl"><p>عزيزنا المكلف،</p><p>تشير سجلاتنا إلى أنك مؤهل لاسترداد مبلغ 1,180 درهم. لمعالجة استردادك، يرجى تأكيد بيانات حسابك المصرفي عبر البوابة الآمنة أدناه.</p><p><a href="{{link}}">المطالبة بالاسترداد</a></p></div>',
 '/phishing-landing/gov-tax-refund'),

('60000000-0000-0000-0000-000000000010', null, 'Visa Renewal Required', 'مطلوب تجديد التأشيرة', 'government', 'en', 'medium',
 'Your residency visa requires immediate renewal', 'تأشيرة إقامتك تتطلب التجديد الفوري',
 'GDRFA Services', 'خدمات الإقامة وشؤون الأجانب', 'services@gdrfa-renewal-portal.com',
 '<p>Dear Resident,</p><p>Our system indicates your residency visa is due to expire within 7 days. Avoid fines by completing your renewal application online now.</p><p><a href="{{link}}">Renew Visa</a></p>',
 '<div dir="rtl"><p>عزيزنا المقيم،</p><p>يشير نظامنا إلى أن تأشيرة إقامتك ستنتهي صلاحيتها خلال 7 أيام. تجنب الغرامات عبر إكمال طلب التجديد الآن عبر الإنترنت.</p><p><a href="{{link}}">تجديد التأشيرة</a></p></div>',
 '/phishing-landing/gov-visa-renewal'),

('60000000-0000-0000-0000-000000000011', null, 'Traffic Fine Payment', 'دفع مخالفة مرورية', 'government', 'en', 'easy',
 'You have an outstanding traffic fine', 'لديك مخالفة مرورية مستحقة',
 'Traffic Fines Department', 'إدارة المخالفات المرورية', 'fines@traffic-services-gov.com',
 '<p>Dear Driver,</p><p>You have an unpaid traffic fine of AED 600 on your vehicle. Pay within 5 days to avoid additional penalties and registration suspension.</p><p><a href="{{link}}">Pay Fine</a></p>',
 '<div dir="rtl"><p>عزيزنا السائق،</p><p>لديك مخالفة مرورية غير مدفوعة بقيمة 600 درهم على مركبتك. يرجى الدفع خلال 5 أيام لتجنب غرامات إضافية وتعليق التسجيل.</p><p><a href="{{link}}">دفع المخالفة</a></p></div>',
 '/phishing-landing/gov-traffic-fine'),

('60000000-0000-0000-0000-000000000012', null, 'National ID Update Required', 'مطلوب تحديث الهوية الوطنية', 'government', 'en', 'hard',
 'Update your Emirates ID information', 'قم بتحديث معلومات هويتك الإماراتية',
 'Federal Authority for Identity', 'الهيئة الاتحادية للهوية', 'updates@ica-id-services.com',
 '<p>Dear Citizen/Resident,</p><p>Your Emirates ID record requires an update due to a recent regulation change. Failure to update within 10 days may affect access to government services.</p><p><a href="{{link}}">Update My Information</a></p>',
 '<div dir="rtl"><p>عزيزنا المواطن/المقيم،</p><p>يتطلب سجل هويتك الإماراتية تحديثًا بسبب تغيير تنظيمي حديث. عدم التحديث خلال 10 أيام قد يؤثر على وصولك إلى الخدمات الحكومية.</p><p><a href="{{link}}">تحديث معلوماتي</a></p></div>',
 '/phishing-landing/gov-id-update'),

('60000000-0000-0000-0000-000000000013', null, 'Customs Duty Payment Notice', 'إشعار دفع رسوم جمركية', 'government', 'ar', 'medium',
 'Outstanding customs duty on your recent shipment', 'رسوم جمركية مستحقة على شحنتك الأخيرة',
 'UAE Customs', 'الجمارك الإماراتية', 'duties@uae-customs-payments.com',
 '<p>Dear Resident,</p><p>A customs duty of AED 320 is pending on a recent shipment under your name. Pay now to release your shipment from customs hold.</p><p><a href="{{link}}">Pay Customs Duty</a></p>',
 '<div dir="rtl"><p>عزيزنا المقيم،</p><p>هناك رسوم جمركية بقيمة 320 درهم معلقة على شحنة حديثة باسمك. ادفع الآن للإفراج عن شحنتك من الحجز الجمركي.</p><p><a href="{{link}}">دفع الرسوم الجمركية</a></p></div>',
 '/phishing-landing/gov-customs-duty'),

('60000000-0000-0000-0000-000000000014', null, 'Vehicle Registration Renewal', 'تجديد تسجيل المركبة', 'government', 'ar', 'easy',
 'Your vehicle registration is about to expire', 'تسجيل مركبتك على وشك الانتهاء',
 'RTA Vehicle Licensing', 'ترخيص المركبات - هيئة الطرق والمواصلات', 'licensing@rta-renewals-online.com',
 '<p>Dear Vehicle Owner,</p><p>Your vehicle registration expires in 3 days. Renew online now to avoid a fine and ensure your insurance remains valid.</p><p><a href="{{link}}">Renew Registration</a></p>',
 '<div dir="rtl"><p>عزيزنا مالك المركبة،</p><p>سينتهي تسجيل مركبتك خلال 3 أيام. جدد الآن عبر الإنترنت لتجنب الغرامة وضمان استمرار صلاحية التأمين.</p><p><a href="{{link}}">تجديد التسجيل</a></p></div>',
 '/phishing-landing/gov-vehicle-renewal'),

('60000000-0000-0000-0000-000000000015', null, 'Court Notice - Action Required', 'إشعار محكمة - إجراء مطلوب', 'government', 'ar', 'hard',
 'You have a pending legal notice', 'لديك إشعار قانوني معلق',
 'Dubai Courts', 'محاكم دبي', 'notices@dubai-courts-elegal.com',
 '<p>Dear Sir/Madam,</p><p>A legal notice has been filed against you and requires your response within 48 hours. View the case details and respond via the secure portal.</p><p><a href="{{link}}">View Notice</a></p>',
 '<div dir="rtl"><p>السيد/السيدة المحترم/ة،</p><p>تم تقديم إشعار قانوني ضدك ويتطلب ردك خلال 48 ساعة. اطلع على تفاصيل القضية ورد عبر البوابة الآمنة.</p><p><a href="{{link}}">عرض الإشعار</a></p></div>',
 '/phishing-landing/gov-court-notice'),

('60000000-0000-0000-0000-000000000016', null, 'Pension Fund Statement Update', 'تحديث كشف صندوق التقاعد', 'government', 'ar', 'medium',
 'Your pension fund statement requires verification', 'كشف صندوق التقاعد الخاص بك يتطلب التحقق',
 'GPSSA', 'الهيئة العامة للتقاعد والتأمينات الاجتماعية', 'verify@gpssa-statements.com',
 '<p>Dear Member,</p><p>Your annual pension contribution statement is ready, but requires identity verification before you can view it. Please verify to access your statement.</p><p><a href="{{link}}">Verify & View Statement</a></p>',
 '<div dir="rtl"><p>عزيزنا المشترك،</p><p>كشف اشتراكات التقاعد السنوي جاهز، ولكنه يتطلب التحقق من الهوية قبل عرضه. يرجى التحقق للوصول إلى كشفك.</p><p><a href="{{link}}">التحقق وعرض الكشف</a></p></div>',
 '/phishing-landing/gov-pension-statement');

-- ----------------------------------------------------------------------------
-- HR / PAYROLL (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000017', null, 'Payroll System Update Required', 'مطلوب تحديث نظام الرواتب', 'hr_payroll', 'en', 'medium',
 'Action required: Update your payroll details', 'إجراء مطلوب: قم بتحديث بيانات راتبك',
 'Al Falah Holdings Payroll', 'رواتب مجموعة الفلاح القابضة', 'payroll@alfalah-hldgs-portal.com',
 '<p>Dear Employee,</p><p>We are migrating to a new payroll system. To ensure your salary is processed without delay, please confirm your bank details via the link below before Thursday.</p><p><a href="{{link}}">Update Payroll Details</a></p><p>HR Operations</p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>نقوم بالانتقال إلى نظام رواتب جديد. لضمان معالجة راتبك دون تأخير، يرجى تأكيد بياناتك المصرفية عبر الرابط أدناه قبل يوم الخميس.</p><p><a href="{{link}}">تحديث بيانات الراتب</a></p><p>عمليات الموارد البشرية</p></div>',
 '/phishing-landing/hr-payroll-update'),

('60000000-0000-0000-0000-000000000018', null, 'New HR Policy - Acknowledgement Required', 'سياسة جديدة للموارد البشرية - يتطلب الإقرار', 'hr_payroll', 'en', 'easy',
 'Please review and acknowledge the updated HR policy', 'يرجى مراجعة سياسة الموارد البشرية المحدثة والإقرار بها',
 'Al Falah Holdings HR', 'الموارد البشرية - مجموعة الفلاح القابضة', 'hr-notices@alfalah-hr-online.com',
 '<p>Dear Team,</p><p>Our remote work policy has been updated effective this month. All employees must review and digitally sign the new policy by Friday.</p><p><a href="{{link}}">Review & Sign Policy</a></p>',
 '<div dir="rtl"><p>عزيزي الفريق،</p><p>تم تحديث سياسة العمل عن بُعد اعتبارًا من هذا الشهر. يجب على جميع الموظفين مراجعة السياسة الجديدة والتوقيع عليها إلكترونيًا بحلول يوم الجمعة.</p><p><a href="{{link}}">مراجعة وتوقيع السياسة</a></p></div>',
 '/phishing-landing/hr-policy-ack'),

('60000000-0000-0000-0000-000000000019', null, 'Salary Slip Available', 'كشف الراتب متاح', 'hr_payroll', 'en', 'easy',
 'Your March salary slip is ready to view', 'كشف راتب شهر مارس جاهز للعرض',
 'Al Falah Holdings Payroll', 'رواتب مجموعة الفلاح القابضة', 'payslips@alfalah-payslip-portal.com',
 '<p>Dear Employee,</p><p>Your salary slip for this month is now available. Please log in to view and download your payslip.</p><p><a href="{{link}}">View Payslip</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>كشف راتبك لهذا الشهر متاح الآن. يرجى تسجيل الدخول لعرض كشف الراتب وتنزيله.</p><p><a href="{{link}}">عرض كشف الراتب</a></p></div>',
 '/phishing-landing/hr-payslip'),

('60000000-0000-0000-0000-000000000020', null, 'Annual Leave Balance Update', 'تحديث رصيد الإجازة السنوية', 'hr_payroll', 'en', 'medium',
 'Your annual leave balance has changed', 'تغير رصيد إجازتك السنوية',
 'Al Falah Holdings HR', 'الموارد البشرية - مجموعة الفلاح القابضة', 'leave@alfalah-hr-services.com',
 '<p>Dear Employee,</p><p>Due to a recent policy adjustment, your remaining annual leave balance has been recalculated. Please log in to verify your updated balance and confirm your details.</p><p><a href="{{link}}">View Leave Balance</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>بسبب تعديل حديث في السياسة، تمت إعادة احتساب رصيد إجازتك السنوية المتبقي. يرجى تسجيل الدخول للتحقق من رصيدك المحدث وتأكيد بياناتك.</p><p><a href="{{link}}">عرض رصيد الإجازة</a></p></div>',
 '/phishing-landing/hr-leave-balance'),

('60000000-0000-0000-0000-000000000021', null, 'Mandatory Training Enrollment', 'التسجيل الإلزامي في التدريب', 'hr_payroll', 'ar', 'medium',
 'You are enrolled in a mandatory compliance training', 'تم تسجيلك في تدريب إلزامي للامتثال',
 'Al Falah Holdings Learning', 'التعلم - مجموعة الفلاح القابضة', 'training@alfalah-learning-hub.com',
 '<p>Dear Employee,</p><p>You have been enrolled in a mandatory compliance training that must be completed within 5 business days. Please log in using your corporate credentials to begin.</p><p><a href="{{link}}">Start Training</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>تم تسجيلك في تدريب إلزامي للامتثال يجب إكماله خلال 5 أيام عمل. يرجى تسجيل الدخول باستخدام بيانات اعتماد شركتك للبدء.</p><p><a href="{{link}}">بدء التدريب</a></p></div>',
 '/phishing-landing/hr-training-enrollment'),

('60000000-0000-0000-0000-000000000022', null, 'End of Year Bonus Confirmation', 'تأكيد مكافأة نهاية العام', 'hr_payroll', 'ar', 'medium',
 'Confirm your details to receive your year-end bonus', 'أكد بياناتك لاستلام مكافأة نهاية العام',
 'Al Falah Holdings Finance', 'المالية - مجموعة الفلاح القابضة', 'bonus@alfalah-finance-team.com',
 '<p>Dear Employee,</p><p>Congratulations! You are eligible for a year-end performance bonus. To process the payment, please confirm your bank account details by Friday.</p><p><a href="{{link}}">Confirm Bank Details</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>تهانينا! أنت مؤهل للحصول على مكافأة أداء نهاية العام. لمعالجة الدفعة، يرجى تأكيد بيانات حسابك المصرفي بحلول يوم الجمعة.</p><p><a href="{{link}}">تأكيد البيانات المصرفية</a></p></div>',
 '/phishing-landing/hr-bonus-confirm'),

('60000000-0000-0000-0000-000000000023', null, 'Employee Survey - Win a Prize', 'استبيان الموظفين - اربح جائزة', 'hr_payroll', 'ar', 'easy',
 'Complete the employee satisfaction survey', 'أكمل استبيان رضا الموظفين',
 'Al Falah Holdings HR', 'الموارد البشرية - مجموعة الفلاح القابضة', 'surveys@alfalah-employee-survey.com',
 '<p>Dear Employee,</p><p>Help us improve! Complete this short survey using your employee login and be entered into a prize draw.</p><p><a href="{{link}}">Take Survey</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>ساعدنا على التحسين! أكمل هذا الاستبيان القصير باستخدام بيانات تسجيل دخول موظفيك وادخل في سحب على جائزة.</p><p><a href="{{link}}">إجراء الاستبيان</a></p></div>',
 '/phishing-landing/hr-survey-prize'),

('60000000-0000-0000-0000-000000000024', null, 'Password Expiry Notice', 'إشعار انتهاء صلاحية كلمة المرور', 'hr_payroll', 'ar', 'hard',
 'Your corporate password expires today', 'كلمة مرور شركتك تنتهي صلاحيتها اليوم',
 'Al Falah IT Helpdesk', 'الدعم الفني - مجموعة الفلاح القابضة', 'helpdesk@alfalah-it-support.net',
 '<p>Dear Employee,</p><p>Your corporate account password expires today. To avoid being locked out, please reset your password immediately using the secure link below.</p><p><a href="{{link}}">Reset Password</a></p>',
 '<div dir="rtl"><p>عزيزي الموظف،</p><p>تنتهي صلاحية كلمة مرور حسابك في الشركة اليوم. لتجنب قفل حسابك، يرجى إعادة تعيين كلمة المرور فورًا عبر الرابط الآمن أدناه.</p><p><a href="{{link}}">إعادة تعيين كلمة المرور</a></p></div>',
 '/phishing-landing/hr-password-expiry');

-- ----------------------------------------------------------------------------
-- INVOICE FRAUD / BEC (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000025', null, 'Invoice Payment Overdue', 'فاتورة دفع متأخرة', 'invoice_fraud', 'en', 'medium',
 'Invoice #INV-20458 is overdue - please process payment', 'الفاتورة رقم INV-20458 متأخرة - يرجى معالجة الدفع',
 'Gulf Office Supplies LLC', 'شركة الخليج للوازم المكتبية', 'accounts@gulf-office-supplies-billing.com',
 '<p>Dear Accounts Team,</p><p>Our records show invoice #INV-20458 (AED 8,750) remains unpaid and is now 15 days overdue. Please process payment using the attached updated bank details to avoid service interruption.</p><p><a href="{{link}}">View Invoice</a></p>',
 '<div dir="rtl"><p>عزيزي فريق الحسابات،</p><p>تشير سجلاتنا إلى أن الفاتورة رقم INV-20458 (8,750 درهم) لا تزال غير مدفوعة وقد تجاوزت موعد استحقاقها بـ 15 يومًا. يرجى معالجة الدفع باستخدام بيانات الحساب المصرفي المحدثة المرفقة لتجنب انقطاع الخدمة.</p><p><a href="{{link}}">عرض الفاتورة</a></p></div>',
 '/phishing-landing/invoice-overdue'),

('60000000-0000-0000-0000-000000000026', null, 'Updated Bank Details for Vendor Payment', 'بيانات مصرفية محدثة لدفعة المورد', 'invoice_fraud', 'en', 'hard',
 'Important: Our bank details have changed', 'هام: تغيرت بياناتنا المصرفية',
 'Emirates Tech Solutions', 'شركة الإمارات لحلول التقنية', 'finance@emiratestech-solutions-billing.com',
 '<p>Dear Partner,</p><p>Please be advised that our company has changed banks. For all future and pending payments, kindly use the new account details provided in the attached document.</p><p><a href="{{link}}">View Updated Details</a></p><p>Regards, Finance Department</p>',
 '<div dir="rtl"><p>عزيزنا الشريك،</p><p>نود إعلامكم بأن شركتنا قامت بتغيير البنك المتعامل معه. لجميع المدفوعات الحالية والمستقبلية، يرجى استخدام بيانات الحساب الجديدة الموضحة في المستند المرفق.</p><p><a href="{{link}}">عرض البيانات المحدثة</a></p><p>مع التحية، إدارة المالية</p></div>',
 '/phishing-landing/invoice-bank-change'),

('60000000-0000-0000-0000-000000000027', null, 'Purchase Order Confirmation', 'تأكيد أمر الشراء', 'invoice_fraud', 'en', 'medium',
 'PO #4471 confirmation needed - urgent', 'مطلوب تأكيد أمر الشراء رقم 4471 - عاجل',
 'Al Falah Procurement', 'مشتريات مجموعة الفلاح القابضة', 'procurement@alfalah-po-system.com',
 '<p>Dear Supplier,</p><p>Please confirm receipt and acceptance of purchase order #4471 (AED 22,300) by replying with your signed acknowledgement and updated invoice.</p><p><a href="{{link}}">View Purchase Order</a></p>',
 '<div dir="rtl"><p>عزيزنا المورد،</p><p>يرجى تأكيد استلام وقبول أمر الشراء رقم 4471 (22,300 درهم) من خلال الرد بإقرار موقع وفاتورة محدثة.</p><p><a href="{{link}}">عرض أمر الشراء</a></p></div>',
 '/phishing-landing/invoice-po-confirm'),

('60000000-0000-0000-0000-000000000028', null, 'Urgent Wire Transfer Request', 'طلب تحويل مالي عاجل', 'invoice_fraud', 'en', 'hard',
 'Need this done before my meeting - urgent transfer', 'أحتاج إنجاز هذا قبل اجتماعي - تحويل عاجل',
 'Saeed Al Nahyan (CEO)', 'سعيد آل نهيان (الرئيس التنفيذي)', 'ceo.alnahyan.office@alfalah-exec-office.com',
 '<p>Hi,</p><p>I''m heading into back-to-back meetings and need you to process an urgent wire transfer of AED 45,000 to a new supplier before noon. I''ll send the account details shortly. Please confirm you can action this now.</p><p><a href="{{link}}">Confirm Availability</a></p><p>Sent from my iPhone</p>',
 '<div dir="rtl"><p>مرحبًا،</p><p>أنا في اجتماعات متتالية وأحتاج منك معالجة تحويل مالي عاجل بقيمة 45,000 درهم إلى مورد جديد قبل الظهر. سأرسل بيانات الحساب قريبًا. يرجى تأكيد قدرتك على تنفيذ هذا الآن.</p><p><a href="{{link}}">تأكيد التوفر</a></p><p>أُرسلت من آيفون الخاص بي</p></div>',
 '/phishing-landing/invoice-ceo-transfer'),

('60000000-0000-0000-0000-000000000029', null, 'Past Due Subscription Renewal', 'تجديد اشتراك متأخر', 'invoice_fraud', 'ar', 'easy',
 'Your software subscription has expired', 'انتهت صلاحية اشتراك البرنامج الخاص بك',
 'CloudWork Software', 'برمجيات كلاود وورك', 'billing@cloudwork-software-billing.com',
 '<p>Dear Customer,</p><p>Your CloudWork subscription expired and your team will lose access in 24 hours. Renew now to avoid service disruption.</p><p><a href="{{link}}">Renew Subscription</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>انتهت صلاحية اشتراكك في كلاود وورك وسيفقد فريقك الوصول خلال 24 ساعة. جدد الآن لتجنب انقطاع الخدمة.</p><p><a href="{{link}}">تجديد الاشتراك</a></p></div>',
 '/phishing-landing/invoice-subscription-renewal'),

('60000000-0000-0000-0000-000000000030', null, 'Credit Note Adjustment', 'تعديل إشعار دائن', 'invoice_fraud', 'ar', 'medium',
 'Credit note issued - review required', 'تم إصدار إشعار دائن - يلزم المراجعة',
 'Marina Logistics Co.', 'شركة مارينا للخدمات اللوجستية', 'accounts@marina-logistics-finance.com',
 '<p>Dear Accounts Team,</p><p>We have issued a credit note adjustment of AED 3,400 against invoice #7821. Please review the attached statement and confirm the adjusted balance.</p><p><a href="{{link}}">Review Credit Note</a></p>',
 '<div dir="rtl"><p>عزيزي فريق الحسابات،</p><p>أصدرنا إشعار دائن بتعديل قيمته 3,400 درهم مقابل الفاتورة رقم 7821. يرجى مراجعة الكشف المرفق وتأكيد الرصيد المعدل.</p><p><a href="{{link}}">مراجعة إشعار الدائن</a></p></div>',
 '/phishing-landing/invoice-credit-note'),

('60000000-0000-0000-0000-000000000031', null, 'Contract Renewal - Signature Needed', 'تجديد العقد - يلزم التوقيع', 'invoice_fraud', 'ar', 'medium',
 'Please sign the renewed service agreement', 'يرجى توقيع اتفاقية الخدمة المجددة',
 'Al Falah Legal & Compliance', 'الشؤون القانونية والامتثال - مجموعة الفلاح القابضة', 'contracts@alfalah-legal-docs.com',
 '<p>Dear Vendor,</p><p>Attached is the renewed service agreement for the upcoming year. Please review and sign electronically by end of week to avoid a lapse in services.</p><p><a href="{{link}}">Review & Sign</a></p>',
 '<div dir="rtl"><p>عزيزنا المورد،</p><p>مرفق اتفاقية الخدمة المجددة للعام القادم. يرجى المراجعة والتوقيع إلكترونيًا بنهاية الأسبوع لتجنب انقطاع الخدمات.</p><p><a href="{{link}}">المراجعة والتوقيع</a></p></div>',
 '/phishing-landing/invoice-contract-sign'),

('60000000-0000-0000-0000-000000000032', null, 'Refund Processing Error', 'خطأ في معالجة الاسترداد', 'invoice_fraud', 'ar', 'hard',
 'A refund to your account failed - update details', 'فشلت عملية استرداد إلى حسابك - حدّث البيانات',
 'Al Falah Finance Shared Services', 'الخدمات المالية المشتركة - مجموعة الفلاح القابضة', 'refunds@alfalah-shared-finance.com',
 '<p>Dear Vendor,</p><p>A refund of AED 1,950 to your account could not be processed due to outdated bank details. Please update your information to receive the refund.</p><p><a href="{{link}}">Update Bank Details</a></p>',
 '<div dir="rtl"><p>عزيزنا المورد،</p><p>تعذرت معالجة استرداد بقيمة 1,950 درهم إلى حسابك بسبب بيانات مصرفية قديمة. يرجى تحديث معلوماتك لاستلام المبلغ المسترد.</p><p><a href="{{link}}">تحديث البيانات المصرفية</a></p></div>',
 '/phishing-landing/invoice-refund-error');

-- ----------------------------------------------------------------------------
-- DELIVERY (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000033', null, 'Package Delivery Failed', 'فشل توصيل الطرد', 'delivery', 'en', 'easy',
 'Delivery attempt failed - reschedule now', 'فشلت محاولة التوصيل - أعد الجدولة الآن',
 'Aramex Delivery', 'أرامكس للتوصيل', 'tracking@aramex-delivery-update.com',
 '<p>Dear Customer,</p><p>We attempted to deliver your package today but no one was available to receive it. Please reschedule your delivery within 48 hours or your package will be returned to sender.</p><p><a href="{{link}}">Reschedule Delivery</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>حاولنا توصيل طردك اليوم ولكن لم يكن هناك أحد لاستلامه. يرجى إعادة جدولة التوصيل خلال 48 ساعة وإلا سيتم إرجاع الطرد إلى المرسل.</p><p><a href="{{link}}">إعادة جدولة التوصيل</a></p></div>',
 '/phishing-landing/delivery-failed'),

('60000000-0000-0000-0000-000000000034', null, 'Customs Fee Payment Required', 'مطلوب دفع رسوم جمركية', 'delivery', 'en', 'medium',
 'Pay AED 25 customs fee to release your package', 'ادفع رسوم جمركية بقيمة 25 درهم للإفراج عن طردك',
 'DHL Express', 'دي إتش إل إكسبريس', 'customs@dhl-fees-online.com',
 '<p>Dear Customer,</p><p>Your incoming package is being held at customs. A small fee of AED 25 is required for clearance. Pay now to avoid storage charges and delays.</p><p><a href="{{link}}">Pay Customs Fee</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>طردك القادم محتجز لدى الجمارك. مطلوب رسوم بسيطة قدرها 25 درهم للتخليص. ادفع الآن لتجنب رسوم التخزين والتأخير.</p><p><a href="{{link}}">دفع الرسوم الجمركية</a></p></div>',
 '/phishing-landing/delivery-customs-fee'),

('60000000-0000-0000-0000-000000000035', null, 'Delivery Address Confirmation', 'تأكيد عنوان التوصيل', 'delivery', 'en', 'medium',
 'Confirm your delivery address for an incoming parcel', 'أكد عنوان التوصيل لطرد قادم',
 'Emirates Post', 'بريد الإمارات', 'delivery@emiratespost-tracking.com',
 '<p>Dear Customer,</p><p>We have a parcel addressed to you, but the delivery address could not be verified. Please confirm your address details to proceed with delivery.</p><p><a href="{{link}}">Confirm Address</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>لدينا طرد موجه إليك، ولكن تعذر التحقق من عنوان التوصيل. يرجى تأكيد بيانات عنوانك للمتابعة في عملية التوصيل.</p><p><a href="{{link}}">تأكيد العنوان</a></p></div>',
 '/phishing-landing/delivery-address-confirm'),

('60000000-0000-0000-0000-000000000036', null, 'Your Parcel is on Hold', 'طردك قيد الانتظار', 'delivery', 'en', 'hard',
 'Your parcel is on hold pending payment confirmation', 'طردك قيد الانتظار بانتظار تأكيد الدفع',
 'FedEx Middle East', 'فيديكس الشرق الأوسط', 'support@fedex-parcel-hold.com',
 '<p>Dear Customer,</p><p>Your parcel #FX9183746 is on hold due to an unconfirmed payment of AED 18.50 for redelivery. Confirm payment within 24 hours to avoid the parcel being returned.</p><p><a href="{{link}}">Confirm Payment</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>طردك رقم FX9183746 قيد الانتظار بسبب عدم تأكيد دفع رسوم إعادة التوصيل البالغة 18.50 درهم. أكد الدفع خلال 24 ساعة لتجنب إرجاع الطرد.</p><p><a href="{{link}}">تأكيد الدفع</a></p></div>',
 '/phishing-landing/delivery-parcel-hold'),

('60000000-0000-0000-0000-000000000037', null, 'Shipment Tracking Update', 'تحديث تتبع الشحنة', 'delivery', 'ar', 'easy',
 'Your shipment is out for delivery today', 'شحنتك في طريقها للتوصيل اليوم',
 'Aramex Delivery', 'أرامكس للتوصيل', 'noreply@aramex-shipment-track.com',
 '<p>Dear Customer,</p><p>Good news! Your shipment is out for delivery today. Track its live location and delivery window using the link below.</p><p><a href="{{link}}">Track Shipment</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>أخبار سارة! شحنتك في طريقها للتوصيل اليوم. تتبع موقعها الحالي ووقت التوصيل المتوقع عبر الرابط أدناه.</p><p><a href="{{link}}">تتبع الشحنة</a></p></div>',
 '/phishing-landing/delivery-tracking-update'),

('60000000-0000-0000-0000-000000000038', null, 'Failed Delivery - Pay Redelivery Fee', 'فشل التوصيل - ادفع رسوم إعادة التوصيل', 'delivery', 'ar', 'medium',
 'Redelivery fee required for your package', 'مطلوب رسوم إعادة توصيل لطردك',
 'SMSA Express', 'سمسا إكسبرس', 'fees@smsa-redelivery.com',
 '<p>Dear Customer,</p><p>Your package could not be delivered due to an incorrect address. A small redelivery fee of AED 12 is required. Pay now to schedule redelivery.</p><p><a href="{{link}}">Pay Redelivery Fee</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>تعذر توصيل طردك بسبب عنوان غير صحيح. مطلوب رسوم إعادة توصيل بسيطة قدرها 12 درهم. ادفع الآن لجدولة إعادة التوصيل.</p><p><a href="{{link}}">دفع رسوم إعادة التوصيل</a></p></div>',
 '/phishing-landing/delivery-redelivery-fee'),

('60000000-0000-0000-0000-000000000039', null, 'Package Held - ID Verification', 'الطرد محتجز - يلزم التحقق من الهوية', 'delivery', 'ar', 'hard',
 'ID verification needed to release your package', 'مطلوب التحقق من الهوية للإفراج عن طردك',
 'DHL Express', 'دي إتش إل إكسبريس', 'verification@dhl-id-check.com',
 '<p>Dear Customer,</p><p>Your package contains items requiring ID verification per import regulations. Please upload a copy of your Emirates ID to release the shipment.</p><p><a href="{{link}}">Upload ID</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>يحتوي طردك على عناصر تتطلب التحقق من الهوية وفقًا للوائح الاستيراد. يرجى تحميل نسخة من هويتك الإماراتية للإفراج عن الشحنة.</p><p><a href="{{link}}">تحميل الهوية</a></p></div>',
 '/phishing-landing/delivery-id-verification'),

('60000000-0000-0000-0000-000000000040', null, 'Free Shipping Voucher', 'قسيمة شحن مجانية', 'delivery', 'ar', 'easy',
 'You have received a free shipping voucher', 'لقد استلمت قسيمة شحن مجانية',
 'Emirates Post Rewards', 'مكافآت بريد الإمارات', 'rewards@emiratespost-vouchers.com',
 '<p>Dear Customer,</p><p>As a thank you for being a loyal customer, you have received a free shipping voucher worth AED 50. Claim it now before it expires.</p><p><a href="{{link}}">Claim Voucher</a></p>',
 '<div dir="rtl"><p>عزيزنا العميل،</p><p>كشكر لك على ولائك، حصلت على قسيمة شحن مجانية بقيمة 50 درهم. اطلبها الآن قبل انتهاء صلاحيتها.</p><p><a href="{{link}}">المطالبة بالقسيمة</a></p></div>',
 '/phishing-landing/delivery-free-voucher');

-- ----------------------------------------------------------------------------
-- WHATSAPP (8)
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000041', null, 'You''ve Won a Prize!', 'لقد فزت بجائزة!', 'whatsapp', 'en', 'easy',
 'Congratulations! You''ve won a prize from Al Falah Holdings', 'تهانينا! لقد فزت بجائزة من مجموعة الفلاح القابضة',
 '+971 50 123 4567', '+971 50 123 4567', 'whatsapp-notify@alfalah-rewards-promo.com',
 '<p>Congratulations! 🎉 Your number has been randomly selected to win an iPhone 16 Pro from our annual employee appreciation draw. Click the link to claim your prize before it expires.</p><p><a href="{{link}}">Claim My Prize</a></p>',
 '<div dir="rtl"><p>تهانينا! 🎉 تم اختيار رقمك عشوائيًا للفوز بجهاز آيفون 16 برو من سحب تقدير الموظفين السنوي. انقر على الرابط للمطالبة بجائزتك قبل انتهاء صلاحيتها.</p><p><a href="{{link}}">المطالبة بجائزتي</a></p></div>',
 '/phishing-landing/whatsapp-prize-win'),

('60000000-0000-0000-0000-000000000042', null, 'Bank Security Verification Code', 'رمز التحقق الأمني من البنك', 'whatsapp', 'en', 'hard',
 'Your verification code was requested', 'تم طلب رمز التحقق الخاص بك',
 'Al Falah Bank', 'بنك الفلاح', 'no-reply@al-falah-otp-verify.com',
 '<p>We noticed a request to access your Al Falah Bank account from a new device. If this was you, reply with the 6-digit code sent to your phone to confirm. If not, reply STOP immediately.</p><p><a href="{{link}}">Secure My Account</a></p>',
 '<div dir="rtl"><p>لاحظنا طلبًا للوصول إلى حساب بنك الفلاح الخاص بك من جهاز جديد. إذا كان هذا أنت، رد بالرمز المكون من 6 أرقام المرسل إلى هاتفك للتأكيد. إذا لم يكن كذلك، رد بكلمة "إيقاف" فورًا.</p><p><a href="{{link}}">تأمين حسابي</a></p></div>',
 '/phishing-landing/whatsapp-bank-otp'),

('60000000-0000-0000-0000-000000000043', null, 'Job Offer Opportunity', 'فرصة عمل', 'whatsapp', 'en', 'medium',
 'Exciting remote job opportunity - high salary', 'فرصة عمل عن بُعد مثيرة - راتب مرتفع',
 '+971 52 987 6543', '+971 52 987 6543', 'recruiter@global-careers-offers.com',
 '<p>Hello! We came across your profile and would like to offer you a remote part-time position with a salary of AED 8,000/month. No experience needed. Reply with your CV and ID copy to proceed.</p><p><a href="{{link}}">Apply Now</a></p>',
 '<div dir="rtl"><p>مرحبًا! اطلعنا على ملفك الشخصي ونود أن نعرض عليك وظيفة عن بُعد بدوام جزئي براتب 8,000 درهم شهريًا. لا حاجة لخبرة. رد بسيرتك الذاتية ونسخة من هويتك للمتابعة.</p><p><a href="{{link}}">قدّم الآن</a></p></div>',
 '/phishing-landing/whatsapp-job-offer'),

('60000000-0000-0000-0000-000000000044', null, 'Family Emergency - Urgent', 'حالة طوارئ عائلية - عاجل', 'whatsapp', 'en', 'hard',
 'Hi, it''s me, I lost my phone - urgent help needed', 'مرحبًا، أنا هو، فقدت هاتفي - أحتاج مساعدة عاجلة',
 'Unknown Number (claiming to be a relative)', 'رقم غير معروف (يدّعي أنه قريب)', 'familyhelp@temp-mail-service.com',
 '<p>Hi, this is my new number, I lost my phone and SIM. I urgently need to pay a bill before the deadline today but my banking app isn''t working on this new phone. Can you transfer AED 1,200 to this account and I''ll pay you back tonight?</p><p><a href="{{link}}">View Bank Details</a></p>',
 '<div dir="rtl"><p>مرحبًا، هذا رقمي الجديد، فقدت هاتفي وشريحة الاتصال. أحتاج بشكل عاجل لدفع فاتورة قبل الموعد النهائي اليوم ولكن تطبيق البنك لا يعمل على هذا الهاتف الجديد. هل يمكنك تحويل 1,200 درهم إلى هذا الحساب وسأعيدها لك الليلة؟</p><p><a href="{{link}}">عرض البيانات المصرفية</a></p></div>',
 '/phishing-landing/whatsapp-family-emergency'),

('60000000-0000-0000-0000-000000000045', null, 'Delivery Notification via WhatsApp', 'إشعار توصيل عبر واتساب', 'whatsapp', 'ar', 'easy',
 'Your package is arriving today - confirm details', 'طردك سيصل اليوم - أكد التفاصيل',
 'Aramex Delivery Bot', 'روبوت توصيل أرامكس', 'bot@aramex-whatsapp-notify.com',
 '<p>Hello, your package is scheduled for delivery today between 2-5 PM. Please confirm your address and preferred time slot via the link to avoid a missed delivery.</p><p><a href="{{link}}">Confirm Delivery</a></p>',
 '<div dir="rtl"><p>مرحبًا، طردك مجدول للتوصيل اليوم بين الساعة 2-5 مساءً. يرجى تأكيد عنوانك والوقت المفضل عبر الرابط لتجنب فوات التوصيل.</p><p><a href="{{link}}">تأكيد التوصيل</a></p></div>',
 '/phishing-landing/whatsapp-delivery-notify'),

('60000000-0000-0000-0000-000000000046', null, 'Government Survey Reward', 'مكافأة استبيان حكومي', 'whatsapp', 'ar', 'medium',
 'Complete this survey to receive AED 100', 'أكمل هذا الاستبيان لاستلام 100 درهم',
 '+971 56 222 1111', '+971 56 222 1111', 'survey@gov-citizen-feedback.com',
 '<p>The Ministry of Community Development is conducting a short survey on public services. Complete it within 5 minutes and receive AED 100 credited to your account.</p><p><a href="{{link}}">Start Survey</a></p>',
 '<div dir="rtl"><p>تجري وزارة تنمية المجتمع استبيانًا قصيرًا حول الخدمات العامة. أكمله خلال 5 دقائق واحصل على 100 درهم تُضاف إلى حسابك.</p><p><a href="{{link}}">بدء الاستبيان</a></p></div>',
 '/phishing-landing/whatsapp-gov-survey'),

('60000000-0000-0000-0000-000000000047', null, 'Group Invite - Investment Opportunity', 'دعوة مجموعة - فرصة استثمارية', 'whatsapp', 'ar', 'hard',
 'You''ve been added to "Smart Investors UAE" group', 'تمت إضافتك إلى مجموعة "المستثمرون الأذكياء الإمارات"',
 'Investment Community Admin', 'مسؤول مجتمع الاستثمار', 'admin@smart-investors-group.com',
 '<p>You''ve been added to a group sharing exclusive crypto investment opportunities with guaranteed returns of 20% weekly. Join now via the link to start investing with as little as AED 500.</p><p><a href="{{link}}">Join Investment Group</a></p>',
 '<div dir="rtl"><p>تمت إضافتك إلى مجموعة تشارك فرص استثمار حصرية في العملات الرقمية بعوائد مضمونة تصل إلى 20% أسبوعيًا. انضم الآن عبر الرابط لبدء الاستثمار بمبلغ يبدأ من 500 درهم فقط.</p><p><a href="{{link}}">الانضمام لمجموعة الاستثمار</a></p></div>',
 '/phishing-landing/whatsapp-investment-group'),

('60000000-0000-0000-0000-000000000048', null, 'CEO WhatsApp Request', 'طلب عبر واتساب من الرئيس التنفيذي', 'whatsapp', 'ar', 'hard',
 'Quick favor needed - are you available?', 'أحتاج معروفًا سريعًا - هل أنت متاح؟',
 '+971 55 444 7890 (Saved as "CEO Saeed")', '+971 55 444 7890 (محفوظ باسم "الرئيس التنفيذي سعيد")', 'n/a',
 '<p>Hi, I''m in a board meeting and can''t talk. I need you to purchase 5 iTunes gift cards (AED 500 each) for a client gift and send me the codes. I''ll reimburse you today. Keep this confidential for now.</p><p><a href="{{link}}">Reply Here</a></p>',
 '<div dir="rtl"><p>مرحبًا، أنا في اجتماع مجلس الإدارة ولا أستطيع التحدث. أحتاج منك شراء 5 بطاقات هدايا آيتونز (500 درهم لكل منها) كهدية لعميل وإرسال الأكواد لي. سأرد لك المبلغ اليوم. حافظ على سرية هذا الأمر حاليًا.</p><p><a href="{{link}}">الرد هنا</a></p></div>',
 '/phishing-landing/whatsapp-ceo-giftcards');

-- ----------------------------------------------------------------------------
-- QR CODE (8)
-- The "body_html" describes the physical/digital placement of the QR code
-- and the destination it encodes for the simulation.
-- ----------------------------------------------------------------------------
insert into public.phishing_templates (id, tenant_id, name, name_ar, category, language, difficulty, subject, subject_ar, sender_name, sender_name_ar, sender_email, body_html, body_html_ar, landing_page_url) values

('60000000-0000-0000-0000-000000000049', null, 'Scan to Claim Your Reward', 'امسح للحصول على مكافأتك', 'qr_code', 'en', 'easy',
 'Scan to claim your employee appreciation reward', 'امسح الرمز للحصول على مكافأة تقدير الموظف',
 'Al Falah Holdings Rewards', 'مكافآت مجموعة الفلاح القابضة', 'rewards@alfalah-qr-promo.com',
 '<p>A flyer placed near the office pantry reads: "Scan this QR code to claim your AED 100 employee appreciation voucher before Friday!" Scanning leads to a fake rewards portal asking for corporate login credentials.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>ملصق موضوع بالقرب من مطبخ المكتب يقول: "امسح رمز QR هذا للحصول على قسيمة تقدير الموظف بقيمة 100 درهم قبل يوم الجمعة!" يؤدي المسح إلى بوابة مكافآت وهمية تطلب بيانات اعتماد الشركة.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-reward-claim'),

('60000000-0000-0000-0000-000000000050', null, 'Updated Wi-Fi Access QR', 'رمز QR محدث للوصول إلى الواي فاي', 'qr_code', 'en', 'medium',
 'Scan for the new guest Wi-Fi access', 'امسح للحصول على وصول الواي فاي الجديد للضيوف',
 'Al Falah IT Department', 'تقنية المعلومات - مجموعة الفلاح القابضة', 'it@alfalah-wifi-access.com',
 '<p>A printed sign in the meeting room reads: "Our Wi-Fi network has changed. Scan this QR code to connect to the new secure network." Scanning leads to a fake captive portal that harvests corporate credentials.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>لافتة مطبوعة في غرفة الاجتماعات تقول: "تم تغيير شبكة الواي فاي الخاصة بنا. امسح رمز QR هذا للاتصال بالشبكة الآمنة الجديدة." يؤدي المسح إلى بوابة وهمية تجمع بيانات اعتماد الشركة.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-wifi-access'),

('60000000-0000-0000-0000-000000000051', null, 'Parking Payment QR Code', 'رمز QR لدفع رسوم الانتظار', 'qr_code', 'en', 'medium',
 'Scan to pay for parking', 'امسح لدفع رسوم الانتظار',
 'Smart Parking Services', 'خدمات الانتظار الذكي', 'pay@smart-parking-uae-pay.com',
 '<p>A sticker placed over a legitimate parking meter QR code reads: "Pay for parking via QR - card payments only." Scanning leads to a fake payment page that captures card details.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>ملصق موضوع فوق رمز QR شرعي لعداد الانتظار يقول: "ادفع رسوم الانتظار عبر QR - الدفع بالبطاقة فقط." يؤدي المسح إلى صفحة دفع وهمية تلتقط بيانات البطاقة.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-parking-payment'),

('60000000-0000-0000-0000-000000000052', null, 'Restaurant Menu / Promo QR Code', 'رمز QR لقائمة المطعم / العروض', 'qr_code', 'en', 'easy',
 'Scan for our digital menu and a free dessert', 'امسح للحصول على القائمة الرقمية وحلوى مجانية',
 'Cafe Marhaba', 'مقهى مرحبا', 'promo@cafe-marhaba-deals.com',
 '<p>A table tent card in the office cafeteria reads: "Scan to view our menu and get a free dessert with any meal today!" Scanning leads to a fake login page mimicking a popular food delivery app.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>بطاقة على طاولة في مقصف المكتب تقول: "امسح لعرض قائمتنا واحصل على حلوى مجانية مع أي وجبة اليوم!" يؤدي المسح إلى صفحة تسجيل دخول وهمية تحاكي تطبيق توصيل طعام شهير.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-restaurant-promo'),

('60000000-0000-0000-0000-000000000053', null, 'Conference Badge QR Check-in', 'تسجيل دخول بطاقة المؤتمر عبر QR', 'qr_code', 'ar', 'medium',
 'Scan your badge QR for session feedback', 'امسح رمز QR على بطاقتك لتقديم ملاحظات الجلسة',
 'GCC Cyber Summit', 'قمة الخليج للأمن السيبراني', 'feedback@gcc-cybersummit-app.com',
 '<p>At a conference, a screen displays: "Scan this QR code to access exclusive session slides and submit feedback for a chance to win a tablet." The link leads to a fake conference app login.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>في أحد المؤتمرات، تعرض الشاشة: "امسح رمز QR هذا للوصول إلى شرائح الجلسات الحصرية وتقديم ملاحظاتك للفوز بجهاز لوحي." يؤدي الرابط إلى تسجيل دخول وهمي لتطبيق المؤتمر.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-conference-checkin'),

('60000000-0000-0000-0000-000000000054', null, 'Elevator Maintenance Notice QR', 'إشعار صيانة المصعد عبر QR', 'qr_code', 'ar', 'hard',
 'Scan to report elevator issues', 'امسح للإبلاغ عن مشاكل المصعد',
 'Building Facilities Management', 'إدارة مرافق المبنى', 'facilities@building-fm-services.com',
 '<p>A notice taped inside the elevator reads: "Elevator under maintenance. Scan this QR code to report any issues or request priority access." The link leads to a fake building portal requesting employee ID login.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>إشعار ملصق داخل المصعد يقول: "المصعد قيد الصيانة. امسح رمز QR هذا للإبلاغ عن أي مشاكل أو طلب وصول ذي أولوية." يؤدي الرابط إلى بوابة مبنى وهمية تطلب تسجيل دخول برقم الموظف.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-elevator-notice'),

('60000000-0000-0000-0000-000000000055', null, 'Charity Donation QR Code', 'رمز QR للتبرع الخيري', 'qr_code', 'ar', 'medium',
 'Scan to donate to flood relief efforts', 'امسح للتبرع لجهود إغاثة الفيضانات',
 'UAE Community Relief Fund', 'صندوق الإغاثة المجتمعي الإماراتي', 'donate@uae-relief-fund-donate.com',
 '<p>A poster in the office lobby reads: "Help families affected by recent floods. Scan to donate any amount via card." The QR code leads to a fake donation page that captures card details.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>ملصق في بهو المكتب يقول: "ساعد العائلات المتضررة من الفيضانات الأخيرة. امسح للتبرع بأي مبلغ عبر البطاقة." يؤدي رمز QR إلى صفحة تبرع وهمية تلتقط بيانات البطاقة.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-charity-donation'),

('60000000-0000-0000-0000-000000000056', null, 'Desk Equipment Survey QR', 'استبيان معدات المكتب عبر QR', 'qr_code', 'ar', 'easy',
 'Scan to request new desk equipment', 'امسح لطلب معدات مكتبية جديدة',
 'Al Falah Facilities Team', 'فريق المرافق - مجموعة الفلاح القابضة', 'facilities@alfalah-equipment-request.com',
 '<p>A sticker on office desks reads: "Need a new chair, monitor, or keyboard? Scan this QR code to submit a request using your employee login." The link leads to a fake internal portal harvesting credentials.</p><p><a href="{{link}}">[Simulated QR destination]</a></p>',
 '<div dir="rtl"><p>ملصق على مكاتب الموظفين يقول: "هل تحتاج كرسيًا أو شاشة أو لوحة مفاتيح جديدة؟ امسح رمز QR هذا لتقديم طلب باستخدام بيانات تسجيل دخول موظفيك." يؤدي الرابط إلى بوابة داخلية وهمية تجمع بيانات الاعتماد.</p><p><a href="{{link}}">[وجهة رمز QR المحاكاة]</a></p></div>',
 '/phishing-landing/qr-equipment-request');
