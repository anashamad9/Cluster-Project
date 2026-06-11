"use client";

import { useState } from "react";
import { useLocale } from "next-intl";
import { Bot, ChevronDown, Languages, LogOut, Menu, Moon, Search, Sun, X } from "lucide-react";
import { useTheme } from "next-themes";
import { AppIcon } from "@/components/dashboard/icon";
import { Button } from "@/components/ui/button";
import { Link, usePathname, useRouter } from "@/i18n/navigation";
import { navArabic, roleNames, roleNamesArabic, roleNav } from "@/lib/demo-data";
import type { UserRole } from "@/lib/auth/roles";
import { cn } from "@/lib/utils";

export function AppShell({ role, children }: { role: UserRole; children: React.ReactNode }) {
  const [mobileOpen, setMobileOpen] = useState(false);
  const [chatOpen, setChatOpen] = useState(false);
  const locale = useLocale();
  const pathname = usePathname();
  const router = useRouter();
  const { resolvedTheme, setTheme } = useTheme();

  const switchLocale = () => router.replace(pathname, { locale: locale === "en" ? "ar" : "en" });

  return (
    <div className="min-h-screen bg-muted/30">
      <aside className={cn("fixed inset-y-0 start-0 z-40 flex w-64 flex-col bg-sidebar px-3 py-4 shadow-[1px_0_0_rgba(0,0,0,.06)] transition-transform duration-200", mobileOpen ? "translate-x-0" : locale === "ar" ? "translate-x-full lg:translate-x-0" : "-translate-x-full lg:translate-x-0")}>
        <div className="flex h-11 items-center justify-between px-2">
          <Link href={`/${role}/${role === "superadmin" ? "tenants" : "dashboard"}`} className="flex items-center gap-2.5">
            <span className="grid size-9 place-items-center rounded-xl bg-primary text-sm font-black text-primary-foreground shadow-sm">CX</span>
            <span><strong className="block leading-none">CyberCultX</strong><small className="text-[10px] uppercase tracking-[.16em] text-muted-foreground">{locale === "ar" ? "استخبارات المخاطر" : "Risk intelligence"}</small></span>
          </Link>
          <button className="grid size-10 place-items-center lg:hidden" onClick={() => setMobileOpen(false)} aria-label="Close navigation"><X className="size-5" /></button>
        </div>
        <div className="mt-6 rounded-xl bg-muted/60 p-3">
          <p className="text-xs text-muted-foreground">{locale === "ar" ? "مساحة العمل الحالية" : "Current workspace"}</p>
          <div className="mt-1 flex items-center justify-between"><span className="text-sm font-semibold">{locale === "ar" ? roleNamesArabic[role] : roleNames[role]}</span><ChevronDown className="size-4 text-muted-foreground" /></div>
        </div>
        <nav className="mt-5 space-y-1">
          {roleNav[role].map((item) => {
            const href = `/${role}/${item.href}`;
            const active = pathname === href;
            return <Link key={item.href} href={href} onClick={() => setMobileOpen(false)} className={cn("flex min-h-11 items-center gap-3 rounded-xl px-3 text-sm font-medium text-muted-foreground transition-[background-color,color,transform] active:scale-[.96]", active ? "bg-primary text-primary-foreground shadow-sm" : "hover:bg-muted hover:text-foreground")}><AppIcon name={item.icon} className="size-4.5" />{locale === "ar" ? navArabic[item.label] : item.label}</Link>;
          })}
        </nav>
        <div className="mt-auto rounded-xl bg-primary/8 p-3">
          <div className="flex items-center gap-2 text-sm font-semibold"><Bot className="size-4 text-primary" /> {locale === "ar" ? "مساعد المخاطر الذكي" : "AI risk assistant"}</div>
          <p className="mt-1 text-xs leading-relaxed text-muted-foreground">{locale === "ar" ? "اسأل عن وضع المخاطر أو أفضل إجراء تالٍ." : "Ask about your risk posture or next best action."}</p>
          <Button className="mt-3 w-full" size="sm" onClick={() => setChatOpen(true)}>{locale === "ar" ? "فتح المساعد" : "Open assistant"}</Button>
        </div>
      </aside>

      <div className="lg:ps-64">
        <header className="sticky top-0 z-30 flex h-16 items-center gap-3 bg-background/85 px-4 shadow-[0_1px_0_rgba(0,0,0,.06)] backdrop-blur-xl sm:px-6">
          <button className="grid size-10 place-items-center lg:hidden" onClick={() => setMobileOpen(true)} aria-label="Open navigation"><Menu className="size-5" /></button>
          <div className="relative hidden max-w-md flex-1 sm:block"><Search className="absolute start-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" /><input className="h-10 w-full rounded-xl bg-muted/70 ps-10 pe-4 text-sm outline-none ring-primary/20 transition-shadow focus:ring-3" placeholder={locale === "ar" ? "البحث عن موظفين وتقارير ودورات..." : "Search people, reports, courses..."} /></div>
          <div className="ms-auto flex items-center gap-1">
            <button className="grid size-10 place-items-center rounded-xl hover:bg-muted" onClick={switchLocale} aria-label="Switch language"><Languages className="size-4.5" /></button>
            <button className="grid size-10 place-items-center rounded-xl hover:bg-muted" onClick={() => setTheme(resolvedTheme === "dark" ? "light" : "dark")} aria-label="Toggle theme">{resolvedTheme === "dark" ? <Sun className="size-4.5" /> : <Moon className="size-4.5" />}</button>
            <Link href={`/${role}/notifications`} className="relative grid size-10 place-items-center rounded-xl hover:bg-muted"><AppIcon name="bell" className="size-4.5" /><span className="absolute end-2 top-2 size-2 rounded-full bg-red-500 ring-2 ring-background" /></Link>
            <div className="ms-2 grid size-9 place-items-center rounded-full bg-primary/15 text-xs font-bold text-primary">{role.slice(0, 2).toUpperCase()}</div>
            <form action="/api/auth/logout" method="post">
              <input type="hidden" name="locale" value={locale} />
              <button type="submit" className="grid size-10 place-items-center rounded-xl text-muted-foreground hover:bg-muted hover:text-foreground" aria-label="Sign out"><LogOut className="size-4.5" /></button>
            </form>
          </div>
        </header>
        <main className="mx-auto w-full max-w-[1500px] p-4 sm:p-6 lg:p-8">{children}</main>
      </div>

      {chatOpen && <ChatPanel locale={locale} onClose={() => setChatOpen(false)} />}
    </div>
  );
}

