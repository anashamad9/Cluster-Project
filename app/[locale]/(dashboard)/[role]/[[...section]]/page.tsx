import { notFound } from "next/navigation";
import { AppShell } from "@/components/dashboard/app-shell";
import { RolePage } from "@/components/dashboard/role-page";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { getDashboardData } from "@/lib/dashboard-data";

export default async function WorkspacePage({ params }: { params: Promise<{ locale: string; role: string; section?: string[] }> }) {
  const { locale, role, section } = await params;
  if (!(role in ROLE_HOME)) notFound();
  const userRole = role as UserRole;
  const defaultSection = userRole === "superadmin" ? "tenants" : "dashboard";
  const data = await getDashboardData(userRole);
  return <AppShell role={userRole}><RolePage locale={locale} role={userRole} section={section?.[0] ?? defaultSection} data={data} /></AppShell>;
}
