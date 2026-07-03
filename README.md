# tmux-window-focus

**10-slot speed dial for tmux windows across all sessions.**

Assign your most important tmux windows to numbered slots (1-10), then jump to them instantly with `prefix + s 1` through `prefix + s 0`. Manage slots via an intuitive key table: add, assign, delete, reorder, list with fzf, and clear.

---

## Problem

When you have many tmux sessions and windows (e.g., project work, logs, editors, servers), finding and switching to the right window is tedious. Built-in tools like `choose-tree` don't have fuzzy filtering, and general fzf-switchers require navigating a hierarchy or picking a category first.

`tmux-window-focus` solves this with a **curated priority list**. You decide which windows matter most, assign them to numbered slots (like a speed dial), and switch in one keystroke.

---

## Requirements

- **tmux** 3.0 or later
- **fzf** with `fzf-tmux` (for the list view only; slot jumping works without it)

Install fzf via your package manager or from [junegunn/fzf](https://github.com/junegunn/fzf).

---

## Installation

### Option 1: TPM (recommended)

Add to your `~/.tmux.conf`:

```tmux
set -g @plugin 'donnyaw/tmux-window-focus'
```

Press `prefix + I` to install.

TPM loads the root `tmux-window-focus.tmux` file automatically.

### Option 2: Manual

Clone the repository:

```bash
git clone https://github.com/donnyaw/tmux-window-focus.git ~/.tmux/plugins/tmux-window-focus
```

Add to your `~/.tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/tmux-window-focus/tmux-window-focus.tmux
```

Reload tmux:

```bash
tmux source-file ~/.tmux.conf
```

---

## Usage

### Entering the focus key table

Press **`prefix + s`**. This enters the `tmux-window-focus` key table and shows a short help message in the tmux message bar for 5 seconds.

The next key (`a`, `1`, `l`, etc.) must be pressed before tmux's `repeat-time` expires. If tmux returns to the normal key table too quickly, increase it in `~/.tmux.conf`:

```tmux
set -g repeat-time 3000
```

### Key reference

| Key sequence | Action |
|---|---|
| `prefix + s 1` | Jump to slot 1 |
| `prefix + s 2` | Jump to slot 2 |
| ... | ... |
| `prefix + s 9` | Jump to slot 9 |
| `prefix + s 0` | Jump to slot 10 |
| `prefix + s a` | Add current window to the first free slot (auto, no duplicates) |
| `prefix + s A` | Assign current window to a specific slot (prompted) |
| `prefix + s d` | Delete/clear a specific slot (prompted) |
| `prefix + s m` | Move/reorder a slot (prompted: `from:to` format) |
| `prefix + s l` | List all occupied slots in fzf with preview |
| `prefix + s s` | Show all occupied slots in the tmux message bar |
| `prefix + s ?` | Show focus-mode help |
| `prefix + s c` | Clear all 10 slots (with y/n confirmation) |
| `prefix + s Esc` | Exit focus key table without action |

---

## Workflows

### Basic: Add and jump

1. Navigate to the window you want to bookmark.
2. `prefix + s a` — adds it to the first free slot.
3. `prefix + s 1` — jumps back to it later.

If the current window is already focused, it will not be added again. tmux shows the existing slot number instead.

### Assign to a specific slot

1. Navigate to the window.
2. `prefix + s A`, type `5`, press Enter.
3. The window is now in slot 5. `prefix + s 5` jumps to it.

Assigning to a specific slot overwrites that slot. If the same window already exists in another slot, the old entry is cleared so one window is only stored once.

### Reorder by priority

When slots 1-5 are filled and you want to promote slot 5 to slot 2:

1. `prefix + s m`
2. Type `5:2`, press Enter.
3. Slot 5 content moves to slot 2. Existing slots 2-4 shift down one position.

### View and jump with fzf

1. `prefix + s l`
2. A floating fzf window shows all occupied slots with preview of their windows.
3. Type to filter, press Enter to jump.

### Show status bar

1. `prefix + s s`
2. A message like `focus: [1]work:3 editor [2]project:1 tests` appears briefly.

---

## Storage

All focus data is stored in:

```
~/.config/tmux-window-focus/list
```

The file is plain text with exactly 10 lines. Each line corresponds to a slot (line 1 = slot 1, etc.). Non-empty lines contain only one value: tmux `window_id`.

```
<window_id>
```

Example:
```
@12
@18

@5
```

Slots 3, 6-10 are empty (free). You can edit this file manually — the scripts re-read it each time. Session name, window index, and window name are **not stored**; they are resolved live from tmux when showing or jumping to a slot.

### Why window_id?

tmux assigns a stable `window_id` (like `@12`) to each window at creation. Unlike `session:index`, this identifier does not change when windows are reordered or renumbered. This keeps the focus list window-only and avoids persisting session data.

---

## Example session

```text
You have these tmux sessions/windows:

  work:    1 (editor)  2 (server)  3 (logs)
  project: 1 (vim)     2 (tests)   3 (docs)
  personal: 1 (music)

You use editor, server, tests, and music most often.

Step 1: Go to work:1, press prefix + s a → slot 1
Step 2: Go to work:2, press prefix + s a → slot 2
Step 3: Go to project:2, press prefix + s a → slot 3
Step 4: Go to personal:1, press prefix + s a → slot 4

Now:
  prefix + s 1 → work:1 (editor)
  prefix + s 2 → work:2 (server)
  prefix + s 3 → project:2 (tests)
  prefix + s 4 → personal:1 (music)
```

---

## Scripts reference

All scripts live in `scripts/` and are called from the key bindings.

| Script | Purpose | Arguments |
|---|---|---|
| `focus-go.sh` | Jump to a slot | `N` (1-10) |
| `focus-add.sh` | Add current window to first free slot | none |
| `focus-assign.sh` | Assign current window to a specific slot | `N` (1-10) |
| `focus-delete.sh` | Clear a specific slot | `N` (1-10) |
| `focus-clear.sh` | Clear all 10 slots | none |
| `focus-move.sh` | Reorder a slot (shift priority) | `from:to` format |
| `focus-list.sh` | Interactive fzf list with preview | none |
| `focus-show.sh` | Display all slots in tmux message | none |
| `focus-common.sh` | Shared library (sourced by all others) | n/a |

### Running scripts directly

Scripts can be run from a shell attached to a running tmux server for testing:

```bash
cd ~/.tmux/plugins/tmux-window-focus/scripts
./focus-go.sh 1
./focus-add.sh
./focus-show.sh
```

Messages are displayed via `tmux display-message` and appear in the tmux message bar.

---

## Customization

### Change the prefix key

Edit the binding in `tmux-window-focus.conf` or your `.tmux.conf`:

```tmux
# Example: use prefix + z instead of prefix + s
unbind s
bind z switch-client -T tmux-window-focus
```

### Change number of slots

Edit `scripts/focus-common.sh`:

```bash
FOCUS_SLOTS=10  # change to any number
```

Then add corresponding key bindings for new slots.

### Status bar integration

Add to your `~/.tmux.conf`:

```tmux
set -g status-right '#[fg=cyan]F:#(~/.tmux/plugins/tmux-window-focus/scripts/focus-status.sh)/10'
```

Create `focus-status.sh`:

```bash
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/focus-common.sh"
count_occupied
```

---

## Architecture

```text
User presses prefix + s
  │
  ▼
enters tmux-window-focus key table
  │
  ├── 1-0 → focus-go.sh N → read slot N → switch to window
  ├── a   → focus-add.sh  → find empty slot → write current window_id
  ├── A   → focus-assign.sh N → write to specific slot
  ├── d   → focus-delete.sh N → clear slot
  ├── m   → focus-move.sh from:to → shift entries → reorder
  ├── l   → focus-list.sh → fzf → select → jump
  ├── s   → focus-show.sh → display-message
  ├── c   → confirm → focus-clear.sh → clear all
  └── Esc → exit to root table
```

All scripts source `focus-common.sh` for shared functions:

```text
focus-common.sh
  ├── ensure_list_file()   — create ~/.config/tmux-window-focus/list
  ├── read_slot(N)         — read line N from file
  ├── write_slot(N, val)   — write line N
  ├── clear_slot(N)        — empty a slot
  ├── find_first_empty()   — find next free slot
  ├── get_current_target() — get current window_id only
  ├── switch_to_window()   — switch client + select window
  └── display_msg()        — tmux display-message
```

The root `tmux-window-focus.tmux` file is the plugin entrypoint. It detects the plugin directory and binds all commands to the correct local `scripts/` path, which makes TPM and custom clone paths work reliably.

---

## Comparison with similar tools

| Tool | Approach | Best for |
|---|---|---|
| **tmux-window-focus** | 10 fixed numbered slots, curated list, priority ordering | Users who want a small set of important windows available instantly |
| **tmux-fzf** | Category menu (session/window/pane/...) then fzf | Users who want access to everything |
| **session-window-fzf** | Flat combined list of all sessions and windows | Users who want to fuzzy-search everything at once |
| **choose-tree** | Built-in tree view, no fzf | Users who prefer a hierarchical view |

---

## License

MIT

---

## Links

- GitHub: [donnyaw/tmux-window-focus](https://github.com/donnyaw/tmux-window-focus)
- Author: [donnyaw](https://github.com/donnyaw)
