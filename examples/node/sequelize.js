// TenantsDB + Sequelize Example
// Connect to tenant database with Sequelize ORM

const { Sequelize, DataTypes } = require('sequelize');

// Replace with your tenant connection string
const CONNECTION_STRING = process.env.DATABASE_URL || 'postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme';

const sequelize = new Sequelize(CONNECTION_STRING);

// Define model
const Account = sequelize.define('Account', {
    name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    balance: {
        type: DataTypes.DECIMAL(15, 2),
        defaultValue: 0
    }
}, {
    tableName: 'accounts',
    timestamps: false
});

async function main() {
    try {
        // Test connection
        await sequelize.authenticate();
        console.log('Connected to tenant database');

        // Query accounts
        const accounts = await Account.findAll();
        console.log('Accounts:', JSON.stringify(accounts, null, 2));

    } catch (error) {
        console.error('Error:', error.message);
    } finally {
        await sequelize.close();
    }
}

main();