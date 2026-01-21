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
```json
{
  "success": true,
  "api_key": "tenantsdb_sk_xxx...",
  "project_id": "tdb_abc123"
}
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
API URL  https://api.tenantsdb.com    
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
      "id": 1,
      "key": "tenantsdb_sk_xxx...",
      "project_id": "tdb_2abf90d3",
      "project_name": "Default",
      "tier": "free",
      "is_active": true,
      "created_at": "2026-01-17T20:12:06Z",
      "last_used_at": "2026-01-21T19:28:38Z"
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
  "success": true,
  "count": 6,
  "workspaces": [
    {
      "id": "fintech",
      "name": "fintech",
      "database": "PostgreSQL",
      "version": "1.0",
      "created_at": 1768771909
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

### workspaces get

Get workspace.
```bash
tdb workspaces get <workspace_id>
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
  "success": true,
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
    }
  ]
}
```

### blueprints get

Get blueprint.
```bash
tdb blueprints get <blueprint_name>
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
  "success": true,
  "count": 2,
  "tenants": [
    {
      "tenant_id": "acme",
      "status": "active",
      "databases": [...]
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
| `--name` | ✅ | - | Tenant name |
| `--blueprint` | ✅ | - | Blueprint name |
| `--isolation` | ❌ | 1 | Isolation level (1 or 2) |

**Example:**
```bash
tdb tenants create --name acme --blueprint fintech --isolation 1
```

### tenants get

Get tenant details.
```bash
tdb tenants get <tenant_id>
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

### tenants metrics

Get tenant metrics.
```bash
tdb tenants metrics <tenant_id>
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
  "count": 5,
  "jobs": [
    {
      "job_id": "dep_231e",
      "blueprint_id": "fintech",
      "status": "completed",
      "progress": 100,
      "progress_display": "100%",
      "total_tenants": 1,
      "completed_tenants": 1,
      "failed_tenants": 0,
      "started_at": "2026-01-18T19:52:19Z",
      "completed_at": "2026-01-18T19:52:19Z"
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