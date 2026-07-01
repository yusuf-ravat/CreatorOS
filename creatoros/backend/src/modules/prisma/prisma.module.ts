import { Module, Global, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Global()
@Module({
  providers: [
    {
      provide: PrismaClient,
      useFactory: () => {
        const prisma = new PrismaClient({
          log: process.env.NODE_ENV === 'development' 
            ? ['query', 'error', 'warn'] 
            : ['error'],
        });
        
        // Enable query logging in development
        if (process.env.NODE_ENV === 'development') {
          prisma.$use(async (params, next) => {
            const before = Date.now();
            const result = await next(params);
            const after = Date.now();
            console.log(
              `Query ${params.model}.${params.action} took ${after - before}ms`,
            );
            return result;
          });
        }
        
        return prisma;
      },
    },
  ],
  exports: [PrismaClient],
})
export class PrismaModule implements OnModuleInit, OnModuleDestroy {
  constructor(private prisma: PrismaClient) {}

  async onModuleInit() {
    await this.prisma.$connect();
    console.log('✅ Database connected');
  }

  async onModuleDestroy() {
    await this.prisma.$disconnect();
    console.log('🔌 Database disconnected');
  }
}
