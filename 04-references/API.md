# API Reference

Full list of REST API endpoints.

Base URL: `https://api.tenantsdb.com`

---

## Authentication

All endpoints (except `/signup` and `/login`) require header:
```
X-API-Key: YOUR_API_KEY
```

---

## Health

### GET /
Service info.

**Response:**
```json
{
  "service": "TenantsDB API",
  "version": "1.0.0"
}
```

### GET /health
Health check.

**Response:**
```json
{
  "status": "healthy"
}
```

---

## Auth

### POST /signup
Create new account.

**Request:**
```json
{
  "email": "you@company.com",
  "password": "yourpassword",
  "project_name": "My Project"
}
```

**Response:**
```json
{
  "success": true,
  "api_key": "tdb_xxxxxxxxxxxx",
  "project_id": "tdb_abc123"
}
```

### POST /login
Login to existing account.

**Request:**
```json
{
  "email": "you@company.com",
  "password": "yourpassword"
}
```

**Response:**
```json
{
  "success": true,
  "projects": [
    {
      "project_id": "tdb_abc123",
      "name": "My Project",
      "api_key": "tdb_xxxxxxxxxxxx"
    }
  ]
}
```

---

## Projects

### GET /projects
List all projects.

### POST /projects
Create project.

**Request:**
```json
{
  "name": "New Project"
}
```

### DELETE /projects/{id}
Delete project.

---

## API Keys

### GET /apikeys
List API keys.

### POST /apikeys
Generate new API key.

**Request:**
```json
{
  "project_name": "Key Name"
}
```

### DELETE /apikeys/{id}
Delete API key.

---

## Workspaces

### GET /workspaces
List all workspaces.

### POST /workspaces
Create workspace.

**Request:**
```json
{
  "name": "myapp",
  "database": "PostgreSQL"
}
```

**Database options:** `PostgreSQL`, `MySQL`, `MongoDB`, `Redis`

**Response:**
```json
{
  "success": true,
  "workspace": {
    "id": "ws_xxx",
    "name": "myapp",
    "connection_string": "postgresql://ws_xxx:pass@pg.tenantsdb.com:5432/myapp_dev"
  }
}
```

### GET /workspaces/{id}
Get workspace details.

### DELETE /workspaces/{id}
Delete workspace.

### GET /workspaces/{id}/schema
Get current schema.

### POST /workspaces/{id}/schema
Import schema.

**From template:**
```json
{
  "source": "template",
  "template": "fintech"
}
```

**From JSON:**
```json
{
  "source": "json",
  "tables": [...]
}
```

**From database:**
```json
{
  "source": "database",
  "connection": {
    "type": "postgresql",
    "host": "db.example.com",
    "port": 5432,
    "database": "mydb",
    "user": "admin",
    "password": "secret"
  }
}
```

### POST /workspaces/{id}/queries
Run query in workspace.

**Request:**
```json
{
  "query": "SELECT * FROM accounts"
}
```

### GET /workspaces/{id}/diff
Get pending DDL changes.

### DELETE /workspaces/{id}/diff/{ddl_id}
Skip DDL from deploy queue.

### POST /workspaces/{id}/diff/{ddl_id}/revert
Revert DDL change.

### GET /workspaces/{id}/settings
Get workspace settings.

### POST /workspaces/{id}/settings
Update workspace settings.

### POST /workspaces/{id}/import-data/analyze
Analyze source database.

**Request:**
```json
{
  "connection": {
    "type": "postgresql",
    "host": "db.example.com",
    "port": 5432,
    "database": "mydb",
    "user": "admin",
    "password": "secret"
  },
  "routing_field": "tenant_id"
}
```

### POST /workspaces/{id}/import-data
Start data import.

**Request:**
```json
{
  "connection": {
    "type": "postgresql",
    "host": "db.example.com",
    "port": 5432,
    "database": "mydb",
    "user": "admin",
    "password": "secret"
  },
  "routing_field": "tenant_id",
  "options": {
    "drop_routing_column": true,
    "create_tenants": true
  }
}
```

### GET /workspaces/{id}/import-data/status
Check import progress.

**Query params:** `import_id`

### POST /workspaces/{id}/import-full
Import schema and data.

---

## Blueprints

### GET /blueprints
List all blueprints.

### GET /blueprints/{name}
Get blueprint schema.

### GET /blueprints/{name}/versions
List blueprint versions.

---

## Tenants

### GET /tenants
List all tenants.

### POST /tenants
Create tenant.

**Request:**
```json
{
  "tenant_id": "acme",
  "databases": [
    {
      "blueprint": "myapp",
      "isolation_level": 1
    }
  ]
}
```

**Isolation levels:**
- `1` = Shared (multi-tenant pool)
- `2` = Dedicated (own VM)

**Response:**
```json
{
  "success": true,
  "tenant": {
    "tenant_id": "acme",
    "databases": [
      {
        "database_type": "PostgreSQL",
        "connection_string": "postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme"
      }
    ]
  }
}
```

### GET /tenants/{id}
Get tenant details.

### DELETE /tenants/{id}
Delete tenant (soft delete).

**Query params:** `hard=true` for permanent deletion.

### POST /tenants/{id}/suspend
Suspend tenant.

### POST /tenants/{id}/resume
Resume tenant.

### POST /tenants/{id}/restore
Restore soft-deleted tenant.

### PATCH /tenants/{id}/isolation
Update isolation level.

**Request:**
```json
{
  "isolation_level": 2
}
```

### POST /tenants/{id}/backup
Trigger backup.

### GET /tenants/{id}/backups
List backups.

### POST /tenants/{id}/rollback
Rollback to backup.

**Request:**
```json
{
  "date": "2026-01-15"
}
```
Or:
```json
{
  "storage_path": "s3://bucket/path/backup.sql"
}
```

### GET /tenants/{id}/logs
Get query logs.

**Query params:**
- `type` — Filter: `error`, `slow`
- `since` — Time: `1h`, `24h`, `7d`

### GET /tenants/{id}/logs/stats
Get log statistics.

### GET /tenants/{id}/metrics
Get performance metrics.

### GET /tenants/{id}/deployments
Get deployment history.

---

## Deployments

### GET /deployments
List all deployments.

### POST /deployments
Create deployment.

**Request:**
```json
{
  "blueprint_name": "myapp",
  "version": "v3",
  "deploy_all": true
}
```

### GET /deployments/{id}
Get deployment status.

---

## Admin

### POST /admin/query
Run query on tenant(s).

**Request:**
```json
{
  "tenant_id": "acme",
  "query": "SELECT * FROM accounts",
  "database_type": "PostgreSQL",
  "blueprint": "myapp",
  "all_tenants": false
}
```

---

## Webhooks

### POST /webhooks/vm-ready
VM provisioning callback (internal).