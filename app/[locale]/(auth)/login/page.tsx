import { getLocale, getTranslations } from "next-intl/server";
import { ShieldCheck } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { BackgroundRippleEffect } from "@/components/ui/background-ripple-effect";
import { roleEmails, roleNamesArabic } from "@/lib/demo-data";
import type { UserRole } from "@/lib/auth/roles";

export default async function LoginPage() {
  const t = await getTranslations("auth");
  const locale = await getLocale();

  return (
    <div className="grid min-h-screen bg-muted/30 lg:grid-cols-[1.1fr_.9fr]">
      <section className="relative hidden overflow-hidden bg-[#240303] p-12 text-white lg:flex lg:flex-col">
        <BackgroundRippleEffect
          rows={18}
          cols={20}
          cellSize={64}
          className="[--cell-border-color:rgba(254,202,202,.24)] [--cell-fill-color:rgba(220,38,38,.13)] [--cell-shadow-color:rgba(248,113,113,.35)]"
        />
        <div className="pointer-events-none absolute inset-0 z-[4] bg-[radial-gradient(circle_at_18%_18%,rgba(239,68,68,.68),transparent_42%),linear-gradient(145deg,rgba(153,27,27,.48),rgba(31,8,8,.88))]" />
        <div className="relative z-10 flex items-center gap-3"><span className="grid size-11 place-items-center rounded-2xl bg-white/15 font-black shadow-sm backdrop-blur">{t("brandInitials")}</span><strong className="text-xl">{t("brandName")}</strong></div>
        <div className="relative z-10 my-auto max-w-xl"><p className="text-sm font-semibold uppercase tracking-[.2em] text-white/60">{t("marketingEyebrow")}</p><h2 className="mt-5 text-5xl font-bold leading-tight text-balance">{t("marketingTitle")}</h2><p className="mt-6 text-lg leading-relaxed text-white/70">{t("marketingDescription")}</p></div>
        <div className="relative z-10 flex items-center gap-3 text-sm text-white/65"><ShieldCheck className="size-5" /> {t("marketingSecurity")}</div>
      </section>
      <section className="flex items-center justify-center p-5 sm:p-10">
        <div className="w-full max-w-md">
          <div className="mb-8 lg:hidden"><span className="grid size-11 place-items-center rounded-2xl bg-primary font-black text-primary-foreground">CX</span></div>
          <h1 className="text-3xl font-bold tracking-tight">{t("signInTitle")}</h1>
          <p className="mt-2 text-sm text-muted-foreground">{t("signInSubtitle")}</p>
          <form action="/api/auth/login" method="post" className="mt-8 space-y-5">
            <input type="hidden" name="locale" value={locale} />
            <div className="space-y-2"><Label htmlFor="email">{t("email")}</Label><Input id="email" name="email" type="email" defaultValue={roleEmails.employee} required /></div>
            <div className="space-y-2"><div className="flex justify-between"><Label htmlFor="password">{t("password")}</Label><a className="text-xs font-medium text-primary hover:underline" href={`/${locale}/forgot-password`}>{t("forgotPassword")}</a></div><Input id="password" name="password" type="password" defaultValue="CyberCultX@2026" required /></div>
            <Button className="w-full" size="lg" type="submit">{t("signInButton")}</Button>
          </form>
          <div className="mt-7 rounded-2xl bg-muted p-4">
            <p className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">{t("demoRoles")}</p>
            <div className="mt-3 space-y-2">
              {Object.entries(roleEmails).map(([role, email]) => (
                <div key={role} className="flex items-center gap-2 rounded-xl bg-background p-2 shadow-sm">
                  <div className="min-w-0 flex-1">
                    <p className="text-xs font-semibold">{locale === "ar" ? roleNamesArabic[role as UserRole] : role}</p>
                    <code className="block truncate text-[10px] text-muted-foreground">{email}</code>
                  </div>
                  <form action="/api/auth/demo-login" method="post">
                    <input type="hidden" name="locale" value={locale} />
                    <input type="hidden" name="role" value={role} />
                    <Button type="submit" variant="outline" size="sm">
                      {locale === "ar" ? "دخول مؤقت" : "Temporary login"}
                    </Button>
                  </form>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