function ChatPanel({ locale, onClose }: { locale: string; onClose: () => void }) {
  const [messages, setMessages] = useState([{ by: "assistant", text: locale === "ar" ? "تتحسن المخاطر البشرية في مؤسستك. ما الذي تود فهمه؟" : "Your organization’s human risk is improving. What would you like to understand?" }]);
  const [value, setValue] = useState("");
  async function send() {
    if (!value.trim()) return;
    const question = value;
    setValue("");
    setMessages((m) => [...m, { by: "user", text: question }]);
    const response = await fetch("/api/chat", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ message: question }) });
    const data = await response.json();
    setMessages((m) => [...m, { by: "assistant", text: data.message }]);
  }
  return (
    <div className="fixed inset-0 z-50 bg-black/20 backdrop-blur-[2px]" onClick={onClose}>
      <section className="absolute inset-y-0 end-0 flex w-full max-w-md flex-col bg-background p-4 shadow-2xl" onClick={(event) => event.stopPropagation()}>
        <div className="flex items-center justify-between border-b pb-4"><div><h2 className="font-semibold">{locale === "ar" ? "مساعد المخاطر الذكي" : "AI risk assistant"}</h2><p className="text-xs text-muted-foreground">{locale === "ar" ? "إرشادات مبنية على السياق" : "Context-aware guidance"}</p></div><button className="grid size-10 place-items-center rounded-xl hover:bg-muted" onClick={onClose}><X className="size-5" /></button></div>
        <div className="flex-1 space-y-3 overflow-y-auto py-4">{messages.map((message, index) => <div key={index} className={cn("max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed", message.by === "assistant" ? "bg-muted" : "ms-auto bg-primary text-primary-foreground")}>{message.text}</div>)}</div>
        <div className="flex gap-2 border-t pt-4"><input value={value} onChange={(e) => setValue(e.target.value)} onKeyDown={(e) => e.key === "Enter" && send()} className="h-11 min-w-0 flex-1 rounded-xl bg-muted px-3 text-sm outline-none ring-primary/20 focus:ring-3" placeholder={locale === "ar" ? "اكتب سؤالك..." : "Ask a question..."} /><Button onClick={send}>{locale === "ar" ? "إرسال" : "Send"}</Button></div>
      </section>
    </div>
  );
}
