import type { UserRole } from "@/lib/auth/roles";

export type NavItem = {
  label: string;
  href: string;
  icon:
    | "dashboard"
    | "risk"
    | "learn"
    | "assessment"
    | "phishing"
    | "people"
    | "reports"
    | "settings"
    | "tenants"
    | "audit";
};

export const roleNames: Record<UserRole, string> = {
  employee: "Employee",
  executive: "Executive",
  hr: "HR",
  admin: "Admin",
  superadmin: "Super Admin",
};

export const roleNamesArabic: Record<UserRole, string> = {
  employee: "الموظف",
  executive: "الإدارة التنفيذية",
  hr: "الموارد البشرية",
  admin: "مسؤول النظام",
  superadmin: "المسؤول العام",
};

export const navArabic: Record<string, string> = {
  Overview: "نظرة عامة",
  "My risk": "مخاطري",
  Learning: "التعلّم",
  Assessments: "التقييمات",
  Phishing: "التصيد الاحتيالي",
  "Risk intelligence": "استخبارات المخاطر",
  Reports: "التقارير",
  People: "الموظفون",
  Campaigns: "الحملات",
  "Audit log": "سجل التدقيق",
  Settings: "الإعدادات",
  Tenants: "المؤسسات",
  Platform: "المنصة",
};

export const roleNav: Record<UserRole, NavItem[]> = {
  employee: [
    { label: "Overview", href: "dashboard", icon: "dashboard" },
    { label: "My risk", href: "risk", icon: "risk" },
    { label: "Learning", href: "learning", icon: "learn" },
    { label: "Assessments", href: "assessments", icon: "assessment" },
    { label: "Phishing", href: "phishing", icon: "phishing" },
  ],
  executive: [
    { label: "Overview", href: "dashboard", icon: "dashboard" },
    { label: "Risk intelligence", href: "risk", icon: "risk" },
    { label: "Reports", href: "reports", icon: "reports" },
  ],
  hr: [
    { label: "Overview", href: "dashboard", icon: "dashboard" },
    { label: "People", href: "people", icon: "people" },
    { label: "Learning", href: "learning", icon: "learn" },
    { label: "Reports", href: "reports", icon: "reports" },
  ],
  admin: [
    { label: "Overview", href: "dashboard", icon: "dashboard" },
    { label: "People", href: "people", icon: "people" },
    { label: "Campaigns", href: "campaigns", icon: "phishing" },
    { label: "Audit log", href: "audit", icon: "audit" },
    { label: "Settings", href: "settings", icon: "settings" },
  ],
  superadmin: [
    { label: "Tenants", href: "tenants", icon: "tenants" },
    { label: "Platform", href: "dashboard", icon: "dashboard" },
    { label: "Audit log", href: "audit", icon: "audit" },
    { label: "Settings", href: "settings", icon: "settings" },
  ],
};

export const roleEmails: Record<UserRole, string> = {
  employee: "employee@alfalah.demo",
  executive: "exec@alfalah.demo",
  hr: "hr@alfalah.demo",
  admin: "admin@alfalah.demo",
  superadmin: "superadmin@cybercultx.com",
};

export function roleFromEmail(email: string): UserRole {
  if (email.includes("superadmin")) return "superadmin";
  if (email.startsWith("admin")) return "admin";
  if (email.startsWith("hr")) return "hr";
  if (email.startsWith("exec")) return "executive";
  return "employee";
}
