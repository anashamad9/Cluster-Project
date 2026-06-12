import { createServerClient } from "@supabase/ssr";
import { NextResponse } from "next/server";
import { hasSupabaseEnv } from "@/lib/config";

export async function POST(request: Request) {
  const form = await request.formData();
  const locale = form.get("locale") === "ar" ? "ar" : "en";
  const response = NextResponse.redirect(new URL(`/${locale}/login`, request.url), 303);

  if (hasSupabaseEnv) {
    const supabase = createServerClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        cookies: {
          getAll() {
            const cookieHeader = request.headers.get("cookie") ?? "";
            return cookieHeader
              .split(";")
              .map((cookie) => cookie.trim())
              .filter(Boolean)
              .map((cookie) => {
                const separator = cookie.indexOf("=");
                return {
                  name: separator === -1 ? cookie : cookie.slice(0, separator),
                  value: separator === -1 ? "" : cookie.slice(separator + 1),
                };
              });
          },
          setAll(cookiesToSet) {
            for (const { name, value, options } of cookiesToSet) {
              response.cookies.set(name, value, options);
            }
          },
        },
      },
    );

    await supabase.auth.signOut({ scope: "local" });
  }

  response.cookies.delete("cybercultx_demo_role");
  return response;
}
