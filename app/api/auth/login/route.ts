import { NextResponse } from "next/server";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { roleFromEmail } from "@/lib/demo-data";
import { hasSupabaseEnv } from "@/lib/config";
import { createClient } from "@/lib/supabase/server";
import { checkRateLimit } from "@/lib/security/rate-limit";
import { logAudit } from "@/lib/security/audit";

export async function POST(request: Request) {
  const form = await request.formData();
  const email = String(form.get("email") ?? "").toLowerCase();
  const password = String(form.get("password") ?? "");
  const locale = String(form.get("locale") ?? "en");
  let role: UserRole = roleFromEmail(email);

  if (hasSupabaseEnv) {
    const supabase = await createClient();
    const ip = request.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ?? "unknown";
    const allowed = await checkRateLimit(supabase, `login:${ip}`, 10, 60);
    if (!allowed) return NextResponse.redirect(new URL(`/${locale}/login?error=rateLimited`, request.url), 303);
    const { data: lockRows } = await supabase.rpc("is_account_locked", { p_email: email });
    const lock = Array.isArray(lockRows) ? lockRows[0] : lockRows;
    if (lock?.locked) return NextResponse.redirect(new URL(`/${locale}/login?error=accountLocked`, request.url), 303);
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    await supabase.rpc("record_login_attempt", { p_email: email, p_success: !error, p_ip_address: ip, p_user_agent: request.headers.get("user-agent") });
    if (error || !data.user) {
      await logAudit(supabase, { action: "login_failed", actorEmail: email, ipAddress: ip, userAgent: request.headers.get("user-agent") });
      return NextResponse.redirect(new URL(`/${locale}/login?error=credentials`, request.url), 303);
    }
    await logAudit(supabase, { action: "login_success", actorId: data.user.id, actorEmail: email, ipAddress: ip, userAgent: request.headers.get("user-agent") });
    const { data: profile } = await supabase.from("profiles").select("role").eq("id", data.user.id).single();
    role = (profile?.role as UserRole | undefined) ?? role;
  }

  const response = NextResponse.redirect(new URL(`/${locale}${ROLE_HOME[role]}`, request.url), 303);
  if (!hasSupabaseEnv) {
    response.cookies.set("cybercultx_demo_role", role, {
      httpOnly: true,
      sameSite: "lax",
      path: "/",
      maxAge: 60 * 60 * 8,
    });
  } else {
    response.cookies.delete("cybercultx_demo_role");
  }
  return response;
}
