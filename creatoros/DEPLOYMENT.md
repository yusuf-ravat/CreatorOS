# CreatorOS Deployment Guide

## Prerequisites

- Docker & Docker Compose installed
- Git installed
- Node.js 20+ (for local development)
- AWS account (for S3 storage)
- Domain name (for production)
- SSL certificate (Let's Encrypt recommended)

---

## Quick Start with Docker

### 1. Clone the Repository

```bash
git clone <repository-url>
cd creatoros
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` and update the following required variables:

```env
# Required - Change these!
DB_PASSWORD=your-secure-password
JWT_SECRET=your-super-secret-jwt-key-min-32-chars

# Optional - For full functionality
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
RESEND_API_KEY=your-resend-api-key
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
STRIPE_SECRET_KEY=your-stripe-key
OPENAI_API_KEY=your-openai-key
```

### 3. Start All Services

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database (port 5432)
- Redis cache (port 6379)
- Backend API (port 3001)
- Frontend Web App (port 3000)

### 4. Run Database Migrations

```bash
docker-compose exec backend npx prisma migrate deploy
docker-compose exec backend npx prisma db seed
```

### 5. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **API Documentation**: http://localhost:3001/api/docs

### 6. Stop Services

```bash
docker-compose down
```

To also remove volumes (database data):

```bash
docker-compose down -v
```

---

## Production Deployment

### Option 1: Docker Compose on VPS

#### 1. Prepare Server

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### 2. Clone and Configure

```bash
git clone <repository-url> /opt/creatoros
cd /opt/creatoros
cp .env.example .env
# Edit .env with production values
```

#### 3. Setup SSL with Nginx

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend

  frontend:
    # ... existing config
    
  backend:
    # ... existing config
    
  postgres:
    # ... existing config
    
  redis:
    # ... existing config
```

#### 4. Deploy

```bash
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml exec backend npx prisma migrate deploy
```

### Option 2: AWS ECS/Fargate

1. Build and push images to ECR
2. Create ECS cluster
3. Define task definitions
4. Create services
5. Setup RDS PostgreSQL
6. Setup ElastiCache Redis
7. Configure Application Load Balancer
8. Setup CloudFront for CDN

### Option 3: Kubernetes

See `k8s/` directory for Kubernetes manifests.

---

## Backup and Restore

### Backup Database

```bash
docker-compose exec postgres pg_dump -U creatoros creatoros_db > backup.sql
```

### Restore Database

```bash
docker-compose exec -T postgres psql -U creatoros creatoros_db < backup.sql
```

### Automated Backups

Add to crontab:

```bash
0 2 * * * cd /opt/creatoros && docker-compose exec -T postgres pg_dump -U creatoros creatoros_db > backups/backup-$(date +\%Y\%m\%d).sql
```

---

## Monitoring

### Health Checks

- Backend: http://localhost:3001/health
- Frontend: http://localhost:3000
- Database: `docker-compose exec postgres pg_isready`
- Redis: `docker-compose exec redis redis-cli ping`

### Logs

```bash
# View all logs
docker-compose logs -f

# View specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

### Metrics

- Enable Prometheus metrics in backend
- Use Grafana for dashboards
- Setup Sentry for error tracking

---

## Scaling

### Horizontal Scaling

```bash
# Scale backend instances
docker-compose up -d --scale backend=3

# Scale with load balancer
docker-compose -f docker-compose.prod.yml up -d
```

### Database Optimization

- Add read replicas
- Enable connection pooling (PgBouncer)
- Optimize queries with indexes
- Use pgvector for AI features

---

## Security Checklist

- [ ] Change all default passwords
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Enable database encryption
- [ ] Setup regular backups
- [ ] Enable audit logging
- [ ] Configure rate limiting
- [ ] Update dependencies regularly
- [ ] Enable 2FA for admin accounts
- [ ] Review RBAC permissions

---

## Troubleshooting

### Container won't start

```bash
docker-compose logs <service-name>
docker-compose ps
```

### Database connection issues

```bash
docker-compose exec postgres pg_isready
docker-compose exec backend env | grep DATABASE
```

### Clear and rebuild

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---

## Support

For issues and questions:
- GitHub Issues: <repository-url>/issues
- Documentation: /docs
- Email: support@creatoros.com
