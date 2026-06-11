import { NextResponse } from "next/server";
import type { EmailOtpType } from "@supabase/supabase-js";
import { hasSupabaseEnv } from "@/lib/config";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: Request) {
  const url = new URL(request.url);
  const tokenHash = url.searchParams.get("token_hash");
  const type = url.searchParams.get("type") as EmailOtpType | null;
  const next = url.searchParams.get("next") || "/reset-password";

  if (hasSupabaseEnv && tokenHash && type) {
    const supabase = await createClient();
    await supabase.auth.verifyOtp({ type, token_hash: tokenHash });
  }

  return NextResponse.redirect(new URL(`/en${next}`, request.url));
}
