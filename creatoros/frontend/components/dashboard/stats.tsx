import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { DollarSign, TrendingUp, TrendingDown, Clock, Building2, Calendar } from 'lucide-react'

const stats = [
  {
    title: 'Total Revenue',
    value: '$127,450',
    change: '+12.5%',
    trend: 'up',
    icon: DollarSign,
  },
  {
    title: 'Pending Payments',
    value: '$23,500',
    change: '-5.2%',
    trend: 'down',
    icon: Clock,
  },
  {
    title: 'Expected Revenue',
    value: '$89,200',
    change: '+8.1%',
    trend: 'up',
    icon: TrendingUp,
  },
  {
    title: 'Active Brand Deals',
    value: '24',
    change: '+3',
    trend: 'up',
    icon: Building2,
  },
]

export function DashboardStats() {
  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
      {stats.map((stat) => {
        const Icon = stat.icon
        const isUp = stat.trend === 'up'
        
        return (
          <Card key={stat.title}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">{stat.title}</CardTitle>
              <Icon className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stat.value}</div>
              <p className={`text-xs flex items-center gap-1 ${isUp ? 'text-green-600' : 'text-red-600'}`}>
                {isUp ? <TrendingUp className="h-3 w-3" /> : <TrendingDown className="h-3 w-3" />}
                {stat.change} from last month
              </p>
            </CardContent>
          </Card>
        )
      })}
    </div>
  )
}
