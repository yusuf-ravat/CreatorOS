import { Sparkles } from 'lucide-react'

export function Logo() {
  return (
    <div className="flex items-center gap-2 font-bold text-xl">
      <Sparkles className="h-6 w-6 text-primary" />
      <span>CreatorOS</span>
    </div>
  )
}
