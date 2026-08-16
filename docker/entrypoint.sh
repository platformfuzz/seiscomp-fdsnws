#!/bin/bash
set -euo pipefail

export SEISCOMP_ROOT="${SEISCOMP_ROOT:-/home/sysop/seiscomp}"
export PATH="$SEISCOMP_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$SEISCOMP_ROOT/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export PYTHONPATH="$SEISCOMP_ROOT/lib/python${PYTHONPATH:+:$PYTHONPATH}"

if [ "$(id -u)" = 0 ]; then
  mkdir -p "$SEISCOMP_ROOT/var/lib/archive" /home/sysop/.seiscomp
  chown -R sysop:sysop "$SEISCOMP_ROOT/var" /home/sysop/.seiscomp 2>/dev/null || true
  exec runuser -u sysop -- "$0" "$@"
fi

/docker/write-runtime-config.sh

DB_HOST="${DB_HOST:-mariadb}"
DB_USER="${DB_USER:-sysop}"
DB_PASSWORD="${DB_PASSWORD:-sysop}"
DB_NAME="${DB_NAME:-seiscomp}"

echo "waiting for ${DB_HOST} catalog..."
ok=0
for _ in $(seq 1 90); do
  tables=$(mariadb --skip-ssl -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -N \
    -e "SHOW TABLES" "$DB_NAME" 2>/dev/null | wc -l)
  tables=${tables//[^0-9]/}
  n=$(mariadb --skip-ssl -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -N \
    -e "SELECT COUNT(*) FROM Station" "$DB_NAME" 2>/dev/null || echo 0)
  n=${n//[^0-9]/}
  echo "tables=${tables:-0} Station=${n:-0}"
  if [ "${tables:-0}" -ge 50 ] && [ "${n:-0}" -ge 4 ]; then
    ok=1
    break
  fi
  sleep 2
done
if [ "$ok" != "1" ]; then
  echo "database not ready (need schema and 4 Station rows)" >&2
  exit 1
fi

exec "$@"
