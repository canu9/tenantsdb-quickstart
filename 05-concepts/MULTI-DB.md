# Multi-Database Tenants

A single tenant can use multiple database types simultaneously.

---

## Overview

TenantsDB allows each tenant to have databases across different technologies:

```
┌───────────────────────────────────────────────────────────────────────────────┐
│ Tenant: acme                                                                  │
├───────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │ PostgreSQL │  │   MySQL    │  │  MongoDB   │  │   Redis    │              │
│  │  (orders)  │  │  (users)   │  │ (analytics)│  │ (sessions) │              │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘              │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘
```

**Why?** Different databases excel at different tasks:

| Database | Best For |
|:---------|:---------|
| PostgreSQL | Transactions, relational data, ACID compliance |
| MySQL | Web applications, read-heavy workloads |
| MongoDB | Documents, flexible schemas, rapid iteration |
| Redis | Caching, sessions, real-time data |

---

## Setting Up Multi-Database

### Step 1: Create Workspaces

Create a workspace for each database type:

```bash
# Relational data - transactions
tdb workspaces create --name orders --database PostgreSQL

# Relational data - users
tdb workspaces create --name users --database MySQL

# Analytics/documents
tdb workspaces create --name analytics --database MongoDB

# Caching/sessions
tdb workspaces create --name cache --database Redis
```

### Step 2: Build Schemas

Connect to each workspace and build your schema:

