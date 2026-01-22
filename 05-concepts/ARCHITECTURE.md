# Architecture

How TenantsDB works under the hood.

---

## Overview

TenantsDB is a multi-tenant database orchestration platform. It lets you:

1. Design a schema once
2. Deploy it to hundreds of isolated tenant databases
3. Manage all tenants through a single API

---

## Core Concepts

| Concept | What It Is | Analogy |
|:--------|:-----------|:--------|
| **Workspace** | Development environment for building schemas | Git branch |
| **Blueprint** | Snapshot of a workspace schema | Git commit |
| **Tenant** | Production database for a customer | Deployed instance |

### Workspace

A workspace is where you develop your schema. When you create a workspace, you get:
- A development database
- Connection credentials
- DDL change tracking

```bash
tdb workspaces create --name myapp --database PostgreSQL
```

Connect and build your schema using normal SQL:
```sql
CREATE TABLE users (id SERIAL PRIMARY KEY, email TEXT);
CREATE TABLE orders (id SERIAL PRIMARY KEY, user_id INT);
```

### Blueprint

A blueprint is a versioned snapshot of your workspace schema. Every workspace has a blueprint that tracks:
- All tables and columns
- Indexes and constraints
- Schema version history

Blueprints are automatically created and updated as you modify your workspace.

### Tenant

A tenant is an isolated production database for one of your customers. Each tenant:
- Has its own database
- Gets the blueprint schema deployed
- Is completely isolated from other tenants

```bash
tdb tenants create --name acme --blueprint myapp
tdb tenants create --name globex --blueprint myapp
```

---

## Flow Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                         DEVELOPMENT                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ┌─────────────┐         ┌─────────────┐                        │
│   │  Workspace  │ ──────► │  Blueprint  │                        │
│   │  myapp_dev  │  auto   │  myapp v1.0 │                        │
│   └─────────────┘         └─────────────┘                        │
│         │                       │                                 │
│         │ CREATE TABLE          │                                 │
│         │ ALTER TABLE           │                                 │
│         ▼                       │                                 │
│   DDL changes logged            │                                 │
│                                 │                                 │
└─────────────────────────────────┼────────────────────────────────┘
                                  │
                                  │ deploy
                                  ▼
┌──────────────────────────────────────────────────────────────────┐
│                         PRODUCTION                                │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐           │
│   │ myapp__acme │   │myapp__globex│   │ myapp__wayne│           │
│   │  (tenant)   │   │  (tenant)   │   │  (tenant)   │           │
│   └─────────────┘   └─────────────┘   └─────────────┘           │
│         │                 │                 │                    │
│         │ Same schema     │ Same schema     │ Same schema        │
│         │ Own data        │ Own data        │ Own data           │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Components

```
┌─────────────────────────────────────────────────────────────────┐
│                        Your Application                          │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         TenantsDB Proxy                          │
│  • Authenticates connections                                     │
│  • Routes to correct tenant database                             │
│  • Logs DDL changes (in workspace mode)                          │
└───────────────────────────────┬─────────────────────────────────┘
                                │
          ┌───────────────┬───────────────┬───────────────┐
          ▼               ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  PostgreSQL  │ │    MySQL     │ │   MongoDB    │ │    Redis     │
│    Server    │ │    Server    │ │    Server    │ │    Server    │
├──────────────┤ ├──────────────┤ ├──────────────┤ ├──────────────┤
│ myapp__acme  │ │ myapp__acme  │ │ myapp__acme  │ │ acme:*       │
│ myapp__globex│ │ myapp__globex│ │ myapp__globex│ │ globex:*     │
│ myapp_dev    │ │ myapp_dev    │ │ myapp_dev    │ │ dev:*        │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
```

### API Server

- REST API for management operations
- Handles workspace, blueprint, tenant CRUD
- Triggers deployments
- Manages authentication

### Proxy

- Protocol-aware (PostgreSQL, MySQL, MongoDB, Redis)
- Routes connections based on database name (or key prefix for Redis)
- Captures DDL in workspace mode
- Transparent to your application

### Control Plane

- Stores metadata (tenants, blueprints, deployments)
- Tracks schema versions
- Manages deployment jobs
- Coordinates migrations

---

## Connection Flow

### Workspace Connection (Development)

```
App connects to: myapp_dev
        │
        ▼
┌───────────────┐
│    Proxy      │
│ • Parse db    │
│ • Detect _dev │
│ • Enable DDL  │
│   logging     │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  myapp_dev    │
│  (workspace)  │
└───────────────┘
```

### Tenant Connection (Production)

```
App connects to: myapp__acme
        │
        ▼
┌───────────────┐
│    Proxy      │
│ • Parse db    │
│ • Extract     │
│   tenant_id   │
│ • Route       │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ myapp__acme   │
│  (tenant db)  │
└───────────────┘
```

### Database Naming Convention

| Pattern | Type | Example |
|:--------|:-----|:--------|
| `{blueprint}_dev` | Workspace | `myapp_dev` |
| `{blueprint}__{tenant}` | Tenant | `myapp__acme` |
| `{tenant}:*` | Redis keys | `acme:session:123` |

Note: Tenant databases use double underscore (`__`) to separate blueprint and tenant. Redis uses key prefixes for tenant isolation.

---

## Schema Evolution

### Making Changes

1. Connect to workspace
2. Run DDL (CREATE, ALTER, DROP)
3. Changes are logged automatically

```sql
-- Connected to myapp_dev
ALTER TABLE users ADD COLUMN phone TEXT;
```

### Viewing Pending Changes

```bash
tdb workspaces diff myapp
```

```
Pending DDL Changes:
  1. ALTER TABLE users ADD COLUMN phone TEXT;
```

### Deploying Changes

When you create a new tenant, the current blueprint schema is deployed:

```bash
tdb tenants create --name newcorp --blueprint myapp
# Schema automatically deployed to newcorp
```

To deploy changes to existing tenants:

```bash
tdb deployments create --blueprint myapp --all
```

### Deployment Flow

```
┌─────────────┐
│  Workspace  │
│  (change)   │
└──────┬──────┘
       │ diff detected
       ▼
┌─────────────┐
│  Blueprint  │
│  (updated)  │
└──────┬──────┘
       │ deploy
       ▼
┌─────────────────────────────────────┐
│            Deployment Job           │
├─────────────────────────────────────┤
│ For each tenant:                    │
│   1. Run DDL on tenant database     │
│   2. Record success/failure         │
│   3. Update deployment status       │
└─────────────────────────────────────┘
```

---

## What Happens When...

### You Create a Workspace

1. API creates workspace record
2. Development database created (`myapp_dev`)
3. Blueprint record created (v1.0)
4. Connection credentials generated

### You Create a Tenant

1. API validates blueprint exists
2. Tenant database created (`myapp__acme`)
3. Blueprint schema deployed to tenant
4. Connection credentials returned

### You Run DDL in Workspace

1. Proxy intercepts the query
2. DDL executed on workspace database
3. DDL logged to change tracking
4. Blueprint updated with new schema

### You Deploy to Tenants

1. Deployment job created
2. For each tenant:
   - Run pending DDL statements
   - Record result
3. Deployment marked complete

---

## Summary

| Layer | Purpose |
|:------|:--------|
| Workspace | Develop and test schema changes |
| Blueprint | Version and track schema |
| Tenant | Isolated production database |
| Proxy | Route connections, log DDL |
| API | Manage everything via REST |