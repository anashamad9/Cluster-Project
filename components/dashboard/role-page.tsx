import { Download, Plus, Send, ShieldCheck, Sparkles } from "lucide-react";
import { ActivityItem, EmptyState, ProgressRow, RiskGauge, StatCard, StatusPill, TrendChart } from "@/components/dashboard/widgets";
import { Button } from "@/components/ui/button";
import type { UserRole } from "@/lib/auth/roles";
import type { DashboardData, DashboardPerson } from "@/lib/dashboard-data";
import { assignCourse, createCampaign, createTenant, inviteUser, markNotificationsRead, sendReminder, toggleFeature } from "@/lib/platform-actions";

export function RolePage({ locale, role, section, data }: { locale: string; role: UserRole; section: string; data: DashboardData }) {
  const ar = locale === "ar";
  if (section === "notifications") return <NotificationsPage data={data} ar={ar} />;
  if (section === "people") return <PeoplePage role={role} data={data} ar={ar} />;
  if (section === "learning") return <LearningPage role={role} data={data} ar={ar} />;
  if (section === "assessments") return <AssessmentsPage role={role} data={data} ar={ar} />;
  if (section === "phishing" || section === "campaigns") return <CampaignsPage role={role} data={data} ar={ar} />;
  if (section === "risk") return <RiskPage role={role} data={data} ar={ar} />;
  if (section === "reports") return <ReportsPage data={data} ar={ar} />;
  if (section === "audit") return <AuditPage data={data} ar={ar} />;
  if (section === "settings") return <SettingsPage role={role} data={data} ar={ar} />;
  if (section === "tenants") return <TenantsPage data={data} ar={ar} />;
  return <Dashboard role={role} data={data} ar={ar} />;
}

function Header({ eyebrow, title, description, action }: { eyebrow: string; title: string; description: string; action?: React.ReactNode }) {
  return <header className="mb-7 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between"><div><p className="text-xs font-semibold uppercase tracking-[.18em] text-primary">{eyebrow}</p><h1 className="mt-2 text-3xl font-bold tracking-tight text-balance">{title}</h1><p className="mt-2 max-w-2xl text-sm text-muted-foreground text-pretty">{description}</p></div>{action}</header>;
}

const pct = (value: number) => `${value}%`;
const delta = (value: number, suffix = "points") => `${Math.abs(value)} ${suffix}`;
const money = (value: number, currency: string) => new Intl.NumberFormat("en", { style: "currency", currency, notation: "compact", maximumFractionDigits: 0 }).format(value);

