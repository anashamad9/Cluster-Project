import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  { auth: { persistSession: false, autoRefreshToken: false } },
);

const tenantId = "10000000-0000-0000-0000-000000000001";

const { count: licenseCount } = await supabase
  .from("licenses")
  .select("*", { count: "exact", head: true })
  .eq("tenant_id", tenantId);

if (!licenseCount) {
  const { error } = await supabase.from("licenses").insert({
    tenant_id: tenantId, plan: "enterprise", seats: 250, status: "active",
  });
  if (error) throw error;
  console.log("created demo tenant license");
}

const { count: assessmentCount } = await supabase
  .from("assessments")
  .select("*", { count: "exact", head: true })
  .eq("tenant_id", tenantId);

if (!assessmentCount) {
  const { data: assessment, error } = await supabase.from("assessments").insert({
    tenant_id: tenantId,
    title: "Security Essentials Check",
    title_ar: "اختبار أساسيات الأمن",
    description: "A short knowledge check covering phishing, passwords, and safe access.",
    description_ar: "اختبار قصير يغطي التصيد وكلمات المرور والوصول الآمن.",
    type: "security_knowledge",
    passing_score: 70,
    duration_minutes: 8,
    is_published: true,
  }).select("id").single();
  if (error) throw error;

  const questions = [
    {
      question: "What should you do with a suspicious email link?",
      question_ar: "ماذا يجب أن تفعل مع رابط بريد إلكتروني مشبوه؟",
      options: [
        { key: "a", text: "Click it to inspect the page", text_ar: "انقر عليه لفحص الصفحة" },
        { key: "b", text: "Report it and avoid clicking", text_ar: "أبلغ عنه وتجنب النقر" },
        { key: "c", text: "Forward it to coworkers", text_ar: "أرسله إلى الزملاء" },
      ],
      correct_answer: "b",
    },
    {
      question: "Which password practice is safest?",
      question_ar: "ما ممارسة كلمة المرور الأكثر أمانًا؟",
      options: [
        { key: "a", text: "Reuse one strong password", text_ar: "إعادة استخدام كلمة مرور قوية واحدة" },
        { key: "b", text: "Use unique passwords with a password manager", text_ar: "استخدم كلمات مرور فريدة مع مدير كلمات المرور" },
        { key: "c", text: "Share passwords with your manager", text_ar: "شارك كلمات المرور مع مديرك" },
      ],
      correct_answer: "b",
    },
    {
      question: "How should you verify an urgent payment request?",
      question_ar: "كيف تتحقق من طلب دفع عاجل؟",
      options: [
        { key: "a", text: "Use a known second communication channel", text_ar: "استخدم قناة اتصال ثانية معروفة" },
        { key: "b", text: "Reply to the same email", text_ar: "رد على نفس البريد الإلكتروني" },
        { key: "c", text: "Act immediately", text_ar: "تصرف فورًا" },
      ],
      correct_answer: "a",
    },
  ];

  const { error: questionError } = await supabase.from("assessment_questions").insert(
    questions.map((question, index) => ({
      assessment_id: assessment.id, ...question, order_index: index + 1, points: 1,
    })),
  );
  if (questionError) throw questionError;
  console.log("created starter assessment");
}
