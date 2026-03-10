#!/bin/bash
set -e

# Wait for the database to become ready
echo "Waiting for database connection..."
until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
  sleep 2
done
echo "Database is ready."

# Ensure writable directories exist and have correct ownership for the web server
mkdir -p /var/www/html/Include
mkdir -p /var/www/html/Images/Family
mkdir -p /var/www/html/Images/Person

chown -R www-data:www-data /var/www/html/Include
chown -R www-data:www-data /var/www/html/Images

# Start Apache
exec "$@"