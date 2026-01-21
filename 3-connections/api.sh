#!/bin/bash
# TenantsDB API Examples
# Set TDB_API_KEY in environment or .env file

API_KEY="${TDB_API_KEY:-}"
BASE_URL="https://api.tenantsdb.com"

if [ -z "$API_KEY" ]; then
  echo "Error: TDB_API_KEY not set"
  exit 1
fi

# Health check
curl -s "$BASE_URL/health" | jq

# List workspaces
curl -s "$BASE_URL/workspaces" \
  -H "X-API-Key: $API_KEY" | jq

# Create workspace
curl -s -X POST "$BASE_URL/workspaces" \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "myapp", "database": "PostgreSQL"}' | jq

# List tenants
curl -s "$BASE_URL/tenants" \
  -H "X-API-Key: $API_KEY" | jq

# Create tenant
curl -s -X POST "$BASE_URL/tenants" \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"tenant_id": "acme", "databases": [{"blueprint": "myapp", "isolation_level": 1}]}' | jq

# Get tenant
curl -s "$BASE_URL/tenants/acme" \
  -H "X-API-Key: $API_KEY" | jq