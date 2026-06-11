import { Download, Plus, Send, ShieldCheck, Sparkles } from "lucide-react";
import { ActivityItem, EmptyState, ProgressRow, RiskGauge, StatCard, StatusPill, TrendChart } from "@/components/dashboard/widgets";
import { Button } from "@/components/ui/button";
import { audits, cciTrend, courses, notifications, people, tenants, trend } from "@/lib/demo-data";
import type { UserRole } from "@/lib/auth/roles";

export function RolePage({ locale, role, section }: { locale: string; role: UserRole; section: string }) {
  if (locale === "ar") return <ArabicRolePage role={role} section={section} />;
  if (section === "notifications") return <NotificationsPage />;
  if (section === "people") return <PeoplePage role={role} />;
  if (section === "learning") return <LearningPage />;
  if (section === "assessments") return <AssessmentsPage />;
  if (section === "phishing" || section === "campaigns") return <CampaignsPage role={role} />;
  if (section === "risk") return <RiskPage role={role} />;
  if (section === "reports") return <ReportsPage />;
  if (section === "audit") return <AuditPage />;
  if (section === "settings") return <SettingsPage role={role} />;
  if (section === "tenants") return <TenantsPage />;
  return <Dashboard role={role} />;
}

const arabicSections: Record<string, { eyebrow: string; title: string; description: string }> = {
  dashboard: { eyebrow: "نظرة عامة", title: "لوحة استخبارات المخاطر البشرية", description: "تابع مؤشرات المخاطر والثقافة الأمنية والإجراءات ذات الأولوية." },
  risk: { eyebrow: "استخبارات المخاطر", title: "ملف المخاطر البشرية", description: "تحليل الإشارات السلوكية والأداء التاريخي ومجالات التحسين المتوقعة." },
  learning: { eyebrow: "التعلّم", title: "مركز التعلّم الأمني", description: "مسارات تعليمية مخصصة مبنية على مستوى المخاطر الحالي." },
  assessments: { eyebrow: "التقييمات", title: "تقييمات المعرفة والسلوك", description: "اكتشف نقاط القوة ومجالات التحسين العملية." },
  phishing: { eyebrow: "جاهزية التصيد", title: "أداء محاكاة التصيد", description: "راجع نتائج المحاكاة وتعلّم كيفية اكتشاف الرسائل المشبوهة." },
  campaigns: { eyebrow: "محاكاة التصيد", title: "إدارة الحملات", description: "أنشئ حملات محلية وتابع سلوك الإبلاغ والنتائج." },
  people: { eyebrow: "الموظفون", title: "قائمة مخاطر الموظفين", description: "حدد أولويات الدعم باستخدام المخاطر الحالية وإكمال التدريب." },
  reports: { eyebrow: "التقارير", title: "تقارير الاستخبارات", description: "ملخصات تنفيذية وتقارير تشغيلية جاهزة للتنزيل." },
  audit: { eyebrow: "الحوكمة", title: "سجل التدقيق", description: "راجع أنشطة المصادقة والمنصة المهمة." },
  settings: { eyebrow: "الإعدادات", title: "إعدادات الأمان والمنصة", description: "أدر ضوابط الأمان والخصائص المتاحة." },
  tenants: { eyebrow: "إدارة المنصة", title: "إدارة المؤسسات", description: "تابع المؤسسات والخطط والمقاعد ووضع المخاطر الحالي." },
  notifications: { eyebrow: "صندوق الوارد", title: "الإشعارات", description: "آخر تحديثات التعلّم والمخاطر والمؤسسة." },
};

