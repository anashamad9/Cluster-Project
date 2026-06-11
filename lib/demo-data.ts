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

export const trend = [68, 64, 66, 61, 59, 56, 54, 50, 48, 45, 43, 39];
export const cciTrend = [51, 53, 55, 58, 59, 62, 65, 67, 70, 72, 75, 78];

export const people = [
  { name: "Omar Hassan", department: "Finance", risk: 82, status: "Critical", training: "42%" },
  { name: "Sara Khalid", department: "Operations", risk: 68, status: "High", training: "71%" },
  { name: "Layla Ahmed", department: "Human Resources", risk: 55, status: "High", training: "84%" },
  { name: "Yousef Ali", department: "Technology", risk: 31, status: "Medium", training: "92%" },
  { name: "Mariam Saleh", department: "Legal", risk: 18, status: "Low", training: "100%" },
];

export const courses = [
  { title: "Phishing Defense Essentials", progress: 72, duration: "24 min", xp: 120 },
  { title: "Secure Remote Work", progress: 35, duration: "18 min", xp: 80 },
  { title: "MFA and Password Hygiene", progress: 100, duration: "12 min", xp: 60 },
];

export const notifications = [
  { title: "New learning path assigned", body: "Complete the Q2 security essentials path.", time: "8 min ago" },
  { title: "Risk score improved", body: "Your Human Risk Score improved by 6 points.", time: "Yesterday" },
  { title: "Simulation complete", body: "The April phishing simulation results are ready.", time: "2 days ago" },
];

export const audits = [
  { actor: "admin@alfalah.demo", action: "phishing_campaign.created", target: "April Invoice Drill", time: "Today, 10:42" },
  { actor: "hr@alfalah.demo", action: "course.assigned", target: "Finance department", time: "Today, 09:18" },
  { actor: "exec@alfalah.demo", action: "report.downloaded", target: "Q1 Risk Intelligence", time: "Yesterday, 16:04" },
  { actor: "employee@alfalah.demo", action: "assessment.completed", target: "Security Knowledge", time: "Yesterday, 13:21" },
];

export const tenants = [
  { name: "Al Falah Holdings", plan: "Enterprise", seats: "30 / 250", risk: "39", status: "Active" },
  { name: "Noura Logistics", plan: "Standard", seats: "84 / 100", risk: "51", status: "Trial" },
  { name: "Crescent Health", plan: "Enterprise", seats: "612 / 800", risk: "28", status: "Active" },
];

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
