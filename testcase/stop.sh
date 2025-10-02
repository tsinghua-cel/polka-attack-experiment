#!/usr/bin/env bash
dirs=(*/)

for d in "${dirs[@]}"; do
  d=${d%/}
  echo "Stop for testcase: $d"
  cd $d && docker compose -p normal$d -f docker-compose.yml down ; docker compose -p attack$d -f docker-attack.yml down && cd -
done