function ArabicRolePage({ role, section }: { role: UserRole; section: string }) {
  const copy = arabicSections[section] ?? arabicSections.dashboard;
  if (section === "people") return <><Header {...copy} action={<Button><Plus className="size-4" /> إضافة موظف</Button>} /><ArabicPeopleTable /></>;
  if (section === "tenants") return <><Header {...copy} action={<Button><Plus className="size-4" /> إضافة مؤسسة</Button>} /><ArabicTenants /></>;
  if (section === "audit") return <><Header {...copy} /><ArabicAudit /></>;
  if (section === "learning") return <><Header {...copy} /><ArabicLearning /></>;
  if (section === "reports") return <><Header {...copy} action={<a href="/api/report" target="_blank"><Button><Download className="size-4" /> تنزيل التقرير</Button></a>} /><ArabicReports /></>;
  if (section === "notifications") return <><Header {...copy} /><section className="surface-card divide-y p-3"><ActivityItem title="تم تعيين مسار تعليمي جديد" detail="أكمل مسار أساسيات الأمن للربع الثاني." time="قبل 8 دقائق" /><ActivityItem title="تحسن مستوى المخاطر" detail="تحسن مؤشر المخاطر البشرية بمقدار 6 نقاط." time="أمس" /><ActivityItem title="اكتملت المحاكاة" detail="نتائج محاكاة التصيد جاهزة للمراجعة." time="قبل يومين" /></section></>;
  if (section === "settings") return <><Header {...copy} /><div className="grid gap-4 lg:grid-cols-2"><section className="surface-card p-6"><h2 className="font-semibold">ضوابط الأمان</h2><div className="mt-5 space-y-3"><Control label="قفل الحساب بعد المحاولات الفاشلة" enabled /><Control label="المصادقة متعددة العوامل" /><Control label="تسجيل عمليات التدقيق" enabled /></div></section><section className="surface-card p-6"><h2 className="font-semibold">خصائص المنصة</h2><div className="mt-5 space-y-3"><Control label="المساعد الذكي" enabled /><Control label="استخبارات المخاطر التنبؤية" enabled /><Control label="التقارير بصيغة PDF" enabled /></div></section></div></>;
  if (section === "risk") return <><Header {...copy} /><div className="grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge value={role === "employee" ? 39 : 42} label="مؤشر المخاطر البشرية" /><TrendChart values={trend} label="اتجاه المخاطر خلال 12 أسبوعاً" /></div><div className="mt-4 grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="الالتزام" value="82%" delta="قوي" /><StatCard label="تحمل الضغط" value="69%" delta="مستقر" /><StatCard label="احتمالية الإبلاغ" value="74%" delta="يتحسن" /><StatCard label="الإرهاق الأمني" value="52%" delta="يتحسن" /></div></>;
  if (section === "assessments") return <><Header {...copy} /><div className="grid gap-4 md:grid-cols-2"><Assessment title="اختبار المعرفة الأمنية" detail="20 سؤالاً · 15 دقيقة" score="84%" /><Assessment title="الملف السلوكي السيبراني" detail="32 سؤالاً · 12 دقيقة" score="مكتمل" /></div></>;
  if (section === "phishing" || section === "campaigns") return <><Header {...copy} action={section === "campaigns" ? <Button><Plus className="size-4" /> إنشاء حملة</Button> : undefined} /><div className="grid gap-4 sm:grid-cols-3"><StatCard label="معدل الإبلاغ" value="64%" delta="17%" /><StatCard label="معدل النقر" value="11%" delta="5%" /><StatCard label="الحملات النشطة" value="3" delta="1" /></div><div className="mt-4"><EmptyState title="أداء جيد في أحدث محاكاة" body="تم الإبلاغ عن الرسالة المشبوهة دون فتح الرابط." /></div></>;
  return <><Header {...copy} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="مؤشر المخاطر البشرية" value="39" delta="6 نقاط" /><StatCard label="مؤشر الثقافة السيبرانية" value="78" delta="8%" /><StatCard label="إكمال التعلّم" value="84%" delta="11%" /><StatCard label="المستخدمون النشطون" value="29" delta="3" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge value={39} label="مؤشر المخاطر الحالي" /><TrendChart values={trend} label="اتجاه المخاطر خلال 12 أسبوعاً" /></div></>;
}

