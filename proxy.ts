import createMiddleware from "next-intl/middleware";
import { NextResponse, type NextRequest } from "next/server";
import { routing } from "@/i18n/routing";
import { createMiddlewareClient } from "@/lib/supabase/middleware";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { hasSupabaseEnv } from "@/lib/config";

const AUTH_ROUTES = ["/login", "/forgot-password", "/reset-password"];

const handleI18nRouting = createMiddleware(routing);

export async function proxy(request: NextRequest) {
  const response = handleI18nRouting(request);

  // Locale-prefix redirects from next-intl (e.g. /login -> /en/login) need
  // no further handling — just make sure the auth cookies ride along.
  if (response.status >= 300 && response.status < 400) {
    return response;
  }

  const segments = request.nextUrl.pathname.split("/").filter(Boolean);
  const locale = (routing.locales as readonly string[]).includes(segments[0])
    ? segments[0]
    : routing.defaultLocale;
  const path = "/" + segments.slice(1).join("/");
  const roleSegment = segments[1];

  const isAuthRoute = AUTH_ROUTES.some(
    (route) => path === route || path.startsWith(`${route}/`),
  );
  const isMfaRoute = path === "/mfa";
  const isPublicRoute = path === "/" || isAuthRoute;

  const redirectTo = (pathname: string) => {
    const url = request.nextUrl.clone();
    url.pathname = `/${locale}${pathname}`;
    return NextResponse.redirect(url);
  };

  const demoRole = request.cookies.get("cybercultx_demo_role")?.value as
    | UserRole
    | undefined;

  // Explicit temporary sessions must remain navigable even when Supabase
  // variables exist but the remote project is not fully configured yet.
  if (demoRole && demoRole in ROLE_HOME) {
    if (isAuthRoute || isMfaRoute || path === "/") {
      return redirectTo(ROLE_HOME[demoRole]);
    }
    if (roleSegment && roleSegment in ROLE_HOME && roleSegment !== demoRole) {
      return redirectTo(ROLE_HOME[demoRole]);
    }
    return response;
  }

  if (!hasSupabaseEnv) {
    if (!demoRole) {
      if (!isPublicRoute && !isMfaRoute) return redirectTo("/login");
      return response;
    }
  }

  const supabase = createMiddlewareClient(request, response);
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    if (!isPublicRoute && !isMfaRoute) {
      return redirectTo("/login");
    }
    return response;
  }

  const { data: aal } = await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
  const needsMfa =
    !!aal && aal.nextLevel === "aal2" && aal.currentLevel !== aal.nextLevel;

  if (needsMfa && !isMfaRoute) {
    return redirectTo("/mfa");
  }

  if (!needsMfa && (isMfaRoute || isAuthRoute || path === "/")) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();
    return redirectTo(ROLE_HOME[(profile?.role as UserRole) ?? "employee"]);
  }

  if (roleSegment && roleSegment in ROLE_HOME) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();
    if (profile?.role !== roleSegment) {
      return redirectTo(ROLE_HOME[(profile?.role as UserRole) ?? "employee"]);
    }
  }

  return response;
}

export const config = {
  matcher: ["/((?!api|trpc|_next|_vercel|.*\\..*).*)"],
};
