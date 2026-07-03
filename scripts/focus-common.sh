FOCUS_DIR="${HOME}/.config/tmux-window-focus"
FOCUS_FILE="${FOCUS_DIR}/list"
FOCUS_SLOTS=10

ensure_list_file() {
  mkdir -p "$FOCUS_DIR"
  if [[ ! -f "$FOCUS_FILE" ]]; then
    for _ in $(seq 1 "$FOCUS_SLOTS"); do echo ""; done > "$FOCUS_FILE"
  fi

  local tmp
  tmp=$(mktemp)
  awk -v slots="$FOCUS_SLOTS" 'NR <= slots { print $1 } END { for (i = NR + 1; i <= slots; i++) print "" }' "$FOCUS_FILE" > "$tmp"
  mv "$tmp" "$FOCUS_FILE"
}

read_slot() {
  local slot="$1"
  ensure_list_file
  sed -n "${slot}p" "$FOCUS_FILE"
}

write_slot() {
  local slot="$1"
  local value="$2"
  ensure_list_file
  local tmp
  tmp=$(mktemp)
  awk -v n="$slot" -v v="$value" 'NR == n { print v } NR != n { print }' "$FOCUS_FILE" > "$tmp"
  mv "$tmp" "$FOCUS_FILE"
}

clear_slot() {
  write_slot "$1" ""
}

find_first_empty() {
  ensure_list_file
  awk 'NF == 0 { print NR; exit }' "$FOCUS_FILE"
}

get_current_target() {
  tmux display-message -p "#{window_id}"
}

count_occupied() {
  ensure_list_file
  awk 'NF > 0 { c++ } END { print c+0 }' "$FOCUS_FILE"
}

find_slot_by_window_id() {
  local window_id="$1"
  ensure_list_file
  awk -v wid="$window_id" '$1 == wid { print NR; exit }' "$FOCUS_FILE"
}

clear_window_id_except() {
  local window_id="$1"
  local keep_slot="$2"
  ensure_list_file
  local tmp
  tmp=$(mktemp)
  awk -v wid="$window_id" -v keep="$keep_slot" 'NR != keep && $1 == wid { print ""; next } { print }' "$FOCUS_FILE" > "$tmp"
  mv "$tmp" "$FOCUS_FILE"
}

slot_is_empty() {
  local slot="$1"
  local val
  val=$(read_slot "$slot")
  [[ -z "$val" ]]
}

display_msg() {
  tmux display-message -d "${FOCUS_MESSAGE_DURATION:-5000}" "$*"
}

get_window_id() {
  printf '%s\n' "$1" | awk '{ print $1 }'
}

target_exists() {
  local target="$1"
  local wid
  wid=$(get_window_id "$target")
  tmux display-message -p -t "$wid" '#{window_id}' >/dev/null 2>&1
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
