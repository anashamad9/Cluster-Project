export type UserRole = "employee" | "executive" | "hr" | "admin" | "superadmin";

export const ROLE_HOME: Record<UserRole, string> = {
  employee: "/employee/dashboard",
  executive: "/executive/dashboard",
  hr: "/hr/dashboard",
  admin: "/admin/dashboard",
  superadmin: "/superadmin/tenants",
};
