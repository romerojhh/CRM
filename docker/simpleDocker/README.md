# ChurchCRM Docker Setup

This repository provides a simple **Docker Compose setup** to run **ChurchCRM** with a **MariaDB database** and optional tools for backups and database management.

The stack includes:

* **ChurchCRM** web application
* **MariaDB** database
* Optional **Adminer** database management UI

---

# Quick Start

### 1. Start the containers

Run the following command in the project directory:

```bash
docker compose up -d
```

This will start the following services:

| Service            | Description             | Port          |
| ------------------ | ----------------------- | ------------- |
| churchcrm_web      | ChurchCRM web interface | 8080          |
| churchcrm_db       | MariaDB database        | internal only |
| adminer (optional) | Database management UI  | 8081          |

---

### 2. Open ChurchCRM

Navigate to:

```
http://YOUR_SERVER_IP:8080
```

You will see the ChurchCRM installation page.

---

# Database Configuration

When prompted during installation, enter the following values:

| Setting       | Value                                                              |
| ------------- | ------------------------------------------------------------------ |
| Database Host | `db`                                                               |
| Database Name | `churchcrm`                                                        |
| Username      | `churchcrmuser`                                                    |
| Password      | Value of `MYSQL_PASSWORD` in `.env` (default: `StrongUserPass123`) |

Example:

```
Database Host: db
Database Name: churchcrm
Username: churchcrmuser
Password: StrongUserPass123
```

---

# Default Login

After installation completes, log in with:

```
Username: admin
Password: changeme
```

⚠️ **Important:** Change this password immediately after logging in.

---

# Environment Variables

The `.env` file controls database credentials.

Example `.env`:

```
MYSQL_ROOT_PASSWORD=StrongRootPass123
MYSQL_PASSWORD=StrongUserPass123
CHURCHCRM_VERSION=7.0.2
```

You should change these values before deploying to production.

---

# Optional Features

## Automatic Nightly Database Backup

You can configure automatic backups using **cron**.

### 1. Open the cron editor

```bash
crontab -e
```

### 2. Add this job

```
0 2 * * * docker exec churchcrm_db mariadb-dump -uroot -pStrongRootPass123 churchcrm | gzip > ~/backups/churchcrm_$(date +\%F).sql.gz
```

This will:

* Run **every night at 2 AM**
* Export the database
* Compress it with `gzip`
* Save it to `~/backups/`

Example backup file:

```
churchcrm_2026-03-09.sql.gz
```

---

# Database Management (Adminer)

An optional **Adminer** interface is available to manage the database.

Open:

```
http://YOUR_SERVER_IP:8081
```

Login settings:

| Field    | Value                    |
| -------- | ------------------------ |
| System   | MariaDB                  |
| Server   | db                       |
| Username | churchcrmuser            |
| Password | Same as `MYSQL_PASSWORD` |
| Database | churchcrm                |

Adminer allows you to:

* Browse tables
* Run SQL queries
* Import/export databases
* Manage users

---

# Useful Commands

### View running containers

```bash
docker ps
```

### View logs

```bash
docker logs churchcrm_web
docker logs churchcrm_db
```

### Restart services

```bash
docker compose restart
```

### Stop services

```bash
docker compose down
```

---

# Troubleshooting

### Database connection error

Ensure the database host is:

```
db
```

Not:

```
localhost
```

Docker containers communicate using service names.

---

### Check database health

```bash
docker inspect churchcrm_db
```

---

# License

This setup is provided as an example deployment for ChurchCRM using Docker.
