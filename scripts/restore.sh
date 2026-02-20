#!/bin/bash
set -e

# Resolve project root (scripts/ is one level below)
OTTO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$OTTO_DIR"

COMPOSE_RUN="$OTTO_DIR/docker-compose.yml"
COMPOSE_DEV="$OTTO_DIR/docker-compose.dev.yml"

if [ -z "$1" ]; then
  echo "Usage: $0 <path-to-backup-directory>"
  exit 1
fi

BACKUP_DIR=$1

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup directory not found: $BACKUP_DIR"
  exit 1
fi

echo "Restoring from $BACKUP_DIR..."

# Stop services
echo "Stopping services..."
docker compose -f "$COMPOSE_RUN" down 2>/dev/null || true
docker compose -f "$COMPOSE_DEV" down 2>/dev/null || true

# Restore SQLite data
if [ -f "$BACKUP_DIR/sqlite_data.tar.gz" ]; then
  echo "Restoring SQLite data..."
  tar -xzf "$BACKUP_DIR/sqlite_data.tar.gz" -C .
  echo "  SQLite data restored"
fi

# Restore .env
if [ -f "$BACKUP_DIR/.env" ]; then
  echo "Restoring environment configuration..."
  cp "$BACKUP_DIR/.env" .env
  echo "  .env restored"
fi

# Restore Redis (start Redis, copy dump, restart)
if [ -f "$BACKUP_DIR/redis_dump.rdb" ]; then
  echo "Restoring Redis data..."
  cp "$BACKUP_DIR/redis_dump.rdb" data/redis/dump.rdb 2>/dev/null || true
  echo "  Redis dump copied to data/redis/"
fi

echo "Restore complete. Run 'make dev' or 'make start' to start Otto."