function Dashboard({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  if (role === "employee") return <EmployeeDashboard data={data} ar={ar} />;
  if (role === "executive") return <ExecutiveDashboard data={data} ar={ar} />;
  if (role === "hr") return <HrDashboard data={data} ar={ar} />;
  if (role === "admin") return <AdminDashboard data={data} ar={ar} />;
  return <SuperDashboard data={data} ar={ar} />;
}

function EmployeeDashboard({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "نظرة شخصية" : "Personal overview"} title={ar ? `مرحبًا، ${data.profile.nameAr}` : `Good morning, ${data.profile.name}`} description={ar ? "تعرض هذه الصفحة أحدث بياناتك المسجلة في المنصة." : "This page reflects your latest recorded security activity."} action={<a href={`/${ar ? "ar" : "en"}/employee/risk`}><Button><Sparkles className="size-4" /> {ar ? "عرض التوصيات" : "View recommendations"}</Button></a>} />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label={ar ? "مؤشر المخاطر البشرية" : "Human Risk Score"} value={String(data.currentHrs)} delta={delta(data.riskDelta)} detail={ar ? "الأقل أفضل" : "Lower is better"} /><StatCard label={ar ? "مؤشر الثقافة السيبرانية" : "Cyber Culture Index"} value={String(data.currentCci)} delta={delta(data.cciDelta)} /><StatCard label={ar ? "تقدم التعلم" : "Learning progress"} value={pct(data.metrics.learningCompletion)} detail={`${data.courses.filter((course) => course.progress > 0 && course.progress < 100).length} ${ar ? "دورات نشطة" : "active courses"}`} /><StatCard label={ar ? "النشاط المتواصل" : "Current streak"} value={`${data.profile.streak} ${ar ? "يوم" : "days"}`} /></div>
    <div className="mt-4 grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge value={data.currentHrs} label={ar ? "مؤشر المخاطر البشرية" : "Human Risk Score"} /><TrendChart values={data.riskTrend} label={ar ? "اتجاه المخاطر" : "Your risk trend"} /></div>
    <div className="mt-4 grid gap-4 lg:grid-cols-2"><CourseProgress data={data} ar={ar} /><NotificationList data={data} ar={ar} compact /></div></>;
}

function ExecutiveDashboard({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "الاستخبارات التنفيذية" : "Executive intelligence"} title={ar ? "نظرة عامة على مخاطر المؤسسة" : "Organization risk overview"} description={ar ? "ملخص مباشر لوضع المخاطر والثقافة الأمنية." : "A live view of human risk exposure, culture strength, and predictive signals."} action={<ReportButton ar={ar} />} />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label={ar ? "مخاطر المؤسسة" : "Organization HRS"} value={String(data.currentHrs)} delta={delta(data.riskDelta)} /><StatCard label={ar ? "مؤشر الثقافة" : "Cyber Culture Index"} value={String(data.currentCci)} delta={delta(data.cciDelta)} /><StatCard label={ar ? "التعرض المالي المتوقع" : "Estimated exposure"} value={money(data.exposure.value, data.exposure.currency)} /><StatCard label={ar ? "الموظفون مرتفعو المخاطر" : "High-risk employees"} value={String(data.metrics.atRisk)} /></div>
    <div className="mt-4 grid gap-4 xl:grid-cols-[1.6fr_.8fr]"><TrendChart values={data.riskTrend} label={ar ? "مسار مخاطر المؤسسة" : "Organization risk trajectory"} /><RiskGauge value={data.currentHrs} label={ar ? "المخاطر الحالية" : "Current organization HRS"} /></div>
    <Predictive data={data} ar={ar} /></>;
}

function HrDashboard({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "استخبارات الموظفين" : "People intelligence"} title={ar ? "جاهزية القوى العاملة" : "Workforce security readiness"} description={ar ? "متابعة المشاركة والمخاطر وإكمال التعلم." : "Track engagement, behavioral risk, and learning completion across your workforce."} action={<ReminderAction ar={ar} />} />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label={ar ? "إكمال التعلم" : "Learning completion"} value={pct(data.metrics.learningCompletion)} /><StatCard label={ar ? "إكمال التقييمات" : "Assessment completion"} value={pct(data.metrics.assessmentCompletion)} /><StatCard label={ar ? "الموظفون المعرضون للخطر" : "At-risk employees"} value={String(data.metrics.atRisk)} positive={false} /><StatCard label={ar ? "المتعلمون النشطون" : "Active learners"} value={`${data.metrics.activeLearners} / ${data.metrics.activeUsers}`} /></div>
    <div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><PeopleTable data={data} ar={ar} /><DepartmentReadiness data={data} ar={ar} /></div></>;
}

function AdminDashboard({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "عمليات الأمن" : "Security operations"} title={ar ? "مركز قيادة البرنامج" : "Program command center"} description={ar ? "إدارة المستخدمين والحملات والضوابط." : "Manage campaigns, users, content, and operational security controls."} action={<CampaignAction data={data} ar={ar} />} />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label={ar ? "المستخدمون النشطون" : "Active users"} value={String(data.metrics.activeUsers)} /><StatCard label={ar ? "معدل الإبلاغ" : "Campaign report rate"} value={pct(data.campaignStats.reportRate)} /><StatCard label={ar ? "الحملات النشطة" : "Active campaigns"} value={String(data.campaignStats.active)} /><StatCard label={ar ? "اعتماد المصادقة المتعددة" : "MFA adoption"} value={pct(data.metrics.mfaAdoption)} /></div>
    <div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><PeopleTable data={data} ar={ar} /><Controls data={data} ar={ar} /></div></>;
}

function SuperDashboard({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "عمليات المنصة" : "Platform operations"} title={ar ? "صحة منصة CyberCultX" : "CyberCultX platform health"} description={ar ? "متابعة المؤسسات والتراخيص وخدمات المنصة." : "Monitor tenant adoption, licensing, and platform-wide controls."} />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><StatCard label={ar ? "المؤسسات النشطة" : "Active tenants"} value={String(data.tenants.filter((tenant) => tenant.status === "active").length)} /><StatCard label={ar ? "المقاعد المرخصة" : "Licensed seats"} value={String(data.metrics.licensedSeats)} /><StatCard label={ar ? "المستخدمون النشطون" : "Active users"} value={String(data.metrics.activeUsers)} /><StatCard label={ar ? "متوسط المخاطر" : "Average HRS"} value={String(data.currentHrs)} /></div>
    <div className="mt-4 grid gap-4 xl:grid-cols-[1.5fr_1fr]"><TrendChart values={data.riskTrend} label={ar ? "اتجاه المخاطر عبر المنصة" : "Platform risk trend"} /><Controls data={data} ar={ar} /></div></>;
}

function RiskPage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "استخبارات المخاطر" : "Risk intelligence"} title={role === "employee" ? (ar ? "ملف المخاطر البشرية" : "Your human risk profile") : (ar ? "استخبارات المخاطر التنبؤية" : "Predictive human risk intelligence")} description={ar ? "إشارات سلوكية وأداء تاريخي من قاعدة البيانات." : "Behavioral signals and historical performance from Supabase."} />
    <div className="grid gap-4 xl:grid-cols-[.8fr_1.7fr]"><RiskGauge value={data.currentHrs} /><TrendChart values={data.riskTrend} /></div>
    <div className="mt-4 grid gap-4 md:grid-cols-2 xl:grid-cols-4"><Prediction title={ar ? "الالتزام" : "Compliance"} value={pct(data.dimensions.compliance)} /><Prediction title={ar ? "التحكم بالفضول" : "Curiosity control"} value={pct(100 - data.dimensions.curiosity)} /><Prediction title={ar ? "تحمل الضغط" : "Stress tolerance"} value={pct(data.dimensions.stressTolerance)} /><Prediction title={ar ? "احتمالية الإبلاغ" : "Reporting likelihood"} value={pct(data.predictive.reportingLikelihood)} /></div></>;
}

