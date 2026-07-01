'use client'

import { usePathname } from 'next/navigation'
import Link from 'next/link'
import { cn } from '@/lib/utils'
import {
  LayoutDashboard,
  Building2,
  KanbanSquare,
  Calendar,
  FileText,
  Receipt,
  CreditCard,
  PieChart,
  Users,
  TaskSquare,
  FolderOpen,
  Bot,
  Settings,
} from 'lucide-react'

const navItems = [
  { title: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { title: 'Brands', href: '/dashboard/brands', icon: Building2 },
  { title: 'Deals', href: '/dashboard/deals', icon: KanbanSquare },
  { title: 'Calendar', href: '/dashboard/calendar', icon: Calendar },
  { title: 'Contracts', href: '/dashboard/contracts', icon: FileText },
  { title: 'Invoices', href: '/dashboard/invoices', icon: Receipt },
  { title: 'Payments', href: '/dashboard/payments', icon: CreditCard },
  { title: 'Analytics', href: '/dashboard/analytics', icon: PieChart },
  { title: 'Team', href: '/dashboard/team', icon: Users },
  { title: 'Tasks', href: '/dashboard/tasks', icon: TaskSquare },
  { title: 'Files', href: '/dashboard/files', icon: FolderOpen },
  { title: 'AI Assistant', href: '/dashboard/ai', icon: Bot },
  { title: 'Settings', href: '/dashboard/settings', icon: Settings },
]

export function DashboardNav() {
  const pathname = usePathname()

  return (
    <nav className="space-y-1">
      {navItems.map((item) => {
        const Icon = item.icon
        const isActive = pathname === item.href || pathname?.startsWith(`${item.href}/`)

        return (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
              isActive
                ? 'bg-primary text-primary-foreground'
                : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
            )}
          >
            <Icon className="h-4 w-4" />
            {item.title}
          </Link>
        )
      })}
    </nav>
  )
}
