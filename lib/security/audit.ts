import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";

type AuditParams = {
  action: string;
  actorId?: string | null;
  actorEmail?: string | null;
  tenantId?: string | null;
  targetType?: string | null;
  targetId?: string | null;
  metadata?: Record<string, unknown>;
  ipAddress?: string | null;
  userAgent?: string | null;
};

export async function logAudit(supabase: SupabaseClient, params: AuditParams) {
  await supabase.from("audit_logs").insert({
    tenant_id: params.tenantId ?? null,
    actor_id: params.actorId ?? null,
    actor_email: params.actorEmail ?? null,
    action: params.action,
    target_type: params.targetType ?? null,
    target_id: params.targetId ?? null,
    metadata: params.metadata ?? {},
    ip_address: params.ipAddress ?? null,
    user_agent: params.userAgent ?? null,
  });
}
