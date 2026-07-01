-- CreatorOS Database Schema
-- PostgreSQL 15+ with pgvector extension

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgvector";

-- ============================================================================
-- ENUMS
-- ============================================================================

CREATE TYPE user_role AS ENUM (
    'OWNER', 'ADMIN', 'MANAGER', 'ASSISTANT', 'ACCOUNTANT', 'VIEWER'
);

CREATE TYPE deal_stage AS ENUM (
    'LEAD', 'CONTACTED', 'NEGOTIATION', 'PROPOSAL_SENT', 'CONTRACT_SENT',
    'SIGNED', 'CONTENT_IN_PROGRESS', 'SUBMITTED', 'APPROVED', 'INVOICE_SENT',
    'PAYMENT_PENDING', 'COMPLETED', 'CANCELLED'
);

CREATE TYPE deal_status AS ENUM (
    'ACTIVE', 'PAUSED', 'COMPLETED', 'CANCELLED', 'ON_HOLD'
);

CREATE TYPE priority_level AS ENUM (
    'LOW', 'MEDIUM', 'HIGH', 'URGENT'
);

CREATE TYPE invoice_status AS ENUM (
    'DRAFT', 'SENT', 'VIEWED', 'PARTIAL', 'PAID', 'OVERDUE', 'CANCELLED'
);

CREATE TYPE payment_status AS ENUM (
    'PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED'
);

CREATE TYPE task_status AS ENUM (
    'TODO', 'IN_PROGRESS', 'REVIEW', 'COMPLETED', 'CANCELLED'
);

CREATE TYPE notification_type AS ENUM (
    'DEAL_UPDATE', 'INVOICE_REMINDER', 'PAYMENT_REMINDER', 'DEADLINE_REMINDER',
    'TASK_REMINDER', 'COMMENT', 'MENTION', 'SYSTEM', 'AI_SUGGESTION'
);

CREATE TYPE subscription_plan AS ENUM (
    'FREE', 'STARTER', 'PRO', 'TEAM', 'ENTERPRISE'
);

CREATE TYPE subscription_status AS ENUM (
    'TRIALING', 'ACTIVE', 'CANCELLED', 'PAST_DUE', 'PAUSED'
);

CREATE TYPE platform_type AS ENUM (
    'YOUTUBE', 'INSTAGRAM', 'TIKTOK', 'TWITCH', 'PODCAST', 'BLOG', 'LINKEDIN', 'TWITTER', 'OTHER'
);

CREATE TYPE content_type AS ENUM (
    'REEL', 'SHORTS', 'LONG_VIDEO', 'STORY', 'PODCAST', 'BLOG', 'LIVE_STREAM', 'POST', 'TWEET'
);

CREATE TYPE relationship_status AS ENUM (
    'NEW', 'CONTACTED', 'NEGOTIATING', 'ACTIVE', 'INACTIVE', 'BLACKLISTED'
);

CREATE TYPE file_type AS ENUM (
    'CONTRACT', 'INVOICE', 'IMAGE', 'VIDEO', 'DOCUMENT', 'BRAND_ASSET', 'MEDIA_KIT', 'OTHER'
);

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Organizations (Tenants)
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo_url TEXT,
    website_url TEXT,
    description TEXT,
    timezone VARCHAR(50) DEFAULT 'UTC',
    currency VARCHAR(3) DEFAULT 'USD',
    language VARCHAR(10) DEFAULT 'en',
    tax_id VARCHAR(100),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(255),
    settings JSONB DEFAULT '{}',
    branding JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_organizations_slug ON organizations(slug);
CREATE INDEX idx_organizations_name ON organizations(name);

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    full_name VARCHAR(200) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    avatar_url TEXT,
    phone VARCHAR(20),
    timezone VARCHAR(50) DEFAULT 'UTC',
    language VARCHAR(10) DEFAULT 'en',
    is_email_verified BOOLEAN DEFAULT FALSE,
    is_two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255),
    last_login_at TIMESTAMP WITH TIME ZONE,
    last_login_ip INET,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_deleted ON users(deleted_at);

-- Organization Members (Many-to-Many with roles)
CREATE TABLE organization_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role user_role NOT NULL DEFAULT 'VIEWER',
    permissions JSONB DEFAULT '[]',
    invited_by UUID REFERENCES users(id),
    invited_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    joined_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, ACTIVE, SUSPENDED, REMOVED
    UNIQUE(organization_id, user_id)
);

