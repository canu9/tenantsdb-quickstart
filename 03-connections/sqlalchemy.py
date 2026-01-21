# TenantsDB + SQLAlchemy
# pip install sqlalchemy psycopg2-binary

import os
from sqlalchemy import create_engine, Column, Integer, String, Numeric
from sqlalchemy.orm import declarative_base, sessionmaker

# Get connection string from environment or replace directly
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://acme:xxx@pg.tenantsdb.com:5432/myapp__acme')

engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
Base = declarative_base()

class Account(Base):
    __tablename__ = 'accounts'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    balance = Column(Numeric(15, 2), default=0)

def main():
    session = Session()
    accounts = session.query(Account).all()
    for account in accounts:
        print(f"{account.name}: {account.balance}")
    session.close()

if __name__ == '__main__':
    main()