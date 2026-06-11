import { getLocale } from "next-intl/server";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default async function ForgotPasswordPage() {
  const locale = await getLocale();
  return <main className="grid min-h-screen place-items-center bg-muted/30 p-5"><section className="surface-card w-full max-w-md p-7"><span className="grid size-11 place-items-center rounded-2xl bg-primary font-black text-primary-foreground">CX</span><h1 className="mt-6 text-2xl font-bold">Reset your password</h1><p className="mt-2 mb-7 text-sm text-muted-foreground">Enter your work email and we’ll send recovery instructions.</p><form action={`/${locale}/reset-password`} className="space-y-4"><div className="space-y-2"><Label htmlFor="email">Work email</Label><Input id="email" name="email" type="email" required /></div><Button className="w-full" type="submit">Send reset link</Button></form></section></main>;
}
