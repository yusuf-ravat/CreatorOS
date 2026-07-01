# CreatorOS - API Documentation

## Base URL

```
Development: http://localhost:3001/api/v1
Production: https://api.creatoros.com/api/v1
```

## Authentication

All API endpoints (except public ones) require authentication using JWT tokens.

### Headers
```
Authorization: Bearer <access_token>
X-Organization-ID: <organization_id>
```

## Response Format

### Success Response
```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

## Common HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 204 | No Content - Successful deletion |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing or invalid token |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 409 | Conflict - Resource already exists |
| 422 | Unprocessable Entity - Validation error |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error |

---

## API Endpoints

### Authentication

#### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "firstName": "John",
  "lastName": "Doe",
  "organizationName": "My Creator Studio"
}
```

Response: `201 Created`
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe"
    },
    "organization": {
      "id": "uuid",
      "name": "My Creator Studio",
      "slug": "my-creator-studio"
    },
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token"
  }
}
```

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

Response: `200 OK`
```json
{
  "success": true,
  "data": {
    "user": { ... },
    "organization": { ... },
    "accessToken": "jwt_token",
    "refreshToken": "refresh_token"
  }
}
```

#### Google OAuth
```http
GET /auth/google
```

Redirects to Google OAuth consent screen.

```http
GET /auth/google/callback?code=<authorization_code>
```

#### Refresh Token
```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token"
}
```

#### Logout
```http
POST /auth/logout
Authorization: Bearer <token>
```

#### Forgot Password
```http
POST /auth/forgot-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

#### Reset Password
```http
POST /auth/reset-password
Content-Type: application/json

{
  "token": "reset_token",
  "password": "NewSecurePassword123!"
}
```

---

### Organizations

#### Get Current Organization
```http
GET /organizations/current
Authorization: Bearer <token>
X-Organization-ID: <org_id>
```

Response: `200 OK`
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "My Creator Studio",
    "slug": "my-creator-studio",
    "logoUrl": "https://...",
    "timezone": "America/New_York",
    "currency": "USD",
    "subscription": {
      "plan": "PRO",
      "status": "ACTIVE"
    }
  }
}
```

#### Update Organization
```http
PATCH /organizations/current
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Name",
  "logoUrl": "https://...",
  "timezone": "Europe/London",
  "currency": "GBP"
}
```

#### Get Organization Members
```http
GET /organizations/members
Authorization: Bearer <token>
Query Parameters:
  - page: number (default: 1)
  - limit: number (default: 20)
  - role: string (optional)
  - status: string (optional)
```

#### Invite Member
```http
POST /organizations/invite
Authorization: Bearer <token>
Content-Type: application/json

{
  "email": "newmember@example.com",
  "role": "MANAGER"
}
```

#### Update Member Role
```http
PATCH /organizations/members/:memberId
Authorization: Bearer <token>
Content-Type: application/json

{
  "role": "ADMIN"
}
```

#### Remove Member
```http
DELETE /organizations/members/:memberId
Authorization: Bearer <token>
```

---

### Brands

#### List Brands
```http
GET /brands
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - search: string
  - industry: string
  - relationshipStatus: string
  - sort: string (name, createdAt, etc.)
  - order: asc | desc
```

Response: `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Brand Name",
      "companyName": "Brand Inc.",
      "industry": "Fashion",
      "relationshipStatus": "ACTIVE",
      "contactPerson": "John Smith",
      "email": "contact@brand.com",
      "createdAt": "2024-01-15T10:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 50
  }
}
```

#### Get Brand
```http
GET /brands/:id
Authorization: Bearer <token>
```

#### Create Brand
```http
POST /brands
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Brand Name",
  "companyName": "Brand Inc.",
  "websiteUrl": "https://brand.com",
  "industry": "Fashion",
  "contactPerson": "John Smith",
  "email": "contact@brand.com",
  "phone": "+1234567890",
  "country": "United States",
  "socialLinks": {
    "instagram": "@brand",
    "twitter": "@brand"
  }
}
```

#### Update Brand
```http
PATCH /brands/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Brand Name",
  "relationshipStatus": "NEGOTIATING"
}
```

#### Delete Brand
```http
DELETE /brands/:id
Authorization: Bearer <token>
```

#### Add Brand Contact
```http
POST /brands/:id/contacts
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Jane Doe",
  "title": "Marketing Manager",
  "email": "jane@brand.com",
  "phone": "+1234567890",
  "isPrimary": true
}
```

---

### Deals

#### List Deals
```http
GET /deals
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - search: string
  - stage: string
  - status: string
  - priority: string
  - brandId: string
  - assignedTo: string
  - dueDateFrom: date
  - dueDateTo: date
  - sort: string
  - order: asc | desc
