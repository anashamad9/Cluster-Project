import OpenAI from "openai";
import { hasOpenAIEnv } from "@/lib/config";

const fallback = "Based on the current demo data, human risk is improving while security fatigue remains the main area to watch. Prioritize targeted learning for high-risk employees and continue short, localized phishing simulations.";

export async function POST(request: Request) {
  const { message } = await request.json();
  if (!hasOpenAIEnv) return Response.json({ message: fallback, demo: true });

  try {
    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const response = await openai.responses.create({
      model: process.env.OPENAI_MODEL || "gpt-4.1-mini",
      instructions: "You are CyberCultX, a concise enterprise human-risk intelligence assistant. Never claim access to data not supplied.",
      input: `Demo organization context: HRS 39, CCI 78, security fatigue 52%, phishing susceptibility 38%. User question: ${String(message).slice(0, 2000)}`,
    });
    return Response.json({ message: response.output_text || fallback, demo: false });
  } catch {
    return Response.json({ message: fallback, demo: true });
  }
}
