import { hasOpenAIEnv, hasSupabaseEnv } from "@/lib/config";

export async function GET() {
  return Response.json({ ok: true, mode: hasSupabaseEnv ? "supabase" : "demo", integrations: { supabase: hasSupabaseEnv, openai: hasOpenAIEnv } });
}
