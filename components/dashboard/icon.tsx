import {
  Bell,
  BookOpen,
  Bot,
  Building2,
  ClipboardCheck,
  FileBarChart,
  Gauge,
  GraduationCap,
  LayoutDashboard,
  ListChecks,
  LucideIcon,
  Settings,
  ShieldAlert,
  Target,
  Users,
} from "lucide-react";

const icons: Record<string, LucideIcon> = {
  dashboard: LayoutDashboard,
  risk: Gauge,
  learn: GraduationCap,
  assessment: ClipboardCheck,
  phishing: Target,
  people: Users,
  reports: FileBarChart,
  settings: Settings,
  tenants: Building2,
  audit: ListChecks,
  bell: Bell,
  bot: Bot,
  course: BookOpen,
  alert: ShieldAlert,
};

export function AppIcon({ name, className }: { name: string; className?: string }) {
  const Icon = icons[name] ?? LayoutDashboard;
  return <Icon aria-hidden="true" className={className} />;
}
