# WezTerm portable configuration

This directory contains the current WezTerm setup used on ghy:

- WezTerm starts a login zsh directly; it does not start tmux.
- `Alt+h/j/k/l/o` navigates panes.
- `Alt+Shift+H/J/K/L` resizes panes.
- `Alt+-` and `Alt+\\` split panes vertically and horizontally.
- `Alt+m` toggles pane zoom; `Alt+x` closes a pane; `Alt+v` opens copy mode.
- `Alt+c/n/p/Tab` creates and switches tabs.
- `Alt+t` renames the current tab.
- `Alt+s` saves the current workspace; `Alt+r` restores a saved workspace.
- The workspace is saved automatically every 15 minutes and restored on GUI startup.

## Install on another machine

Install WezTerm using the platform's package manager. On Debian/Ubuntu, the official `.deb` package is the preferred option:

```bash
# Use the official WezTerm installation instructions for the current release.
sudo apt install wezterm
```

If system installation is unavailable, unpack a downloaded `.deb` into a user-owned directory:

```bash
mkdir -p "$HOME/.local/opt/wezterm" "$HOME/.local/bin"
dpkg-deb -x ~/Downloads/wezterm-*.deb "$HOME/.local/opt/wezterm"
ln -sfn "$HOME/.local/opt/wezterm/usr/bin/wezterm" "$HOME/.local/bin/wezterm"
```

Ensure `~/.local/bin` is on `PATH` before starting WezTerm.

Install the workspace plugin expected by `wezterm.lua`:

```bash
mkdir -p "$HOME/.config/wezterm/plugins"
git clone https://github.com/MLFlexer/resurrect.wezterm \
  "$HOME/.config/wezterm/plugins/resurrect.wezterm"
```

Link this repository's configuration as the user config:

```bash
ln -sfn "$PWD/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
```

The configuration derives plugin and workspace-state paths from `wezterm.config_dir`, so it does not contain this machine's absolute paths. Workspace state is intentionally not tracked; each machine keeps its own state in:

```text
~/.config/wezterm/resurrect-state/
```

## Verify

```bash
wezterm --config-file "$HOME/.wezterm.lua" show-keys --lua
```

Confirm the command parses successfully and lists the Alt pane/tab bindings. Start WezTerm and verify that it opens a login zsh and that `Alt+s`/`Alt+r` save and restore the workspace.
