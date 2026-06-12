import OpenAI from "openai";
import type { UserRole } from "@/lib/auth/roles";
import { hasOpenAIEnv } from "@/lib/config";
import { getDashboardData } from "@/lib/dashboard-data";
import { createClient } from "@/lib/supabase/server";

const fallback = "The AI integration is not configured. Your live dashboard data is still available in the platform.";

export async function POST(request: Request) {
  const { message } = await request.json();
  if (!hasOpenAIEnv) return Response.json({ message: fallback, demo: true });

  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    const { data: profile } = user
      ? await supabase.from("profiles").select("role").eq("id", user.id).single()
      : { data: null };
    const data = await getDashboardData((profile?.role as UserRole | undefined) ?? "employee");
    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const response = await openai.responses.create({
      model: process.env.OPENAI_MODEL || "gpt-4.1-mini",
      instructions: "You are CyberCultX, a concise enterprise human-risk intelligence assistant. Never claim access to data not supplied.",
      input: `Live Supabase context: HRS ${data.currentHrs}, CCI ${data.currentCci}, security fatigue ${data.predictive.securityFatigue}%, phishing susceptibility ${data.predictive.phishingSusceptibility}%, learning completion ${data.metrics.learningCompletion}%, high-risk employees ${data.metrics.atRisk}. User question: ${String(message).slice(0, 2000)}`,
    });
    return Response.json({ message: response.output_text || fallback, demo: false });
  } catch {
    return Response.json({ message: fallback, demo: true });
  }
}
