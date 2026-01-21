# API Flow

Integrate TenantsDB via REST API for automation and CI/CD.

---

## Base URL
```
https://api.tenantsdb.com
```

## Authentication

All endpoints (except signup/login) require `X-API-Key` header.
```bash
-H "X-API-Key: YOUR_API_KEY"
```

---

## 1. Signup
```bash
curl -X POST https://api.tenantsdb.com/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "you@company.com",
    "password": "yourpassword",
    "project_name": "Demo"
  }'
```

Response:
```json
{
  "success": true,
  "api_key": "tdb_xxxxxxxxxxxx",
  "project_id": "tdb_abc123"
}
```

Save the `api_key` for subsequent requests.

---

## 2. Create Workspace
```bash
curl -X POST https://api.tenantsdb.com/workspaces \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "fintech",
    "database": "PostgreSQL"
  }'
```

---

## 3. Create Tenants
```bash
curl -X POST https://api.tenantsdb.com/tenants \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "tenant_id": "bank_a",
    "databases": [
      {"blueprint": "fintech", "isolation_level": 1}
    ]
  }'
```

---

## 4. List Tenants
```bash
curl https://api.tenantsdb.com/tenants \
  -H "X-API-Key: YOUR_API_KEY"
```

---

## 5. Query Tenant
```bash
curl -X POST https://api.tenantsdb.com/admin/query \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "tenant_id": "bank_a",
    "query": "SELECT * FROM accounts",
    "database_type": "PostgreSQL",
    "blueprint": "fintech"
  }'
```

---

## All Endpoints

**Auth:**
- `POST /signup` — Create account
- `POST /login` — Login

**Projects:**
- `GET /projects` — List projects
- `POST /projects` — Create project
- `DELETE /projects/{id}` — Delete project

**Workspaces:**
- `GET /workspaces` — List workspaces
- `POST /workspaces` — Create workspace
- `GET /workspaces/{id}` — Get workspace
- `DELETE /workspaces/{id}` — Delete workspace
- `POST /workspaces/{id}/queries` — Run query
- `GET /workspaces/{id}/schema` — Get schema
- `POST /workspaces/{id}/schema` — Import schema

**Blueprints:**
- `GET /blueprints` — List blueprints
- `GET /blueprints/{name}` — Get blueprint
- `GET /blueprints/{name}/versions` — List versions

**Tenants:**
- `GET /tenants` — List tenants
- `POST /tenants` — Create tenant
- `GET /tenants/{id}` — Get tenant
- `DELETE /tenants/{id}` — Delete tenant
- `POST /tenants/{id}/suspend` — Suspend tenant
- `POST /tenants/{id}/resume` — Resume tenant
- `POST /tenants/{id}/backup` — Trigger backup
- `GET /tenants/{id}/backups` — List backups

**Deployments:**
- `GET /deployments` — List deployments
- `POST /deployments` — Create deployment
- `GET /deployments/{id}` — Get status

**Admin:**
- `POST /admin/query` — Query tenant directly