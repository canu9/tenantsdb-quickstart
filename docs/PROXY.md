# Proxy Flow

Connect directly with psql, mysql, mongosh, redis-cli, or any ORM.

---

## 1. Install CLI & Signup
```bash
curl -sSL get.tenantsdb.com | sh
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 2. Create Workspace
```bash
tdb workspaces create --name fintech --database PostgreSQL
```

Copy the connection string from output.

## 3. Connect & Build Schema
```bash
psql "postgresql://ws_xxx:xxx@pg.tenantsdb.com:5432/fintech_dev"
```
```sql
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0
);

INSERT INTO accounts (name, balance) VALUES ('Alice', 1000), ('Bob', 2000);
```

## 4. Create Tenants
```bash
tdb tenants create --name bank_a --blueprint fintech
tdb tenants create --name bank_b --blueprint fintech
```

Copy connection strings from output.

## 5. Connect as Tenant

**bank_a:**
```bash
psql "postgresql://bank_a:xxx@pg.tenantsdb.com:5432/fintech__bank_a"
```
```sql
SELECT * FROM accounts;
-- Only bank_a data!
```

**bank_b:**
```bash
psql "postgresql://bank_b:xxx@pg.tenantsdb.com:5432/fintech__bank_b"
```
```sql
SELECT * FROM accounts;
-- Only bank_b data!
```

**Same table. Different data. Physical isolation.**

---

## ORM Examples

**Node.js (Sequelize):**
```javascript
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('postgresql://bank_a:xxx@pg.tenantsdb.com:5432/fintech__bank_a');
```

**Python (SQLAlchemy):**
```python
from sqlalchemy import create_engine
engine = create_engine('postgresql://bank_a:xxx@pg.tenantsdb.com:5432/fintech__bank_a')
```

---

## Database Endpoints

- PostgreSQL: `pg.tenantsdb.com:5432`
- MySQL: `mysql.tenantsdb.com:3306`
- MongoDB: `mongo.tenantsdb.com:27017`
- Redis: `redis.tenantsdb.com:6379`