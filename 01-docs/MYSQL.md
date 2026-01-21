# MySQL

Connect to TenantsDB with mysql client or any MySQL ORM.

---

## 1. Setup
```bash
curl -sSL get.tenantsdb.com | sh
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 2. Create Workspace
```bash
tdb workspaces create --name myapp --database MySQL
```

Copy connection string from output.

## 3. Connect to Workspace
```bash
mysql -h mysql.tenantsdb.com -P 3306 -u ws_xxx -p myapp_dev
```

## 4. Build Schema
```sql
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
mysql -h mysql.tenantsdb.com -P 3306 -u acme -p myapp__acme
```

**globex:**
```bash
mysql -h mysql.tenantsdb.com -P 3306 -u globex -p myapp__globex
```

Same query, isolated data.

---

## ORM Examples

**Node.js (Sequelize):**
```javascript
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('mysql://acme:xxx@mysql.tenantsdb.com:3306/myapp__acme');
```

**Python (SQLAlchemy):**
```python
from sqlalchemy import create_engine
engine = create_engine('mysql://acme:xxx@mysql.tenantsdb.com:3306/myapp__acme')
```

**Prisma:**
```
DATABASE_URL="mysql://acme:xxx@mysql.tenantsdb.com:3306/myapp__acme"
```

---

## Endpoint

| Host | Port |
|------|------|
| mysql.tenantsdb.com | 3306 |