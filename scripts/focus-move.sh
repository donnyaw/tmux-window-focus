#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/focus-common.sh"

input="${1:-}"
if [[ -z "$input" ]]; then
  display_msg "usage: focus-move.sh <from>:<to>"
  exit 1
fi

from="${input%%:*}"
to="${input##*:}"

if [[ "$input" != *:* || -z "$from" || -z "$to" ]]; then
  display_msg "invalid format: use from:to"
  exit 1
fi

if ! [[ "$from" =~ ^[1-9]$|^10$ ]] || ! [[ "$to" =~ ^[1-9]$|^10$ ]]; then
  display_msg "invalid slot numbers (1-10)"
  exit 1
fi

if [[ "$from" == "$to" ]]; then
  display_msg "source and destination are the same"
  exit 0
fi

if slot_is_empty "$from"; then
  display_msg "focus slot $from is empty, nothing to move"
  exit 0
fi

saved=$(read_slot "$from")

if [[ "$from" -lt "$to" ]]; then
  for i in $(seq $((from + 1)) "$to"); do
    val=$(read_slot "$i")
    write_slot $((i - 1)) "$val"
  done
else
  for i in $(seq "$to" $((from - 1)) | sort -rn); do
    val=$(read_slot "$i")
    write_slot $((i + 1)) "$val"
  done
fi

write_slot "$to" "$saved"
display_msg "moved focus slot $from -> $to"
