#!/bin/bash

DB_NAME="flaskdemo"
DB_USER="pgdba"
DB_PASS="devpw"

# Drop & recreate DB
echo "Dropping and recreating database '$DB_NAME'..."
sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS $DB_NAME;
DROP USER IF EXISTS $DB_USER;

CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';
CREATE DATABASE $DB_NAME OWNER $DB_USER;

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\c $DB_NAME

ALTER SCHEMA public OWNER TO $DB_USER;
GRANT ALL PRIVILEGES ON SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;
EOF

echo "✔️  Database and user setup complete."

# Activate virtualenv if needed
source venv/bin/activate

# Export DB URI to run migrations (optional if using .env)
export FLASK_APP=app.py

echo "🔧 Running migration..."
flask db migrate -m "Reset and rebuild"
flask db upgrade

echo "✅ Migration complete. Database is fresh and ready!"

