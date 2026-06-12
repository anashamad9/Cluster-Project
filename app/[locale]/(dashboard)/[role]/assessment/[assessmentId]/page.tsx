import { notFound } from "next/navigation";
import { AppShell } from "@/components/dashboard/app-shell";
import { Button } from "@/components/ui/button";
import { submitAssessment } from "@/lib/platform-actions";
import { ROLE_HOME, type UserRole } from "@/lib/auth/roles";
import { createServiceRoleClient } from "@/lib/supabase/server";

type Option = { key: string; text: string; text_ar?: string };

export default async function AssessmentPage({ params }: { params: Promise<{ locale: string; role: string; assessmentId: string }> }) {
  const { locale, role, assessmentId } = await params;
  if (!(role in ROLE_HOME)) notFound();
  const supabase = await createServiceRoleClient();
  const [{ data: assessment }, { data: questions }] = await Promise.all([
    supabase.from("assessments").select("title,title_ar,description,description_ar,duration_minutes").eq("id", assessmentId).single(),
    supabase.from("assessment_questions").select("id,question,question_ar,options,order_index").eq("assessment_id", assessmentId).order("order_index"),
  ]);
  if (!assessment) notFound();
  const ar = locale === "ar";
  return <AppShell role={role as UserRole}><div className="mx-auto max-w-4xl">
    <p className="text-xs font-semibold uppercase tracking-[.18em] text-primary">{ar ? "تقييم" : "Assessment"}</p>
    <h1 className="mt-2 text-3xl font-bold">{ar ? assessment.title_ar : assessment.title}</h1>
    <p className="mt-3 text-muted-foreground">{ar ? assessment.description_ar : assessment.description}</p>
    <form action={submitAssessment} className="mt-8 space-y-5"><input type="hidden" name="assessmentId" value={assessmentId} /><input type="hidden" name="locale" value={locale} /><input type="hidden" name="role" value={role} />
      {questions?.map((question) => <fieldset key={question.id} className="surface-card p-6"><legend className="px-2 font-semibold">{question.order_index}. {ar ? question.question_ar : question.question}</legend><div className="mt-4 grid gap-3">{(question.options as Option[]).map((option) => <label key={option.key} className="flex cursor-pointer items-start gap-3 rounded-xl bg-muted/55 p-3 text-sm"><input type="radio" name={`question_${question.id}`} value={option.key} required className="mt-1" /><span>{ar ? option.text_ar : option.text}</span></label>)}</div></fieldset>)}
      <Button size="lg">{ar ? "إرسال التقييم" : "Submit assessment"}</Button>
    </form>
  </div></AppShell>;
}