```

#### Get Deal
```http
GET /deals/:id
Authorization: Bearer <token>
```

#### Create Deal
```http
POST /deals
Authorization: Bearer <token>
Content-Type: application/json

{
  "campaignName": "Summer Campaign 2024",
  "brandId": "uuid",
  "description": "Summer product launch campaign",
  "stage": "LEAD",
  "priority": "HIGH",
  "budget": 50000,
  "currency": "USD",
  "platforms": ["INSTAGRAM", "YOUTUBE"],
  "contentTypes": ["REEL", "LONG_VIDEO"],
  "numPosts": 3,
  "numVideos": 2,
  "dueDate": "2024-06-30",
  "assignedTo": "uuid"
}
```

#### Update Deal
```http
PATCH /deals/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "stage": "NEGOTIATION",
  "priority": "URGENT",
  "budget": 75000
}
```

#### Delete Deal
```http
DELETE /deals/:id
Authorization: Bearer <token>
```

#### Move Deal Stage
```http
PATCH /deals/:id/stage
Authorization: Bearer <token>
Content-Type: application/json

{
  "stage": "CONTRACT_SENT"
}
```

#### Get Pipeline Stages
```http
GET /deals/pipeline/stages
Authorization: Bearer <token>
```

#### Get Pipeline Stats
```http
GET /deals/pipeline/stats
Authorization: Bearer <token>
```

#### Add Deal Activity
```http
POST /deals/:id/activities
Authorization: Bearer <token>
Content-Type: application/json

{
  "activityType": "NOTE",
  "description": "Had a great call with the brand manager"
}
```

---

### Content

#### List Content Items
```http
GET /content
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - platform: string
  - contentType: string
  - status: string
  - dealId: string
  - scheduledDateFrom: date
  - scheduledDateTo: date
```

#### Get Content Item
```http
GET /content/:id
Authorization: Bearer <token>
```

#### Create Content Item
```http
POST /content
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Instagram Reel - Product Launch",
  "dealId": "uuid",
  "platform": "INSTAGRAM",
  "contentType": "REEL",
  "description": "Showcase new product features",
  "scheduledDate": "2024-05-15T14:00:00Z",
  "priority": "HIGH",
  "hashtags": ["#productlaunch", "#sponsored"]
}
```

#### Update Content Item
```http
PATCH /content/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "IN_PROGRESS",
  "script": "Video script content...",
  "caption": "Check out this amazing product! #ad"
}
```

#### Delete Content Item
```http
DELETE /content/:id
Authorization: Bearer <token>
```

#### Get Content Calendar
```http
GET /content/calendar
Authorization: Bearer <token>
Query Parameters:
  - startDate: date
  - endDate: date
  - platform: string
```

---

### Invoices

#### List Invoices
```http
GET /invoices
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - status: string
  - dealId: string
  - dueDateFrom: date
  - dueDateTo: date
```

#### Get Invoice
```http
GET /invoices/:id
Authorization: Bearer <token>
```

#### Create Invoice
```http
POST /invoices
Authorization: Bearer <token>
Content-Type: application/json

{
  "dealId": "uuid",
  "invoiceNumber": "INV-2024-001",
  "billToName": "Brand Inc.",
  "billToEmail": "billing@brand.com",
  "issueDate": "2024-05-01",
  "dueDate": "2024-05-31",
  "items": [
    {
      "description": "Instagram Campaign",
      "quantity": 1,
      "unitPrice": 5000,
      "taxRate": 0
    }
  ],
  "notes": "Thank you for your business!"
}
```

#### Update Invoice
```http
PATCH /invoices/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "SENT"
}
```

#### Delete Invoice
```http
DELETE /invoices/:id
Authorization: Bearer <token>
```

#### Send Invoice
```http
POST /invoices/:id/send
Authorization: Bearer <token>
```

#### Download Invoice PDF
```http
GET /invoices/:id/pdf
Authorization: Bearer <token>
```

---

### Payments

#### List Payments
```http
GET /payments
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - status: string
  - dealId: string
  - invoiceId: string
```

#### Get Payment
```http
GET /payments/:id
Authorization: Bearer <token>
```

#### Record Payment
```http
POST /payments
Authorization: Bearer <token>
Content-Type: application/json

