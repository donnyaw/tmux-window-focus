#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

target=$(get_current_target)
window_id=$(get_window_id "$target")
existing_slot=$(find_slot_by_window_id "$window_id")

if [[ -n "$existing_slot" ]]; then
  display_msg "already bookmarked in slot $existing_slot"
  exit 0
fi

slot=$(find_first_empty)

if [[ -z "$slot" ]]; then
  display_msg "all 10 bookmark slots are full"
  exit 0
fi

write_slot "$slot" "$target"
display_msg "bookmarked $(target_label "$target") (slot $slot)"
