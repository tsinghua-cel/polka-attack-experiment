#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

BASE_SLEEP=${SLEEP_DURATION:-13000}
ATTACK_SLEEP=${ATTACK_SLEEP_DURATION:-13000}

INCLUDE_PATTERNS=()
EXCLUDE_PATTERNS=()
DRY_RUN=0

print_help() {
  grep '^#' "$0" | sed 's/^# \{0,1\}//'
}

log() { printf '\n[%s] %s\n' "$(date '+%F %T')" "$*"; }

run_cmd() {
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "DRY-RUN => $*"
  else
    echo "+ $*"
    eval "$@"
  fi
}

matches_filter() {
  local d="$1"
  local inc_ok=1
  if ((${#INCLUDE_PATTERNS[@]})); then
    inc_ok=0
    for p in "${INCLUDE_PATTERNS[@]}"; do
      if [[ "$d" == *"$p"* ]]; then inc_ok=1; break; fi
    done
  fi
  if [[ $inc_ok -ne 1 ]]; then return 1; fi
  for p in "${EXCLUDE_PATTERNS[@]}"; do
    if [[ "$d" == *"$p"* ]]; then return 1; fi
  done
  return 0
}

cleanup_stack=()
cleanup() {
  if [[ ${#cleanup_stack[@]} -gt 0 ]]; then
    for entry in "${cleanup_stack[@]}"; do
      IFS='|' read -r dir compose_file <<<"$entry"
      if [[ -d "$dir" && -f "$dir/$compose_file" ]]; then
        ( cd "$dir" && run_cmd docker compose -f "$compose_file" down || true )
      fi
    done
  fi
}
trap cleanup INT TERM

FAST=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --include) shift; INCLUDE_PATTERNS+=("${1:?--include need params}") ;;
    --exclude) shift; EXCLUDE_PATTERNS+=("${1:?--exclude need params}") ;;
    --dry-run) DRY_RUN=1 ;;
    --fast) FAST=1 ;;
    -h|--help) print_help; exit 0 ;;
    *) echo "unknown: $1" >&2; exit 1 ;;
  esac
  shift || true
done

if [[ $FAST -eq 1 ]]; then
  BASE_SLEEP=5
  ATTACK_SLEEP=5
fi

log "start process (base sleep=$BASE_SLEEP, attack sleep=$ATTACK_SLEEP, dry-run=$DRY_RUN)"

shopt -s nullglob
dirs=(*/)
shopt -u nullglob

if [[ ${#dirs[@]} -eq 0 ]]; then
  log "finished"
  exit 0
fi

for d in "${dirs[@]}"; do
  d=${d%/}
  if ! matches_filter "$d"; then
    log "skip ignored dir: $d"
    continue
  fi

  pushd "$d" > /dev/null

  compose_file=""
  for c in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
    if [[ -f $c ]]; then compose_file="$c"; break; fi
  done

  if [[ -z $compose_file ]]; then
    log "skip not found compose file: $d"
    popd > /dev/null
    continue
  fi
  cleanup_stack+=("$PWD|$compose_file")

  run_cmd docker compose -f "$compose_file" up -d --build
  run_cmd sleep "$BASE_SLEEP"
  run_cmd docker compose -f "$compose_file" down

  attack_file=""
  for a in docker-attack.yml docker-attack.yaml; do
    if [[ -f $a ]]; then attack_file="$a"; break; fi
  done

  if [[ -n $attack_file ]]; then
    cleanup_stack+=("$PWD|$attack_file")
    run_cmd docker compose -f "$attack_file" up -d
    run_cmd sleep "$ATTACK_SLEEP"
    run_cmd docker compose -f "$attack_file" down
  else
    log "not found attack compose file."
  fi

  unset 'cleanup_stack[-1]' || true
  if [[ -n $attack_file ]]; then unset 'cleanup_stack[-1]' || true; fi

  popd > /dev/null
  log "finished: $d"
  echo "------------------------------------------"

done

log "all finished"