function ArabicPeopleTable() {
  const rows = [
    ["عمر حسن", "المالية", "82", "حرج", "42%"],
    ["سارة خالد", "العمليات", "68", "مرتفع", "71%"],
    ["ليلى أحمد", "الموارد البشرية", "55", "مرتفع", "84%"],
    ["يوسف علي", "تقنية المعلومات", "31", "متوسط", "92%"],
  ];
  return <section className="surface-card overflow-x-auto"><table className="w-full min-w-[680px] text-sm"><thead className="bg-muted/60 text-xs text-muted-foreground"><tr><th className="px-5 py-3 text-start">الموظف</th><th className="px-5 py-3 text-start">القسم</th><th className="px-5 py-3 text-start">المخاطر</th><th className="px-5 py-3 text-start">الحالة</th><th className="px-5 py-3 text-start">التدريب</th></tr></thead><tbody className="divide-y">{rows.map((row) => <tr key={row[0]}>{row.map((cell) => <td key={cell} className="px-5 py-4">{cell}</td>)}</tr>)}</tbody></table></section>;
}

function ArabicLearning() {
  return <div className="grid gap-4 lg:grid-cols-3">{[["أساسيات الدفاع ضد التصيد", 72], ["العمل الآمن عن بُعد", 35], ["المصادقة وكلمات المرور", 100]].map(([title, progress]) => <article key={String(title)} className="surface-card p-6"><div className="grid size-11 place-items-center rounded-xl bg-primary/10 text-primary"><ShieldCheck className="size-5" /></div><h2 className="mt-5 font-semibold">{title}</h2><p className="mt-2 text-sm text-muted-foreground">24 دقيقة · 120 نقطة خبرة</p><div className="mt-6"><ProgressRow title="التقدم" progress={Number(progress)} /></div><Button className="mt-6 w-full">{Number(progress) === 100 ? "مراجعة الدورة" : "متابعة الدورة"}</Button></article>)}</div>;
}

function ArabicReports() {
  return <div className="grid gap-4 md:grid-cols-3">{["تقرير المخاطر الربعي", "التعلّم والثقافة", "جاهزية التصيد"].map((title) => <article key={title} className="surface-card p-6"><ShieldCheck className="size-7 text-primary" /><h2 className="mt-5 font-semibold">{title}</h2><p className="mt-2 text-sm text-muted-foreground">تم التحديث اليوم · العربية والإنجليزية</p><a href="/api/report" target="_blank"><Button variant="outline" className="mt-6"><Download className="size-4" /> تنزيل PDF</Button></a></article>)}</div>;
}

function ArabicAudit() {
  return <section className="surface-card divide-y p-3"><ActivityItem title="تم إنشاء حملة تصيد" detail="تجربة فاتورة شهر أبريل" time="اليوم، 10:42" /><ActivityItem title="تم تعيين دورة" detail="قسم المالية" time="اليوم، 09:18" /><ActivityItem title="تم تنزيل تقرير" detail="تقرير مخاطر الربع الأول" time="أمس، 16:04" /></section>;
}

function ArabicTenants() {
  return <section className="surface-card overflow-x-auto"><table className="w-full min-w-[680px] text-sm"><thead className="bg-muted/60 text-xs text-muted-foreground"><tr><th className="px-5 py-3 text-start">المؤسسة</th><th className="px-5 py-3 text-start">الخطة</th><th className="px-5 py-3 text-start">المقاعد</th><th className="px-5 py-3 text-start">المخاطر</th><th className="px-5 py-3 text-start">الحالة</th></tr></thead><tbody className="divide-y">{[["الفلاح القابضة", "المؤسسات", "30 / 250", "39", "نشط"], ["نورا للخدمات اللوجستية", "القياسية", "84 / 100", "51", "تجريبي"], ["كريسنت الصحية", "المؤسسات", "612 / 800", "28", "نشط"]].map((row) => <tr key={row[0]}>{row.map((cell) => <td key={cell} className="px-5 py-4">{cell}</td>)}</tr>)}</tbody></table></section>;
}

function Header({ eyebrow, title, description, action }: { eyebrow: string; title: string; description: string; action?: React.ReactNode }) {
  return <header className="mb-7 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-semibold uppercase tracking-[.18em] text-primary">{eyebrow}</p><h1 className="mt-2 text-3xl font-bold tracking-tight text-balance">{title}</h1><p className="mt-2 max-w-2xl text-sm text-muted-foreground text-pretty">{description}</p></div>{action}</header>;
}

