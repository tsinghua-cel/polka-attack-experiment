#!/usr/bin/env bash
dirs=(*/)

for d in "${dirs[@]}"; do
  d=${d%/}
  echo "Start testcase: $d"
  cd $d && docker compose -p normal$d -f docker-compose.yml up -d --build ; docker compose -p attack$d -f docker-attack.yml up -d --build && cd -
done