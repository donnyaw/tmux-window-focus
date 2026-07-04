#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

slot="${1:-}"
if [[ -z "$slot" ]]; then
  display_msg "usage: bookmark-assign.sh <slot>"
  exit 1
fi

if ! [[ "$slot" =~ ^[1-9]$|^10$ ]]; then
  display_msg "invalid slot: $slot (1-10)"
  exit 1
fi

target=$(get_current_target)
window_id=$(get_window_id "$target")
clear_window_id_except "$window_id" "$slot"
write_slot "$slot" "$target"
display_msg "assigned $(target_label "$target") to bookmark slot $slot"
