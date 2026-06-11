import { NextResponse } from "next/server";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { hasSupabaseEnv } from "@/lib/config";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  const form = await request.formData();
  const locale = String(form.get("locale") ?? "en");
  const code = String(form.get("code") ?? "");
  let role: UserRole = "employee";
  if (hasSupabaseEnv) {
    const supabase = await createClient();
    const { data: factors } = await supabase.auth.mfa.listFactors();
    const factor = factors?.totp?.[0];
    if (!factor) return NextResponse.redirect(new URL(`/${locale}/login`, request.url), 303);
    const { data: challenge } = await supabase.auth.mfa.challenge({ factorId: factor.id });
    if (!challenge) return NextResponse.redirect(new URL(`/${locale}/mfa?error=invalid`, request.url), 303);
    const { error } = await supabase.auth.mfa.verify({ factorId: factor.id, challengeId: challenge.id, code });
    if (error) return NextResponse.redirect(new URL(`/${locale}/mfa?error=invalid`, request.url), 303);
    const { data: userData } = await supabase.auth.getUser();
    const { data: profile } = await supabase.from("profiles").select("role").eq("id", userData.user?.id ?? "").single();
    role = (profile?.role as UserRole | undefined) ?? role;
  }
  return NextResponse.redirect(new URL(`/${locale}${ROLE_HOME[role]}`, request.url), 303);
}
