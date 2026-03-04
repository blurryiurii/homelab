#!/usr/bin/env bash

# This script will update all containers as specified in docker-compose.yml's
# Overleaf doesn't use regular docker-compose.yml, so it's handled separately.

set -euo pipefail  # fail early

# run from script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1
echo "Updating containers in ${SCRIPT_DIR}"

# Overleaf: run overleaf/bin/upgrade, then up
if [ -d "overleaf" ]; then
  echo "Updating Overleaf"
  (cd "$SCRIPT_DIR/overleaf" && ./bin/upgrade && ./bin/up -d)
fi

for dir in */; do
  # Skip exceptions: overleaf has custom binaries, portainer is no longer used
  excluded=("overleaf/" "portainer/" )
  skip=0
  for ex in "${excluded[@]}"; do
    [[ "$dir" == "$ex" ]] && { skip=1; break; }
  done
  [[ $skip -eq 1 ]] && continue

  echo "Updating ${dir%/}"
  # add sudo to both commands if you use rootful docker!
  ( cd "$dir" && docker compose pull && docker compose up -d --remove-orphans )
done

# let's cleanup any dangling images too
echo "Cleaning up dangling images..."
docker image prune -f