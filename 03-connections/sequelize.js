// TenantsDB + Sequelize
// npm install sequelize pg

const { Sequelize, DataTypes } = require('sequelize');

// Get connection string from environment or replace directly
const DATABASE_URL = process.env.DATABASE_URL || 'postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme';

const sequelize = new Sequelize(DATABASE_URL);

const Account = sequelize.define('Account', {
    name: { type: DataTypes.STRING, allowNull: false },
    balance: { type: DataTypes.DECIMAL(15, 2), defaultValue: 0 }
}, { tableName: 'accounts', timestamps: false });

async function main() {
    await sequelize.authenticate();
    console.log('Connected');

    const accounts = await Account.findAll();
    console.log(accounts);

    await sequelize.close();
}

main();