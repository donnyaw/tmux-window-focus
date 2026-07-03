#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

tmux bind-key s display-message -d 5000 "focus: 1-0 jump | a add | A assign | l list | ? help" \; switch-client -T tmux-window-focus

tmux bind-key -T tmux-window-focus 1 run-shell -b "$SCRIPTS_DIR/focus-go.sh 1"
tmux bind-key -T tmux-window-focus 2 run-shell -b "$SCRIPTS_DIR/focus-go.sh 2"
tmux bind-key -T tmux-window-focus 3 run-shell -b "$SCRIPTS_DIR/focus-go.sh 3"
tmux bind-key -T tmux-window-focus 4 run-shell -b "$SCRIPTS_DIR/focus-go.sh 4"
tmux bind-key -T tmux-window-focus 5 run-shell -b "$SCRIPTS_DIR/focus-go.sh 5"
tmux bind-key -T tmux-window-focus 6 run-shell -b "$SCRIPTS_DIR/focus-go.sh 6"
tmux bind-key -T tmux-window-focus 7 run-shell -b "$SCRIPTS_DIR/focus-go.sh 7"
tmux bind-key -T tmux-window-focus 8 run-shell -b "$SCRIPTS_DIR/focus-go.sh 8"
tmux bind-key -T tmux-window-focus 9 run-shell -b "$SCRIPTS_DIR/focus-go.sh 9"
tmux bind-key -T tmux-window-focus 0 run-shell -b "$SCRIPTS_DIR/focus-go.sh 10"

tmux bind-key -T tmux-window-focus a run-shell -b "$SCRIPTS_DIR/focus-add.sh"
tmux bind-key -T tmux-window-focus A command-prompt -p "assign to slot (1-10)" "run-shell -b '$SCRIPTS_DIR/focus-assign.sh %%'"
tmux bind-key -T tmux-window-focus d command-prompt -p "delete slot (1-10)" "run-shell -b '$SCRIPTS_DIR/focus-delete.sh %%'"
tmux bind-key -T tmux-window-focus m command-prompt -p "move from:to (e.g. 5:2)" "run-shell -b '$SCRIPTS_DIR/focus-move.sh %%'"
tmux bind-key -T tmux-window-focus l run-shell -b "$SCRIPTS_DIR/focus-list.sh"
tmux bind-key -T tmux-window-focus s run-shell -b "$SCRIPTS_DIR/focus-show.sh"
tmux bind-key -T tmux-window-focus ? display-message -d 5000 "focus: 1-0 jump | a add | A assign | d delete | m move | l list | s show | c clear"
tmux bind-key -T tmux-window-focus c confirm-before -p "clear all focus slots? (y/n)" "run-shell -b '$SCRIPTS_DIR/focus-clear.sh'"
tmux bind-key -T tmux-window-focus Escape switch-client -T root
