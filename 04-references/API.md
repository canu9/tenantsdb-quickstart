# API Reference

Full list of REST API endpoints.

Base URL: `https://api.tenantsdb.com`

---

## Authentication

All endpoints (except `/signup` and `/login`) require header:
```
Authorization: Bearer YOUR_API_KEY
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
  "api_key": "tenantsdb_sk_xxxxxxxxxxxx",
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
      "api_key": "tenantsdb_sk_xxxxxxxxxxxx"
    }
  ]
}
```

---

## Projects

### GET /projects
List all projects.

**Response:**
```json
{
  "success": true,
  "count": 2,
  "projects": [
    {
      "project_id": "tdb_2abf90d3",
      "name": "Healthcare SaaS",
      "api_key_count": 2,
      "created_at": "2026-01-17T20:12:06Z"
    },
    {
      "project_id": "tdb_43cd4942",
      "name": "E-commerce Platform",
      "api_key_count": 1,
      "created_at": "2026-01-17T20:12:24Z"
    }
  ]
}
```

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

**Response:**
```json
{
  "success": true,
  "count": 2,
  "api_keys": [
    {
      "id": 3,
      "key": "tenantsdb_sk_3cc032060bb9984af05f7a1d172c92917da41f528cd8b6c87e8cf0439ff7d501",
      "project_id": "tdb_2abf90d3",
      "project_name": "CI Pipeline",
      "tier": "free",
      "is_active": true,
      "created_at": "2026-01-17T20:26:07Z"
    },
    {
      "id": 1,
      "key": "tenantsdb_sk_a91de15692a7219f08c1619ef72039df8e77398a7828187d4921f5c296897c5c",
      "project_id": "tdb_2abf90d3",
      "project_name": "Default",
      "tier": "free",
      "is_active": true,
      "created_at": "2026-01-17T20:12:06Z",
      "last_used_at": "2026-01-22T18:59:13Z"
    }
  ]
}
```

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

**Response:**
```json
{
  "count": 7,
  "success": true,
  "workspaces": [
    {
      "created_at": 1768982386,
      "database": "MongoDB",
      "id": "final-mongo",
      "name": "final-mongo",
      "version": "1.0"
    },
    {
      "created_at": 1768982385,
      "database": "MySQL",
      "id": "final-mysql",
      "name": "final-mysql",
      "version": "1.0"
    },
    {
      "created_at": 1768771909,
      "database": "PostgreSQL",
      "id": "fintech",
      "name": "fintech",
      "version": "1.0"
    }
  ]
}
```

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
  "id": "myapp",
  "blueprint": "myapp",
  "database": "PostgreSQL",
  "message": "Workspace 'myapp' created. Connect via proxy to build your schema.",
  "connection": {
    "host": "pg.tenantsdb.com",
    "port": 5432,
    "database": "myapp_dev",
    "user": "tdb_2abf90d3",
    "password": "tdb_d2bf66ed7898c448"
  },
  "connection_string": "postgresql://tdb_2abf90d3:tdb_d2bf66ed7898c448@pg.tenantsdb.com:5432/myapp_dev"
}
```

### GET /workspaces/{id}
Get workspace details.

**Response:**
```json
{
  "success": true,
  "id": "fintech",
  "name": "fintech",
  "version": "1.0",
  "database": "PostgreSQL",
  "schema": {
    "type": "tables",
    "data": {
      "table_count": 0,
      "tables": null
    }
  },
  "undeployed_changes": 0,
  "connection": {
    "host": "pg.tenantsdb.com",
    "port": 5432,
    "database": "fintech_dev",
    "user": "tdb_2abf90d3",
    "password": "tdb_d2bf66ed7898c448"
  },
  "connection_string": "postgresql://tdb_2abf90d3:tdb_d2bf66ed7898c448@pg.tenantsdb.com:5432/fintech_dev"
}
```

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

**Response:**
```json
{
  "blueprints": [
    {
      "id": "tdb_2abf90d3_fintech_v1_0",
      "name": "fintech",
      "version": "1.0",
      "workspace_id": "tdb_2abf90d3_fintech_dev",
      "database_type": "PostgreSQL",
      "project_id": "tdb_2abf90d3",
      "created_at": 1768771909,
      "deployed_to": [
        "acme"
      ]
    },
    {
      "id": "tdb_2abf90d3_final-mysql_v1_0",
      "name": "final-mysql",
      "version": "1.0",
      "workspace_id": "tdb_2abf90d3_final-mysql_dev",
      "database_type": "MySQL",
      "project_id": "tdb_2abf90d3",
      "created_at": 1768982385,
      "deployed_to": null
    }
  ],
  "success": true
}
```

### GET /blueprints/{name}
Get blueprint schema.

### GET /blueprints/{name}/versions
List blueprint versions.

---

## Tenants

### GET /tenants
List all tenants.

**Response:**
```json
{
  "count": 1,
  "success": true,
  "tenants": [
    {
      "created_at": "2026-01-21T20:55:11.169386Z",
      "databases": [
        {
          "blueprint": "fintech",
          "database_type": "PostgreSQL"
        },
        {
          "blueprint": "legacy-import-mysql",
          "database_type": "MySQL"
        }
      ],
      "status": "ready",
      "tenant_id": "acme"
    }
  ]
}
```

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
  "tenant_id": "acme",
  "status": "ready",
  "databases": [
    {
      "blueprint": "fintech",
      "database_type": "PostgreSQL",
      "isolation_level": 1,
      "connection": {
        "database": "fintech__acme",
        "connection_string": "postgresql://tdb_2abf90d3:tdb_d2bf66ed7898c448@pg.tenantsdb.com:5432/fintech__acme"
      }
    }
  ]
}
```

