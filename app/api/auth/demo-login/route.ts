import { NextResponse } from "next/server";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";

export async function POST(request: Request) {
  const form = await request.formData();
  const requestedRole = String(form.get("role") ?? "employee");
  const locale = form.get("locale") === "ar" ? "ar" : "en";
  const role: UserRole =
    requestedRole in ROLE_HOME ? (requestedRole as UserRole) : "employee";

  const response = NextResponse.redirect(
    new URL(`/${locale}${ROLE_HOME[role]}`, request.url),
    303,
  );
  response.cookies.set("cybercultx_demo_role", role, {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 8,
  });
  return response;
}
