import { getLocale } from "next-intl/server";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default async function MfaPage() {
  const locale = await getLocale();
  return <main className="grid min-h-screen place-items-center bg-muted/30 p-5"><section className="surface-card w-full max-w-md p-7"><h1 className="text-2xl font-bold">Two-factor authentication</h1><p className="mt-2 text-sm text-muted-foreground">Enter the six-digit code from your authenticator app.</p><form action="/api/auth/mfa" method="post" className="mt-7 space-y-4"><input type="hidden" name="locale" value={locale} /><div className="space-y-2"><Label htmlFor="code">Authentication code</Label><Input id="code" name="code" inputMode="numeric" pattern="[0-9]{6}" placeholder="000000" required /></div><Button className="w-full">Verify</Button></form></section></main>;
}