function Dashboard({ role }: { role: UserRole }) {
  if (role === "employee") return <EmployeeDashboard />;
  if (role === "executive") return <ExecutiveDashboard />;
  if (role === "hr") return <HrDashboard />;
  if (role === "admin") return <AdminDashboard />;
  return <SuperDashboard />;
}

function EmployeeDashboard() {
  return <><Header eyebrow="Personal overview" title="Good morning, Omar" description="Your security habits are improving. Complete one recommended action this week to keep the momentum." action={<Button><Sparkles className="size-4" /> View recommendations</Button>} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Human Risk Score" value="39" delta="6 points" detail="Lower is better" /><StatCard label="Cyber Culture Index" value="78" delta="8%" detail="Above organization average" /><StatCard label="Learning progress" value="72%" delta="12%" detail="3 active courses" /><StatCard label="Current streak" value="14 days" delta="Best" detail="Keep learning daily" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge /><TrendChart values={trend} label="Your risk is trending down" /></div><div className="mt-4 grid gap-4 lg:grid-cols-2"><section className="surface-card p-6"><h2 className="font-semibold">Continue learning</h2><div className="mt-5 space-y-5">{courses.slice(0, 2).map((course) => <ProgressRow key={course.title} title={course.title} progress={course.progress} detail={`${course.duration} · ${course.xp} XP`} />)}</div></section><section className="surface-card p-6"><h2 className="font-semibold">Recent activity</h2><div className="mt-2 divide-y">{notifications.map((item) => <ActivityItem key={item.title} title={item.title} detail={item.body} time={item.time} />)}</div></section></div></>;
}

function ExecutiveDashboard() {
  return <><Header eyebrow="Executive intelligence" title="Organization risk overview" description="A concise view of human risk exposure, culture strength, and predicted pressure points." action={<a href="/api/report" target="_blank"><Button><Download className="size-4" /> Download board report</Button></a>} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Organization HRS" value="39" delta="9 points" /><StatCard label="Cyber Culture Index" value="78" delta="14%" /><StatCard label="Estimated exposure" value="$412K" delta="$86K" /><StatCard label="High-risk employees" value="7" delta="3 people" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[1.6fr_.8fr]"><TrendChart values={trend} label="Organization risk trajectory" /><RiskGauge value={39} label="Current organization HRS" /></div><div className="mt-4 surface-card p-6"><h2 className="font-semibold">Predictive risk intelligence</h2><p className="mt-1 text-sm text-muted-foreground">Forecasted pressure points for the next 30 days</p><div className="mt-5 grid gap-4 md:grid-cols-3"><Prediction title="Security fatigue" value="52%" trend="Improving" /><Prediction title="Phishing susceptibility" value="38%" trend="Improving" /><Prediction title="Insider threat likelihood" value="16%" trend="Stable" /></div></div></>;
}

function HrDashboard() {
  return <><Header eyebrow="People intelligence" title="Workforce security readiness" description="Track engagement, behavioral risk, and learning completion across your workforce." action={<Button><Send className="size-4" /> Send reminder</Button>} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Learning completion" value="84%" delta="11%" /><StatCard label="Assessment completion" value="76%" delta="8%" /><StatCard label="At-risk employees" value="12" positive={false} delta="2 new" /><StatCard label="Active learners" value="24 / 29" delta="4%" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><PeopleTable /><section className="surface-card p-6"><h2 className="font-semibold">Department readiness</h2><div className="mt-6 space-y-5"><ProgressRow title="Technology" progress={94} /><ProgressRow title="Human Resources" progress={86} /><ProgressRow title="Operations" progress={74} /><ProgressRow title="Finance" progress={61} /></div></section></div></>;
}

