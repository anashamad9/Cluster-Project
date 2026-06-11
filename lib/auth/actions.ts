"use server";

import { headers } from "next/headers";
import { getLocale } from "next-intl/server";
import { redirect } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/server";
import { logAudit } from "@/lib/security/audit";
import { checkRateLimit } from "@/lib/security/rate-limit";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";

export type ActionState = {
  error?: string;
  lockedMinutes?: number;
  success?: boolean;
} | undefined;

async function requestMeta() {
  const headersList = await headers();
  const ip =
    headersList.get("x-forwarded-for")?.split(",")[0]?.trim() ?? null;
  const userAgent = headersList.get("user-agent");
  return { ip, userAgent };
}

export async function login(
  _prevState: ActionState,
  formData: FormData,
): Promise<ActionState> {
  const email = String(formData.get("email") ?? "")
    .trim()
    .toLowerCase();
  const password = String(formData.get("password") ?? "");

  if (!email || !password) {
    return { error: "invalidCredentials" };
  }

  const supabase = await createClient();
  const { ip, userAgent } = await requestMeta();

  const allowed = await checkRateLimit(supabase, `login:${ip ?? "unknown"}`, 10, 60);
  if (!allowed) {
    return { error: "rateLimited" };
  }

  const { data: lockRows } = await supabase.rpc("is_account_locked", {
    p_email: email,
  });
  const lock = Array.isArray(lockRows) ? lockRows[0] : lockRows;

  if (lock?.locked) {
    const minutes = lock.locked_until
      ? Math.max(
          1,
          Math.ceil(
            (new Date(lock.locked_until).getTime() - Date.now()) / 60000,
          ),
        )
      : 15;
    return { error: "accountLocked", lockedMinutes: minutes };
  }

  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  await supabase.rpc("record_login_attempt", {
    p_email: email,
    p_success: !error,
    p_ip_address: ip,
    p_user_agent: userAgent,
  });

  if (error || !data.user) {
    await logAudit(supabase, {
      action: "login_failed",
      actorEmail: email,
      ipAddress: ip,
      userAgent,
    });
    return { error: "invalidCredentials" };
  }

  await logAudit(supabase, {
    action: "login_success",
    actorId: data.user.id,
    actorEmail: email,
    ipAddress: ip,
    userAgent,
  });

  const locale = await getLocale();

  const { data: aal } = await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
  if (aal && aal.nextLevel === "aal2" && aal.currentLevel !== aal.nextLevel) {
    redirect({ href: "/mfa", locale });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", data.user.id)
    .single();

  redirect({ href: ROLE_HOME[(profile?.role as UserRole) ?? "employee"], locale });
}

export async function logout() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) {
    await logAudit(supabase, {
      action: "logout",
      actorId: user.id,
      actorEmail: user.email,
    });
  }

  await supabase.auth.signOut();

  const locale = await getLocale();
  redirect({ href: "/login", locale });
}

export async function verifyMfaChallenge(
  _prevState: ActionState,
  formData: FormData,
): Promise<ActionState> {
  const code = String(formData.get("code") ?? "").trim();
  if (!code) {
    return { error: "mfaInvalid" };
  }

  const supabase = await createClient();

  const { data: factorsData, error: factorsError } =
    await supabase.auth.mfa.listFactors();
  const totpFactor = factorsData?.totp?.[0];

  if (factorsError || !totpFactor) {
    return { error: "mfaInvalid" };
  }

  const { data: challenge, error: challengeError } =
    await supabase.auth.mfa.challenge({ factorId: totpFactor.id });

  if (challengeError || !challenge) {
    return { error: "mfaInvalid" };
  }

  const { error: verifyError } = await supabase.auth.mfa.verify({
    factorId: totpFactor.id,
    challengeId: challenge.id,
    code,
  });

  if (verifyError) {
    return { error: "mfaInvalid" };
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  await logAudit(supabase, {
    action: "mfa_verify_success",
    actorId: user?.id,
    actorEmail: user?.email,
  });

  const locale = await getLocale();

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user!.id)
    .single();

  redirect({ href: ROLE_HOME[(profile?.role as UserRole) ?? "employee"], locale });
}