{
  "invoiceId": "uuid",
  "dealId": "uuid",
  "amount": 5000,
  "currency": "USD",
  "paymentMethod": "BANK_TRANSFER",
  "paymentDate": "2024-05-15",
  "referenceNumber": "REF123456"
}
```

#### Update Payment
```http
PATCH /payments/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "COMPLETED"
}
```

---

### Tasks

#### List Tasks
```http
GET /tasks
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - status: string
  - priority: string
  - assignedTo: string
  - dealId: string
  - dueDateFrom: date
  - dueDateTo: date
```

#### Get Task
```http
GET /tasks/:id
Authorization: Bearer <token>
```

#### Create Task
```http
POST /tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Review contract terms",
  "dealId": "uuid",
  "description": "Review and approve contract clauses",
  "priority": "HIGH",
  "dueDate": "2024-05-20T17:00:00Z",
  "assignedTo": "uuid"
}
```

#### Update Task
```http
PATCH /tasks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "COMPLETED",
  "completionPercentage": 100
}
```

#### Delete Task
```http
DELETE /tasks/:id
Authorization: Bearer <token>
```

#### Add Task Comment
```http
POST /tasks/:id/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Task completed ahead of schedule"
}
```

---

### Files

#### List Files
```http
GET /files
Authorization: Bearer <token>
Query Parameters:
  - folderId: string (optional, null for root)
  - fileType: string
  - search: string
```

#### Upload File
```http
POST /files/upload
Authorization: Bearer <token>
Content-Type: multipart/form-data

FormData:
  - file: <file>
  - folderId: string (optional)
  - fileType: string
```

#### Get File
```http
GET /files/:id
Authorization: Bearer <token>
```

#### Delete File
```http
DELETE /files/:id
Authorization: Bearer <token>
```

#### Create Folder
```http
POST /files/folder
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Contracts 2024",
  "folderId": "uuid" (optional, for subfolder)
}
```

#### Get File Download URL
```http
GET /files/:id/download
Authorization: Bearer <token>
```

---

### Analytics

#### Get Dashboard Stats
```http
GET /analytics/dashboard
Authorization: Bearer <token>
Query Parameters:
  - period: string (7d, 30d, 90d, 1y, custom)
  - startDate: date (if custom)
  - endDate: date (if custom)
```

Response: `200 OK`
```json
{
  "success": true,
  "data": {
    "totalRevenue": 150000,
    "pendingPayments": 25000,
    "expectedRevenue": 75000,
    "activeDeals": 12,
    "upcomingDeadlines": 5,
    "todayTasks": 3,
    "revenueByPlatform": [
      { "platform": "INSTAGRAM", "revenue": 80000 },
      { "platform": "YOUTUBE", "revenue": 70000 }
    ],
    "dealFunnel": {
      "LEAD": 20,
      "CONTACTED": 15,
      "NEGOTIATION": 10,
      "SIGNED": 5,
      "COMPLETED": 8
    }
  }
}
```

#### Get Revenue Report
```http
GET /analytics/revenue
Authorization: Bearer <token>
Query Parameters:
  - groupBy: string (day, week, month, year)
  - startDate: date
  - endDate: date
```

#### Get Deal Analytics
```http
GET /analytics/deals
Authorization: Bearer <token>
```

#### Export Report
```http
GET /analytics/export/:type
Authorization: Bearer <token>
Query Parameters:
  - format: string (csv, xlsx, pdf)
  - startDate: date
  - endDate: date
```

---

### AI Assistant

#### Generate Email
```http
POST /ai/email
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "SPONSORSHIP_REPLY",
  "context": {
    "dealId": "uuid",
    "brandName": "Brand Inc."
  },
  "tone": "professional",
  "additionalNotes": "Mention our previous successful collaboration"
}
```

Response: `200 OK`
```json
{
  "success": true,
  "data": {
    "subject": "Re: Sponsorship Opportunity",
    "body": "Dear Brand Team,\n\nThank you for reaching out..."
  }
}
```

#### Generate Proposal
```http
POST /ai/proposal
Authorization: Bearer <token>
Content-Type: application/json

{
  "dealId": "uuid",
  "template": "standard"
}
```

#### Summarize Contract
```http
POST /ai/contract/summarize
Authorization: Bearer <token>
Content-Type: application/json

{
  "contractId": "uuid"
}
```

#### Get Content Ideas
```http
POST /ai/content-ideas
Authorization: Bearer <token>
Content-Type: application/json

