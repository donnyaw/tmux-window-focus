# tmux-window-bookmarks

**10-slot bookmarks for tmux windows across all sessions.**

Bookmark your most important tmux windows into numbered slots from 1 to 10, then jump to them instantly with `prefix + s 1` through `prefix + s 0`. Manage slots with add, assign, delete, reorder, list, show, and clear actions.

## Requirements

- tmux 3.0 or later
- fzf with `fzf-tmux` for the list view

Slot jumping works without fzf; only `prefix + s l` needs `fzf-tmux`.

## Installation

### TPM

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'donnyaw/tmux-window-bookmarks'
```

Press `prefix + I` to install.

TPM loads `tmux-window-bookmarks.tmux` automatically.

### Manual

```bash
git clone https://github.com/donnyaw/tmux-window-bookmarks.git ~/.tmux/plugins/tmux-window-bookmarks
```

Add to `~/.tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/tmux-window-bookmarks/tmux-window-bookmarks.tmux
```

Reload tmux:

```bash
tmux source-file ~/.tmux.conf
```

## Usage

Press `prefix + s` to enter the `tmux-window-bookmarks` key table.

| Key sequence | Action |
|---|---|
| `prefix + s 1` through `prefix + s 9` | Jump to slots 1-9 |
| `prefix + s 0` | Jump to slot 10 |
| `prefix + s n` | Jump to next bookmarked window |
| `prefix + s p` | Jump to previous bookmarked window |
| `prefix + s a` | Add current window to the first free slot |
| `prefix + s A` | Assign current window to a specific slot |
| `prefix + s d` | Delete a specific slot |
| `prefix + s k` | Delete (kill) current window's bookmark |
| `prefix + s m` | Move/reorder a slot with `from:to` |
| `prefix + s l` | List occupied slots in fzf with preview |
| `prefix + s s` | Show occupied slots in the tmux message bar |
| `prefix + s ?` | Show bookmark-mode help |
| `prefix + s c` | Clear all slots with confirmation |
| `prefix + s Esc` | Exit bookmark mode |

Direct cycle shortcuts are also installed:

| Key sequence | Action |
|---|---|
| `Alt+n` | Jump to next bookmarked window |
| `Alt+p` | Jump to previous bookmarked window |
| `Alt+Shift+PageDown` | Jump to next bookmarked window when supported by terminal |
| `Alt+Shift+PageUp` | Jump to previous bookmarked window when supported by terminal |

## Workflows

### Add and Jump

1. Navigate to the window you want to bookmark.
2. Press `prefix + s a`.
3. Later, press `prefix + s 1` to jump back to slot 1.

If the current window is already bookmarked, tmux shows the existing slot number instead of adding a duplicate.

### Assign to a Specific Slot

1. Navigate to the window.
2. Press `prefix + s A`, type `5`, and press Enter.
3. Use `prefix + s 5` to jump to that window.

Assigning overwrites that slot. If the same window exists in another slot, the old entry is cleared so one window appears only once.

### Reorder by Priority

1. Press `prefix + s m`.
2. Type `5:2` and press Enter.
3. Slot 5 moves to slot 2, and the slots between shift to keep ordering stable.

### List with fzf

1. Press `prefix + s l`.
2. Filter the bookmark list.
3. Press Enter to jump.

## Storage

Bookmark data is stored in:

```text
~/.config/tmux-window-bookmarks/list
```

The file has exactly 10 lines. Each line maps to one slot and stores only a tmux `window_id`, such as `@12`.

If you have bookmark data from a previous storage path, you can copy it manually.

## Why window_id?

tmux `window_id` values stay stable even when windows are reordered or renumbered. This keeps bookmarks window-only and avoids storing session names. Display labels are resolved live as `window-name [session-name]`.

## Scripts

All helpers live in `scripts/`.

| Script | Purpose |
|---|---|
| `bookmark-go.sh` | Jump to a slot |
| `bookmark-add.sh` | Add current window to first free slot |
| `bookmark-assign.sh` | Assign current window to a specific slot |
| `bookmark-delete.sh` | Clear a specific slot |
| `bookmark-delete-current.sh` | Clear the bookmark for the current window |
| `bookmark-clear.sh` | Clear all slots |
| `bookmark-move.sh` | Reorder a slot |
| `bookmark-list.sh` | Interactive fzf list with preview |
| `bookmark-show.sh` | Display occupied slots in tmux message bar |
| `bookmark-next.sh` | Cycle to next bookmarked window |
| `bookmark-prev.sh` | Cycle to previous bookmarked window |
| `bookmark-common.sh` | Shared storage and tmux helper functions |

## Architecture

```text
prefix + s
  -> tmux-window-bookmarks key table
  -> 1-0: bookmark-go.sh
  -> a: bookmark-add.sh
  -> A: bookmark-assign.sh
  -> d: bookmark-delete.sh
  -> D: bookmark-delete-current.sh
  -> m: bookmark-move.sh
  -> n/p: bookmark-next.sh / bookmark-prev.sh
  -> l: bookmark-list.sh
  -> s: bookmark-show.sh
  -> c: bookmark-clear.sh
```

## Comparison

| Tool | Approach | Best for |
|---|---|---|
| `tmux-window-bookmarks` | 10 fixed numbered bookmark slots | Important windows you want instantly available |
| `tmux-fzf` | Category menu then fzf | Accessing all tmux objects |
| `choose-tree` | Built-in tree view | Hierarchical navigation without fzf |

## License

MIT

## Links

- GitHub: [donnyaw/tmux-window-bookmarks](https://github.com/donnyaw/tmux-window-bookmarks)
- Author: [donnyaw](https://github.com/donnyaw)