function PeoplePage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "الموظفون" : "People"} title={ar ? "قائمة مخاطر الموظفين" : "Employee risk roster"} description={ar ? "مرتبة حسب أحدث مؤشر مخاطر مسجل." : "Prioritized using the latest recorded risk and learning completion."} action={role === "admin" ? <InviteAction data={data} ar={ar} /> : <AssignAction data={data} ar={ar} />} /><PeopleTable data={data} ar={ar} /></>;
}

function PeopleTable({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <section className="surface-card overflow-hidden"><div className="flex items-center justify-between p-5"><div><h2 className="font-semibold">{ar ? "قائمة الأولوية" : "Priority roster"}</h2><p className="text-sm text-muted-foreground">{ar ? "مرتبة حسب المخاطر الحالية" : "Sorted by current risk"}</p></div><StatusPill>{data.people.length} {ar ? "موظف" : "employees"}</StatusPill></div><div className="overflow-x-auto"><table className="w-full min-w-[680px] text-start text-sm"><thead className="bg-muted/60 text-xs uppercase tracking-wider text-muted-foreground"><tr>{[ar ? "الموظف" : "Employee", ar ? "القسم" : "Department", ar ? "المخاطر" : "Risk", ar ? "الحالة" : "Status", ar ? "التدريب" : "Training"].map((head) => <th key={head} className="px-5 py-3 text-start">{head}</th>)}</tr></thead><tbody className="divide-y">{data.people.map((person) => <PersonRow key={person.id} person={person} ar={ar} />)}</tbody></table></div></section>;
}

function PersonRow({ person, ar }: { person: DashboardPerson; ar: boolean }) {
  const labels = { Low: "منخفض", Medium: "متوسط", High: "مرتفع", Critical: "حرج" };
  return <tr className="hover:bg-muted/30"><td className="px-5 py-4 font-medium">{ar ? person.nameAr : person.name}</td><td className="px-5 py-4 text-muted-foreground">{ar ? person.departmentAr : person.department}</td><td className="px-5 py-4 tabular-nums">{person.risk}</td><td className="px-5 py-4"><StatusPill tone={person.status === "Low" ? "good" : person.status === "Critical" ? "bad" : "warn"}>{ar ? labels[person.status] : person.status}</StatusPill></td><td className="px-5 py-4 tabular-nums">{pct(person.training)}</td></tr>;
}

function LearningPage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  const locale = ar ? "ar" : "en";
  return <><Header eyebrow={ar ? "التعلم" : "Learning"} title={ar ? "مركز التعلم الأمني" : "Security learning center"} description={ar ? "الدورات المنشورة وتقدمك المسجل." : "Published courses and your recorded progress."} /><div className="grid gap-4 lg:grid-cols-3">{data.courses.map((course) => <article key={course.id} className="surface-card p-6"><ShieldCheck className="size-7 text-primary" /><h2 className="mt-5 font-semibold">{ar ? course.titleAr : course.title}</h2><p className="mt-2 text-sm text-muted-foreground">{course.duration} {ar ? "دقيقة" : "min"} · {course.xp} XP</p><div className="mt-6"><ProgressRow title={ar ? "التقدم" : "Progress"} progress={course.progress} /></div><a href={`/${locale}/${role}/course/${course.id}`}><Button variant={course.progress === 100 ? "outline" : "default"} className="mt-6 w-full">{course.progress === 100 ? (ar ? "مراجعة الدورة" : "Review course") : (ar ? "متابعة الدورة" : "Continue course")}</Button></a></article>)}</div></>;
}

