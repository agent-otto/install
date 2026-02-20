#!/bin/bash
set -e

# Resolve project root (scripts/ is one level below)
OTTO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$OTTO_DIR"

COMPOSE_RUN="$OTTO_DIR/docker-compose.yml"
COMPOSE_DEV="$OTTO_DIR/docker-compose.dev.yml"

# Determine which compose file is active
if docker compose -f "$COMPOSE_RUN" ps --quiet redis 2>/dev/null | grep -q .; then
  COMPOSE="docker compose -f $COMPOSE_RUN"
  REDIS_SERVICE="redis"
elif docker compose -f "$COMPOSE_DEV" ps --quiet redis 2>/dev/null | grep -q .; then
  COMPOSE="docker compose -f $COMPOSE_DEV"
  REDIS_SERVICE="redis"
else
  echo "Error: No running Otto containers found. Start Otto first."
  exit 1
fi

# Create a timestamped backup directory
BACKUP_DIR="backups/$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting backup to $BACKUP_DIR..."

# Backup SQLite data
echo "Backing up SQLite data..."
tar -czf "$BACKUP_DIR/sqlite_data.tar.gz" data/sqlite 2>/dev/null || true

# Backup Redis
echo "Backing up Redis..."
# Pass password if REDIS_PASSWORD is set (prod uses requirepass)
REDIS_AUTH=""
if [ -n "${REDIS_PASSWORD:-}" ]; then
  REDIS_AUTH="-a $REDIS_PASSWORD"
fi
$COMPOSE exec -T $REDIS_SERVICE redis-cli $REDIS_AUTH BGSAVE > /dev/null 2>&1
sleep 2
REDIS_CONTAINER=$($COMPOSE ps -q $REDIS_SERVICE)
docker cp "$REDIS_CONTAINER:/data/dump.rdb" "$BACKUP_DIR/redis_dump.rdb" 2>/dev/null || echo "  Warning: Could not copy Redis dump"

# Backup .env (if exists)
if [ -f ".env" ]; then
  cp .env "$BACKUP_DIR/"
  echo "  Copied .env"
fi

echo "Backup complete: $BACKUP_DIR"