**PostgreSQL (orders):**
```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_email TEXT,
  total DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

**MySQL (users):**
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  plan VARCHAR(50) DEFAULT 'free',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**MongoDB (analytics):**
```javascript
db.createCollection("events")
db.events.createIndex({ "timestamp": 1 })
```

**Redis (cache):**
```
# Configure TTL patterns via API or workspace settings
```

### Step 3: Create Tenant with Multiple Databases

```bash
tdb tenants create --name acme --blueprint orders
tdb tenants create --name acme --blueprint users
tdb tenants create --name acme --blueprint analytics
tdb tenants create --name acme --blueprint cache
```

Or via API in one call:

```json
POST /tenants
{
  "tenant_id": "acme",
  "databases": [
    { "blueprint": "orders" },
    { "blueprint": "users" },
    { "blueprint": "analytics" },
    { "blueprint": "cache" }
  ]
}
```

---

## Connection Strings

Each database gets its own connection:

```bash
tdb tenants get acme --json
```

```json
{
  "tenant_id": "acme",
  "status": "ready",
  "databases": [
    {
      "blueprint": "orders",
      "database_type": "PostgreSQL",
      "connection": {
        "connection_string": "postgresql://user:pass@pg.tenantsdb.com:5432/orders__acme"
      }
    },
    {
      "blueprint": "users",
      "database_type": "MySQL",
      "connection": {
        "connection_string": "mysql://user:pass@mysql.tenantsdb.com:3306/users__acme"
      }
    },
    {
      "blueprint": "analytics",
      "database_type": "MongoDB",
      "connection": {
        "connection_string": "mongodb://user:pass@mongo.tenantsdb.com:27017/analytics__acme"
      }
    },
    {
      "blueprint": "cache",
      "database_type": "Redis",
      "connection": {
        "connection_string": "redis://acme:apikey@redis.tenantsdb.com:6379/0"
      }
    }
  ]
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Your Application                                │
└───────┬───────────────┬───────────────────┬───────────────────┬─────────────┘
        │               │                   │                   │
        ▼               ▼                   ▼                   ▼
┌────────────┐  ┌────────────┐      ┌────────────┐      ┌────────────┐
│  PG Proxy  │  │MySQL Proxy │      │Mongo Proxy │      │Redis Proxy │
│   :5432    │  │   :3306    │      │   :27017   │      │   :6379    │
└─────┬──────┘  └─────┬──────┘      └─────┬──────┘      └─────┬──────┘
      │               │                   │                   │
      ▼               ▼                   ▼                   ▼
┌────────────┐  ┌────────────┐      ┌────────────┐      ┌────────────┐
│ PostgreSQL │  │   MySQL    │      │  MongoDB   │      │   Redis    │
│orders__acme│  │users__acme │      │analytics__ │      │  acme:*    │
└────────────┘  └────────────┘      └────────────┘      └────────────┘
```

Each proxy:
- Speaks native protocol
- Routes to correct tenant
- Fully transparent to your app

---

## Use Cases

### E-commerce Platform

| Data | Database | Why |
|:-----|:---------|:----|
| Orders, transactions | PostgreSQL | ACID transactions, joins |
| Customers, accounts | MySQL | Simple relational, fast reads |
| Product catalog search | MongoDB | Flexible attributes, fast reads |
| Shopping cart, sessions | Redis | Speed, TTL expiration |

### SaaS Application

| Data | Database | Why |
|:-----|:---------|:----|
| Users, authentication | MySQL | Simple relational, fast reads |
| Subscriptions, billing | PostgreSQL | ACID transactions, financial data |
| Activity logs, events | MongoDB | High write throughput, flexible schema |
| Feature flags, rate limits | Redis | Sub-millisecond reads |

### IoT Platform

| Data | Database | Why |
|:-----|:---------|:----|
| Device registry, configs | PostgreSQL | Relational data, constraints |
| User accounts, permissions | MySQL | Simple auth, fast lookups |
| Sensor readings, time-series | MongoDB | Document storage, sharding |
| Real-time alerts, pub/sub | Redis | Streams, pub/sub |

---

## Isolation Levels Per Database

Each database can have different isolation levels:

```json
{
  "tenant_id": "enterprise_corp",
  "databases": [
    { 
      "blueprint": "orders", 
      "isolation_level": 2 
    },
    { 
      "blueprint": "users", 
      "isolation_level": 1 
    },
    { 
      "blueprint": "analytics", 
      "isolation_level": 1 
    },
    { 
      "blueprint": "cache", 
      "isolation_level": 1 
    }
  ]
}
```

| Blueprint | Level | Why |
|:----------|:------|:----|
| orders | L2 (Dedicated) | Critical transactions, need guaranteed performance |
| users | L1 (Pooled) | Simple reads, can share resources |
| analytics | L1 (Pooled) | Read-heavy, can tolerate shared resources |
| cache | L1 (Pooled) | Ephemeral data, cost-efficient |

---

## Querying Across Databases

TenantsDB manages each database independently. Cross-database queries happen in your application:

```javascript
// Your application code
async function getOrderWithAnalytics(orderId, tenantId) {
  // Query PostgreSQL
  const order = await pgPool.query(
    'SELECT * FROM orders WHERE id = $1', 
    [orderId]
  );
  
  // Query MongoDB
  const events = await mongoDb.collection('events').find({
    order_id: orderId
  }).toArray();
  
  return { order, events };
}
```

---

## Deployment

Schema changes deploy per-blueprint:

```bash
# Deploy orders schema changes
tdb deployments create --blueprint orders --all

# Deploy analytics schema changes
tdb deployments create --blueprint analytics --all
```

Each blueprint deploys independently to all tenants using it.

---

## Listing Tenant Databases

```bash
tdb tenants list --json
```

```json
{
  "tenants": [
    {
      "tenant_id": "acme",
      "status": "ready",
      "databases": [
        { "blueprint": "orders", "database_type": "PostgreSQL" },
        { "blueprint": "users", "database_type": "MySQL" },
        { "blueprint": "analytics", "database_type": "MongoDB" },
        { "blueprint": "cache", "database_type": "Redis" }
      ]
    }
  ]
}
```

---

## Constraints

| Rule | Description |
|:-----|:------------|
| One blueprint per database type per tenant | A tenant can have one PostgreSQL and one MySQL blueprint, but not two PostgreSQL blueprints |
| Blueprints are independent | No cross-blueprint foreign keys |
| Connections are separate | Each database has own connection string |

---

## FAQ

**Q: Can a tenant have two PostgreSQL databases?**
A: No. One blueprint per database type per tenant. Use different tables within one PostgreSQL blueprint.

**Q: Do all tenants need all databases?**
A: No. Each tenant can have different combinations based on their needs.

**Q: How do I add a database to an existing tenant?**
A: Just create the tenant with the new blueprint:
```bash
tdb tenants create --name acme --blueprint newblueprint
```

**Q: How do I remove a single database from a tenant?**
A: Not supported yet. You can only delete the entire tenant. To remove one database, delete the tenant and recreate with only the databases you want:
```bash
tdb tenants delete acme --hard
tdb tenants create --name acme --blueprint orders
tdb tenants create --name acme --blueprint cache
# (skip the database you want to remove)
```