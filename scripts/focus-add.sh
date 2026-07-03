#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/focus-common.sh"

target=$(get_current_target)
window_id=$(get_window_id "$target")
existing_slot=$(find_slot_by_window_id "$window_id")

if [[ -n "$existing_slot" ]]; then
  display_msg "already focused in slot $existing_slot"
  exit 0
fi

slot=$(find_first_empty)

if [[ -z "$slot" ]]; then
  display_msg "all 10 focus slots are full"
  exit 0
fi

write_slot "$slot" "$target"
display_msg "focused $(get_session "$target"):$(get_window_index "$target") (slot $slot)"
