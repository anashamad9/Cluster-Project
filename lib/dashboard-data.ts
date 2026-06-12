import type { UserRole } from "@/lib/auth/roles";
import { hasOpenAIEnv, hasSupabaseEnv } from "@/lib/config";
import { createClient } from "@/lib/supabase/server";

type Row = Record<string, unknown>;

export type DashboardPerson = {
  id: string;
  name: string;
  nameAr: string;
  department: string;
  departmentAr: string;
  risk: number;
  status: "Low" | "Medium" | "High" | "Critical";
  training: number;
};

export type DashboardCourse = {
  id: string;
  title: string;
  titleAr: string;
  duration: number;
  xp: number;
  progress: number;
};

export type DashboardAssessment = {
  id: string;
  title: string;
  titleAr: string;
  duration: number;
  questionCount: number;
  score: string;
};

export type DashboardData = {
  connected: boolean;
  profile: {
    id: string;
    tenantId: string | null;
    name: string;
    nameAr: string;
    streak: number;
  };
  tenantName: string;
  currentHrs: number;
  currentCci: number;
  riskTrend: number[];
  cciTrend: number[];
  riskDelta: number;
  cciDelta: number;
  dimensions: {
    compliance: number;
    curiosity: number;
    stressTolerance: number;
    susceptibility: number;
  };
  predictive: {
    securityFatigue: number;
    phishingSusceptibility: number;
    insiderThreat: number;
    reportingLikelihood: number;
  };
  exposure: { value: number; currency: string };
  people: DashboardPerson[];
  courses: DashboardCourse[];
  assessments: DashboardAssessment[];
  notifications: { id: string; title: string; titleAr: string; body: string; bodyAr: string; time: string }[];
  audits: { id: string; actor: string; action: string; target: string; time: string }[];
  campaigns: { id: string; title: string; recipients: number; reportRate: number; status: string }[];
  templates: { id: string; name: string; nameAr: string }[];
  campaignStats: { reportRate: number; clickRate: number; active: number; completed: number };
  departments: { name: string; nameAr: string; readiness: number }[];
  tenants: { id: string; name: string; nameAr: string; plan: string; seats: string; risk: number; status: string }[];
  metrics: {
    learningCompletion: number;
    assessmentCompletion: number;
    activeLearners: number;
    activeUsers: number;
    atRisk: number;
    mfaAdoption: number;
    licensedSeats: number;
  };
  controls: {
    mfaRequired: boolean;
    aiAssistant: boolean;
    predictiveRisk: boolean;
    phishingSimulations: boolean;
    pdfReports: boolean;
  };
};

const EMPTY: DashboardData = {
  connected: false,
  profile: { id: "", tenantId: null, name: "User", nameAr: "المستخدم", streak: 0 },
  tenantName: "",
  currentHrs: 0,
  currentCci: 0,
  riskTrend: [],
  cciTrend: [],
  riskDelta: 0,
  cciDelta: 0,
  dimensions: { compliance: 0, curiosity: 0, stressTolerance: 0, susceptibility: 0 },
  predictive: { securityFatigue: 0, phishingSusceptibility: 0, insiderThreat: 0, reportingLikelihood: 0 },
  exposure: { value: 0, currency: "USD" },
  people: [],
  courses: [],
  assessments: [],
  notifications: [],
  audits: [],
  campaigns: [],
  templates: [],
  campaignStats: { reportRate: 0, clickRate: 0, active: 0, completed: 0 },
  departments: [],
  tenants: [],
  metrics: { learningCompletion: 0, assessmentCompletion: 0, activeLearners: 0, activeUsers: 0, atRisk: 0, mfaAdoption: 0, licensedSeats: 0 },
  controls: { mfaRequired: false, aiAssistant: hasOpenAIEnv, predictiveRisk: false, phishingSimulations: false, pdfReports: false },
};

const number = (value: unknown) => Math.round(Number(value) || 0);
const average = (values: number[]) => values.length ? number(values.reduce((sum, value) => sum + value, 0) / values.length) : 0;

function timeAgo(value: string | null) {
  if (!value) return "";
  const days = Math.max(0, Math.floor((Date.now() - new Date(value).getTime()) / 86_400_000));
  if (days === 0) return "Today";
  if (days === 1) return "Yesterday";
  return `${days} days ago`;
}

function band(value: number): DashboardPerson["status"] {
  if (value >= 75) return "Critical";
  if (value >= 50) return "High";
  if (value >= 25) return "Medium";
  return "Low";
}

