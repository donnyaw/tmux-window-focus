#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/focus-common.sh"

ensure_list_file

lines=$(awk '
  NF > 0 {
    slot = NR
    wid = $1
    sess = $2
    win = $3
    display = sprintf("[%d] %s:%s", slot, sess, win)
    printf "%s\t%s\t%s\t%s\n", slot, display, sess, wid
  }
' "$FOCUS_FILE")

if [[ -z "$lines" ]]; then
  display_msg "no windows in focus list"
  exit 0
fi

selection=$(echo "$lines" | fzf-tmux -p -w 60% -h 40% \
  --header 'focus slots | Enter=jump' \
  --delimiter $'\t' \
  --with-nth 2 \
  --preview '
    s=$(echo {} | cut -f3)
    w=$(echo {} | cut -f4)
    tmux list-windows -t "$s" -F "  #I: #W (#{window_panes}p)" 2>/dev/null | head -20
  ' \
  --preview-window right:40% \
  2>/dev/null || true)

if [[ -z "$selection" ]]; then
  exit 0
fi

wid=$(echo "$selection" | cut -f4)
sess=$(echo "$selection" | cut -f3)

tmux switch-client -t "$sess"
if ! tmux select-window -t "$wid" 2>/dev/null; then
  display_msg "focus target no longer exists"
fi