function AssessmentsPage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  const locale = ar ? "ar" : "en";
  return <><Header eyebrow={ar ? "التقييمات" : "Assessments"} title={ar ? "تقييمات المعرفة والسلوك" : "Knowledge and behavior assessments"} description={ar ? "التقييمات المنشورة وأحدث نتائجك." : "Published assessments and latest recorded results."} />{data.assessments.length ? <div className="grid gap-4 md:grid-cols-2">{data.assessments.map((assessment) => <article key={assessment.id} className="surface-card p-6"><div className="flex items-start justify-between gap-4"><ShieldCheck className="size-7 text-primary" /><StatusPill tone={assessment.score === "Not attempted" ? "neutral" : "good"}>{assessment.score === "Not attempted" && ar ? "لم تتم المحاولة" : assessment.score}</StatusPill></div><h2 className="mt-5 font-semibold">{ar ? assessment.titleAr : assessment.title}</h2><p className="mt-2 text-sm text-muted-foreground">{assessment.questionCount} {ar ? "سؤال" : "questions"} · {assessment.duration} {ar ? "دقيقة" : "minutes"}</p><a href={`/${locale}/${role}/assessment/${assessment.id}`}><Button className="mt-6" variant="outline">{ar ? "بدء التقييم" : "Take assessment"}</Button></a></article>)}</div> : <EmptyState title={ar ? "لا توجد تقييمات منشورة" : "No published assessments"} body={ar ? "قم بتشغيل ملف 04_assessments.sql لإضافة التقييمات." : "Run 04_assessments.sql to add the assessment catalog."} />}</>;
}

function CampaignsPage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  const employee = role === "employee";
  return <><Header eyebrow={ar ? "محاكاة التصيد" : "Phishing simulations"} title={employee ? (ar ? "أداء المحاكاة" : "Simulation performance") : (ar ? "عمليات الحملات" : "Campaign operations")} description={ar ? "نتائج حملات التصيد المسجلة في قاعدة البيانات." : "Phishing campaign results recorded in Supabase."} action={!employee ? <CampaignAction data={data} ar={ar} /> : undefined} />
    <div className="grid gap-4 sm:grid-cols-3"><StatCard label={ar ? "معدل الإبلاغ" : "Report rate"} value={pct(data.campaignStats.reportRate)} /><StatCard label={ar ? "معدل النقر" : "Click rate"} value={pct(data.campaignStats.clickRate)} positive={false} /><StatCard label={employee ? (ar ? "المحاكاة المكتملة" : "Simulations completed") : (ar ? "الحملات النشطة" : "Active campaigns")} value={String(employee ? data.campaignStats.completed : data.campaignStats.active)} /></div>
    <div className="mt-4 surface-card p-6"><h2 className="font-semibold">{ar ? "الحملات الأخيرة" : "Recent campaigns"}</h2><div className="mt-4 divide-y">{data.campaigns.length ? data.campaigns.map((campaign) => <ActivityItem key={campaign.id} title={campaign.title} detail={`${campaign.recipients} ${ar ? "مستلم" : "recipients"} · ${campaign.reportRate}% ${ar ? "أبلغوا" : "reported"}`} time={campaign.status} />) : <EmptyState title={ar ? "لا توجد حملات" : "No campaigns yet"} body={ar ? "ستظهر الحملات هنا بعد إنشائها." : "Campaign data will appear here once created."} />}</div></div></>;
}

