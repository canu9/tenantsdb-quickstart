# CLI Reference

Full list of `tdb` commands.

---

## Global Flags

| Flag | Description |
|------|-------------|
| `--json` | Output as JSON |
| `--quiet` | Minimal output |
| `--verbose` | Debug output |
| `--output <file>` | Save output to file |

---

## Authentication

### version
```bash
tdb version
```
Print CLI version.

### signup
```bash
tdb signup --email <email> --password <password> --project <name>
```
Create new account.

| Flag | Required | Description |
|------|----------|-------------|
| `--email` | ✅ | Email address |
| `--password` | ✅ | Password (min 8 chars) |
| `--project` | ❌ | Project name (default: "My Project") |

### login
```bash
tdb login --email <email> --password <password>
```
Login to existing account.

---

## Config

### config set
```bash
tdb config set --api-url <url> --api-key <key>
```
Set configuration.

### config show
```bash
tdb config show
```
Show current configuration.

---

## Projects

### projects list
```bash
tdb projects list
```
List all projects.

### projects create
```bash
tdb projects create --name <name>
```
Create new project.

### projects delete
```bash
tdb projects delete <project_id>
```
Delete project.

---

## API Keys

### apikeys list
```bash
tdb apikeys list
```
List all API keys.

### apikeys create
```bash
tdb apikeys create --name <name>
```
Create new API key.

### apikeys delete
```bash
tdb apikeys delete <key_id>
```
Delete API key.

---

## Workspaces

### workspaces list
```bash
tdb workspaces list
```
List all workspaces.

### workspaces create
```bash
tdb workspaces create --name <name> --database <type>
```
Create workspace.

| Flag | Required | Options |
|------|----------|---------|
| `--name` | ✅ | Workspace name |
| `--database` | ✅ | PostgreSQL, MySQL, MongoDB, Redis |

### workspaces get
```bash
tdb workspaces get <workspace_id>
```
Get workspace details.

### workspaces delete
```bash
tdb workspaces delete <workspace_id>
```
Delete workspace.

### workspaces query
```bash
tdb workspaces query <workspace_id> --query <query>
```
Run query in workspace.

### workspaces schema
```bash
tdb workspaces schema <workspace_id> --template <name>
```
Import schema from template.

| Flag | Description |
|------|-------------|
| `--template` | Template name (ecommerce, saas, blog, fintech) |
| `--json` | JSON schema definition |
| `--database` | Database connection JSON |

### workspaces diff
```bash
tdb workspaces diff <workspace_id>
```
Show pending DDL changes.

### workspaces diff-skip
```bash
tdb workspaces diff-skip <workspace_id> <ddl_id>
```
Skip DDL from deploy queue.

### workspaces diff-revert
```bash
tdb workspaces diff-revert <workspace_id> <ddl_id>
```
Revert DDL change.

### workspaces settings
```bash
tdb workspaces settings <workspace_id>
```
Get workspace settings.

### workspaces import-analyze
```bash
tdb workspaces import-analyze <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```
Analyze source database before import.

| Flag | Required | Description |
|------|----------|-------------|
| `--host` | ✅ | Source database host |
| `--port` | ❌ | Source database port (default: 5432) |
| `--database` | ✅ | Source database name |
| `--user` | ✅ | Source database user |
| `--password` | ✅ | Source database password |
| `--type` | ❌ | postgresql, mysql, mongodb (default: postgresql) |
| `--routing-field` | ❌ | Routing field name (default: tenant_id) |

### workspaces import-data
```bash
tdb workspaces import-data <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```
Import data from external database.

| Flag | Required | Description |
|------|----------|-------------|
| `--host` | ✅ | Source database host |
| `--database` | ✅ | Source database name |
| `--user` | ✅ | Source database user |
| `--password` | ✅ | Source database password |
| `--routing-field` | ❌ | Routing field (default: tenant_id) |
| `--drop-routing` | ❌ | Drop routing column after import (default: true) |
| `--create-tenants` | ❌ | Auto-create tenants (default: true) |