CREATE INDEX idx_org_members_org ON organization_members(organization_id);
CREATE INDEX idx_org_members_user ON organization_members(user_id);
CREATE INDEX idx_org_members_status ON organization_members(status);

-- OAuth Accounts
CREATE TABLE oauth_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL, -- google, linkedin, etc.
    provider_account_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP WITH TIME ZONE,
    scopes TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(provider, provider_account_id)
);

CREATE INDEX idx_oauth_user ON oauth_accounts(user_id);
CREATE INDEX idx_oauth_provider ON oauth_accounts(provider);

-- Sessions & Refresh Tokens
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    refresh_token_hash VARCHAR(255) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);

-- ============================================================================
-- CRM MODULES
-- ============================================================================

-- Brands (Contacts/Companies)
CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    website_url TEXT,
    industry VARCHAR(100),
    contact_person VARCHAR(200),
    email VARCHAR(255),
    phone VARCHAR(20),
    country VARCHAR(100),
    city VARCHAR(100),
    address TEXT,
    social_links JSONB DEFAULT '{}', -- {instagram, youtube, tiktok, linkedin, twitter}
    notes TEXT,
    relationship_status relationship_status DEFAULT 'NEW',
    tags TEXT[],
    custom_fields JSONB DEFAULT '{}',
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_brands_org ON brands(organization_id);
CREATE INDEX idx_brands_name ON brands(name);
CREATE INDEX idx_brands_status ON brands(relationship_status);
CREATE INDEX idx_brands_industry ON brands(industry);

-- Brand Contacts (Multiple contacts per brand)
CREATE TABLE brand_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    title VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    is_primary BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_brand_contacts_brand ON brand_contacts(brand_id);

