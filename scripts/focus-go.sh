#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/focus-common.sh"

slot="${1:-}"
if [[ -z "$slot" ]]; then
  display_msg "usage: focus-go.sh <slot>"
  exit 1
fi

if ! [[ "$slot" =~ ^[1-9]$|^10$ ]]; then
  display_msg "invalid slot: $slot (1-10)"
  exit 1
fi

if slot_is_empty "$slot"; then
  display_msg "focus slot $slot is empty"
  exit 0
fi

target=$(read_slot "$slot")
if ! tmux has-session -t "$(get_session "$target")" 2>/dev/null; then
  display_msg "focus slot $slot: session no longer exists"
  exit 0
fi

if ! switch_to_window "$target"; then
  display_msg "focus slot $slot: window no longer exists"
  exit 0
fi
display_msg "jumped to focus slot $slot"