function AdminDashboard() {
  return <><Header eyebrow="Security operations" title="Program command center" description="Manage campaigns, users, content, and operational security controls." action={<Button><Plus className="size-4" /> New campaign</Button>} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Active users" value="29" delta="3 this month" /><StatCard label="Campaign report rate" value="64%" delta="17%" /><StatCard label="Open actions" value="8" positive={false} delta="2 urgent" /><StatCard label="MFA adoption" value="72%" delta="9%" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><PeopleTable /><section className="surface-card p-6"><h2 className="font-semibold">Security controls</h2><div className="mt-5 space-y-3"><Control label="Row-level tenant isolation" enabled /><Control label="Login lockout protection" enabled /><Control label="MFA required" /><Control label="AI assistant" enabled /><Control label="Predictive intelligence" enabled /></div></section></div></>;
}

function SuperDashboard() {
  return <><Header eyebrow="Platform operations" title="CyberCultX platform health" description="Monitor tenant adoption, licensing, global services, and platform-wide controls." action={<Button><Plus className="size-4" /> Add tenant</Button>} /><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label="Active tenants" value="18" delta="3 this quarter" /><StatCard label="Licensed seats" value="4,280" delta="12%" /><StatCard label="Monthly active users" value="3,412" delta="8%" /><StatCard label="Platform uptime" value="99.98%" delta="Healthy" /></div><div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><TrendChart values={cciTrend} label="Platform adoption trend" /><section className="surface-card p-6"><h2 className="font-semibold">Service health</h2><div className="mt-5 space-y-3"><Control label="Authentication" enabled /><Control label="Database" enabled /><Control label="AI assistant" enabled /><Control label="Notification delivery" enabled /><Control label="Report generation" enabled /></div></section></div></>;
}

function RiskPage({ role }: { role: UserRole }) {
  return <><Header eyebrow="Risk intelligence" title={role === "employee" ? "Your human risk profile" : "Predictive human risk intelligence"} description="Behavioral signals, historical performance, and predicted areas requiring attention." /><div className="grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge value={role === "employee" ? 39 : 42} /><TrendChart values={trend} /></div><div className="mt-4 grid gap-4 md:grid-cols-2 xl:grid-cols-4"><Prediction title="Compliance" value="82%" trend="Strong" /><Prediction title="Curiosity control" value="61%" trend="Improving" /><Prediction title="Stress tolerance" value="69%" trend="Stable" /><Prediction title="Reporting likelihood" value="74%" trend="Improving" /></div></>;
}

function PeoplePage({ role }: { role: UserRole }) {
  return <><Header eyebrow="People" title="Employee risk roster" description="Prioritize support using current risk, learning completion, and department signals." action={<Button><Plus className="size-4" /> {role === "admin" ? "Invite user" : "Assign learning"}</Button>} /><PeopleTable /></>;
}

function PeopleTable() {
  return <section className="surface-card overflow-hidden"><div className="flex items-center justify-between p-5"><div><h2 className="font-semibold">Priority roster</h2><p className="text-sm text-muted-foreground">Sorted by current risk</p></div><StatusPill>29 employees</StatusPill></div><div className="overflow-x-auto"><table className="w-full min-w-[680px] text-start text-sm"><thead className="bg-muted/60 text-xs uppercase tracking-wider text-muted-foreground"><tr><th className="px-5 py-3 text-start">Employee</th><th className="px-5 py-3 text-start">Department</th><th className="px-5 py-3 text-start">Risk</th><th className="px-5 py-3 text-start">Status</th><th className="px-5 py-3 text-start">Training</th></tr></thead><tbody className="divide-y">{people.map((person) => <tr key={person.name} className="hover:bg-muted/30"><td className="px-5 py-4 font-medium">{person.name}</td><td className="px-5 py-4 text-muted-foreground">{person.department}</td><td className="px-5 py-4 tabular-nums">{person.risk}</td><td className="px-5 py-4"><StatusPill tone={person.status === "Low" ? "good" : person.status === "Critical" ? "bad" : "warn"}>{person.status}</StatusPill></td><td className="px-5 py-4 tabular-nums">{person.training}</td></tr>)}</tbody></table></div></section>;
}

