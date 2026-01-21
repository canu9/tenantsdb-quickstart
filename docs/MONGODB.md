# MongoDB

Connect to TenantsDB with mongosh or any MongoDB driver.

---

## 1. Setup
```bash
curl -sSL get.tenantsdb.com | sh
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 2. Create Workspace
```bash
tdb workspaces create --name myapp --database MongoDB
```

Copy connection string from output.

## 3. Connect to Workspace
```bash
mongosh "mongodb://ws_xxx:xxx@mongo.tenantsdb.com:27017/myapp_dev"
```

## 4. Build Schema
```javascript
db.createCollection("accounts")

db.accounts.insertMany([
    { name: "Alice", balance: 1000 },
    { name: "Bob", balance: 2000 }
])
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
mongosh "mongodb://acme:xxx@mongo.tenantsdb.com:27017/myapp__acme"
```

**globex:**
```bash
mongosh "mongodb://globex:xxx@mongo.tenantsdb.com:27017/myapp__globex"
```

Same query, isolated data.

---

## Driver Examples

**Node.js:**
```javascript
const { MongoClient } = require('mongodb');
const client = new MongoClient('mongodb://acme:xxx@mongo.tenantsdb.com:27017/myapp__acme');
```

**Python (PyMongo):**
```python
from pymongo import MongoClient
client = MongoClient('mongodb://acme:xxx@mongo.tenantsdb.com:27017/myapp__acme')
```

**Mongoose:**
```javascript
const mongoose = require('mongoose');
mongoose.connect('mongodb://acme:xxx@mongo.tenantsdb.com:27017/myapp__acme');
```

---

## Endpoint

| Host | Port |
|------|------|
| mongo.tenantsdb.com | 27017 |