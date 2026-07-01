'use client'

import { cn } from '@/lib/utils'
import { DashboardNav } from './dashboard-nav'
import { Logo } from './logo'

interface SidebarProps extends React.HTMLAttributes<HTMLDivElement> {}

export function Sidebar({ className }: SidebarProps) {
  return (
    <div className={cn('pb-12 min-h-screen', className)}>
      <div className="space-y-4 py-4">
        <div className="px-3 py-2">
          <div className="mb-4 px-2">
            <Logo />
          </div>
          <DashboardNav />
        </div>
      </div>
    </div>
  )
}
