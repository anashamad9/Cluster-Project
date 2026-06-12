"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient, createServiceRoleClient } from "@/lib/supabase/server";
import type { UserRole } from "@/lib/auth/roles";

async function context() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error("Unauthorized");
  const { data: profile } = await supabase.from("profiles").select("id,tenant_id,role,full_name").eq("id", user.id).single();
  if (!profile) throw new Error("Profile not found");
  return { supabase, user, profile: profile as { id: string; tenant_id: string | null; role: UserRole; full_name: string } };
}

function requireRole(role: UserRole, allowed: UserRole[]) {
  if (!allowed.includes(role)) throw new Error("Forbidden");
}

export async function completeCourse(formData: FormData) {
  const { supabase, user } = await context();
  const courseId = String(formData.get("courseId") ?? "");
  const locale = formData.get("locale") === "ar" ? "ar" : "en";
  const role = String(formData.get("role") ?? "employee");
  const { data: course } = await supabase.from("courses").select("xp_reward").eq("id", courseId).single();
  if (!course) throw new Error("Course not found");
  const { data: existing } = await supabase.from("course_enrollments").select("status").eq("profile_id", user.id).eq("course_id", courseId).maybeSingle();
  await supabase.from("course_enrollments").upsert({
    profile_id: user.id, course_id: courseId, status: "completed", progress_pct: 100,
    started_at: new Date().toISOString(), completed_at: new Date().toISOString(),
  }, { onConflict: "profile_id,course_id" });
  if (existing?.status !== "completed") {
    await supabase.rpc("award_xp", { p_profile_id: user.id, p_amount: course.xp_reward, p_reason: "course_completed", p_reference_type: "course", p_reference_id: courseId });
  }
  revalidatePath(`/${locale}/${role}/learning`);
  redirect(`/${locale}/${role}/learning`);
}

export async function submitAssessment(formData: FormData) {
  const { supabase, user } = await context();
  const assessmentId = String(formData.get("assessmentId") ?? "");
  const locale = formData.get("locale") === "ar" ? "ar" : "en";
  const role = String(formData.get("role") ?? "employee");
  const [{ data: assessment }, { data: questions }] = await Promise.all([
    supabase.from("assessments").select("passing_score,type").eq("id", assessmentId).single(),
    supabase.from("assessment_questions").select("id,correct_answer,points").eq("assessment_id", assessmentId),
  ]);
  if (!assessment || !questions?.length) throw new Error("Assessment not found");
  const answers: Record<string, string> = {};
  let earned = 0;
  let possible = 0;
  for (const question of questions) {
    const answer = String(formData.get(`question_${question.id}`) ?? "");
    answers[question.id] = answer;
    possible += question.points;
    if (assessment.type === "psychometric" || answer === question.correct_answer) earned += question.points;
  }
  const score = assessment.type === "psychometric" ? 100 : Math.round(earned / Math.max(possible, 1) * 100);
  const passed = score >= assessment.passing_score;
  await supabase.from("assessment_attempts").insert({
    profile_id: user.id, assessment_id: assessmentId, score, passed, answers,
    started_at: new Date().toISOString(), completed_at: new Date().toISOString(),
  });
  if (assessment.type === "security_knowledge" && passed) {
    await supabase.rpc("award_xp", { p_profile_id: user.id, p_amount: 30, p_reason: "assessment_passed", p_reference_type: "assessment", p_reference_id: assessmentId });
  }
  revalidatePath(`/${locale}/${role}/assessments`);
  redirect(`/${locale}/${role}/assessments`);
}

export async function sendReminder(formData: FormData) {
  const { profile } = await context();
  requireRole(profile.role, ["hr", "admin", "superadmin"]);
  if (!profile.tenant_id) throw new Error("Tenant required");
  const supabase = profile.role === "hr" ? await createServiceRoleClient() : (await context()).supabase;
  const body = String(formData.get("body") ?? "Please review and complete your outstanding security learning.");
  await supabase.from("notifications").insert({
    tenant_id: profile.tenant_id, sender_id: profile.id, target_type: "all",
    title: "Security learning reminder", title_ar: "تذكير بالتعلم الأمني",
    body, body_ar: "يرجى مراجعة وإكمال التدريب الأمني المتبقي.",
  });
  revalidatePath("/", "layout");
}

