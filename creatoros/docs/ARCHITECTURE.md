# CreatorOS - Architecture Documentation

## System Overview

CreatorOS is a multi-tenant SaaS CRM platform built with modern microservices architecture principles. The system follows a modular monolith approach for initial deployment with clear boundaries for future microservices extraction.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Web    │  │  Mobile  │  │  Tablet  │  │   API    │   │
│  │   App    │  │   App    │  │   App    │  │ Clients  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Load Balancer (AWS ALB)                 │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                       CDN (CloudFront)                       │
│                    Static Assets & Media                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (Next.js)                        │
│              SSR, ISR, API Routes, Static                    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Backend (NestJS)                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Auth   │  │   CRM    │  │ Payments │  │    AI    │   │
│  │  Module  │  │  Module  │  │  Module  │  │  Module  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Content  │  │  Finance │  │ Analytics│  │  Notify  │   │
│  │  Module  │  │  Module  │  │  Module  │  │  Module  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  PostgreSQL   │  │    Redis      │  │     AWS       │
│  + pgvector   │  │   (Cache)     │  │     S3        │
│  (Primary DB) │  │  (Session)    │  │   (Storage)   │
└───────────────┘  └───────────────┘  └───────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│    Prisma     │  │   BullMQ      │  │    Resend     │
│     ORM       │  │   (Queue)     │  │    (Email)    │
└───────────────┘  └───────────────┘  └───────────────┘
```

## Technology Stack

### Frontend
- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript 5+
- **Styling**: Tailwind CSS 3+
- **UI Components**: shadcn/ui
- **State Management**: React Query (TanStack Query)
- **Forms**: React Hook Form + Zod
- **Real-time**: Socket.io Client

### Backend
- **Framework**: NestJS 10+
- **Language**: TypeScript 5+
- **API**: REST with Swagger/OpenAPI
- **Authentication**: JWT + Refresh Tokens
- **Validation**: class-validator, class-transformer
- **Real-time**: Socket.io
- **Queue**: BullMQ

### Database
- **Primary**: PostgreSQL 15+
- **Vector Search**: pgvector extension
- **ORM**: Prisma 5+
- **Migrations**: Prisma Migrate

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **Orchestration**: Kubernetes (production)
- **Cloud**: AWS (EC2, RDS, S3, CloudFront)
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry, Prometheus, Grafana

### Third-party Services
- **Payments**: Stripe
- **Email**: Resend
- **AI**: OpenAI GPT-4, Google Gemini
- **Storage**: AWS S3
- **CDN**: CloudFront

## Multi-Tenancy Strategy

### Database-Level Isolation
Each organization gets:
- Shared database schema
- Organization ID on all records
- Row-level security policies
- Separate encryption keys (optional)

### Tenant Identification
- Subdomain-based: `org.creatoros.com`
- Path-based: `creatoros.com/org/dashboard`
- Header-based: `X-Organization-ID`

## Security Architecture

### Authentication Flow
```
User → Login → JWT Access Token (15min) + Refresh Token (7d)
           ↓
    Store in HTTP-only cookies
           ↓
    Validate on each request
           ↓
    Refresh when expired
```

### Authorization (RBAC)
- Role-based access control
- Permission-based resource access
- Organization-level isolation
- Resource-level permissions

### Security Measures
- JWT with RS256 signing
- Password hashing (bcrypt)
- Rate limiting (express-rate-limit)
- CORS configuration
- Helmet.js headers
- Input validation & sanitization
- SQL injection prevention (Prisma)
- XSS protection
- CSRF tokens
- Audit logging

## Scalability Strategy

### Horizontal Scaling
- Stateless backend services
- Session storage in Redis
- Load balancer distribution
- Database read replicas

### Caching Strategy
- Redis for session management
- Query result caching
- API response caching
- CDN for static assets

### Database Optimization
- Indexing on frequently queried columns
- Connection pooling (PgBouncer)
- Read/write splitting
- Partitioning for large tables
- Materialized views for analytics

## Module Breakdown

### 1. Authentication Module
- User registration/login
- OAuth (Google, LinkedIn)
- 2FA support
- Password reset
- Email verification
- Session management

### 2. Organization Module
- Workspace management
- Team invitations
- Role assignment
- Billing & subscription
- Settings management

### 3. Brand CRM Module
- Brand contact management
- Relationship tracking
- Communication history
- Notes & attachments
- Deal history

### 4. Deal Pipeline Module
- Kanban board
- Stage management
- Drag-and-drop
- Deal tracking
- Probability scoring

### 5. Content Calendar Module
- Multi-platform scheduling
- Content types management
- Deadline tracking
- Collaboration tools
- Publishing workflow

### 6. Contract Management Module
- Document upload
- Version control
- E-signature integration
- Expiry tracking
- Template management

### 7. Invoice & Payment Module
- Invoice generation
- Payment tracking
- Stripe integration
- Tax calculations
- Financial reports

### 8. Analytics Module
- Revenue dashboards
- Performance metrics
- Custom reports
- Data export
- AI insights

### 9. AI Module
- Email drafting
- Proposal generation
- Contract analysis
- Content suggestions
- Pricing recommendations
- Forecasting

### 10. Notification Module
- In-app notifications
- Email notifications
- Push notifications
- Notification preferences
- Scheduled reminders

## API Design Principles

### RESTful Standards
- Resource-oriented URLs
- HTTP verbs for actions
- Consistent error responses
- Pagination for lists
- Filtering & sorting
- Versioning strategy

### Response Format
```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100
  },
  "errors": []
}
```

### Error Handling
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": []
  }
}
```

## Deployment Architecture

### Development
- Docker Compose for local development
- Hot reload enabled
- Mock services for third-party APIs

### Staging
- Mirror of production
- Automated deployments from develop branch
- Integration testing

### Production
- Multi-AZ deployment
- Auto-scaling groups
- Database clustering
- Backup strategies
- Disaster recovery plan

## Monitoring & Observability

### Logging
- Structured JSON logging
- Centralized log aggregation
- Log levels (ERROR, WARN, INFO, DEBUG)

### Metrics
- Application performance monitoring
- Database query performance
- API response times
- Error rates
- Business metrics

### Alerting
- Critical error notifications
- Performance degradation alerts
- Security incident alerts
- Business metric thresholds

## Future Considerations

### Microservices Migration Path
1. Extract Authentication service
2. Separate Payment processing
3. Independent AI service
4. Dedicated Analytics service
5. Notification service

### Feature Roadmap
- Mobile applications (React Native)
- Browser extensions
- Advanced AI capabilities
- Marketplace integrations
- White-label options
- Enterprise features
