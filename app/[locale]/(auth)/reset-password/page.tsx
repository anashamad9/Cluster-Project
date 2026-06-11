import { getLocale } from "next-intl/server";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default async function ResetPasswordPage() {
  const locale = await getLocale();
  return <main className="grid min-h-screen place-items-center bg-muted/30 p-5"><section className="surface-card w-full max-w-md p-7"><h1 className="text-2xl font-bold">Set a new password</h1><p className="mt-2 text-sm text-muted-foreground">Use at least eight characters.</p><form action={`/${locale}/login`} className="mt-7 space-y-4"><div className="space-y-2"><Label htmlFor="password">New password</Label><Input id="password" type="password" minLength={8} required /></div><div className="space-y-2"><Label htmlFor="confirm">Confirm password</Label><Input id="confirm" type="password" minLength={8} required /></div><Button className="w-full">Update password</Button></form></section></main>;
}