export async function assignCourse(formData: FormData) {
  const { supabase: userClient, profile } = await context();
  requireRole(profile.role, ["hr", "admin", "superadmin"]);
  const supabase = profile.role === "hr" ? await createServiceRoleClient() : userClient;
  const courseId = String(formData.get("courseId") ?? "");
  const profileId = String(formData.get("profileId") ?? "");
  const targetIds = profileId ? [profileId] : (await supabase.from("profiles").select("id").eq("tenant_id", profile.tenant_id!)).data?.map((item) => item.id) ?? [];
  if (targetIds.length) {
    await supabase.from("course_enrollments").upsert(targetIds.map((id) => ({ profile_id: id, course_id: courseId, status: "not_started", progress_pct: 0 })), { onConflict: "profile_id,course_id" });
  }
  revalidatePath("/", "layout");
}

export async function createCampaign(formData: FormData) {
  const { supabase, profile } = await context();
  requireRole(profile.role, ["admin", "superadmin"]);
  if (!profile.tenant_id) throw new Error("Tenant required");
  const name = String(formData.get("name") ?? "").trim();
  const templateId = String(formData.get("templateId") ?? "");
  const { data: campaign } = await supabase.from("phishing_campaigns").insert({
    tenant_id: profile.tenant_id, name, template_id: templateId, target_type: "all",
    status: "running", scheduled_at: new Date().toISOString(), started_at: new Date().toISOString(), created_by: profile.id,
  }).select("id").single();
  if (campaign) {
    const { data: people } = await supabase.from("profiles").select("id").eq("tenant_id", profile.tenant_id).eq("status", "active");
    if (people?.length) await supabase.from("phishing_campaign_targets").insert(people.map((person) => ({ campaign_id: campaign.id, profile_id: person.id, status: "pending" })));
  }
  revalidatePath("/", "layout");
}

export async function inviteUser(formData: FormData) {
  const { profile } = await context();
  requireRole(profile.role, ["admin", "superadmin"]);
  const email = String(formData.get("email") ?? "").trim().toLowerCase();
  const fullName = String(formData.get("fullName") ?? "").trim();
  const role = String(formData.get("userRole") ?? "employee") as UserRole;
  const tenantId = String(formData.get("tenantId") ?? profile.tenant_id ?? "");
  const service = await createServiceRoleClient();
  await service.auth.admin.createUser({
    email, password: String(formData.get("password") ?? "ChangeMe@2026"), email_confirm: true,
    user_metadata: { full_name: fullName, role, tenant_id: tenantId },
  });
  revalidatePath("/", "layout");
}

export async function toggleFeature(formData: FormData) {
  const { supabase, profile } = await context();
  requireRole(profile.role, ["admin", "superadmin"]);
  const key = String(formData.get("key") ?? "");
  const enabled = formData.get("enabled") !== "true";
  const tenantId = profile.role === "superadmin" && formData.get("global") === "true" ? null : profile.tenant_id;
  const { data: existing } = await supabase.from("feature_flags").select("id").eq("key", key).is("tenant_id", tenantId).maybeSingle();
  if (existing) await supabase.from("feature_flags").update({ enabled }).eq("id", existing.id);
  else await supabase.from("feature_flags").insert({ key, enabled, tenant_id: tenantId, description: key });
  revalidatePath("/", "layout");
}

export async function markNotificationsRead() {
  const { supabase, user } = await context();
  await supabase.from("notification_recipients").update({ read_at: new Date().toISOString() }).eq("profile_id", user.id).is("read_at", null);
  revalidatePath("/", "layout");
}

export async function createTenant(formData: FormData) {
  const { supabase, profile } = await context();
  requireRole(profile.role, ["superadmin"]);
  const name = String(formData.get("name") ?? "").trim();
  const slug = String(formData.get("slug") ?? "").trim().toLowerCase();
  const plan = String(formData.get("plan") ?? "standard");
  const seats = Number(formData.get("seats") ?? 50);
  const { data: tenant } = await supabase.from("tenants").insert({ name, slug, plan, status: "active", employee_count: seats }).select("id").single();
  if (tenant) await supabase.from("licenses").insert({ tenant_id: tenant.id, plan, seats, status: "active" });
  revalidatePath("/", "layout");
}