-- Deals/Sponsorships
CREATE TABLE deals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    campaign_name VARCHAR(255) NOT NULL,
    description TEXT,
    stage deal_stage NOT NULL DEFAULT 'LEAD',
    status deal_status NOT NULL DEFAULT 'ACTIVE',
    priority priority_level DEFAULT 'MEDIUM',
    
    -- Financial
    budget DECIMAL(15, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    expected_revenue DECIMAL(15, 2),
    actual_revenue DECIMAL(15, 2),
    
    -- Deliverables
    platforms platform_type[],
    content_types content_type[],
    num_posts INTEGER DEFAULT 0,
    num_videos INTEGER DEFAULT 0,
    deliverables JSONB DEFAULT '[]',
    
    -- Timeline
    start_date DATE,
    due_date DATE,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Assignment
    assigned_to UUID REFERENCES users(id),
    manager_id UUID REFERENCES users(id),
    
    -- Probability & Scoring
    probability INTEGER DEFAULT 0, -- 0-100
    ai_score DECIMAL(5, 2),
    
    tags TEXT[],
    custom_fields JSONB DEFAULT '{}',
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_deals_org ON deals(organization_id);
CREATE INDEX idx_deals_brand ON deals(brand_id);
CREATE INDEX idx_deals_stage ON deals(stage);
CREATE INDEX idx_deals_status ON deals(status);
CREATE INDEX idx_deals_assigned ON deals(assigned_to);
CREATE INDEX idx_deals_due_date ON deals(due_date);

-- Deal Pipeline Stages (Customizable per org)
CREATE TABLE pipeline_stages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    position INTEGER NOT NULL,
    color VARCHAR(7), -- hex color
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pipeline_stages_org ON pipeline_stages(organization_id);

-- Deal Activity/Timeline
CREATE TABLE deal_activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    deal_id UUID NOT NULL REFERENCES deals(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    activity_type VARCHAR(50) NOT NULL, -- STAGE_CHANGE, NOTE, EMAIL, CALL, MEETING, FILE_UPLOAD
    description TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_deal_activities_deal ON deal_activities(deal_id);
CREATE INDEX idx_deal_activities_type ON deal_activities(activity_type);

-- ============================================================================
-- CONTENT CALENDAR
-- ============================================================================

-- Content Items
CREATE TABLE content_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    platform platform_type NOT NULL,
    content_type content_type NOT NULL,
    status task_status DEFAULT 'TODO',
    priority priority_level DEFAULT 'MEDIUM',
    
    -- Scheduling
    scheduled_date TIMESTAMP WITH TIME ZONE,
    published_date TIMESTAMP WITH TIME ZONE,
    due_date TIMESTAMP WITH TIME ZONE,
    
    -- Content Details
    script TEXT,
    caption TEXT,
    hashtags TEXT[],
    thumbnail_url TEXT,
    video_url TEXT,
    
    -- Approval Workflow
    approval_status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED, REVISIONS
    approved_by UUID REFERENCES users(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    
    -- Analytics
    views BIGINT,
    likes BIGINT,
    comments BIGINT,
    shares BIGINT,
    engagement_rate DECIMAL(5, 2),
    
    assigned_to UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_content_org ON content_items(organization_id);
CREATE INDEX idx_content_deal ON content_items(deal_id);
CREATE INDEX idx_content_platform ON content_items(platform);
CREATE INDEX idx_content_status ON content_items(status);
CREATE INDEX idx_content_scheduled ON content_items(scheduled_date);
CREATE INDEX idx_content_assigned ON content_items(assigned_to);

-- ============================================================================
-- CONTRACTS
-- ============================================================================

CREATE TABLE contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    contract_number VARCHAR(100),
    type VARCHAR(50), -- SPONSORSHIP, EXCLUSIVE, MULTI_CAMPAIGN, etc.
    
    -- Terms
    start_date DATE,
    end_date DATE,
    value DECIMAL(15, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    payment_terms TEXT,
    exclusivity BOOLEAN DEFAULT FALSE,
    
    -- File Management
    file_url TEXT NOT NULL,
    file_type VARCHAR(20),
    file_size BIGINT,
    version INTEGER DEFAULT 1,
    
    -- Status
    status VARCHAR(20) DEFAULT 'DRAFT', -- DRAFT, SENT, SIGNED, EXPIRED, TERMINATED
    signed_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    
    -- Reminders
    renewal_reminder_days INTEGER DEFAULT 30,
    expiry_reminder_days INTEGER DEFAULT 7,
    
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_contracts_org ON contracts(organization_id);
CREATE INDEX idx_contracts_deal ON contracts(deal_id);
CREATE INDEX idx_contracts_status ON contracts(status);
CREATE INDEX idx_contracts_end_date ON contracts(end_date);

-- Contract Versions
CREATE TABLE contract_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    contract_id UUID NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,
    version INTEGER NOT NULL,
    file_url TEXT NOT NULL,
    changes_summary TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_contract_versions_contract ON contract_versions(contract_id);

-- ============================================================================
-- INVOICES & PAYMENTS
-- ============================================================================

-- Invoices
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
    invoice_number VARCHAR(100) NOT NULL,
    
    -- Parties
    bill_to_name VARCHAR(255) NOT NULL,
    bill_to_email VARCHAR(255),
    bill_to_address TEXT,
    bill_to_tax_id VARCHAR(100),
    
    -- Amounts
    subtotal DECIMAL(15, 2) NOT NULL,
    tax_rate DECIMAL(5, 2) DEFAULT 0,
    tax_amount DECIMAL(15, 2) DEFAULT 0,
    discount_amount DECIMAL(15, 2) DEFAULT 0,
    total_amount DECIMAL(15, 2) NOT NULL,
    amount_paid DECIMAL(15, 2) DEFAULT 0,
    amount_due DECIMAL(15, 2) GENERATED ALWAYS AS (total_amount - amount_paid) STORED,
    currency VARCHAR(3) DEFAULT 'USD',
    
    -- Status
    status invoice_status NOT NULL DEFAULT 'DRAFT',
    
    -- Dates
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    paid_at TIMESTAMP WITH TIME ZONE,
    
    -- Payment Details
    payment_method VARCHAR(50),
    bank_details JSONB,
    stripe_invoice_id VARCHAR(255),
    
    -- Files
    pdf_url TEXT,
    
    notes TEXT,
    terms TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoices_org ON invoices(organization_id);
CREATE INDEX idx_invoices_deal ON invoices(deal_id);
CREATE INDEX idx_invoices_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);

-- Invoice Line Items
CREATE TABLE invoice_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    description VARCHAR(500) NOT NULL,
    quantity DECIMAL(10, 2) DEFAULT 1,
    unit_price DECIMAL(15, 2) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    tax_rate DECIMAL(5, 2) DEFAULT 0,
    position INTEGER NOT NULL
);

CREATE INDEX idx_invoice_items_invoice ON invoice_items(invoice_id);

-- Payments
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    invoice_id UUID REFERENCES invoices(id) ON DELETE SET NULL,
    deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
    
    amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    exchange_rate DECIMAL(10, 6) DEFAULT 1,
    
    status payment_status NOT NULL DEFAULT 'PENDING',
    payment_method VARCHAR(50), -- STRIPE, BANK_TRANSFER, PAYPAL, CHECK, etc.
    payment_processor_id VARCHAR(255), -- Stripe payment intent ID
    
    -- Bank Transfer Details
    reference_number VARCHAR(255),
    bank_name VARCHAR(255),
    account_number_last4 VARCHAR(10),
    
    -- Dates
    payment_date DATE,
    received_at TIMESTAMP WITH TIME ZONE,
    
    notes TEXT,
    metadata JSONB DEFAULT '{}',
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_org ON payments(organization_id);
CREATE INDEX idx_payments_invoice ON payments(invoice_id);
CREATE INDEX idx_payments_deal ON payments(deal_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_date ON payments(payment_date);

-- ============================================================================
-- EXPENSES
-- ============================================================================

CREATE TABLE expense_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    parent_id UUID REFERENCES expense_categories(id) ON DELETE SET NULL,
    color VARCHAR(7),
    is_system BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_expense_categories_org ON expense_categories(organization_id);

CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    category_id UUID REFERENCES expense_categories(id) ON DELETE SET NULL,
    deal_id UUID REFERENCES deals(id) ON DELETE SET NULL,
    
    description VARCHAR(500) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    tax_amount DECIMAL(15, 2) DEFAULT 0,
    total_amount DECIMAL(15, 2) GENERATED ALWAYS AS (amount + tax_amount) STORED,
    
    expense_date DATE NOT NULL,
    vendor_name VARCHAR(255),
    payment_method VARCHAR(50),
    receipt_url TEXT,
    
    is_billable BOOLEAN DEFAULT FALSE,
    is_reimbursable BOOLEAN DEFAULT FALSE,
    
    notes TEXT,
    tags TEXT[],
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_expenses_org ON expenses(organization_id);
CREATE INDEX idx_expenses_category ON expenses(category_id);
CREATE INDEX idx_expenses_deal ON expenses(deal_id);
CREATE INDEX idx_expenses_date ON expenses(expense_date);

-- ============================================================================
-- TASKS
-- ============================================================================

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    deal_id UUID REFERENCES deals(id) ON DELETE CASCADE,
    content_id UUID REFERENCES content_items(id) ON DELETE CASCADE,
    parent_task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status task_status NOT NULL DEFAULT 'TODO',
    priority priority_level DEFAULT 'MEDIUM',
    
    -- Assignment
    assigned_to UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    
    -- Scheduling
    due_date TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Recurrence
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern VARCHAR(20), -- DAILY, WEEKLY, MONTHLY, YEARLY
    recurrence_config JSONB,
    
    -- Progress
    checklist JSONB DEFAULT '[]',
    completion_percentage INTEGER DEFAULT 0,
    
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tasks_org ON tasks(organization_id);
CREATE INDEX idx_tasks_deal ON tasks(deal_id);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_to);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_parent ON tasks(parent_task_id);

-- Task Comments
CREATE TABLE task_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    parent_comment_id UUID REFERENCES task_comments(id) ON DELETE CASCADE,
    mentions UUID[],
    attachments JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_task_comments_task ON task_comments(task_id);
CREATE INDEX idx_task_comments_user ON task_comments(user_id);

-- ============================================================================
-- FILES
-- ============================================================================

CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    folder_id UUID REFERENCES files(id) ON DELETE CASCADE, -- Self-reference for folders
    
    name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255),
    file_type file_type NOT NULL,
    mime_type VARCHAR(100),
    file_size BIGINT NOT NULL,
    
    -- Storage
    storage_provider VARCHAR(50) DEFAULT 'S3',
    bucket_name VARCHAR(255),
    storage_key VARCHAR(500) NOT NULL,
    public_url TEXT,
    download_url TEXT,
    
    -- Metadata
    width INTEGER,
    height INTEGER,
    duration INTEGER, -- for videos/audio in seconds
    metadata JSONB DEFAULT '{}',
    
    -- Versioning
    version INTEGER DEFAULT 1,
    is_latest_version BOOLEAN DEFAULT TRUE,
    
    -- Access
    access_level VARCHAR(20) DEFAULT 'PRIVATE', -- PRIVATE, ORGANIZATION, PUBLIC
    password_hash VARCHAR(255),
    expires_at TIMESTAMP WITH TIME ZONE,
    
    uploaded_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_files_org ON files(organization_id);
CREATE INDEX idx_files_folder ON files(folder_id);
CREATE INDEX idx_files_type ON files(file_type);
CREATE INDEX idx_files_uploaded_by ON files(uploaded_by);

-- ============================================================================
-- CONTACTS (General)
-- ============================================================================

CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50) NOT NULL, -- BRAND_MANAGER, EDITOR, FREELANCER, SPONSOR, AGENCY, ASSISTANT
    company VARCHAR(255),
    title VARCHAR(100),
    
    email VARCHAR(255),
    phone VARCHAR(20),
    country VARCHAR(100),
    
    social_links JSONB DEFAULT '{}',
    notes TEXT,
    tags TEXT[],
    custom_fields JSONB DEFAULT '{}',
    
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_contacts_org ON contacts(organization_id);
CREATE INDEX idx_contacts_type ON contacts(type);
CREATE INDEX idx_contacts_name ON contacts(name);

