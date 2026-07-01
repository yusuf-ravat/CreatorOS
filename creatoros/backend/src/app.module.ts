import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { ScheduleModule } from '@nestjs/schedule';

// Database
import { PrismaModule } from './modules/prisma/prisma.module';

// Core Modules
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { OrganizationsModule } from './modules/organizations/organizations.module';
import { BrandsModule } from './modules/brands/brands.module';
import { DealsModule } from './modules/deals/deals.module';
import { CampaignsModule } from './modules/campaigns/campaigns.module';
import { ContentModule } from './modules/content/content.module';
import { ContractsModule } from './modules/contracts/contracts.module';
import { InvoicesModule } from './modules/invoices/invoices.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { ExpensesModule } from './modules/expenses/expenses.module';
import { TasksModule } from './modules/tasks/tasks.module';
import { FilesModule } from './modules/files/files.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { AIModule } from './modules/ai/ai.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { IntegrationsModule } from './modules/integrations/integrations.module';

// Common
import { CommonModule } from './common/common.module';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),

    // Rate Limiting
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        throttlers: [
          {
            ttl: config.get('THROTTLE_TTL', 60),
            limit: config.get('THROTTLE_LIMIT', 10),
          },
        ],
      }),
    }),

    // Scheduled Jobs
    ScheduleModule.forRoot(),

    // Database
    PrismaModule,

    // Common Utilities
    CommonModule,

    // Feature Modules
    AuthModule,
    UsersModule,
    OrganizationsModule,
    BrandsModule,
    DealsModule,
    CampaignsModule,
    ContentModule,
    ContractsModule,
    InvoicesModule,
    PaymentsModule,
    ExpensesModule,
    TasksModule,
    FilesModule,
    AnalyticsModule,
    AIModule,
    NotificationsModule,
    IntegrationsModule,
  ],
})
export class AppModule {}