function latestBy<T extends Row>(rows: T[], key: string) {
  const map = new Map<string, T>();
  for (const row of rows) if (!map.has(String(row[key]))) map.set(String(row[key]), row);
  return map;
}

export async function getDashboardData(role: UserRole): Promise<DashboardData> {
  if (!hasSupabaseEnv) return EMPTY;

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return EMPTY;

  const { data: profile } = await supabase
    .from("profiles")
    .select("id,tenant_id,full_name,full_name_ar,streak_days")
    .eq("id", user.id)
    .single();
  if (!profile) return EMPTY;

  const tenantId = profile.tenant_id as string | null;
  const [
    profilesResult, departmentsResult, riskResult, dimensionsResult,
    predictiveResult, exposureResult, coursesResult, enrollmentsResult,
    assessmentsResult, questionsResult, attemptsResult, campaignsResult,
    targetsResult, notificationsResult, auditsResult, tenantsResult, templatesResult,
    licensesResult, flagsResult,
  ] = await Promise.all([
    supabase.from("profiles").select("id,tenant_id,email,full_name,full_name_ar,department_id,status,mfa_enabled,last_activity_at,created_at"),
    supabase.from("departments").select("id,name,name_ar"),
    supabase.from("risk_scores").select("profile_id,tenant_id,hrs,cci,recorded_at").order("recorded_at", { ascending: false }),
    supabase.from("behavioral_dimensions").select("profile_id,compliance,curiosity,stress_tolerance,social_engineering_susceptibility,recorded_at").order("recorded_at", { ascending: false }),
    supabase.from("predictive_risk_indicators").select("profile_id,security_fatigue,phishing_susceptibility,insider_threat_likelihood,reporting_likelihood,recorded_at").order("recorded_at", { ascending: false }),
    supabase.from("financial_risk_exposure").select("estimated_value,currency,recorded_at").order("recorded_at", { ascending: false }).limit(1),
    supabase.from("courses").select("id,title,title_ar,duration_minutes,xp_reward,is_published").eq("is_published", true),
    supabase.from("course_enrollments").select("profile_id,course_id,status,progress_pct,updated_at"),
    supabase.from("assessments").select("id,title,title_ar,duration_minutes,is_published").eq("is_published", true),
    supabase.from("assessment_questions").select("assessment_id"),
    supabase.from("assessment_attempts").select("profile_id,assessment_id,score,completed_at").order("completed_at", { ascending: false }),
    supabase.from("phishing_campaigns").select("id,name,status,created_at").order("created_at", { ascending: false }),
    supabase.from("phishing_campaign_targets").select("campaign_id,profile_id,status,reported_at,clicked_at"),
    supabase.from("notifications").select("id,title,title_ar,body,body_ar,created_at").order("created_at", { ascending: false }).limit(20),
    supabase.from("audit_logs").select("id,actor_email,action,target_type,target_id,created_at").order("created_at", { ascending: false }).limit(30),
    supabase.from("tenants").select("id,name,name_ar,plan,status,employee_count"),
    supabase.from("phishing_templates").select("id,name,name_ar").limit(100),
    supabase.from("licenses").select("tenant_id,seats,status"),
    supabase.from("feature_flags").select("key,enabled,tenant_id"),
  ]);

  const profiles = profilesResult.data ?? [];
  const departments = departmentsResult.data ?? [];
  const riskRows = riskResult.data ?? [];
  const dimensionRows = dimensionsResult.data ?? [];
  const predictiveRows = predictiveResult.data ?? [];
  const enrollments = enrollmentsResult.data ?? [];
  const attempts = attemptsResult.data ?? [];
  const campaignRows = campaignsResult.data ?? [];
  const targets = targetsResult.data ?? [];
  const departmentMap = new Map(departments.map((item) => [item.id, item]));
  const latestRisk = latestBy(riskRows, "profile_id");
  const latestDimensions = latestBy(dimensionRows, "profile_id");
  const enrollmentByPerson = new Map<string, Row[]>();
  for (const enrollment of enrollments) enrollmentByPerson.set(enrollment.profile_id, [...(enrollmentByPerson.get(enrollment.profile_id) ?? []), enrollment]);

  const people = profiles
    .filter((item) => item.tenant_id && item.status === "active")
    .map((item) => {
      const personRisk = number(latestRisk.get(item.id)?.hrs);
      const personEnrollments = enrollmentByPerson.get(item.id) ?? [];
      const department = departmentMap.get(item.department_id);
      return {
        id: item.id,
        name: item.full_name,
        nameAr: item.full_name_ar || item.full_name,
        department: department?.name || "Unassigned",
        departmentAr: department?.name_ar || department?.name || "غير محدد",
        risk: personRisk,
        status: band(personRisk),
        training: average(personEnrollments.map((row) => number(row.progress_pct))),
      };
    })
    .sort((a, b) => b.risk - a.risk);

  const visibleRisk = role === "employee" ? riskRows.filter((row) => row.profile_id === user.id) : riskRows;
  const byDate = new Map<string, Row[]>();
  for (const row of visibleRisk) byDate.set(row.recorded_at, [...(byDate.get(row.recorded_at) ?? []), row]);
  const datedRisk = [...byDate.entries()].sort(([a], [b]) => a.localeCompare(b));
  const riskTrend = datedRisk.map(([, rows]) => average(rows.map((row) => Number(row.hrs))));
  const cciTrend = datedRisk.map(([, rows]) => average(rows.map((row) => Number(row.cci))));
  const currentHrs = riskTrend.at(-1) ?? 0;
  const currentCci = cciTrend.at(-1) ?? 0;

  const chosenDimensions = role === "employee"
    ? latestDimensions.get(user.id)
    : {
        compliance: average([...latestDimensions.values()].map((row) => number(row.compliance))),
        curiosity: average([...latestDimensions.values()].map((row) => number(row.curiosity))),
        stress_tolerance: average([...latestDimensions.values()].map((row) => number(row.stress_tolerance))),
        social_engineering_susceptibility: average([...latestDimensions.values()].map((row) => number(row.social_engineering_susceptibility))),
      };
  const chosenPredictive = predictiveRows.find((row) => role === "employee" ? row.profile_id === user.id : row.profile_id === null) ?? predictiveRows[0];
  const ownEnrollments = enrollments.filter((row) => row.profile_id === user.id);
  const progressByCourse = new Map(ownEnrollments.map((row) => [row.course_id, number(row.progress_pct)]));
  const questionCounts = new Map<string, number>();
  for (const question of questionsResult.data ?? []) questionCounts.set(question.assessment_id, (questionCounts.get(question.assessment_id) ?? 0) + 1);
  const latestAttempts = latestBy(role === "employee" ? attempts.filter((row) => row.profile_id === user.id) : attempts, "assessment_id");

  const campaignStatsRows = role === "employee" ? targets.filter((target) => target.profile_id === user.id) : targets;
  const sentTargets = campaignStatsRows.filter((target) => target.status !== "pending");
  const reports = campaignStatsRows.filter((target) => target.reported_at);
  const clicks = campaignStatsRows.filter((target) => target.clicked_at);
  const campaigns = campaignRows.map((campaign) => {
    const recipients = targets.filter((target) => target.campaign_id === campaign.id);
    return {
      id: campaign.id,
      title: campaign.name,
      recipients: recipients.length,
      reportRate: recipients.length ? number(recipients.filter((target) => target.reported_at).length / recipients.length * 100) : 0,
      status: campaign.status,
    };
  });

  const flags = new Map<string, boolean>();
  for (const flag of flagsResult.data ?? []) {
    if (!flags.has(flag.key) || flag.tenant_id === tenantId) flags.set(flag.key, flag.enabled);
  }
  const activeProfiles = profiles.filter((item) => item.status === "active");
  const activeLearnerIds = new Set(enrollments.filter((row) => row.status === "in_progress").map((row) => row.profile_id));
  const completedAttempts = attempts.filter((row) => row.completed_at);
  const tenantRows = tenantsResult.data ?? [];
  const licenseMap = new Map((licensesResult.data ?? []).map((license) => [license.tenant_id, license]));
  const tenantRisk = new Map<string, number[]>();
  for (const row of latestRisk.values()) tenantRisk.set(row.tenant_id, [...(tenantRisk.get(row.tenant_id) ?? []), number(row.hrs)]);

  return {
    connected: true,
    profile: { id: profile.id, tenantId, name: profile.full_name, nameAr: profile.full_name_ar || profile.full_name, streak: number(profile.streak_days) },
    tenantName: tenantRows.find((tenant) => tenant.id === tenantId)?.name ?? "",
    currentHrs,
    currentCci,
    riskTrend,
    cciTrend,
    riskDelta: riskTrend.length > 1 ? riskTrend[0] - currentHrs : 0,
    cciDelta: cciTrend.length > 1 ? currentCci - cciTrend[0] : 0,
    dimensions: {
      compliance: number(chosenDimensions?.compliance),
      curiosity: number(chosenDimensions?.curiosity),
      stressTolerance: number(chosenDimensions?.stress_tolerance),
      susceptibility: number(chosenDimensions?.social_engineering_susceptibility),
    },
    predictive: {
      securityFatigue: number(chosenPredictive?.security_fatigue),
      phishingSusceptibility: number(chosenPredictive?.phishing_susceptibility),
      insiderThreat: number(chosenPredictive?.insider_threat_likelihood),
      reportingLikelihood: number(chosenPredictive?.reporting_likelihood),
    },
    exposure: { value: number(exposureResult.data?.[0]?.estimated_value), currency: exposureResult.data?.[0]?.currency ?? "USD" },
    people,
    courses: (coursesResult.data ?? []).map((course) => ({
      id: course.id,
      title: course.title,
      titleAr: course.title_ar || course.title,
      duration: number(course.duration_minutes),
      xp: number(course.xp_reward),
      progress: progressByCourse.get(course.id) ?? 0,
    })),
    assessments: (assessmentsResult.data ?? []).map((assessment) => {
      const attempt = latestAttempts.get(assessment.id);
      return {
        id: assessment.id,
        title: assessment.title,
        titleAr: assessment.title_ar || assessment.title,
        duration: number(assessment.duration_minutes),
        questionCount: questionCounts.get(assessment.id) ?? 0,
        score: attempt ? `${number(attempt.score)}%` : "Not attempted",
      };
    }),
    notifications: (notificationsResult.data ?? []).map((item) => ({
      id: item.id, title: item.title, titleAr: item.title_ar || item.title,
      body: item.body, bodyAr: item.body_ar || item.body, time: timeAgo(item.created_at),
    })),
    audits: (auditsResult.data ?? []).map((item) => ({
      id: String(item.id), actor: item.actor_email || "System", action: item.action,
      target: [item.target_type, item.target_id].filter(Boolean).join(": ") || "Platform", time: timeAgo(item.created_at),
    })),
    campaigns,
    templates: (templatesResult.data ?? []).map((template) => ({ id: template.id, name: template.name, nameAr: template.name_ar || template.name })),
    campaignStats: {
      reportRate: sentTargets.length ? number(reports.length / sentTargets.length * 100) : 0,
      clickRate: sentTargets.length ? number(clicks.length / sentTargets.length * 100) : 0,
      active: campaignRows.filter((campaign) => campaign.status === "running").length,
      completed: new Set(campaignStatsRows.map((target) => target.campaign_id)).size,
    },
    departments: departments.map((department) => {
      const ids = profiles.filter((item) => item.department_id === department.id).map((item) => item.id);
      const rows = enrollments.filter((row) => ids.includes(row.profile_id));
      return { name: department.name, nameAr: department.name_ar || department.name, readiness: average(rows.map((row) => number(row.progress_pct))) };
    }),
    tenants: tenantRows.map((tenant) => {
      const license = licenseMap.get(tenant.id);
      const used = profiles.filter((item) => item.tenant_id === tenant.id && item.status === "active").length;
      return {
        id: tenant.id, name: tenant.name, nameAr: tenant.name_ar || tenant.name, plan: tenant.plan,
        seats: `${used} / ${license?.seats ?? tenant.employee_count ?? 0}`,
        risk: average(tenantRisk.get(tenant.id) ?? []), status: tenant.status,
      };
    }),
    metrics: {
      learningCompletion: average(enrollments.map((row) => number(row.progress_pct))),
      assessmentCompletion: (assessmentsResult.data ?? []).length && activeProfiles.length
        ? number(completedAttempts.length / ((assessmentsResult.data ?? []).length * activeProfiles.length) * 100) : 0,
      activeLearners: activeLearnerIds.size,
      activeUsers: activeProfiles.length,
      atRisk: people.filter((person) => person.risk >= 50).length,
      mfaAdoption: activeProfiles.length ? number(activeProfiles.filter((item) => item.mfa_enabled).length / activeProfiles.length * 100) : 0,
      licensedSeats: (licensesResult.data ?? []).reduce((sum, license) => sum + number(license.seats), 0),
    },
    controls: {
      mfaRequired: flags.get("mfa_required") ?? false,
      aiAssistant: (flags.get("ai_chat_assistant") ?? false) && hasOpenAIEnv,
      predictiveRisk: flags.get("predictive_risk_intelligence") ?? false,
      phishingSimulations: flags.get("phishing_simulations") ?? false,
      pdfReports: flags.get("pdf_reports") ?? false,
    },
  };
}