function LearningPage() {
  return <><Header eyebrow="Learning" title="Security learning center" description="Personalized learning paths designed around current behavioral risk." /><div className="grid gap-4 lg:grid-cols-3">{courses.map((course) => <article key={course.title} className="surface-card p-6"><div className="grid size-11 place-items-center rounded-xl bg-primary/10 text-primary"><ShieldCheck className="size-5" /></div><h2 className="mt-5 font-semibold">{course.title}</h2><p className="mt-2 text-sm text-muted-foreground">{course.duration} · Earn {course.xp} XP</p><div className="mt-6"><ProgressRow title="Progress" progress={course.progress} /></div><Button variant={course.progress === 100 ? "outline" : "default"} className="mt-6 w-full">{course.progress === 100 ? "Review course" : "Continue course"}</Button></article>)}</div></>;
}

function AssessmentsPage() {
  return <><Header eyebrow="Assessments" title="Knowledge and behavior assessments" description="Understand your strengths and uncover practical areas for improvement." /><div className="grid gap-4 md:grid-cols-2"><Assessment title="Security Knowledge Check" detail="20 questions · 15 minutes" score="84%" /><Assessment title="Cyber Behavior Profile" detail="32 questions · 12 minutes" score="Complete" /></div></>;
}

function Assessment({ title, detail, score }: { title: string; detail: string; score: string }) {
  return <article className="surface-card p-6"><div className="flex items-start justify-between gap-4"><div className="grid size-11 place-items-center rounded-xl bg-primary/10 text-primary"><ShieldCheck className="size-5" /></div><StatusPill tone="good">{score}</StatusPill></div><h2 className="mt-5 font-semibold">{title}</h2><p className="mt-2 text-sm text-muted-foreground">{detail}</p><Button variant="outline" className="mt-6">View results</Button></article>;
}

function CampaignsPage({ role }: { role: UserRole }) {
  if (role === "employee") return <><Header eyebrow="Phishing readiness" title="Simulation performance" description="Review simulation outcomes and learn the signals you handled well." /><div className="grid gap-4 sm:grid-cols-3"><StatCard label="Report rate" value="80%" delta="18%" /><StatCard label="Click rate" value="10%" delta="8%" /><StatCard label="Simulations completed" value="6" delta="2" /></div><div className="mt-4"><EmptyState title="You handled the latest simulation safely" body="You reported the suspicious message without opening the link." /></div></>;
  return <><Header eyebrow="Phishing simulations" title="Campaign operations" description="Create localized simulations, track reporting behavior, and follow up with targeted learning." action={<Button><Plus className="size-4" /> Create campaign</Button>} /><div className="grid gap-4 sm:grid-cols-3"><StatCard label="Average report rate" value="64%" delta="17%" /><StatCard label="Average click rate" value="11%" delta="5%" /><StatCard label="Active campaigns" value="3" delta="1" /></div><div className="mt-4 surface-card p-6"><h2 className="font-semibold">Recent campaigns</h2><div className="mt-4 divide-y">{["April Invoice Drill", "Executive WhatsApp Scam", "Delivery Notification Test"].map((title, i) => <ActivityItem key={title} title={title} detail={`${29 - i * 4} recipients · ${64 + i * 6}% reported`} time={i === 0 ? "Running" : "Complete"} />)}</div></div></>;
}

function ReportsPage() {
  return <><Header eyebrow="Reports" title="Intelligence reports" description="Board-ready summaries and operational exports in a consistent reporting format." action={<a href="/api/report" target="_blank"><Button><Download className="size-4" /> Generate PDF</Button></a>} /><div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">{["Quarterly Risk Intelligence", "Learning & Culture", "Phishing Readiness"].map((title) => <article key={title} className="surface-card p-6"><div className="grid size-11 place-items-center rounded-xl bg-primary/10 text-primary"><ShieldCheck className="size-5" /></div><h2 className="mt-5 font-semibold">{title}</h2><p className="mt-2 text-sm text-muted-foreground">Updated today · English & Arabic</p><a href="/api/report" target="_blank"><Button variant="outline" className="mt-6"><Download className="size-4" /> Download PDF</Button></a></article>)}</div></>;
}

