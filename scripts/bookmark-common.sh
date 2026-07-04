BOOKMARK_DIR="${HOME}/.config/tmux-window-bookmarks"
BOOKMARK_FILE="${BOOKMARK_DIR}/list"
BOOKMARK_SLOTS=10

ensure_list_file() {
  mkdir -p "$BOOKMARK_DIR"
  if [[ ! -f "$BOOKMARK_FILE" ]]; then
    for _ in $(seq 1 "$BOOKMARK_SLOTS"); do echo ""; done > "$BOOKMARK_FILE"
  fi

  local tmp
  tmp=$(mktemp)
  awk -v slots="$BOOKMARK_SLOTS" 'NR <= slots { print $1 } END { for (i = NR + 1; i <= slots; i++) print "" }' "$BOOKMARK_FILE" > "$tmp"
  mv "$tmp" "$BOOKMARK_FILE"
}

read_slot() {
  local slot="$1"
  ensure_list_file
  sed -n "${slot}p" "$BOOKMARK_FILE"
}

write_slot() {
  local slot="$1"
  local value="$2"
  ensure_list_file
  local tmp
  tmp=$(mktemp)
  awk -v n="$slot" -v v="$value" 'NR == n { print v } NR != n { print }' "$BOOKMARK_FILE" > "$tmp"
  mv "$tmp" "$BOOKMARK_FILE"
}

clear_slot() {
  write_slot "$1" ""
}

find_first_empty() {
  ensure_list_file
  awk 'NF == 0 { print NR; exit }' "$BOOKMARK_FILE"
}

get_current_target() {
  tmux display-message -p "#{window_id}"
}

count_occupied() {
  ensure_list_file
  awk 'NF > 0 { c++ } END { print c+0 }' "$BOOKMARK_FILE"
}

find_slot_by_window_id() {
  local window_id="$1"
  ensure_list_file
  awk -v wid="$window_id" '$1 == wid { print NR; exit }' "$BOOKMARK_FILE"
}

clear_window_id_except() {
  local window_id="$1"
  local keep_slot="$2"
  ensure_list_file
  local tmp
  tmp=$(mktemp)
  awk -v wid="$window_id" -v keep="$keep_slot" 'NR != keep && $1 == wid { print ""; next } { print }' "$BOOKMARK_FILE" > "$tmp"
  mv "$tmp" "$BOOKMARK_FILE"
}

slot_is_empty() {
  local slot="$1"
  local val
  val=$(read_slot "$slot")
  [[ -z "$val" ]]
}

display_msg() {
  tmux display-message -d "${BOOKMARK_MESSAGE_DURATION:-8000}" "$*"
}

get_window_id() {
  printf '%s\n' "$1" | awk '{ print $1 }'
}

target_exists() {
  local target="$1"
  local wid
  wid=$(get_window_id "$target")
  tmux list-windows -a -F '#{window_id}' 2>/dev/null | grep -Fx "$wid" >/dev/null
}

target_session() {
  tmux display-message -p -t "$(get_window_id "$1")" '#{session_name}'
}

target_label() {
  tmux display-message -p -t "$(get_window_id "$1")" '#{window_name} [#{session_name}]'
}

switch_to_window() {
  local target="$1"
  local wid
  wid=$(get_window_id "$target")
  if ! target_exists "$wid"; then
    return 1
  fi
  tmux switch-client -t "$(target_session "$wid")"
  tmux select-window -t "$wid"
}
