#!/bin/bash
# Source: /reference/sandbox/utilities/exec/ — "Script in Existing Container
# (Remote Mode - Existing Container)".
# Wait for database to be ready
until pg_isready -U postgres; do
  echo "Waiting for database..."
  sleep 2
done

# Create tables
psql -U postgres -d myapp -c "
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
  );
"

echo "DB_INITIALIZED=true" >> $EXEC_OUTPUT
