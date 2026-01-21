# PostgreSQL

Connect to TenantsDB with psql or any PostgreSQL ORM.

---

## 1. Setup
```bash
curl -sSL get.tenantsdb.com | sh
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 2. Create Workspace
```bash
tdb workspaces create --name myapp --database PostgreSQL
```

Copy connection string from output.

## 3. Connect to Workspace
```bash
psql "postgresql://ws_xxx:xxx@pg.tenantsdb.com:5432/myapp_dev"
```

## 4. Build Schema
```sql
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0
);

INSERT INTO accounts (name, balance) VALUES ('Alice', 1000), ('Bob', 2000);
```

Or import template:
```bash
tdb workspaces schema myapp --template fintech
```

## 5. Create Tenants
```bash
tdb tenants create --name acme --blueprint myapp
tdb tenants create --name globex --blueprint myapp
```

## 6. Connect to Tenant Database

**acme:**
```bash
psql "postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme"
```

**globex:**
```bash
psql "postgresql://globex:xxx@pg.tenantsdb.com:5432/myapp__globex"
```

Same query, isolated data.

---

## ORM Examples

**Node.js (Sequelize):**
```javascript
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme');
```

**Python (SQLAlchemy):**
```python
from sqlalchemy import create_engine
engine = create_engine('postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme')
```

**Prisma:**
```
DATABASE_URL="postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme"
```

---

## Endpoint

| Host | Port |
|------|------|
| pg.tenantsdb.com | 5432 |