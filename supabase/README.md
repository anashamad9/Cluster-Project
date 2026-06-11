# CyberCultX — Supabase Setup

This folder contains everything needed to provision the database for
CyberCultX: schema migrations, RLS policies, and demo seed data for the
"Al Falah Holdings" tenant.

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and create a new project (free
   tier is fine for development).
2. Once provisioned, open **Project Settings → API** and copy:
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role` key → `SUPABASE_SERVICE_ROLE_KEY` (server-only, never expose to the client)

Add these to a `.env.local` file in the project root (see `.env.example`).

## 2. Run the migrations

Open the **SQL Editor** in the Supabase dashboard and run each file in
`supabase/migrations/` **in order**, one at a time:

1. `0001_extensions_and_enums.sql`
2. `0002_core_tables.sql`
3. `0003_security_audit.sql`
4. `0004_risk_intelligence.sql`
5. `0005_learning_gamification.sql`
6. `0006_assessments.sql`
7. `0007_phishing.sql`
8. `0008_notifications.sql`
9. `0009_ai_and_system.sql`
10. `0010_rls_helpers.sql`
11. `0011_rls_policies.sql`

Alternatively, if you have the Supabase CLI linked to your project, run:

```bash
supabase db push
```

(with the migration files copied/symlinked into the CLI's expected
`supabase/migrations` naming convention — the files here are already
numbered correctly for `supabase db push`).

## 3. Run the seed data

After all 11 migrations succeed, run each file in `supabase/seed/` **in
order**, again via the SQL Editor:

1. `01_core.sql` — demo tenant "Al Falah Holdings", departments, AI config,
   feature flags, achievements, course categories
2. `02_users.sql` — 5 demo accounts (one per role) + 25 generated employees
3. `03_courses.sql` — 10 courses with lessons
4. `04_assessments.sql` — 3 assessments (1 psychometric + 2 security knowledge) with questions
5. `05_phishing_templates.sql` — 56 bilingual phishing simulation templates
6. `06_demo_activity.sql` — 12-week risk score history, behavioral profiles,
   predictive risk indicators, financial exposure, course enrollments,
   assessment attempts, XP/achievements, phishing campaigns + results, and
   notifications

> **Note:** Seed files 02–06 must run as the `postgres` role (the default
> role used by the SQL Editor) because `02_users.sql` inserts directly into
> `auth.users` / `auth.identities`.

## 4. Demo login credentials

All demo accounts share the password:

```
CyberCultX@2026
```

| Role        | Email                      |
|-------------|----------------------------|
| SuperAdmin  | superadmin@cybercultx.com  |
| Admin       | admin@alfalah.demo         |
| HR          | hr@alfalah.demo            |
| Executive   | exec@alfalah.demo          |
| Employee    | employee@alfalah.demo      |

25 additional employee accounts are also seeded across departments
(`<firstname>.<lastname-fragment><n>@alfalah.demo`) using the same password,
for roster/leaderboard/heatmap data richness.

## 5. Verify

Run this quick check in the SQL Editor after seeding:

```sql
select role, count(*) from public.profiles group by role order by role;
select count(*) from public.phishing_templates;
select count(*) from public.courses;
select count(*) from public.risk_scores;
```

You should see 5 roles represented across 30 profiles, 56 phishing
templates, 10 courses, and ~348 risk score rows (29 tenant profiles × 12
weeks).
