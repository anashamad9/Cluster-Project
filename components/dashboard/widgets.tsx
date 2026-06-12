import { ArrowDownRight, ArrowUpRight, CheckCircle2, Clock3 } from "lucide-react";
import { cn } from "@/lib/utils";

export function StatCard({
  label,
  value,
  delta,
  positive = true,
  detail,
}: {
  label: string;
  value: string;
  delta?: string;
  positive?: boolean;
  detail?: string;
}) {
  const TrendIcon = positive ? ArrowDownRight : ArrowUpRight;
  return (
    <article className="surface-card group p-5">
      <p className="text-sm text-muted-foreground">{label}</p>
      <div className="mt-3 flex items-end justify-between gap-3">
        <strong className="text-3xl tracking-tight tabular-nums">{value}</strong>
        {delta && (
          <span className={cn("inline-flex items-center gap-1 rounded-full px-2 py-1 text-xs font-semibold", positive ? "bg-emerald-500/10 text-emerald-600" : "bg-amber-500/10 text-amber-600")}>
            <TrendIcon className="size-3.5" /> {delta}
          </span>
        )}
      </div>
      {detail && <p className="mt-3 text-xs text-muted-foreground">{detail}</p>}
    </article>
  );
}

export function RiskGauge({ value = 39, label = "Human Risk Score" }: { value?: number; label?: string }) {
  const circumference = 2 * Math.PI * 52;
  const offset = circumference - (value / 100) * circumference;
  return (
    <div className="surface-card flex min-h-72 flex-col items-center justify-center p-6 text-center">
      <div className="relative size-44">
        <svg viewBox="0 0 128 128" className="-rotate-90 size-full">
          <circle cx="64" cy="64" r="52" fill="none" stroke="currentColor" strokeWidth="10" className="text-muted" />
          <circle cx="64" cy="64" r="52" fill="none" stroke="currentColor" strokeWidth="10" strokeLinecap="round" strokeDasharray={circumference} strokeDashoffset={offset} className="text-primary transition-[stroke-dashoffset] duration-700" />
        </svg>
        <div className="absolute inset-0 flex flex-col items-center justify-center">
          <strong className="text-4xl tabular-nums">{value}</strong>
          <span className="text-xs text-muted-foreground">out of 100</span>
        </div>
      </div>
      <h3 className="mt-4 font-semibold">{label}</h3>
      <p className="mt-1 text-sm text-muted-foreground">Medium risk · improving steadily</p>
    </div>
  );
}

export function TrendChart({ values, label = "12-week trend" }: { values: number[]; label?: string }) {
  const chartValues = values.length > 1 ? values : values.length === 1 ? [values[0], values[0]] : [0, 0];
  const points = chartValues.map((value, index) => `${(index / (chartValues.length - 1)) * 100},${100 - value}`).join(" ");
  return (
    <div className="surface-card min-h-72 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="font-semibold">{label}</h3>
          <p className="mt-1 text-sm text-muted-foreground">Weekly organization snapshot</p>
        </div>
        <span className="rounded-full bg-emerald-500/10 px-3 py-1 text-xs font-semibold text-emerald-600">Healthy trend</span>
      </div>
      <div className="mt-8 h-40">
        <svg viewBox="0 0 100 100" preserveAspectRatio="none" className="size-full overflow-visible">
          {[20, 40, 60, 80].map((y) => <line key={y} x1="0" x2="100" y1={y} y2={y} stroke="currentColor" strokeWidth=".3" className="text-border" />)}
          <polyline points={points} fill="none" stroke="currentColor" strokeWidth="2.5" vectorEffect="non-scaling-stroke" strokeLinecap="round" strokeLinejoin="round" className="text-primary" />
        </svg>
      </div>
    </div>
  );
}

export function ProgressRow({ title, progress, detail }: { title: string; progress: number; detail?: string }) {
  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between gap-4 text-sm">
        <span className="font-medium">{title}</span>
        <span className="text-muted-foreground tabular-nums">{progress}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-muted">
        <div className="h-full rounded-full bg-primary transition-[width] duration-500" style={{ width: `${progress}%` }} />
      </div>
      {detail && <p className="text-xs text-muted-foreground">{detail}</p>}
    </div>
  );
}

export function StatusPill({ children, tone = "neutral" }: { children: React.ReactNode; tone?: "good" | "warn" | "bad" | "neutral" }) {
  return <span className={cn("rounded-full px-2.5 py-1 text-xs font-semibold", tone === "good" && "bg-emerald-500/10 text-emerald-600", tone === "warn" && "bg-amber-500/10 text-amber-600", tone === "bad" && "bg-red-500/10 text-red-600", tone === "neutral" && "bg-muted text-muted-foreground")}>{children}</span>;
}

export function EmptyState({ title, body }: { title: string; body: string }) {
  return (
    <div className="surface-card flex min-h-56 flex-col items-center justify-center p-8 text-center">
      <CheckCircle2 className="size-9 text-emerald-500" />
      <h3 className="mt-4 font-semibold">{title}</h3>
      <p className="mt-2 max-w-sm text-sm text-muted-foreground">{body}</p>
    </div>
  );
}

export function ActivityItem({ title, detail, time }: { title: string; detail: string; time: string }) {
  return (
    <div className="flex gap-3 py-3">
      <div className="mt-1 grid size-8 shrink-0 place-items-center rounded-lg bg-primary/10 text-primary"><Clock3 className="size-4" /></div>
      <div className="min-w-0 flex-1">
        <p className="text-sm font-medium">{title}</p>
        <p className="truncate text-xs text-muted-foreground">{detail}</p>
      </div>
      <span className="shrink-0 text-xs text-muted-foreground">{time}</span>
    </div>
  );
}
