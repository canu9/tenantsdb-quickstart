# TenantsDB Quickstart

Physical database isolation for multi-tenant SaaS. No `WHERE tenant_id` clauses. No noisy neighbors. No data leaks.

---

## Choose Your Path

**🖥️ CLI** — Quick demo, management  
→ [01-docs/CLI.md](01-docs/CLI.md)

**🌐 API** — HTTP integration, automation  
→ [01-docs/API.md](01-docs/API.md)

**🔌 Direct Connection** — Connect with native clients or ORMs  
→ [PostgreSQL](01-docs/POSTGRES.md) | [MySQL](01-docs/MYSQL.md) | [MongoDB](01-docs/MONGODB.md) | [Redis](01-docs/REDIS.md)

---

## Schemas

- `02-schemas/fintech.sql` — Banking (accounts, transactions, audit)
- `02-schemas/iot.sql` — IoT (devices, sensors, readings)

**Quick import:**
```bash
tdb workspaces schema <workspace_id> --template fintech
```

**Or run SQL directly:**
```bash
psql "CONNECTION_STRING" -f 02-schemas/fintech.sql
```

---

## Connection Examples

- `03-connections/sequelize.js` — Node.js Sequelize
- `03-connections/prisma.js` — Node.js Prisma
- `03-connections/sqlalchemy.py` — Python SQLAlchemy
- `03-connections/api.sh` — curl HTTP examples

---

## Full References

- [04-references/CLI.md](04-references/CLI.md) — All CLI commands
- [04-references/API.md](04-references/API.md) — All API endpoints

---

## Links

- [Website](https://tenantsdb.com)
- [Documentation](https://docs.tenantsdb.com)

---

*The Stripe of Databases*