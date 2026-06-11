import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const form = await request.formData();
  const locale = form.get("locale") === "ar" ? "ar" : "en";
  const response = NextResponse.redirect(new URL(`/${locale}/login`, request.url), 303);
  response.cookies.delete("cybercultx_demo_role");
  return response;
}