{
  "platform": "INSTAGRAM",
  "niche": "fitness",
  "count": 10
}
```

#### Get Pricing Suggestions
```http
POST /ai/pricing
Authorization: Bearer <token>
Content-Type: application/json

{
  "platforms": ["INSTAGRAM", "YOUTUBE"],
  "deliverables": {
    "posts": 3,
    "videos": 2
  },
  "niche": "fashion",
  "audienceSize": 500000
}
```

---

### Notifications

#### List Notifications
```http
GET /notifications
Authorization: Bearer <token>
Query Parameters:
  - page: number
  - limit: number
  - unreadOnly: boolean
  - type: string
```

#### Mark as Read
```http
PATCH /notifications/:id/read
Authorization: Bearer <token>
```

#### Mark All as Read
```http
PATCH /notifications/read-all
Authorization: Bearer <token>
```

#### Delete Notification
```http
DELETE /notifications/:id
Authorization: Bearer <token>
```

#### Get Notification Preferences
```http
GET /notifications/preferences
Authorization: Bearer <token>
```

#### Update Notification Preferences
```http
PATCH /notifications/preferences
Authorization: Bearer <token>
Content-Type: application/json

{
  "dealUpdates": {
    "inApp": true,
    "email": true,
    "push": false
  },
  "invoiceReminders": {
    "inApp": true,
    "email": true,
    "push": true
  }
}
```

---

### Subscriptions

#### Get Subscription
```http
GET /subscription
Authorization: Bearer <token>
```

#### Get Available Plans
```http
GET /subscription/plans
Authorization: Bearer <token>
```

#### Upgrade Subscription
```http
POST /subscription/upgrade
Authorization: Bearer <token>
Content-Type: application/json

{
  "plan": "PRO",
  "interval": "MONTH"
}
```

#### Cancel Subscription
```http
POST /subscription/cancel
Authorization: Bearer <token>
Content-Type: application/json

{
  "cancelAtPeriodEnd": true
}
```

#### Get Usage
```http
GET /subscription/usage
Authorization: Bearer <token>
```

---

### Integrations

#### List Integrations
```http
GET /integrations
Authorization: Bearer <token>
```

#### Connect Integration
```http
POST /integrations/:service/connect
Authorization: Bearer <token>
```

Examples:
- `POST /integrations/google-calendar/connect`
- `POST /integrations/slack/connect`
- `POST /integrations/stripe/connect`

#### Disconnect Integration
```http
DELETE /integrations/:id
Authorization: Bearer <token>
```

#### Update Integration Settings
```http
PATCH /integrations/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "settings": {
    "syncEnabled": true,
    "syncFrequency": "HOURLY"
  }
}
```

---

## Rate Limiting

| Endpoint Type | Limit | Window |
|--------------|-------|--------|
| Authentication | 10 requests | 1 minute |
| API (General) | 100 requests | 1 minute |
| AI Endpoints | 20 requests | 1 minute |
| File Upload | 10 requests | 1 minute |

Rate limit headers included in responses:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000
```

## Webhooks

CreatorOS sends webhook events to configured endpoints.

### Available Events

- `deal.created`
- `deal.updated`
- `deal.stage_changed`
- `invoice.sent`
- `invoice.paid`
- `payment.received`
- `task.completed`
- `contract.signed`

### Webhook Payload
```json
{
  "id": "evt_uuid",
  "type": "deal.created",
  "createdAt": "2024-01-15T10:00:00Z",
  "organizationId": "org_uuid",
  "data": {
    "id": "deal_uuid",
    "campaignName": "Summer Campaign",
    ...
  }
}
```

### Webhook Signature
Webhooks include a signature header for verification:
```
X-CreatorOS-Signature: sha256=<signature>
```

---

## Error Codes

| Code | Description |
|------|-------------|
| AUTH_001 | Invalid credentials |
| AUTH_002 | Token expired |
| AUTH_003 | Invalid token |
| AUTH_004 | Email not verified |
| ORG_001 | Organization not found |
| ORG_002 | Member not found |
| ORG_003 | Invalid role |
| DEAL_001 | Deal not found |
| DEAL_002 | Invalid stage transition |
| INV_001 | Invoice not found |
| INV_002 | Invoice already sent |
| FILE_001 | File not found |
| FILE_002 | File too large |
| FILE_003 | Invalid file type |
| SUB_001 | Subscription not found |
| SUB_002 | Payment failed |
| AI_001 | AI service unavailable |
| AI_002 | Invalid prompt |
| RATE_001 | Rate limit exceeded |
