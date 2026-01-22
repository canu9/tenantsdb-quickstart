# CLI Reference

Complete `tdb` command reference with examples.

---

## Global Flags

All commands support these flags:

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |
| `--quiet` | Minimal output |
| `--verbose` | Debug output |
| `--output <file>` | Save output to file |

---

## version

Print CLI version.
```bash
tdb version
```

**Response:**
```
tdb v1.0.1 (built 2026-01-02)
```

---

## signup

Create new account.
```bash
tdb signup --email <email> --password <password> [--project <name>]
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--email` | ✅ | - | Email address |
| `--password` | ✅ | - | Password (min 8 chars) |
| `--project` | ❌ | My Project | Project name |

**Example:**
```bash
tdb signup --email you@company.com --password secret123 --project "Demo"
```

**Response:**
```
✓ Account created!
✓ API key saved to ~/.tenantsdb.json
Project ID: tdb_abc123
```

---

## login

Login to existing account.
```bash
tdb login --email <email> --password <password>
```

| Flag | Required | Description |
|------|----------|-------------|
| `--email` | ✅ | Email address |
| `--password` | ✅ | Password |

---

## config

### config set

Set configuration.
```bash
tdb config set [--api-url <url>] [--api-key <key>]
```

| Flag | Description |
|------|-------------|
| `--api-url` | API URL |
| `--api-key` | API Key |

### config show

Show configuration.
```bash
tdb config show
```

**Response:**
```
KEY      VALUE                    
API URL  http://localhost:9876    
API Key  tenantsdb_sk_a91de15...  
```

---

## projects

### projects list

List projects.
```bash
tdb projects list [--json]
```

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

### projects create

Create project.
```bash
tdb projects create --name <name>
```

| Flag | Description |
|------|-------------|
| `--name` | Project name |

### projects delete

Delete project.
```bash
tdb projects delete <project_id>
```

---

## apikeys

### apikeys list

List API keys.
```bash
tdb apikeys list [--json]
```

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

### apikeys create

Create API key.
```bash
tdb apikeys create [--name <name>]
```

| Flag | Description |
|------|-------------|
| `--name` | Key name |

### apikeys delete

Delete API key.
```bash
tdb apikeys delete <key_id>
```

---

## workspaces

### workspaces list

List workspaces.
```bash
tdb workspaces list [--json]
```

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

### workspaces create

Create workspace.
```bash
tdb workspaces create --name <name> --database <type>
```

| Flag | Required | Description |
|------|----------|-------------|
| `--name` | ✅ | Workspace name |
| `--database` | ✅ | PostgreSQL, MySQL, MongoDB, Redis |

**Example:**
```bash
tdb workspaces create --name myapp --database PostgreSQL
```

**Response:**
```
✓ Workspace 'myapp' created
```

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

### workspaces get

Get workspace details.
```bash
tdb workspaces get <workspace_id> [--json]
```

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

### workspaces delete

Delete workspace.
```bash
tdb workspaces delete <workspace_id>
```

### workspaces query

Run query in workspace.
```bash
tdb workspaces query <workspace_id> --query <query>
```

| Flag | Description |
|------|-------------|
| `--query` | OQL or native query |

**Example:**
```bash
tdb workspaces query myapp --query "SELECT * FROM accounts"
```

### workspaces schema

Import schema to workspace.
```bash
tdb workspaces schema <workspace_id> [--template <name>] [--json <json>] [--database <conn>]
```

| Flag | Description |
|------|-------------|
| `--template` | Template name (ecommerce, saas, blog, fintech) |
| `--json` | JSON schema definition |
| `--database` | Database connection JSON for import |

**Example:**
```bash
tdb workspaces schema myapp --template fintech
```

### workspaces diff

Show workspace diff.
```bash
tdb workspaces diff <workspace_id>
```

### workspaces diff-skip

Skip DDL from deploy queue.
```bash
tdb workspaces diff-skip <workspace_id> <ddl_id>
```

### workspaces diff-revert

Revert DDL (undo change in workspace).
```bash
tdb workspaces diff-revert <workspace_id> <ddl_id>
```

### workspaces settings

Get workspace settings.
```bash
tdb workspaces settings <workspace_id>
```

### workspaces import-analyze

Analyze source database before import.
```bash
tdb workspaces import-analyze <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--host` | ✅ | - | Source database host |
| `--port` | ❌ | 5432 | Source database port |
| `--database` | ✅ | - | Source database name |
| `--user` | ✅ | - | Source database user |
| `--password` | ✅ | - | Source database password |
| `--type` | ❌ | postgresql | Database type (postgresql, mysql, mongodb) |
| `--routing-field` | ❌ | tenant_id | Routing field name |

**Example:**
```bash
tdb workspaces import-analyze myapp \
  --host localhost \
  --port 5432 \
  --database legacy_app \
  --user admin \
  --password secret \
  --routing-field company_id
```

**Error Response (invalid routing field):**
```
✗ Analysis failed
✗ Error: no table found with routing field 'invalid_field'
```

### workspaces import-data

