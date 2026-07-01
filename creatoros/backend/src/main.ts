import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import helmet from 'helmet';
import compression from 'compression';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // Security
  app.use(helmet());
  app.use(compression());

  // CORS
  app.enableCors({
    origin: configService.get('FRONTEND_URL', 'http://localhost:3000'),
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  });

  // Global prefix
  const apiPrefix = configService.get('API_PREFIX', '/api/v1');
  app.setGlobalPrefix(apiPrefix);

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('CreatorOS API')
    .setDescription('AI-powered CRM for Creators & Influencers - Complete REST API')
    .setVersion('1.0')
    .addTag('auth', 'Authentication & Authorization')
    .addTag('users', 'User Management')
    .addTag('organizations', 'Organization & Workspace')
    .addTag('brands', 'Brand CRM')
    .addTag('deals', 'Sponsorship Deals & Pipeline')
    .addTag('campaigns', 'Campaign Management')
    .addTag('content', 'Content Calendar')
    .addTag('contracts', 'Contract Management')
    .addTag('invoices', 'Invoice Management')
    .addTag('payments', 'Payment Tracking')
    .addTag('expenses', 'Expense Management')
    .addTag('tasks', 'Task Management')
    .addTag('files', 'File Manager')
    .addTag('analytics', 'Analytics & Reports')
    .addTag('ai', 'AI Features')
    .addTag('notifications', 'Notifications')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });

  // Graceful shutdown
  app.enableShutdownHooks();

  const port = configService.get('PORT', 3001);
  await app.listen(port);
  
  console.log(`🚀 CreatorOS API running on: http://localhost:${port}${apiPrefix}`);
  console.log(`📚 Swagger docs available at: http://localhost:${port}/docs`);
}

bootstrap();
