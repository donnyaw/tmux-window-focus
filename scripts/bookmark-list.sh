#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/bookmark-common.sh"

ensure_list_file

TAB=$'\t'
lines=""
slot=0
while IFS= read -r target; do
  slot=$((slot + 1))
  [[ -z "$target" ]] && continue
  if target_exists "$target"; then
    label=$(target_label "$target")
    lines+="${slot}${TAB}[${slot}] ${label}${TAB}${target}"$'\n'
  else
    lines+="${slot}${TAB}[${slot}] stale:${target}${TAB}${target}"$'\n'
  fi
done < "$BOOKMARK_FILE"

if [[ -z "$lines" ]]; then
  display_msg "no windows in bookmark list"
  exit 0
fi

selection=$(echo "$lines" | fzf-tmux -p -w 60% -h 40% \
  --header 'bookmark slots | Enter=jump' \
  --delimiter $'\t' \
  --with-nth 2 \
  --preview '
    w=$(echo {} | cut -f3)
    tmux list-panes -t "$w" -F "  #P: #T" 2>/dev/null
  ' \
  --preview-window right:40% \
  2>/dev/null || true)

if [[ -z "$selection" ]]; then
  exit 0
fi

wid=$(echo "$selection" | cut -f3)

if ! switch_to_window "$wid"; then
  display_msg "bookmark target no longer exists"
fi
