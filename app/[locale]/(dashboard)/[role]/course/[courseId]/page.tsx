import { notFound } from "next/navigation";
import { AppShell } from "@/components/dashboard/app-shell";
import { Button } from "@/components/ui/button";
import { completeCourse } from "@/lib/platform-actions";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { createClient } from "@/lib/supabase/server";

export default async function CoursePage({ params }: { params: Promise<{ locale: string; role: string; courseId: string }> }) {
  const { locale, role, courseId } = await params;
  if (!(role in ROLE_HOME)) notFound();
  const supabase = await createClient();
  const [{ data: course }, { data: lessons }] = await Promise.all([
    supabase.from("courses").select("title,title_ar,description,description_ar,duration_minutes,xp_reward").eq("id", courseId).single(),
    supabase.from("course_lessons").select("id,title,title_ar,content,content_ar,duration_minutes,order_index").eq("course_id", courseId).order("order_index"),
  ]);
  if (!course) notFound();
  const ar = locale === "ar";
  return <AppShell role={role as UserRole}><div className="mx-auto max-w-4xl">
    <p className="text-xs font-semibold uppercase tracking-[.18em] text-primary">{ar ? "دورة أمنية" : "Security course"}</p>
    <h1 className="mt-2 text-3xl font-bold">{ar ? course.title_ar : course.title}</h1>
    <p className="mt-3 text-muted-foreground">{ar ? course.description_ar : course.description}</p>
    <p className="mt-3 text-sm font-medium">{course.duration_minutes} {ar ? "دقيقة" : "minutes"} · {course.xp_reward} XP</p>
    <div className="mt-8 space-y-4">{lessons?.map((lesson) => <article key={lesson.id} className="surface-card p-6"><div className="flex items-center justify-between gap-3"><h2 className="font-semibold">{lesson.order_index}. {ar ? lesson.title_ar : lesson.title}</h2><span className="text-xs text-muted-foreground">{lesson.duration_minutes} min</span></div><p className="mt-4 leading-7 text-muted-foreground">{ar ? lesson.content_ar : lesson.content}</p></article>)}</div>
    <form action={completeCourse} className="mt-8"><input type="hidden" name="courseId" value={courseId} /><input type="hidden" name="locale" value={locale} /><input type="hidden" name="role" value={role} /><Button size="lg">{ar ? "إكمال الدورة والحصول على النقاط" : "Complete course and earn XP"}</Button></form>
  </div></AppShell>;
}