function ReportsPage({ data, ar }: { data: DashboardData; ar: boolean }) {
  const cards = ar ? [["تقرير المخاطر","risk"], ["التعلم والثقافة","learning"], ["جاهزية التصيد","phishing"]] : [["Risk Intelligence","risk"], ["Learning & Culture","learning"], ["Phishing Readiness","phishing"]];
  return <><Header eyebrow={ar ? "التقارير" : "Reports"} title={ar ? "تقارير الاستخبارات" : "Intelligence reports"} description={ar ? `أحدث بيانات ${data.tenantName}.` : `Reports generated from the latest ${data.tenantName} data.`} action={<ReportButton ar={ar} type="risk" />} /><div className="grid gap-4 md:grid-cols-3">{cards.map(([title, type]) => <article key={title} className="surface-card p-6"><ShieldCheck className="size-7 text-primary" /><h2 className="mt-5 font-semibold">{title}</h2><p className="mt-2 text-sm text-muted-foreground">{ar ? "بيانات مباشرة من Supabase" : "Live Supabase data"}</p><ReportButton ar={ar} type={type} outline /></article>)}</div></>;
}

function NotificationsPage({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "صندوق الوارد" : "Inbox"} title={ar ? "الإشعارات" : "Notifications"} description={ar ? "إشعاراتك المسجلة في المنصة." : "Your platform notifications."} action={<form action={markNotificationsRead}><Button variant="outline">{ar ? "تحديد الكل كمقروء" : "Mark all read"}</Button></form>} /><NotificationList data={data} ar={ar} /></>;
}

function NotificationList({ data, ar, compact = false }: { data: DashboardData; ar: boolean; compact?: boolean }) {
  return <section className="surface-card p-6"><h2 className="font-semibold">{ar ? "آخر النشاطات" : "Recent activity"}</h2><div className="mt-2 divide-y">{data.notifications.slice(0, compact ? 5 : 20).map((item) => <ActivityItem key={item.id} title={ar ? item.titleAr : item.title} detail={ar ? item.bodyAr : item.body} time={item.time} />)}</div></section>;
}

function AuditPage({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "الحوكمة" : "Governance"} title={ar ? "سجل التدقيق" : "Audit log"} description={ar ? "أحدث نشاطات المصادقة والمنصة." : "Latest authentication and platform activity."} /><section className="surface-card overflow-x-auto"><table className="w-full min-w-[720px] text-sm"><thead className="bg-muted/60 text-xs uppercase text-muted-foreground"><tr>{[ar ? "الفاعل" : "Actor", ar ? "الإجراء" : "Action", ar ? "الهدف" : "Target", ar ? "الوقت" : "Time"].map((head) => <th key={head} className="px-5 py-3 text-start">{head}</th>)}</tr></thead><tbody className="divide-y">{data.audits.map((entry) => <tr key={entry.id}><td className="px-5 py-4">{entry.actor}</td><td className="px-5 py-4 font-mono text-xs">{entry.action}</td><td className="px-5 py-4">{entry.target}</td><td className="px-5 py-4 text-muted-foreground">{entry.time}</td></tr>)}</tbody></table></section></>;
}

function SettingsPage({ role, data, ar }: { role: UserRole; data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "الإعدادات" : "Configuration"} title={ar ? "إعدادات المنصة" : `${role === "superadmin" ? "Platform" : "Organization"} settings`} description={ar ? "حالة خصائص الأمان والمنصة." : "Current security controls and feature availability."} /><Controls data={data} ar={ar} /></>;
}

