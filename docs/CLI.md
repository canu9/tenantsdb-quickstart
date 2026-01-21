# CLI Flow

Get started with TenantsDB using the command line.

---

## 1. Install CLI
```bash
curl -sSL get.tenantsdb.com | sh
```

## 2. Create Account
```bash
tdb signup --email you@company.com --password yourpassword --project "Demo"
```

## 3. Create Workspace
```bash
tdb workspaces create --name fintech --database PostgreSQL
```

## 4. Import Schema
```bash
tdb workspaces schema fintech --template fintech
```

Or use your own SQL file.

## 5. Create Tenants
```bash
tdb tenants create --name bank_a --blueprint fintech
tdb tenants create --name bank_b --blueprint fintech
```

## 6. Query Tenants
```bash
tdb query --tenant bank_a --query "SELECT * FROM accounts" --blueprint fintech
```
```bash
tdb query --tenant bank_b --query "SELECT * FROM accounts" --blueprint fintech
```

**Same query. Different data. Physical isolation.**

---

## All CLI Commands
```bash
tdb --help
```

See full reference: [CLI Reference](CLI-REFERENCE.md)