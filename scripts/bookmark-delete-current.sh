#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

target=$(get_current_target)
window_id=$(get_window_id "$target")
existing_slot=$(find_slot_by_window_id "$window_id")

if [[ -z "$existing_slot" ]]; then
  display_msg "current window is not bookmarked"
  exit 0
fi

clear_slot "$existing_slot"
display_msg "removed $(target_label "$target") from bookmark slot $existing_slot"