export async function requestPasswordReset(
  _prevState: ActionState,
  formData: FormData,
): Promise<ActionState> {
  const email = String(formData.get("email") ?? "")
    .trim()
    .toLowerCase();

  if (!email) {
    return { success: true };
  }

  const supabase = await createClient();
  const { ip } = await requestMeta();

  const allowed = await checkRateLimit(
    supabase,
    `reset:${ip ?? email}`,
    5,
    300,
  );
  if (!allowed) {
    return { error: "rateLimited" };
  }

  const headersList = await headers();
  const origin = headersList.get("origin") ?? "";

  await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${origin}/auth/confirm?type=recovery&next=/reset-password`,
  });

  return { success: true };
}

export async function updatePassword(
  _prevState: ActionState,
  formData: FormData,
): Promise<ActionState> {
  const password = String(formData.get("password") ?? "");
  const confirmPassword = String(formData.get("confirmPassword") ?? "");

  if (password.length < 8) {
    return { error: "passwordTooShort" };
  }
  if (password !== confirmPassword) {
    return { error: "passwordMismatch" };
  }

  const supabase = await createClient();
  const {
    data: { user },
    error: getUserError,
  } = await supabase.auth.getUser();

  if (getUserError || !user) {
    return { error: "sessionExpired" };
  }

  const { error } = await supabase.auth.updateUser({ password });
  if (error) {
    return { error: "updateFailed" };
  }

  await logAudit(supabase, {
    action: "password_reset",
    actorId: user.id,
    actorEmail: user.email,
  });

  return { success: true };
}

export async function enrollMfa() {
  const supabase = await createClient();

  const { data: factorsData } = await supabase.auth.mfa.listFactors();
  const existingUnverified = factorsData?.all.find(
    (factor) => factor.factor_type === "totp" && factor.status === "unverified",
  );

  if (existingUnverified) {
    await supabase.auth.mfa.unenroll({ factorId: existingUnverified.id });
  }

  const { data, error } = await supabase.auth.mfa.enroll({ factorType: "totp" });

  if (error || !data) {
    return { error: "mfaInvalid" as const };
  }

  return {
    factorId: data.id,
    qrCode: data.totp.qr_code,
    secret: data.totp.secret,
  };
}

export async function confirmMfaEnrollment(
  _prevState: ActionState,
  formData: FormData,
): Promise<ActionState> {
  const factorId = String(formData.get("factorId") ?? "");
  const code = String(formData.get("code") ?? "").trim();

  if (!factorId || !code) {
    return { error: "mfaInvalid" };
  }

  const supabase = await createClient();

  const { data: challenge, error: challengeError } =
    await supabase.auth.mfa.challenge({ factorId });

  if (challengeError || !challenge) {
    return { error: "mfaInvalid" };
  }

  const { error: verifyError } = await supabase.auth.mfa.verify({
    factorId,
    challengeId: challenge.id,
    code,
  });

  if (verifyError) {
    return { error: "mfaInvalid" };
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) {
    await supabase
      .from("profiles")
      .update({ mfa_enabled: true })
      .eq("id", user.id);

    await logAudit(supabase, {
      action: "mfa_enrolled",
      actorId: user.id,
      actorEmail: user.email,
    });
  }

  return { success: true };
}

export async function disableMfa(): Promise<ActionState> {
  const supabase = await createClient();

  const { data: factorsData } = await supabase.auth.mfa.listFactors();
  const totpFactor = factorsData?.totp?.[0];

  if (totpFactor) {
    await supabase.auth.mfa.unenroll({ factorId: totpFactor.id });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) {
    await supabase
      .from("profiles")
      .update({ mfa_enabled: false })
      .eq("id", user.id);

    await logAudit(supabase, {
      action: "mfa_disabled",
      actorId: user.id,
      actorEmail: user.email,
    });
  }

  return { success: true };
}
