# CreatorOS - Complete Project Structure

```
creatoros/
├── backend/                          # NestJS Backend
│   ├── prisma/
│   │   ├── schema.prisma            # Database schema
│   │   ├── migrations/              # Database migrations
│   │   └── seed.ts                  # Seed data
│   ├── src/
│   │   ├── main.ts                  # Application entry point
│   │   ├── app.module.ts            # Root module
│   │   ├── modules/
│   │   │   ├── auth/                # Authentication Module
│   │   │   │   ├── auth.module.ts
│   │   │   │   ├── auth.controller.ts
│   │   │   │   ├── auth.service.ts
│   │   │   │   ├── strategies/
│   │   │   │   │   ├── jwt.strategy.ts
│   │   │   │   │   ├── refresh.strategy.ts
│   │   │   │   │   └── google.strategy.ts
│   │   │   │   ├── guards/
│   │   │   │   │   ├── jwt.guard.ts
│   │   │   │   │   ├── roles.guard.ts
│   │   │   │   │   └── permissions.guard.ts
│   │   │   │   ├── decorators/
│   │   │   │   │   ├── roles.decorator.ts
│   │   │   │   │   └── permissions.decorator.ts
│   │   │   │   ├── dto/
│   │   │   │   │   ├── login.dto.ts
│   │   │   │   │   ├── register.dto.ts
│   │   │   │   │   └── refresh-token.dto.ts
│   │   │   │   └── tests/
│   │   │   │       └── auth.e2e-spec.ts
│   │   │   │
│   │   │   ├── organization/        # Organization/Tenant Module
│   │   │   │   ├── organization.module.ts
│   │   │   │   ├── organization.controller.ts
│   │   │   │   ├── organization.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── brand/               # Brand CRM Module
│   │   │   │   ├── brand.module.ts
│   │   │   │   ├── brand.controller.ts
│   │   │   │   ├── brand.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── deal/                # Deal/Pipeline Module
│   │   │   │   ├── deal.module.ts
│   │   │   │   ├── deal.controller.ts
│   │   │   │   ├── deal.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── content/             # Content Calendar Module
│   │   │   │   ├── content.module.ts
│   │   │   │   ├── content.controller.ts
│   │   │   │   ├── content.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── contract/            # Contract Management Module
│   │   │   │   ├── contract.module.ts
│   │   │   │   ├── contract.controller.ts
│   │   │   │   ├── contract.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── invoice/             # Invoice Module
│   │   │   │   ├── invoice.module.ts
│   │   │   │   ├── invoice.controller.ts
│   │   │   │   ├── invoice.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── payment/             # Payment Module
│   │   │   │   ├── payment.module.ts
│   │   │   │   ├── payment.controller.ts
│   │   │   │   ├── payment.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── expense/             # Expense Module
│   │   │   │   ├── expense.module.ts
│   │   │   │   ├── expense.controller.ts
│   │   │   │   ├── expense.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── task/                # Task Management Module
│   │   │   │   ├── task.module.ts
│   │   │   │   ├── task.controller.ts
│   │   │   │   ├── task.service.ts
│   │   │   │   ├── dto/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── file/                # File Management Module
│   │   │   │   ├── file.module.ts
│   │   │   │   ├── file.controller.ts
│   │   │   │   ├── file.service.ts
│   │   │   │   ├── upload/
│   │   │   │   └── tests/
│   │   │   │
│   │   │   ├── contact/             # Contacts Module
│   │   │   │   ├── contact.module.ts
│   │   │   │   ├── contact.controller.ts
│   │   │   │   ├── contact.service.ts
│   │   │   │   └── dto/
│   │   │   │
│   │   │   ├── analytics/           # Analytics Module
│   │   │   │   ├── analytics.module.ts
│   │   │   │   ├── analytics.controller.ts
│   │   │   │   ├── analytics.service.ts
│   │   │   │   └── dto/
│   │   │   │
│   │   │   ├── ai/                  # AI Module
│   │   │   │   ├── ai.module.ts
│   │   │   │   ├── ai.controller.ts
│   │   │   │   ├── ai.service.ts
│   │   │   │   ├── providers/
│   │   │   │   │   ├── openai.provider.ts
│   │   │   │   │   └── gemini.provider.ts
│   │   │   │   └── dto/
│   │   │   │
│   │   │   ├── notification/        # Notification Module
│   │   │   │   ├── notification.module.ts
│   │   │   │   ├── notification.controller.ts
│   │   │   │   ├── notification.service.ts
│   │   │   │   └── dto/
│   │   │   │
│   │   │   ├── subscription/        # Subscription/Billing Module
│   │   │   │   ├── subscription.module.ts
│   │   │   │   ├── subscription.controller.ts
│   │   │   │   ├── subscription.service.ts
│   │   │   │   ├── stripe/
│   │   │   │   └── dto/
│   │   │   │
│   │   │   ├── integration/         # Integrations Module
│   │   │   │   ├── integration.module.ts
│   │   │   │   ├── integration.controller.ts
│   │   │   │   ├── integration.service.ts
│   │   │   │   └── providers/
│   │   │   │
│   │   │   └── activity/            # Activity Feed Module
│   │   │       ├── activity.module.ts
│   │   │       ├── activity.controller.ts
│   │   │       └── activity.service.ts
│   │   │
│   │   ├── common/
│   │   │   ├── decorators/
│   │   │   │   ├── public.decorator.ts
│   │   │   │   ├── current-user.decorator.ts
│   │   │   │   └── api-response.decorator.ts
│   │   │   ├── filters/
│   │   │   │   ├── http-exception.filter.ts
│   │   │   │   └── validation-exception.filter.ts
│   │   │   ├── interceptors/
│   │   │   │   ├── response.interceptor.ts
│   │   │   │   ├── logging.interceptor.ts
│   │   │   │   └── timeout.interceptor.ts
│   │   │   ├── pipes/
│   │   │   │   ├── parse-uuid.pipe.ts
│   │   │   │   └── validation.pipe.ts
│   │   │   ├── guards/
│   │   │   │   ├── tenant.guard.ts
│   │   │   │   └── throttle.guard.ts
│   │   │   ├── middleware/
│   │   │   │   ├── logger.middleware.ts
│   │   │   │   └── tenant.middleware.ts
│   │   │   └── helpers/
│   │   │       ├── pagination.helper.ts
│   │   │       ├── sorting.helper.ts
│   │   │       └── search.helper.ts
│   │   │
│   │   ├── config/
│   │   │   ├── database.config.ts
│   │   │   ├── redis.config.ts
│   │   │   ├── jwt.config.ts
│   │   │   ├── s3.config.ts
│   │   │   ├── email.config.ts
│   │   │   ├── ai.config.ts
│   │   │   └── app.config.ts
│   │   │
│   │   └── types/
│   │       ├── express.d.ts
│   │       └── common.types.ts
│   │
│   ├── test/
│   │   ├── jest-e2e.json
│   │   └── setup.ts
│   │
│   ├── .env.example
│   ├── .eslintrc.js
│   ├── nest-cli.json
│   ├── package.json
│   ├── tsconfig.json
│   └── Dockerfile
│
├── frontend/                         # Next.js Frontend
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   ├── register/
│   │   │   │   └── page.tsx
│   │   │   ├── forgot-password/
│   │   │   │   └── page.tsx
│   │   │   └── layout.tsx
│   │   │
│   │   ├── (dashboard)/
│   │   │   ├── dashboard/
│   │   │   │   └── page.tsx
│   │   │   ├── brands/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── deals/
│   │   │   │   ├── page.tsx
│   │   │   │   ├── pipeline/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── content/
│   │   │   │   ├── page.tsx
│   │   │   │   ├── calendar/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── contracts/
│   │   │   │   └── page.tsx
│   │   │   ├── invoices/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── payments/
│   │   │   │   └── page.tsx
│   │   │   ├── expenses/
│   │   │   │   └── page.tsx
│   │   │   ├── tasks/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx
│   │   │   ├── files/
│   │   │   │   └── page.tsx
│   │   │   ├── contacts/
│   │   │   │   └── page.tsx
│   │   │   ├── analytics/
│   │   │   │   └── page.tsx
│   │   │   ├── ai-assistant/
│   │   │   │   └── page.tsx
│   │   │   ├── settings/
│   │   │   │   ├── page.tsx
│   │   │   │   ├── workspace/
│   │   │   │   ├── team/
│   │   │   │   ├── billing/
│   │   │   │   └── integrations/
│   │   │   └── layout.tsx
│   │   │
│   │   ├── api/                      # API Routes (if needed)
│   │   │   └── webhooks/
│   │   │       └── stripe/
│   │   │           └── route.ts
│   │   │
│   │   ├── layout.tsx                # Root layout
│   │   ├── page.tsx                  # Landing page
│   │   ├── globals.css
│   │   └── not-found.tsx
│   │
│   ├── components/
│   │   ├── ui/                       # shadcn/ui components
│   │   │   ├── button.tsx
│   │   │   ├── input.tsx
│   │   │   ├── dialog.tsx
│   │   │   ├── table.tsx
│   │   │   ├── card.tsx
│   │   │   ├── dropdown-menu.tsx
│   │   │   ├── avatar.tsx
│   │   │   ├── badge.tsx
│   │   │   ├── skeleton.tsx
│   │   │   ├── toast.tsx
│   │   │   └── ...
│   │   │
│   │   ├── layout/
│   │   │   ├── header.tsx
│   │   │   ├── sidebar.tsx
│   │   │   ├── footer.tsx
│   │   │   └── mobile-nav.tsx
│   │   │
│   │   ├── dashboard/
│   │   │   ├── stats-cards.tsx
│   │   │   ├── revenue-chart.tsx
│   │   │   ├── deal-funnel.tsx
│   │   │   ├── recent-activities.tsx
│   │   │   ├── upcoming-deadlines.tsx
│   │   │   └── tasks-widget.tsx
│   │   │
│   │   ├── brands/
│   │   │   ├── brand-list.tsx
│   │   │   ├── brand-card.tsx
│   │   │   ├── brand-form.tsx
│   │   │   └── brand-detail.tsx
│   │   │
│   │   ├── deals/
│   │   │   ├── deal-pipeline.tsx
│   │   │   ├── deal-board.tsx
│   │   │   ├── deal-card.tsx
│   │   │   ├── deal-form.tsx
│   │   │   ├── deal-detail.tsx
│   │   │   └── deal-stage-selector.tsx
│   │   │
│   │   ├── content/
│   │   │   ├── content-calendar.tsx
│   │   │   ├── content-list.tsx
│   │   │   ├── content-card.tsx
│   │   │   ├── content-form.tsx
│   │   │   └── platform-icon.tsx
│   │   │
│   │   ├── invoices/
│   │   │   ├── invoice-list.tsx
│   │   │   ├── invoice-card.tsx
│   │   │   ├── invoice-form.tsx
│   │   │   ├── invoice-detail.tsx
│   │   │   └── invoice-pdf.tsx
│   │   │
│   │   ├── tasks/
│   │   │   ├── task-board.tsx
│   │   │   ├── task-list.tsx
│   │   │   ├── task-card.tsx
│   │   │   └── task-form.tsx
│   │   │
│   │   ├── files/
│   │   │   ├── file-browser.tsx
│   │   │   ├── file-grid.tsx
│   │   │   ├── file-upload.tsx
│   │   │   └── file-preview.tsx
│   │   │
│   │   ├── ai/
│   │   │   ├── ai-chat.tsx
│   │   │   ├── ai-suggestions.tsx
│   │   │   └── ai-email-composer.tsx
│   │   │
│   │   ├── notifications/
│   │   │   ├── notification-bell.tsx
│   │   │   └── notification-list.tsx
│   │   │
│   │   └── shared/
│   │       ├── search-command.tsx
│   │       ├── date-picker.tsx
│   │       ├── rich-text-editor.tsx
│   │       ├── avatar-upload.tsx
│   │       ├── confirmation-dialog.tsx
│   │       └── empty-state.tsx
│   │
│   ├── lib/
│   │   ├── api.ts                    # API client
│   │   ├── utils.ts                  # Utility functions
│   │   ├── validations.ts            # Zod schemas
│   │   ├── constants.ts              # App constants
│   │   └── auth.ts                   # Auth utilities
│   │
│   ├── hooks/
│   │   ├── use-auth.ts
│   │   ├── use-deals.ts
│   │   ├── use-brands.ts
│   │   ├── use-content.ts
│   │   ├── use-invoices.ts
│   │   ├── use-tasks.ts
│   │   ├── use-files.ts
│   │   ├── use-notifications.ts
│   │   ├── use-analytics.ts
│   │   └── use-media-query.ts
│   │
│   ├── types/
│   │   ├── index.ts
│   │   ├── deal.ts
│   │   ├── brand.ts
│   │   ├── content.ts
│   │   ├── invoice.ts
│   │   └── user.ts
│   │
│   ├── public/
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   │
│   ├── .env.example
│   ├── next.config.js
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   ├── tsconfig.json
│   ├── package.json
│   └── Dockerfile
│
├── database/
│   ├── schema.sql                    # Raw SQL schema
│   ├── migrations/                   # Migration files
│   ├── seeds/                        # Seed data scripts
│   └── README.md
│
├── docker/
│   ├── docker-compose.yml            # Local development
│   ├── docker-compose.prod.yml       # Production
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   └── nginx/
│       └── nginx.conf
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── API.md
│   ├── DATABASE.md
│   ├── DEPLOYMENT.md
│   ├── SECURITY.md
│   └── IMAGES/
│       ├── er-diagram.png
│       ├── architecture.png
│       └── wireframes/
│
├── scripts/
│   ├── setup.sh
│   ├── deploy.sh
│   ├── backup.sh
│   └── migrate.sh
│
├── .gitignore
├── README.md
├── LICENSE
└── package.json                      # Root package for monorepo
```

## Key Directories Explained

### Backend (`/backend`)
- **prisma/**: Database schema, migrations, and seeding
- **src/modules/**: Feature modules following NestJS best practices
- **src/common/**: Shared utilities, guards, filters, interceptors
- **src/config/**: Configuration files for different services

### Frontend (`/frontend`)
- **app/**: Next.js App Router pages and layouts
- **components/**: Reusable React components
- **lib/**: Utility functions and API clients
- **hooks/**: Custom React hooks
- **types/**: TypeScript type definitions

### Database (`/database`)
- Raw SQL schema for reference
- Migration files
- Seed data scripts

### Docker (`/docker`)
- Docker Compose configurations
- Container definitions
- Nginx configuration

### Documentation (`/docs`)
- Architecture documentation
- API documentation
- Deployment guides
- Security guidelines
