// TenantsDB + Prisma
// npm install @prisma/client

const { PrismaClient } = require('@prisma/client');

// Set DATABASE_URL in .env or environment
// DATABASE_URL="postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme"

const prisma = new PrismaClient();

async function main() {
    const accounts = await prisma.account.findMany();
    console.log(accounts);
}

main()
    .catch(console.error)
    .finally(() => prisma.$disconnect());