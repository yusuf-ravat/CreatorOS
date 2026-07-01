# CreatorOS - Quick Start Guide

## Get Started in 5 Minutes

### Prerequisites

- Docker & Docker Compose installed
- Git installed

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd creatoros
```

### Step 2: Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and change at minimum:
```env
DB_PASSWORD=your-secure-password
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
```

### Step 3: Start with Docker

```bash
make docker-up
```

Or manually:
```bash
docker-compose up -d
```

### Step 4: Run Migrations

```bash
make migrate
make seed
```

Or manually:
```bash
docker-compose exec backend npx prisma migrate deploy
docker-compose exec backend npm run seed
```

### Step 5: Access Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **API Docs**: http://localhost:3001/api/docs

### Default Credentials (after seeding)

```
Email: admin@creatoros.com
Password: Admin123!
```

---

## Common Commands

Using Makefile (recommended):

```bash
make help           # Show all commands
make dev            # Start development servers
make test           # Run all tests
make build          # Build applications
make docker-up      # Start Docker containers
make docker-down    # Stop Docker containers
make migrate        # Run database migrations
make clean          # Clean build artifacts
```

Without Makefile:

```bash
# Install dependencies
cd backend && npm ci
cd ../frontend && npm ci

# Start backend
cd backend && npm run start:dev

# Start frontend (new terminal)
cd frontend && npm run dev
```

---

## Development Workflow

### 1. Backend Development

```bash
cd backend

# Generate Prisma client after schema changes
npx prisma generate

# Create migration after schema changes
npx prisma migrate dev --name description

# Run tests
npm run test

# Start dev server
npm run start:dev
```

### 2. Frontend Development

```bash
cd frontend

# Install shadcn/ui components
npx shadcn-ui add button
npx shadcn-ui add dialog
# etc.

# Run dev server
npm run dev

# Build for production
npm run build
```

### 3. Database Operations

```bash
# View database
docker-compose exec postgres psql -U creatoros -d creatoros_db

# Backup database
make backup-db

# Reset database (WARNING: deletes all data)
make db-reset
```

---

## Project Structure

```
creatoros/
├── backend/              # NestJS API
│   ├── src/
│   │   ├── modules/     # Feature modules
│   │   ├── common/      # Shared utilities
│   │   └── main.ts
│   ├── prisma/
│   │   └── schema.prisma
│   └── package.json
├── frontend/            # Next.js App
│   ├── src/
│   │   ├── app/        # App router pages
│   │   ├── components/ # React components
│   │   └── lib/        # Utilities
│   └── package.json
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## Troubleshooting

### Port Already in Use

Change ports in `.env`:
```env
DB_PORT=5433
API_PORT=3002
WEB_PORT=3001
```

### Database Connection Error

```bash
# Check if database is running
docker-compose ps

# View database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Permission Issues

```bash
# Fix Docker permissions
sudo chown -R $USER:$USER /var/run/docker.sock

# Fix file permissions
sudo chown -R $USER:$USER ./backend/uploads
```

### Clear Everything and Start Fresh

```bash
make clean
docker-compose down -v
make docker-up
make migrate
make seed
```

---

## Next Steps

1. **Customize Branding**: Update logo, colors in frontend settings
2. **Configure OAuth**: Setup Google login in `.env`
3. **Setup Email**: Add Resend API key for notifications
4. **Configure Storage**: Setup AWS S3 for file uploads
5. **Add Payment**: Configure Stripe for subscriptions
6. **Enable AI**: Add OpenAI/Gemini API keys

---

## Support

- Documentation: `/docs` folder
- API Reference: http://localhost:3001/api/docs
- GitHub Issues: <repository-url>/issues

Welcome to CreatorOS! 🚀
