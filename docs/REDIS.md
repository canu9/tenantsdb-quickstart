# Redis

Connect to TenantsDB with redis-cli or any Redis client.

---

## 1. Setup
```bash
curl -sSL get.tenantsdb.com | sh
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 2. Create Workspace
```bash
tdb workspaces create --name myapp --database Redis
```

Copy connection string from output.

## 3. Connect to Workspace
```bash
redis-cli -h redis.tenantsdb.com -p 6379 -a ws_xxx
```

## 4. Add Data
```bash
SET user:1 "Alice"
SET user:2 "Bob"
HSET account:1 name "Alice" balance 1000
HSET account:2 name "Bob" balance 2000
```

## 5. Create Tenants
```bash
tdb tenants create --name acme --blueprint myapp
tdb tenants create --name globex --blueprint myapp
```

## 6. Connect to Tenant Database

**acme:**
```bash
redis-cli -h redis.tenantsdb.com -p 6379 -a acme
```

**globex:**
```bash
redis-cli -h redis.tenantsdb.com -p 6379 -a globex
```

Same commands, isolated data.

---

## Client Examples

**Node.js (ioredis):**
```javascript
const Redis = require('ioredis');
const redis = new Redis('redis://acme:xxx@redis.tenantsdb.com:6379');
```

**Python (redis-py):**
```python
import redis
r = redis.Redis.from_url('redis://acme:xxx@redis.tenantsdb.com:6379')
```

**Node.js (node-redis):**
```javascript
const { createClient } = require('redis');
const client = createClient({ url: 'redis://acme:xxx@redis.tenantsdb.com:6379' });
```

---

## Endpoint

| Host | Port |
|------|------|
| redis.tenantsdb.com | 6379 |