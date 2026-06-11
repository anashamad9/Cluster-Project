import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";

/**
 * Returns true if the request is allowed, false if the rate limit for
 * `key` has been exceeded within the given window.
 */
export async function checkRateLimit(
  supabase: SupabaseClient,
  key: string,
  maxRequests: number,
  windowSeconds: number,
): Promise<boolean> {
  const { data, error } = await supabase.rpc("check_rate_limit", {
    p_key: key,
    p_max_requests: maxRequests,
    p_window_seconds: windowSeconds,
  });

  if (error) {
    return true;
  }

  return Boolean(data);
}