function TenantsPage({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <><Header eyebrow={ar ? "إدارة المنصة" : "Platform administration"} title={ar ? "إدارة المؤسسات" : "Tenant management"} description={ar ? "المؤسسات والتراخيص ووضع المخاطر." : "Organizations, licenses, and current human risk posture."} action={<TenantAction ar={ar} />} /><section className="surface-card overflow-x-auto"><table className="w-full min-w-[720px] text-sm"><thead className="bg-muted/60 text-xs uppercase text-muted-foreground"><tr>{[ar ? "المؤسسة" : "Organization", ar ? "الخطة" : "Plan", ar ? "المقاعد" : "Seats", ar ? "المخاطر" : "HRS", ar ? "الحالة" : "Status"].map((head) => <th key={head} className="px-5 py-3 text-start">{head}</th>)}</tr></thead><tbody className="divide-y">{data.tenants.map((tenant) => <tr key={tenant.id}><td className="px-5 py-4 font-medium">{ar ? tenant.nameAr : tenant.name}</td><td className="px-5 py-4">{tenant.plan}</td><td className="px-5 py-4 tabular-nums">{tenant.seats}</td><td className="px-5 py-4 tabular-nums">{tenant.risk}</td><td className="px-5 py-4"><StatusPill tone={tenant.status === "active" ? "good" : "warn"}>{tenant.status}</StatusPill></td></tr>)}</tbody></table></section></>;
}

function Predictive({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <div className="mt-4 surface-card p-6"><h2 className="font-semibold">{ar ? "استخبارات المخاطر التنبؤية" : "Predictive risk intelligence"}</h2><div className="mt-5 grid gap-4 md:grid-cols-3"><Prediction title={ar ? "الإرهاق الأمني" : "Security fatigue"} value={pct(data.predictive.securityFatigue)} /><Prediction title={ar ? "قابلية التصيد" : "Phishing susceptibility"} value={pct(data.predictive.phishingSusceptibility)} /><Prediction title={ar ? "احتمال التهديد الداخلي" : "Insider threat likelihood"} value={pct(data.predictive.insiderThreat)} /></div></div>;
}

function CourseProgress({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <section className="surface-card p-6"><h2 className="font-semibold">{ar ? "متابعة التعلم" : "Continue learning"}</h2><div className="mt-5 space-y-5">{data.courses.filter((course) => course.progress > 0 && course.progress < 100).slice(0, 4).map((course) => <ProgressRow key={course.id} title={ar ? course.titleAr : course.title} progress={course.progress} detail={`${course.duration} min · ${course.xp} XP`} />)}</div></section>;
}

function DepartmentReadiness({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <section className="surface-card p-6"><h2 className="font-semibold">{ar ? "جاهزية الأقسام" : "Department readiness"}</h2><div className="mt-6 space-y-5">{data.departments.map((department) => <ProgressRow key={department.name} title={ar ? department.nameAr : department.name} progress={department.readiness} />)}</div></section>;
}

function Controls({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <div className="grid gap-4 lg:grid-cols-2"><section className="surface-card p-6"><h2 className="font-semibold">{ar ? "ضوابط الأمان" : "Security controls"}</h2><div className="mt-5 space-y-3"><Control label={ar ? "فرض المصادقة متعددة العوامل" : "Require MFA enrollment"} featureKey="mfa_required" enabled={data.controls.mfaRequired} /><Control label={ar ? "عزل بيانات المؤسسات" : "Row-level tenant isolation"} enabled /><Control label={ar ? "تسجيل التدقيق" : "Audit logging"} enabled /></div></section><section className="surface-card p-6"><h2 className="font-semibold">{ar ? "خصائص المنصة" : "Product features"}</h2><div className="mt-5 space-y-3"><Control label={ar ? "المخاطر التنبؤية" : "Predictive risk intelligence"} featureKey="predictive_risk_intelligence" enabled={data.controls.predictiveRisk} /><Control label={ar ? "محاكاة التصيد" : "Phishing simulations"} featureKey="phishing_simulations" enabled={data.controls.phishingSimulations} /><Control label={ar ? "تقارير PDF" : "PDF reports"} featureKey="pdf_reports" enabled={data.controls.pdfReports} /></div></section></div>;
}

function ReportButton({ ar, type = "risk", outline = false }: { ar: boolean; type?: string; outline?: boolean }) {
  return <a href={`/api/report?type=${type}`} target="_blank"><Button variant={outline ? "outline" : "default"} className={outline ? "mt-6" : ""}><Download className="size-4" /> {ar ? "تنزيل التقرير" : "Download report"}</Button></a>;
}

function Prediction({ title, value }: { title: string; value: string }) {
  return <article className="surface-card p-5"><p className="text-sm text-muted-foreground">{title}</p><strong className="mt-3 block text-3xl tabular-nums">{value}</strong></article>;
}

function Control({ label, enabled = false, featureKey }: { label: string; enabled?: boolean; featureKey?: string }) {
  const visual = <span className={`relative h-6 w-11 rounded-full ${enabled ? "bg-primary" : "bg-muted-foreground/25"}`}><span className={`absolute top-1 size-4 rounded-full bg-white shadow-sm ${enabled ? "start-6" : "start-1"}`} /></span>;
  return <div className="flex min-h-12 items-center justify-between gap-4 rounded-xl bg-muted/55 px-3"><span className="text-sm font-medium">{label}</span>{featureKey ? <form action={toggleFeature}><input type="hidden" name="key" value={featureKey} /><input type="hidden" name="enabled" value={String(enabled)} /><button aria-label={`Toggle ${label}`}>{visual}</button></form> : visual}</div>;
}

const field = "h-10 w-full rounded-xl border bg-background px-3 text-sm";

function ActionPanel({ label, children }: { label: React.ReactNode; children: React.ReactNode }) {
  return <details className="relative"><summary className="inline-flex h-10 cursor-pointer list-none items-center gap-1.5 rounded-lg bg-primary px-3 text-sm font-medium text-primary-foreground hover:bg-primary/80">{label}</summary><div className="surface-card absolute end-0 z-20 mt-2 w-80 p-4 shadow-xl">{children}</div></details>;
}

function ReminderAction({ ar }: { ar: boolean }) {
  return <ActionPanel label={<><Send className="size-4" /> {ar ? "إرسال تذكير" : "Send reminder"}</>}><form action={sendReminder} className="space-y-3"><textarea name="body" className={`${field} min-h-24 py-2`} defaultValue="Please review and complete your outstanding security learning." /><Button className="w-full">{ar ? "إرسال للجميع" : "Send to everyone"}</Button></form></ActionPanel>;
}

function CampaignAction({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <ActionPanel label={<><Plus className="size-4" /> {ar ? "حملة جديدة" : "New campaign"}</>}><form action={createCampaign} className="space-y-3"><input name="name" required className={field} placeholder={ar ? "اسم الحملة" : "Campaign name"} /><select name="templateId" required className={field}>{data.templates.map((template) => <option key={template.id} value={template.id}>{ar ? template.nameAr : template.name}</option>)}</select><Button className="w-full">{ar ? "إنشاء وتشغيل" : "Create and start"}</Button></form></ActionPanel>;
}

function AssignAction({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <ActionPanel label={<><Plus className="size-4" /> {ar ? "تعيين تعلم" : "Assign learning"}</>}><form action={assignCourse} className="space-y-3"><select name="courseId" className={field}>{data.courses.map((course) => <option key={course.id} value={course.id}>{ar ? course.titleAr : course.title}</option>)}</select><select name="profileId" className={field}><option value="">{ar ? "جميع الموظفين" : "All employees"}</option>{data.people.map((person) => <option key={person.id} value={person.id}>{ar ? person.nameAr : person.name}</option>)}</select><Button className="w-full">{ar ? "تعيين" : "Assign"}</Button></form></ActionPanel>;
}

function InviteAction({ data, ar }: { data: DashboardData; ar: boolean }) {
  return <ActionPanel label={<><Plus className="size-4" /> {ar ? "دعوة مستخدم" : "Invite user"}</>}><form action={inviteUser} className="space-y-3"><input name="fullName" required className={field} placeholder={ar ? "الاسم الكامل" : "Full name"} /><input name="email" type="email" required className={field} placeholder="email@company.com" /><input name="password" required className={field} defaultValue="ChangeMe@2026" /><select name="userRole" className={field}>{["employee","hr","executive","admin"].map((role) => <option key={role}>{role}</option>)}</select><input type="hidden" name="tenantId" value={data.profile.tenantId ?? ""} /><Button className="w-full">{ar ? "إنشاء المستخدم" : "Create user"}</Button></form></ActionPanel>;
}

function TenantAction({ ar }: { ar: boolean }) {
  return <ActionPanel label={<><Plus className="size-4" /> {ar ? "إضافة مؤسسة" : "Add tenant"}</>}><form action={createTenant} className="space-y-3"><input name="name" required className={field} placeholder={ar ? "اسم المؤسسة" : "Organization name"} /><input name="slug" required className={field} placeholder="organization-slug" /><select name="plan" className={field}><option value="standard">Standard</option><option value="enterprise">Enterprise</option></select><input name="seats" type="number" min="1" defaultValue="50" className={field} /><Button className="w-full">{ar ? "إنشاء المؤسسة" : "Create tenant"}</Button></form></ActionPanel>;
}
