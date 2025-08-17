# Docker Services Starter

A ready-to-run Docker Compose setup that provisions common data services for local development:

- MySQL 8.0
- PostgreSQL 16 (alpine)
- MongoDB 6.0
- Redis 7 (alpine)

Includes sensible defaults, persistent named volumes, healthchecks, and initialization scripts to create multiple databases and users.

> Current local date/time: 2025-08-17 11:59

## Contents
- What you get
- Prerequisites
- Quick start
- Services overview (ports, users, passwords)
- Data persistence
- Directory structure
- Useful commands
- Troubleshooting
- Security notes and customization

## What you get
- One-command spin-up of four popular services for microservice development.
- Initialization of multiple databases across MySQL and PostgreSQL.
- A MongoDB init script that creates a user, collection, and index.
- A production-leaning Redis configuration file (tunable for dev/prod).

## Prerequisites
- Docker (Desktop or Engine) 20.10+
- Docker Compose v2 (bundled with modern Docker Desktop) or `docker compose` plugin

Verify:
- `docker --version`
- `docker compose version`

## Quick start
1) Start all services in the background
- `docker compose up -d`

2) Check status
- `docker compose ps`

3) Tail logs (example: MySQL)
- `docker compose logs -f mysql`

4) Stop everything
- `docker compose down`

If you also want to remove persistent data volumes (DANGER: deletes data):
- `docker compose down -v`

## Services overview
All services are attached to the `app-network` bridge network and expose default ports on the host.

- MySQL 8.0
  - Host/Port: localhost:3306
  - Root user: `root`
  - Root password: `password`
  - App user: `dev_user` / `dev_password`
  - Databases created: `onboarding`, `kyc_verification`, `customer`, `document`, `notification`, `tokenization`, `account`
  - Data volume: `mysql_data`

- PostgreSQL 16 (alpine)
  - Host/Port: localhost:5432
  - Superuser: `admin` / `password`
  - App user: `dev_user` / `dev_password`
  - Databases created: `onboarding`, `customer`, `kyc_verification`, `account`, `notification`, `document`, `tokenization`
  - Data volume: `pg_data`

- MongoDB 6.0
  - Host/Port: localhost:27017
  - Root user: `dev_user` / `dev_password`
  - Default DB: `local`
  - Init creates user: `tokenization_user` / `tokenization_password` with readWrite on `local`
  - Collection: `tokenization_records` with unique index on `id`
  - Data volumes: `mongodb-data`, `mongodb-config`

- Redis 7 (alpine)
  - Host/Port: localhost:6379
  - Requires password: `PASSWORD` (set via command in docker-compose)
  - Data volume: `redis_data`

Note: Credentials above are for local development only. Change them before using in any non-local environment.

## Data persistence
Each service uses a named volume to persist data between container restarts:
- MySQL: `mysql_data`
- PostgreSQL: `pg_data`
- MongoDB: `mongodb-data` and `mongodb-config`
- Redis: `redis_data`

To completely reset a service’s data, stop the stack and remove the related volume(s):
- `docker compose down`
- `docker volume rm docker-services_mysql_data` (or the actual volume name shown by `docker volume ls`)

## Directory structure
```
.
├── docker-compose.yml
├── init-db
│   ├── mongo-init.js
│   ├── mysql-init.sql
│   └── postgres-init.sql
└── redis
    └── redis-conf
        └── redis.conf
```

## Useful commands
- Start all services: `docker compose up -d`
- Start a single service: `docker compose up -d mysql`
- View logs: `docker compose logs -f <service>`
- Exec into a container (bash/sh): `docker compose exec <service> sh`
- Stop: `docker compose down`
- Stop and remove volumes: `docker compose down -v`
- List containers: `docker compose ps`

Client connection examples:
- MySQL CLI:
  - `mysql -h 127.0.0.1 -P 3306 -u root -p` (password: `password`)
  - `mysql -h 127.0.0.1 -P 3306 -u dev_user -p` (password: `dev_password`)
- PostgreSQL CLI:
  - `psql -h 127.0.0.1 -p 5432 -U admin -d postgres` (password: `password`)
  - `psql -h 127.0.0.1 -p 5432 -U dev_user -d onboarding` (password: `dev_password`)
- MongoDB Shell (mongosh):
  - `mongosh --username dev_user --password dev_password --authenticationDatabase admin local`
  - For app user: `mongosh --username tokenization_user --password tokenization_password local`
- Redis CLI:
  - `redis-cli -h 127.0.0.1 -p 6379 -a PASSWORD ping`

## Troubleshooting
- Port already in use
  - Error like “port is already allocated”: Another local DB/Redis is running.
  - Stop the conflicting service or change host port mappings in docker-compose.yml.

- Healthcheck failing
  - Give services time on first run as databases initialize and run init scripts.
  - Check logs: `docker compose logs -f <service>`
  - For Redis, remember to authenticate when testing: `redis-cli -a PASSWORD ping`.

- Initialization scripts did not run
  - Init scripts run only on first container start with an empty data directory.
  - If containers already have data, remove the respective volume(s) and start again.

- Authentication errors
  - Ensure you’re using the correct username/password and, for MongoDB, the correct authentication database (often `admin`).

## Security notes and customization
- Change all default passwords before using beyond local development:
  - MySQL: `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`
  - PostgreSQL: `POSTGRES_PASSWORD`, update passwords in `init-db/postgres-init.sql` as needed
  - MongoDB: environment variables and user/password in `init-db/mongo-init.js`
  - Redis: replace `--requirepass PASSWORD` with a stronger secret (and consider env/secret management)
- Consider moving secrets into a `.env` file and referencing them from docker-compose.yml.
- Review and adjust Redis `redis.conf` for your workload (maxmemory, eviction policy, AOF, etc.).

## License
This repository is provided as-is for educational and local development purposes. Add your preferred license if publishing.