-- ============================================================================
-- ANALYTICS & AI
-- ============================================================================

-- AI History/Prompts
CREATE TABLE ai_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    
    feature VARCHAR(100) NOT NULL, -- EMAIL_WRITER, PROPOSAL_GENERATOR, CONTRACT_SUMMARY, etc.
    model VARCHAR(100), -- gpt-4, gemini-pro, etc.
    
    input_prompt TEXT NOT NULL,
    output_response TEXT NOT NULL,
    tokens_used INTEGER,
    cost DECIMAL(10, 6),
    
    context_type VARCHAR(50), -- DEAL, CONTENT, CONTRACT, etc.
    context_id UUID,
    
    rating INTEGER, -- 1-5 stars user feedback
    feedback TEXT,
    is_accepted BOOLEAN,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ai_history_org ON ai_history(organization_id);
CREATE INDEX idx_ai_history_user ON ai_history(user_id);
CREATE INDEX idx_ai_history_feature ON ai_history(feature);
CREATE INDEX idx_ai_history_context ON ai_history(context_type, context_id);

-- Analytics Snapshots (for historical data)
CREATE TABLE analytics_snapshots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    
    snapshot_date DATE NOT NULL,
    
    -- Revenue Metrics
    total_revenue DECIMAL(15, 2) DEFAULT 0,
    monthly_recurring_revenue DECIMAL(15, 2) DEFAULT 0,
    pending_payments DECIMAL(15, 2) DEFAULT 0,
    
    -- Deal Metrics
    total_deals INTEGER DEFAULT 0,
    active_deals INTEGER DEFAULT 0,
    won_deals INTEGER DEFAULT 0,
    lost_deals INTEGER DEFAULT 0,
    average_deal_value DECIMAL(15, 2) DEFAULT 0,
    
    -- Content Metrics
    total_content INTEGER DEFAULT 0,
    published_content INTEGER DEFAULT 0,
    total_views BIGINT DEFAULT 0,
    total_engagement BIGINT DEFAULT 0,
    
    -- Performance
    conversion_rate DECIMAL(5, 2) DEFAULT 0,
    win_rate DECIMAL(5, 2) DEFAULT 0,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_analytics_snapshots_org ON analytics_snapshots(organization_id);
