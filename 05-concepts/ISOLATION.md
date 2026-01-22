# Isolation Levels

TenantsDB offers two isolation levels for tenant databases.

---

## Overview

| Level | Name | Description |
|:------|:-----|:------------|
| **Isolation Level 1** | Pooled Instance | Tenants share database server, separate databases |
| **Isolation Level 2** | Dedicated Instance | Each tenant gets own VM and database server |

> **Note:** "Pooled Instance" means tenants share the database **server** — each tenant still has their own **database** with complete data isolation. Your data is never mixed with other tenants.

Throughout this doc, we use "L1" and "L2" as shorthand for Isolation Level 1 and Isolation Level 2.

---

## Isolation Level 1: Pooled Instance

```
┌─────────────────────────────────────────────────────┐
│ PostgreSQL Server (pooled)                          │
├─────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │
│ │ myapp__acme │ │myapp__globex│ │ myapp__wayne│    │
│ │  (database) │ │  (database) │ │  (database) │    │
│ └─────────────┘ └─────────────┘ └─────────────┘    │
└─────────────────────────────────────────────────────┘
```

**How it works:**
- All tenants on same database server
- Each tenant has own database (data isolation)
- Server resources (CPU, memory, disk I/O) are pooled

**Pros:**
- Instant provisioning
- Lower cost
- Efficient resource usage

**Cons:**
- Noisy neighbor risk (one tenant's load affects others)
- Server performance limits apply to all
- No per-tenant resource guarantees

**Best for:**
- Free/trial tiers
- Low-traffic tenants
- Development environments
- Cost-sensitive deployments

---

## Isolation Level 2: Dedicated Instance

```
┌─────────────────────┐  ┌─────────────────────┐
│ VM: acme            │  │ VM: globex          │
│ ┌─────────────────┐ │  │ ┌─────────────────┐ │
│ │ PostgreSQL      │ │  │ │ PostgreSQL      │ │
│ │ ┌─────────────┐ │ │  │ │ ┌─────────────┐ │ │
│ │ │ myapp__acme │ │ │  │ │ │myapp__globex│ │ │
│ │ └─────────────┘ │ │  │ │ └─────────────┘ │ │
│ └─────────────────┘ │  │ └─────────────────┘ │
└─────────────────────┘  └─────────────────────┘
```

**How it works:**
- Each tenant gets dedicated VM
- Own database server instance
- Isolated CPU, memory, disk

**Pros:**
- Guaranteed resources
- No noisy neighbors
- Better security isolation
- Predictable performance

**Cons:**
- Provisioning takes 2-5 minutes
- Higher cost per tenant
- More infrastructure overhead

**Best for:**
- Enterprise/premium tiers
- High-traffic tenants
- Compliance requirements (data isolation)
- SLA-backed deployments

---

## Comparison

| Aspect | L1 (Pooled) | L2 (Dedicated) |
|:-------|:------------|:---------------|
| Provisioning | Instant | 2-5 minutes |
| Cost | $ | $$$ |
| Performance | Pooled | Guaranteed |
| Data Isolation | ✅ Database-level | ✅ VM-level |
| Resource Isolation | ❌ Shared server | ✅ Own server |
| Noisy neighbor | Possible | None |
| Compliance | Standard | Enterprise |

---

## Creating Tenants

**Isolation Level 1 (default):**
```bash
tdb tenants create --name acme --blueprint myapp
```

**Isolation Level 2:**
```bash
tdb tenants create --name acme --blueprint myapp --isolation 2
```

**API:**
```json
{
  "tenant_id": "acme",
  "databases": [
    {
      "blueprint": "myapp",
      "isolation_level": 2
    }
  ]
}
```

---

## Migrating Between Levels

### L1 → L2 (Upgrade to Dedicated)

```bash
tdb tenants migrate acme --level 2
```

**What happens:**
1. Snapshot current database
2. Provision new VM
3. Restore data to dedicated instance
4. Update routing
5. Tenant status: `migrating` → `ready`

**Downtime:** ~2-5 minutes

### L2 → L1 (Downgrade to Pooled)

```bash
tdb tenants migrate acme --level 1
```

**What happens:**
1. Snapshot dedicated database
2. Restore to pooled server
3. Terminate VM
4. Update routing

**Downtime:** ~1-2 minutes

---

## Checking Isolation Level

**CLI:**
```bash
tdb tenants get acme --json
```

**Response:**
```json
{
  "tenant_id": "acme",
  "databases": [
    {
      "blueprint": "myapp",
      "isolation_level": 1,
      "connection": {...}
    }
  ]
}
```

| Value | Meaning |
|:------|:--------|
| `isolation_level: 1` | Pooled Instance |
| `isolation_level: 2` | Dedicated Instance |

---

## Pricing Guidance

| Tier | Recommended Level | Why |
|:-----|:------------------|:----|
| Free | L1 (Pooled) | Cost efficiency |
| Starter | L1 (Pooled) | Most small apps don't need dedicated resources |
| Pro | L1 or L2 | Depends on traffic and requirements |
| Enterprise | L2 (Dedicated) | Compliance, SLAs, guaranteed performance |

---

## FAQ

**Q: Can I mix L1 and L2 tenants?**
A: Yes. Each tenant can have different isolation level.

**Q: Is my data mixed with other tenants in L1?**
A: No. Each tenant has their own database. "Pooled" refers to the server resources, not the data.

**Q: Does migration cause data loss?**
A: No. Data is snapshotted and restored.

**Q: Can I automate upgrades based on usage?**
A: Not yet. Manual migration via CLI/API.

**Q: Are connection strings the same after migration?**
A: Yes. The proxy handles routing transparently.