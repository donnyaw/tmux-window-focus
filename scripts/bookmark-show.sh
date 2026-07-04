#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

ensure_list_file

parts=""
for slot in $(seq 1 "$BOOKMARK_SLOTS"); do
  if ! slot_is_empty "$slot"; then
    target=$(read_slot "$slot")
    if target_exists "$target"; then
      parts+=" [$slot]$(target_label "$target")"
    else
      parts+=" [$slot]stale:$target"
    fi
  fi
done

if [[ -z "$parts" ]]; then
  display_msg "bookmark list is empty"
else
  display_msg "bookmarks:${parts}"
fi