CREATE INDEX idx_analytics_snapshots_date ON analytics_snapshots(snapshot_date);
CREATE UNIQUE INDEX idx_analytics_snapshots_unique ON analytics_snapshots(organization_id, snapshot_date);

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    
    -- Context
    entity_type VARCHAR(50), -- DEAL, INVOICE, TASK, CONTENT, etc.
    entity_id UUID,
    
    -- Delivery
    channels JSONB DEFAULT '["in_app"]', -- in_app, email, push
    email_sent BOOLEAN DEFAULT FALSE,
    email_sent_at TIMESTAMP WITH TIME ZONE,
    push_sent BOOLEAN DEFAULT FALSE,
    push_sent_at TIMESTAMP WITH TIME ZONE,
    
    -- Status
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    action_url TEXT,
    action_label VARCHAR(100),
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_org ON notifications(organization_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- Notification Preferences
CREATE TABLE notification_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
    
    notification_type VARCHAR(100) NOT NULL,
    channel_in_app BOOLEAN DEFAULT TRUE,
    channel_email BOOLEAN DEFAULT TRUE,
    channel_push BOOLEAN DEFAULT TRUE,
    
    frequency VARCHAR(20) DEFAULT 'IMMEDIATE', -- IMMEDIATE, DAILY_DIGEST, WEEKLY_DIGEST
    quiet_hours_start TIME,
    quiet_hours_end TIME,
    
    UNIQUE(user_id, organization_id, notification_type)
);

