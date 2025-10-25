#!/usr/bin/env bash
set -euo pipefail

DB="alx_airbnb_database"
SCHEMA="schema.sql"

echo "Checking if database '$DB' exists..."
if psql -lqt | cut -d '|' -f 1 | awk '{$1=$1};1' | grep -qx "$DB"; then
  echo "Database '$DB' already exists."
else
  echo "Creating database '$DB'..."
  createdb "$DB"
fi

echo "Applying schema from '$SCHEMA'..."
psql -d "$DB" -f "$SCHEMA"

echo "✅ Database initialization complete!"
