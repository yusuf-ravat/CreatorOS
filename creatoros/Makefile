# Makefile for CreatorOS

.PHONY: help install dev build test lint typecheck docker-up docker-down migrate seed clean deploy-prod

# Default target
help:
	@echo "CreatorOS - Available Commands"
	@echo "================================"
	@echo ""
	@echo "Development:"
	@echo "  make install       - Install all dependencies"
	@echo "  make dev           - Start development servers"
	@echo "  make dev-backend   - Start backend only"
	@echo "  make dev-frontend  - Start frontend only"
	@echo ""
	@echo "Testing:"
	@echo "  make test          - Run all tests"
	@echo "  make test-backend  - Run backend tests"
	@echo "  make test-frontend - Run frontend tests"
	@echo "  make lint          - Run linters"
	@echo "  make typecheck     - Run type checks"
	@echo ""
	@echo "Build:"
	@echo "  make build         - Build both applications"
	@echo "  make build-backend - Build backend"
	@echo "  make build-frontend- Build frontend"
	@echo ""
	@echo "Database:"
	@echo "  make migrate       - Run database migrations"
	@echo "  make seed          - Seed database"
	@echo "  make db-reset      - Reset database (WARNING: deletes all data)"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up     - Start all Docker containers"
	@echo "  make docker-down   - Stop all Docker containers"
	@echo "  make docker-build  - Build Docker images"
	@echo "  make docker-logs   - View Docker logs"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy-prod   - Deploy to production"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         - Clean build artifacts"

# Installation
install:
	@echo "Installing backend dependencies..."
	cd backend && npm ci
	@echo "Installing frontend dependencies..."
	cd frontend && npm ci
	@echo "Generating Prisma client..."
	cd backend && npx prisma generate
	@echo "Installation complete!"

# Development
dev:
	@echo "Starting development servers..."
	@make dev-backend &
	@sleep 2
	@make dev-frontend

dev-backend:
	cd backend && npm run start:dev

dev-frontend:
	cd frontend && npm run dev

# Testing
test: test-backend test-frontend

test-backend:
	cd backend && npm run test

test-frontend:
	cd frontend && npm run test

# Linting
lint:
	cd backend && npm run lint
	cd frontend && npm run lint

# Type Checking
typecheck:
	cd backend && npm run typecheck
	cd frontend && npm run typecheck

# Building
build: build-backend build-frontend

build-backend:
	cd backend && npm run build

build-frontend:
	cd frontend && npm run build

# Database
migrate:
	cd backend && npx prisma migrate deploy

seed:
	cd backend && npm run seed

db-reset:
	@echo "WARNING: This will delete all database data!"
	@read -p "Are you sure? (y/N) " confirm; \
	if [ "$$confirm" = "y" ]; then \
		cd backend && npx prisma migrate reset --force; \
	else \
		echo "Operation cancelled."; \
	fi

# Docker
docker-up:
	docker-compose up -d
	@echo "Services starting..."
	@sleep 5
	@echo "Checking health..."
	docker-compose ps

docker-down:
	docker-compose down

docker-build:
	docker-compose build --no-cache

docker-logs:
	docker-compose logs -f

docker-restart:
	docker-compose restart

# Production Deployment
deploy-prod:
	@echo "Deploying to production..."
	git pull origin main
	docker-compose -f docker-compose.prod.yml pull
	docker-compose -f docker-compose.prod.yml up -d
	docker-compose -f docker-compose.prod.yml exec backend npx prisma migrate deploy
	@echo "Deployment complete!"

# Cleanup
clean:
	@echo "Cleaning build artifacts..."
	rm -rf backend/dist
	rm -rf backend/node_modules
	rm -rf frontend/.next
	rm -rf frontend/node_modules
	rm -rf frontend/out
	find . -name "*.tsbuildinfo" -delete
	find . -name "node_modules" -type d -prune -exec rm -rf {} \;
	@echo "Cleanup complete!"

# Utility commands
logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

logs-db:
	docker-compose logs -f postgres

shell-backend:
	docker-compose exec backend sh

shell-db:
	docker-compose exec postgres psql -U creatoros -d creatoros_db

backup-db:
	@echo "Creating database backup..."
	docker-compose exec postgres pg_dump -U creatoros creatoros_db > backups/backup-$$(date +\%Y\%m\%d-\%H\%M\%S).sql
	@echo "Backup created in backups/ directory"

restore-db:
	@echo "Restoring database from backup..."
	@read -p "Enter backup filename: " file; \
	docker-compose exec -T postgres psql -U creatoros creatoros_db < backups/$$file
	@echo "Database restored!"