CREATE INDEX idx_notification_prefs_user ON notification_preferences(user_id);

-- ============================================================================
-- SUBSCRIPTIONS & BILLING
-- ============================================================================

CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    
    plan subscription_plan NOT NULL DEFAULT 'FREE',
    status subscription_status NOT NULL DEFAULT 'TRIALING',
    
    -- Stripe
    stripe_customer_id VARCHAR(255),
    stripe_subscription_id VARCHAR(255),
    stripe_price_id VARCHAR(255),
    
    -- Billing
    currency VARCHAR(3) DEFAULT 'USD',
    interval VARCHAR(20) DEFAULT 'MONTH', -- MONTH, YEAR
    amount DECIMAL(10, 2),
    
    -- Usage
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    trial_start TIMESTAMP WITH TIME ZONE,
    trial_end TIMESTAMP WITH TIME ZONE,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    ended_at TIMESTAMP WITH TIME ZONE,
    
    -- Limits
    max_users INTEGER,
    max_deals INTEGER,
    max_storage_gb INTEGER,
    max_ai_requests INTEGER,
    
    features JSONB DEFAULT '[]',
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subscriptions_org ON subscriptions(organization_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_stripe ON subscriptions(stripe_customer_id);

-- Usage Tracking
CREATE TABLE usage_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    
    record_date DATE NOT NULL,
    
    users_count INTEGER DEFAULT 0,
    deals_count INTEGER DEFAULT 0,
    storage_bytes BIGINT DEFAULT 0,
    ai_requests_count INTEGER DEFAULT 0,
    api_calls_count INTEGER DEFAULT 0,
    emails_sent_count INTEGER DEFAULT 0,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_usage_records_org ON usage_records(organization_id);
CREATE INDEX idx_usage_records_date ON usage_records(record_date);
CREATE UNIQUE INDEX idx_usage_records_unique ON usage_records(organization_id, record_date);

-- ============================================================================
-- AUDIT LOGS
-- ============================================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    
    action VARCHAR(100) NOT NULL, -- CREATE, UPDATE, DELETE, LOGIN, LOGOUT, etc.
    entity_type VARCHAR(100) NOT NULL,
    entity_id UUID,
    
    ip_address INET,
    user_agent TEXT,
    
    changes JSONB, -- {before: {}, after: {}}
    metadata JSONB DEFAULT '{}',
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_org ON audit_logs(organization_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);

-- ============================================================================
-- INTEGRATIONS
-- ============================================================================

CREATE TABLE integrations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    
    service VARCHAR(100) NOT NULL, -- GOOGLE_CALENDAR, GOOGLE_DRIVE, SLACK, DISCORD, etc.
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, INACTIVE, ERROR
    
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP WITH TIME ZONE,
    scopes TEXT[],
    
    webhook_url TEXT,
    webhook_secret TEXT,
    
    settings JSONB DEFAULT '{}',
    last_synced_at TIMESTAMP WITH TIME ZONE,
    
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_integrations_org ON integrations(organization_id);
CREATE INDEX idx_integrations_service ON integrations(service);

-- ============================================================================
-- ACTIVITY FEED
-- ============================================================================

CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    
    action_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    
    entity_type VARCHAR(100),
    entity_id UUID,
    
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activities_org ON activities(organization_id);
CREATE INDEX idx_activities_user ON activities(user_id);
CREATE INDEX idx_activities_created ON activities(created_at);

-- ============================================================================
-- TRIGGERS & FUNCTIONS
-- ============================================================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables with updated_at
CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_brands_updated_at BEFORE UPDATE ON brands
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_deals_updated_at BEFORE UPDATE ON deals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_content_items_updated_at BEFORE UPDATE ON content_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contracts_updated_at BEFORE UPDATE ON contracts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_invoices_updated_at BEFORE UPDATE ON invoices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_files_updated_at BEFORE UPDATE ON files
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SEED DATA
-- ============================================================================

-- Default Expense Categories
INSERT INTO expense_categories (name, is_system) VALUES
    ('Camera & Equipment', TRUE),
    ('Lighting', TRUE),
    ('Travel', TRUE),
    ('Editing Software', TRUE),
    ('Subscriptions', TRUE),
    ('Freelancers', TRUE),
    ('Office', TRUE),
    ('Taxes', TRUE),
    ('Marketing', TRUE),
    ('Other', TRUE);