### GET /tenants/{id}
Get tenant details.

**Response:**
```json
{
  "success": true,
  "tenant_id": "acme",
  "status": "ready",
  "databases": [
    {
      "blueprint": "fintech",
      "database_type": "PostgreSQL",
      "isolation_level": 1,
      "connection": {
        "database": "fintech__acme",
        "connection_string": "postgresql://tdb_2abf90d3:tdb_d2bf66ed7898c448@pg.tenantsdb.com:5432/fintech__acme"
      }
    },
    {
      "blueprint": "legacy-import-mysql",
      "database_type": "MySQL",
      "isolation_level": 1,
      "connection": {
        "database": "legacy-import-mysql__acme",
        "connection_string": "mysql://tdb_2abf90d3:tdb_d2bf66ed7898c448@mysql.tenantsdb.com:3306/legacy-import-mysql__acme"
      }
    },
    {
      "blueprint": "legacy-import-mongo",
      "database_type": "MongoDB",
      "isolation_level": 1,
      "connection": {
        "database": "legacy-import-mongo__acme",
        "connection_string": "mongodb://tdb_2abf90d3:tdb_d2bf66ed7898c448@mongo.tenantsdb.com:27017/legacy-import-mongo__acme?authMechanism=PLAIN&directConnection=true"
      }
    }
  ]
}
```

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

**Response:**
```json
{
  "success": true,
  "tenant_id": "acme",
  "logs": [],
  "count": 0,
  "has_more": false
}
```

### GET /tenants/{id}/logs/stats
Get log statistics.

### GET /tenants/{id}/metrics
Get performance metrics.

**Response:**
```json
{
  "success": true,
  "tenant_id": "acme",
  "isolation_level": 1,
  "database_type": "PostgreSQL",
  "query_metrics": {
    "queries_today": 0,
    "queries_this_hour": 0,
    "queries_this_week": 0,
    "avg_latency_ms": 0,
    "max_latency_ms": 0,
    "success_rate": 100,
    "failed_queries": 0,
    "slow_queries": 0
  },
  "database_metrics": {
    "note": "Storage and connection metrics only available for L2 (dedicated) tenants"
  }
}
```

### GET /tenants/{id}/deployments
Get deployment history.

---

## Deployments

### GET /deployments
List all deployments.

**Response:**
```json
{
  "success": true,
  "count": 6,
  "jobs": [
    {
      "job_id": "dep_fc60",
      "blueprint_id": "fintech",
      "status": "completed",
      "progress": 100,
      "progress_display": "100%",
      "total_tenants": 1,
      "completed_tenants": 1,
      "failed_tenants": 0,
      "started_at": "2026-01-21T20:55:11Z",
      "completed_at": "2026-01-21T20:55:11Z"
    }
  ]
}
```

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