Import data from external database.
```bash
tdb workspaces import-data <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--host` | ✅ | - | Source database host |
| `--port` | ❌ | 5432 | Source database port |
| `--database` | ✅ | - | Source database name |
| `--user` | ✅ | - | Source database user |
| `--password` | ✅ | - | Source database password |
| `--type` | ❌ | postgresql | Database type (postgresql, mysql, mongodb) |
| `--routing-field` | ❌ | tenant_id | Routing field name |
| `--drop-routing` | ❌ | true | Drop routing column after import |
| `--create-tenants` | ❌ | true | Auto-create tenants |

### workspaces import-full

Import schema and data from external database.
```bash
tdb workspaces import-full <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```

Same flags as `import-data`.

### workspaces import-status

Check import progress.
```bash
tdb workspaces import-status <workspace_id> --import-id <id>
```

| Flag | Required | Description |
|------|----------|-------------|
| `--import-id` | ✅ | Import job ID |

---

## blueprints

### blueprints list

List blueprints.
```bash
tdb blueprints list [--json]
```

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
      "deployed_to": null
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

### blueprints get

Get blueprint details.
```bash
tdb blueprints get <blueprint_name> [--json]
```

**Response:**
```json
{
  "success": true,
  "name": "fintech",
  "version": "1.0",
  "status": "draft",
  "database": "PostgreSQL",
  "workspace": "tdb_2abf90d3_fintech_dev",
  "created_at": "2026-01-21T20:42:37Z",
  "schema": {
    "type": "tables",
    "data": {
      "table_count": 0,
      "tables": null
    }
  },
  "deployment_status": {
    "deployed": false,
    "deployed_to_count": 0,
    "ready_to_deploy": false,
    "total_ddl_statements": 0
  }
}
```

### blueprints versions

List blueprint versions.
```bash
tdb blueprints versions <blueprint_name>
```

---

## tenants

### tenants list

List all tenants.
```bash
tdb tenants list [--json]
```

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

### tenants create

Create tenant.
```bash
tdb tenants create --name <name> --blueprint <blueprint> [--isolation <level>]
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--name` | ✅ | - | Tenant name (lowercase, numbers, underscores only) |
| `--blueprint` | ✅ | - | Blueprint name |
| `--isolation` | ❌ | 1 | Isolation level (1=shared, 2=dedicated) |

**Example:**
```bash
tdb tenants create --name acme --blueprint fintech
```

**Response:**
```
✓ Tenant 'acme' created
```

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

### tenants get

Get tenant details.
```bash
tdb tenants get <tenant_id> [--json]
```

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
    }
  ]
}
```

### tenants delete

Delete tenant.
```bash
tdb tenants delete <tenant_id> [--hard]
```

| Flag | Default | Description |
|------|---------|-------------|
| `--hard` | false | Permanently delete (no recovery) |

### tenants suspend

Suspend tenant.
```bash
tdb tenants suspend <tenant_id>
```

### tenants resume

Resume tenant.
```bash
tdb tenants resume <tenant_id>
```

### tenants restore

Restore soft-deleted tenant.
```bash
tdb tenants restore <tenant_id>
```

### tenants migrate

Migrate tenant isolation level.
```bash
tdb tenants migrate <tenant_id> --level <level>
```

| Flag | Required | Description |
|------|----------|-------------|
| `--level` | ✅ | Target isolation level (1=shared, 2=dedicated) |

### tenants backup

Backup tenant.
```bash
tdb tenants backup <tenant_id>
```

### tenants backups

List tenant backups.
```bash
tdb tenants backups <tenant_id>
```

### tenants rollback

Rollback tenant to backup.
```bash
tdb tenants rollback <tenant_id> [--date <date>] [--path <path>]
```

| Flag | Description |
|------|-------------|
| `--date` | Backup date (e.g., 2026-01-01) |
| `--path` | Storage path (from backups list) |

### tenants logs

Get tenant logs.
```bash
tdb tenants logs <tenant_id> [--type <type>] [--since <time>]
```

| Flag | Description |
|------|-------------|
| `--type` | Filter by type (error, slow) |
| `--since` | Time filter (1h, 24h, 7d) |

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

### tenants metrics

Get tenant metrics.
```bash
tdb tenants metrics <tenant_id> [--json]
```

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

### tenants deployments

List tenant deployments.
```bash
tdb tenants deployments <tenant_id>
```

---

## deployments

### deployments list

List deployments.
```bash
tdb deployments list [--json]
```

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

### deployments status

Get deployment status.
```bash
tdb deployments status <deployment_id>
```

### deployments create

Create deployment.
```bash
tdb deployments create --blueprint <name> [--version <version>] [--all]
```

| Flag | Description |
|------|-------------|
| `--blueprint` | Blueprint name |
| `--version` | Version to deploy |
| `--all` | Deploy to all tenants |

**Example:**
```bash
tdb deployments create --blueprint fintech --all
```

---

## query

Run direct query on tenant(s).
```bash
tdb query --query <query> --blueprint <blueprint> [--tenant <id>] [--all] [--type <type>]
```

| Flag | Required | Default | Description |
|------|----------|---------|-------------|
| `--tenant` | ✅* | - | Tenant ID |
| `--query` | ✅ | - | OQL or native query |
| `--type` | ❌ | PostgreSQL | Database type |
| `--blueprint` | ✅ | - | Blueprint name |
| `--all` | ✅* | false | Query all tenants |

*Either `--tenant` or `--all` required.

**Example:**
```bash
tdb query --tenant acme --query "SELECT * FROM accounts" --blueprint fintech
```