function NotificationsPage() {
  return <><Header eyebrow="Inbox" title="Notifications" description="Updates from your learning, risk program, and organization." /><section className="surface-card divide-y p-3">{notifications.map((item) => <ActivityItem key={item.title} title={item.title} detail={item.body} time={item.time} />)}</section></>;
}

function AuditPage() {
  return <><Header eyebrow="Governance" title="Audit log" description="Review notable authentication and platform activity." /><section className="surface-card overflow-x-auto"><table className="w-full min-w-[720px] text-sm"><thead className="bg-muted/60 text-xs uppercase text-muted-foreground"><tr><th className="px-5 py-3 text-start">Actor</th><th className="px-5 py-3 text-start">Action</th><th className="px-5 py-3 text-start">Target</th><th className="px-5 py-3 text-start">Time</th></tr></thead><tbody className="divide-y">{audits.map((entry) => <tr key={entry.action + entry.time}><td className="px-5 py-4">{entry.actor}</td><td className="px-5 py-4 font-mono text-xs">{entry.action}</td><td className="px-5 py-4">{entry.target}</td><td className="px-5 py-4 text-muted-foreground">{entry.time}</td></tr>)}</tbody></table></section></>;
}

function SettingsPage({ role }: { role: UserRole }) {
  return <><Header eyebrow="Configuration" title={`${role === "superadmin" ? "Platform" : "Organization"} settings`} description="Manage security controls and feature availability." /><div className="grid gap-4 lg:grid-cols-2"><section className="surface-card p-6"><h2 className="font-semibold">Security controls</h2><div className="mt-5 space-y-3"><Control label="Require MFA enrollment" /><Control label="Account lockout" enabled /><Control label="Audit logging" enabled /><Control label="API rate limiting" enabled /></div></section><section className="surface-card p-6"><h2 className="font-semibold">Product features</h2><div className="mt-5 space-y-3"><Control label="AI assistant" enabled /><Control label="Predictive risk intelligence" enabled /><Control label="PDF reports" enabled /><Control label="Arabic experience" enabled /></div></section></div></>;
}

function TenantsPage() {
  return <><Header eyebrow="Platform administration" title="Tenant management" description="Monitor organizations, plans, seats, and current human risk posture." action={<Button><Plus className="size-4" /> Add tenant</Button>} /><section className="surface-card overflow-x-auto"><table className="w-full min-w-[720px] text-sm"><thead className="bg-muted/60 text-xs uppercase text-muted-foreground"><tr><th className="px-5 py-3 text-start">Organization</th><th className="px-5 py-3 text-start">Plan</th><th className="px-5 py-3 text-start">Seats</th><th className="px-5 py-3 text-start">HRS</th><th className="px-5 py-3 text-start">Status</th></tr></thead><tbody className="divide-y">{tenants.map((tenant) => <tr key={tenant.name}><td className="px-5 py-4 font-medium">{tenant.name}</td><td className="px-5 py-4">{tenant.plan}</td><td className="px-5 py-4 tabular-nums">{tenant.seats}</td><td className="px-5 py-4 tabular-nums">{tenant.risk}</td><td className="px-5 py-4"><StatusPill tone="good">{tenant.status}</StatusPill></td></tr>)}</tbody></table></section></>;
}

function Prediction({ title, value, trend: direction }: { title: string; value: string; trend: string }) {
  return <article className="surface-card p-5"><p className="text-sm text-muted-foreground">{title}</p><strong className="mt-3 block text-3xl tabular-nums">{value}</strong><p className="mt-2 text-xs font-medium text-emerald-600">{direction}</p></article>;
}

function Control({ label, enabled = false }: { label: string; enabled?: boolean }) {
  return <div className="flex min-h-12 items-center justify-between gap-4 rounded-xl bg-muted/55 px-3"><span className="text-sm font-medium">{label}</span><span className={`relative h-6 w-11 rounded-full ${enabled ? "bg-primary" : "bg-muted-foreground/25"}`}><span className={`absolute top-1 size-4 rounded-full bg-white shadow-sm transition-[inset-inline-start] ${enabled ? "start-6" : "start-1"}`} /></span></div>;
}
