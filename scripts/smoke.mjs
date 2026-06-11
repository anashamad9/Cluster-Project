const base = process.env.BASE_URL || "http://localhost:3000";

async function expect(route, options = {}, expected = 200) {
  const response = await fetch(`${base}${route}`, { redirect: "manual", ...options });
  if (response.status !== expected) throw new Error(`${route} expected ${expected}, received ${response.status}`);
  console.log(`ok ${route} ${response.status}`);
  return response;
}

await expect("/api/health");
await expect("/en/login");
await expect("/api/chat", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ message: "What should we prioritize?" }) });
const report = await expect("/api/report");
if (report.headers.get("content-type") !== "application/pdf") throw new Error("report endpoint did not return a PDF");

const roles = {
  employee: "employee@alfalah.demo",
  executive: "exec@alfalah.demo",
  hr: "hr@alfalah.demo",
  admin: "admin@alfalah.demo",
  superadmin: "superadmin@cybercultx.com",
};

for (const [role, email] of Object.entries(roles)) {
  const form = new FormData();
  form.set("email", email);
  form.set("password", "CyberCultX@2026");
  form.set("locale", "en");
  const login = await expect("/api/auth/login", { method: "POST", body: form }, 303);
  const cookie = login.headers.get("set-cookie");
  const home = role === "superadmin" ? "tenants" : "dashboard";
  await expect(`/en/${role}/${home}`, { headers: { cookie } });
}

await expect("/ar/login");

const demoForm = new FormData();
demoForm.set("role", "employee");
demoForm.set("locale", "en");
const demoLogin = await expect(
  "/api/auth/demo-login",
  { method: "POST", body: demoForm },
  303,
);
const demoCookie = demoLogin.headers.get("set-cookie");
const logoutPrefetch = await expect("/api/auth/logout", {
  headers: { cookie: demoCookie },
}, 405);
if (logoutPrefetch.headers.get("set-cookie")) {
  throw new Error("GET /api/auth/logout must not clear session cookies");
}
for (const route of [
  "/en/employee/dashboard",
  "/en/employee/risk",
  "/en/employee/learning",
  "/en/employee/assessments",
  "/en/employee/phishing",
  "/en/employee/notifications",
  "/ar/employee/dashboard",
  "/ar/employee/risk",
  "/ar/employee/learning",
]) {
  await expect(route, { headers: { cookie: demoCookie } });
}

const logoutForm = new FormData();
logoutForm.set("locale", "en");
const logout = await expect(
  "/api/auth/logout",
  { method: "POST", body: logoutForm, headers: { cookie: demoCookie } },
  303,
);
if (!logout.headers.get("set-cookie")?.includes("cybercultx_demo_role=")) {
  throw new Error("POST /api/auth/logout did not clear the demo session");
}
