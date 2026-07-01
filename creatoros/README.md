# CreatorOS

**AI-Powered CRM for Creators & Influencers**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org/)
[![NestJS](https://img.shields.io/badge/NestJS-10-red)](https://nestjs.com/)

## Overview

CreatorOS is a modern, enterprise-grade SaaS CRM designed specifically for content creators, influencers, YouTubers, Instagram creators, TikTok creators, podcasters, streamers, agencies, and creator teams.

Replace spreadsheets, Notion, and scattered documents with one unified platform where creators can manage:

- 🎯 Brand deals & sponsorships
- 📅 Content calendars
- 📄 Contracts & invoices
- 💰 Payments & expenses
- 👥 Contacts & relationships
- 📊 Analytics & reporting
- 🤖 AI-powered assistance

## Features

### Core Features

- **Brand CRM**: Manage all your brand relationships in one place
- **Sponsorship Pipeline**: Visual Kanban board to track deal stages
- **Content Calendar**: Plan, schedule, and track content across platforms
- **Contract Management**: Store, version, and track contract lifecycle
- **Invoice Management**: Generate professional invoices with tax support
- **Payment Tracking**: Monitor expected and received payments
- **Expense Tracking**: Categorize and track business expenses
- **Task Management**: Assign tasks, set deadlines, track progress
- **File Manager**: Organize contracts, assets, and media files
- **Analytics Dashboard**: Revenue reports, deal metrics, performance insights

### AI Features

- ✉️ AI Email Writer
- 📝 AI Proposal Generator
- 📄 AI Contract Summary
- 💬 AI Sponsorship Reply
- 🎨 AI Caption Generator
- 💡 AI Content Ideas
- 💰 AI Pricing Suggestions
- 📈 AI Revenue Forecast

### Collaboration

- 👥 Multi-user workspaces
- 🔐 Role-based access control (Owner, Admin, Manager, Assistant, Accountant, Viewer)
- 💬 Comments & mentions
- 📢 Activity feed
- 🔔 Real-time notifications

### Integrations

- Google Calendar
- Google Drive
- Gmail
- Slack
- Discord
- Stripe
- Zoom
- Dropbox
- Notion
- Zapier
- Make

## Tech Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript 5
- **Styling**: Tailwind CSS 3
- **UI Components**: shadcn/ui
- **State**: React Query (TanStack Query)
- **Forms**: React Hook Form + Zod
- **Real-time**: Socket.io

### Backend
- **Framework**: NestJS 10
- **Language**: TypeScript 5
- **API**: REST with Swagger/OpenAPI
- **Auth**: JWT + Refresh Tokens + OAuth
- **Validation**: class-validator
- **Queue**: BullMQ
- **Cache**: Redis

### Database
- **Primary**: PostgreSQL 15
- **Vector Search**: pgvector
- **ORM**: Prisma 5

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **Cloud**: AWS (EC2, RDS, S3, CloudFront)
- **CI/CD**: GitHub Actions
- **Monitoring**: Sentry, Prometheus

### Third-party Services
- **Payments**: Stripe
- **Email**: Resend
- **AI**: OpenAI GPT-4, Google Gemini
- **Storage**: AWS S3

## Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- Docker (optional)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourorg/creatoros.git
cd creatoros
```

2. **Set up environment variables**

Backend `.env`:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/creatoros"
REDIS_URL="redis://localhost:6379"
JWT_SECRET="your-secret-key"
STRIPE_SECRET_KEY="sk_test_..."
RESEND_API_KEY="re_..."
AWS_ACCESS_KEY_ID="..."
AWS_SECRET_ACCESS_KEY="..."
AWS_BUCKET_NAME="creatoros-files"
OPENAI_API_KEY="sk-..."
GOOGLE_CLIENT_ID="..."
GOOGLE_CLIENT_SECRET="..."
```

Frontend `.env.local`:
```env
NEXT_PUBLIC_API_URL="http://localhost:3001/api/v1"
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_..."
```

3. **Install dependencies**
```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
```

4. **Set up database**
```bash
cd backend
npx prisma migrate dev
npx prisma db seed
```

5. **Start development servers**
```bash
# Terminal 1 - Backend
cd backend
npm run start:dev

# Terminal 2 - Frontend
cd frontend
npm run dev
```

6. **Open the application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001
- API Docs: http://localhost:3001/api/docs

## Docker Setup

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## Project Structure

```
creatoros/
├── backend/           # NestJS API server
│   ├── prisma/       # Database schema & migrations
│   └── src/          # Source code
│       ├── modules/  # Feature modules
│       ├── common/   # Shared utilities
│       └── config/   # Configuration
├── frontend/         # Next.js application
│   ├── app/         # App Router pages
│   ├── components/  # React components
│   ├── hooks/       # Custom hooks
│   └── lib/         # Utilities
├── database/         # SQL scripts & seeds
├── docker/           # Docker configurations
└── docs/            # Documentation
```

## Documentation

- [Architecture](./docs/ARCHITECTURE.md)
- [API Reference](./docs/API.md)
- [Database Schema](./docs/ER_DIAGRAM.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)
- [Security](./docs/SECURITY.md)

## API Documentation

Once the backend is running, visit:
- Swagger UI: http://localhost:3001/api/docs
- OpenAPI Spec: http://localhost:3001/api/docs-json

## Development

### Running Tests

```bash
# Backend tests
cd backend
npm run test
npm run test:e2e

# Frontend tests
cd frontend
npm run test
```

### Code Style

```bash
# Format code
npm run format

# Lint code
npm run lint
```

## Deployment

See our comprehensive [Deployment Guide](./docs/DEPLOYMENT.md) for production deployment instructions.

### Quick Deploy

```bash
# Build for production
docker-compose -f docker/docker-compose.prod.yml up -d --build
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Security

CreatorOS takes security seriously. We implement:
- JWT authentication with refresh tokens
- Role-based access control
- Input validation & sanitization
- Rate limiting
- CORS protection
- SQL injection prevention
- XSS protection
- Audit logging

Report security vulnerabilities to security@creatoros.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- Documentation: https://docs.creatoros.com
- Community: https://discord.gg/creatoros
- Email: support@creatoros.com

## Roadmap

- [ ] Mobile applications (iOS & Android)
- [ ] Browser extension
- [ ] Advanced AI features
- [ ] Marketplace for templates
- [ ] White-label options
- [ ] Enterprise SSO
- [ ] Advanced analytics
- [ ] More integrations

## Acknowledgments

Built with ❤️ for creators worldwide.

---

© 2024 CreatorOS. All rights reserved.