### workspaces import-full
```bash
tdb workspaces import-full <workspace_id> --host <host> --database <db> --user <user> --password <pass>
```
Import schema and data from external database.

### workspaces import-status
```bash
tdb workspaces import-status <workspace_id> --import-id <id>
```
Check import progress.

---

## Blueprints

### blueprints list
```bash
tdb blueprints list
```
List all blueprints.

### blueprints get
```bash
tdb blueprints get <blueprint_name>
```
Get blueprint schema.

### blueprints versions
```bash
tdb blueprints versions <blueprint_name>
```
List blueprint versions.

---

## Tenants

### tenants list
```bash
tdb tenants list
```
List all tenants.

### tenants create
```bash
tdb tenants create --name <name> --blueprint <blueprint> --isolation <level>
```
Create tenant.

| Flag | Required | Description |
|------|----------|-------------|
| `--name` | ✅ | Tenant ID |
| `--blueprint` | ✅ | Blueprint name |
| `--isolation` | ❌ | 1 (shared) or 2 (dedicated) |

### tenants get
```bash
tdb tenants get <tenant_id>
```
Get tenant details and connection strings.

### tenants delete
```bash
tdb tenants delete <tenant_id>
tdb tenants delete <tenant_id> --hard
```
Delete tenant. Use `--hard` for permanent deletion.

### tenants suspend
```bash
tdb tenants suspend <tenant_id>
```
Suspend tenant.

### tenants resume
```bash
tdb tenants resume <tenant_id>
```
Resume suspended tenant.

### tenants restore
```bash
tdb tenants restore <tenant_id>
```
Restore soft-deleted tenant.

### tenants migrate
```bash
tdb tenants migrate <tenant_id> --level <level>
```
Migrate tenant isolation level.

| Flag | Required | Description |
|------|----------|-------------|
| `--level` | ✅ | 1 (shared) or 2 (dedicated) |

### tenants backup
```bash
tdb tenants backup <tenant_id>
```
Trigger backup.

### tenants backups
```bash
tdb tenants backups <tenant_id>
```
List tenant backups.

### tenants rollback
```bash
tdb tenants rollback <tenant_id> --date <date>
tdb tenants rollback <tenant_id> --path <s3_path>
```
Rollback tenant to backup.

### tenants logs
```bash
tdb tenants logs <tenant_id>
tdb tenants logs <tenant_id> --type error --since 24h
```
Get tenant logs.

| Flag | Description |
|------|-------------|
| `--type` | Filter: error, slow |
| `--since` | Time: 1h, 24h, 7d |

### tenants metrics
```bash
tdb tenants metrics <tenant_id>
```
Get tenant metrics.

### tenants deployments
```bash
tdb tenants deployments <tenant_id>
```
List tenant deployment history.

---

## Deployments

### deployments list
```bash
tdb deployments list
```
List all deployments.

### deployments create
```bash
tdb deployments create --blueprint <name> --all
```
Create deployment.

| Flag | Description |
|------|-------------|
| `--blueprint` | Blueprint name |
| `--version` | Specific version (optional) |
| `--all` | Deploy to all tenants |

### deployments status
```bash
tdb deployments status <deployment_id>
```
Get deployment status.

---

## Query

### query
```bash
tdb query --tenant <id> --query <query> --blueprint <name>
tdb query --all --query <query> --blueprint <name>
```
Run direct query on tenant(s).

| Flag | Required | Description |
|------|----------|-------------|
| `--tenant` | ✅* | Tenant ID |
| `--query` | ✅ | OQL or native query |
| `--blueprint` | ✅ | Blueprint name |
| `--type` | ❌ | PostgreSQL, MySQL, MongoDB, Redis |
| `--all` | ✅* | Query all tenants |

*Either `--tenant` or `--all` required.