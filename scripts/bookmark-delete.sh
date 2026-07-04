#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

slot="${1:-}"
if [[ -z "$slot" ]]; then
  display_msg "usage: bookmark-delete.sh <slot>"
  exit 1
fi

if ! [[ "$slot" =~ ^[1-9]$|^10$ ]]; then
  display_msg "invalid slot: $slot (1-10)"
  exit 1
fi

if slot_is_empty "$slot"; then
  display_msg "bookmark slot $slot is already empty"
  exit 0
fi

clear_slot "$slot"
display_msg "cleared bookmark slot $slot"
