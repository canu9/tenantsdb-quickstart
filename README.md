# TenantsDB Quickstart

Physical database isolation for multi-tenant SaaS. No `WHERE tenant_id` clauses. No noisy neighbors. No data leaks.

---

## Choose Your Path

**🖥️ CLI** — Quick demo, management  
→ [1-docs/CLI.md](1-docs/CLI.md)

**🌐 API** — HTTP integration, automation  
→ [1-docs/API.md](1-docs/API.md)

**🔌 Direct Connection** — Connect with native clients or ORMs  
→ [PostgreSQL](1-docs/POSTGRES.md) | [MySQL](1-docs/MYSQL.md) | [MongoDB](1-docs/MONGODB.md) | [Redis](1-docs/REDIS.md)

---

## Schemas

- `2-schemas/fintech.sql` — Banking (accounts, transactions, audit)
- `2-schemas/iot.sql` — IoT (devices, sensors, readings)

**Quick import:**
```bash
tdb workspaces schema <workspace_id> --template fintech
```

**Or run SQL directly:**
```bash
psql "CONNECTION_STRING" -f 2-schemas/fintech.sql
```

---

## Connection Examples

- `3-connections/sequelize.js` — Node.js Sequelize
- `3-connections/prisma.js` — Node.js Prisma
- `3-connections/sqlalchemy.py` — Python SQLAlchemy
- `3-connections/api.sh` — curl HTTP examples

---

## Links

- [Website](https://tenantsdb.com)
- [Documentation](https://docs.tenantsdb.com)

---

*The Stripe of Databases*