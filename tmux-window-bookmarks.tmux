#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$CURRENT_DIR/scripts"

tmux bind-key s "display-message -d 5000 \"bookmarks: 1-0 jump | n/p cycle | a add | l list | ? help\" ; switch-client -T tmux-window-bookmarks"
tmux bind-key -n M-S-PPage run-shell -b "$SCRIPTS_DIR/bookmark-prev.sh"
tmux bind-key -n M-S-NPage run-shell -b "$SCRIPTS_DIR/bookmark-next.sh"
tmux bind-key -n M-p run-shell -b "$SCRIPTS_DIR/bookmark-prev.sh"
tmux bind-key -n M-n run-shell -b "$SCRIPTS_DIR/bookmark-next.sh"

tmux bind-key -T tmux-window-bookmarks 1 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 1"
tmux bind-key -T tmux-window-bookmarks 2 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 2"
tmux bind-key -T tmux-window-bookmarks 3 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 3"
tmux bind-key -T tmux-window-bookmarks 4 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 4"
tmux bind-key -T tmux-window-bookmarks 5 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 5"
tmux bind-key -T tmux-window-bookmarks 6 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 6"
tmux bind-key -T tmux-window-bookmarks 7 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 7"
tmux bind-key -T tmux-window-bookmarks 8 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 8"
tmux bind-key -T tmux-window-bookmarks 9 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 9"
tmux bind-key -T tmux-window-bookmarks 0 run-shell -b "$SCRIPTS_DIR/bookmark-go.sh 10"

tmux bind-key -T tmux-window-bookmarks a run-shell -b "$SCRIPTS_DIR/bookmark-add.sh"
tmux bind-key -T tmux-window-bookmarks A command-prompt -p "assign to slot (1-10)" "run-shell -b '$SCRIPTS_DIR/bookmark-assign.sh %%'"
tmux bind-key -T tmux-window-bookmarks d command-prompt -p "delete slot (1-10)" "run-shell -b '$SCRIPTS_DIR/bookmark-delete.sh %%'"
tmux bind-key -T tmux-window-bookmarks k run-shell -b "$SCRIPTS_DIR/bookmark-delete-current.sh"
tmux bind-key -T tmux-window-bookmarks m command-prompt -p "move from:to (e.g. 5:2)" "run-shell -b '$SCRIPTS_DIR/bookmark-move.sh %%'"
tmux bind-key -T tmux-window-bookmarks n run-shell -b "$SCRIPTS_DIR/bookmark-next.sh"
tmux bind-key -T tmux-window-bookmarks p run-shell -b "$SCRIPTS_DIR/bookmark-prev.sh"
tmux bind-key -T tmux-window-bookmarks l run-shell -b "$SCRIPTS_DIR/bookmark-list.sh"
tmux bind-key -T tmux-window-bookmarks s run-shell -b "$SCRIPTS_DIR/bookmark-show.sh"
tmux bind-key -T tmux-window-bookmarks "?" display-message -d 5000 "bookmarks: 1-0 jump | n next | p prev | a add | A assign | d delete | k kill current | m move | l list | s show | c clear"
tmux bind-key -T tmux-window-bookmarks c confirm-before -p "clear all bookmark slots? (y/n)" "run-shell -b '$SCRIPTS_DIR/bookmark-clear.sh'"
tmux bind-key -T tmux-window-bookmarks Escape switch-client -T root
