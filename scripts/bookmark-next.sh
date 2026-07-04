#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

direction="${1:-next}"
current=$(tmux display-message -p '#{window_id}')
ensure_list_file

slots=()
targets=()
slot=0
while IFS= read -r target; do
  slot=$((slot + 1))
  [[ -z "$target" ]] && continue
  target=$(get_window_id "$target")
  if ! target_exists "$target"; then
    clear_slot "$slot"
    continue
  fi
  slots+=("$slot")
  targets+=("$target")
done < "$BOOKMARK_FILE"

count=${#targets[@]}
if [[ "$count" -eq 0 ]]; then
  display_msg "bookmark list is empty"
  exit 0
fi

current_pos=-1
for i in "${!targets[@]}"; do
  if [[ "${targets[$i]}" == "$current" ]]; then
    current_pos=$i
    break
  fi
done

if [[ "$current_pos" -eq -1 ]]; then
  if [[ "$direction" == "prev" ]]; then
    next_pos=$((count - 1))
  else
    next_pos=0
  fi
elif [[ "$direction" == "prev" ]]; then
  next_pos=$(((current_pos - 1 + count) % count))
else
  next_pos=$(((current_pos + 1) % count))
fi

target="${targets[$next_pos]}"
slot="${slots[$next_pos]}"
if switch_to_window "$target"; then
  display_msg "bookmark slot $slot: $(target_label "$target")"
else
  display_msg "bookmark slot $slot: window no longer exists"
fi
