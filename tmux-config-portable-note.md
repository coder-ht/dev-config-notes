# Tmux portable configuration note

Context:
- User prefers tmux daily operations to use direct Alt shortcuts.
- `Ctrl+b` should remain as the fallback tmux prefix.
- `Ctrl+a` is not reliable on this machine because the terminal/input path only made it work with Shift.
- User wants a cleaner tmux style without installing a theme plugin.

Files:
- Primary file to edit: `~/.tmux.conf.local`
- Main config remains Oh my tmux: `~/.tmux.conf`
- Do not edit Oh my tmux main file unless explicitly requested; override in `.tmux.conf.local`.

Theme to reproduce:
```tmux
# Catppuccin Mocha inspired theme
tmux_conf_theme_colour_1="#1e1e2e"    # base
tmux_conf_theme_colour_2="#313244"    # surface0
tmux_conf_theme_colour_3="#6c7086"    # overlay0
tmux_conf_theme_colour_4="#89b4fa"    # blue
tmux_conf_theme_colour_5="#cba6f7"    # mauve
tmux_conf_theme_colour_6="#1e1e2e"    # base
tmux_conf_theme_colour_7="#cdd6f4"    # text
tmux_conf_theme_colour_8="#181825"    # mantle
tmux_conf_theme_colour_9="#a6e3a1"    # green
tmux_conf_theme_colour_10="#cba6f7"   # mauve
tmux_conf_theme_colour_11="#89b4fa"   # blue
tmux_conf_theme_colour_12="#bac2de"   # subtext1
tmux_conf_theme_colour_13="#cdd6f4"   # text
tmux_conf_theme_colour_14="#1e1e2e"   # base
tmux_conf_theme_colour_15="#313244"   # surface0
tmux_conf_theme_colour_16="#f38ba8"   # red
tmux_conf_theme_colour_17="#cdd6f4"   # text

tmux_conf_theme_status_left=" #S "
tmux_conf_theme_status_right=" #{prefix}#{mouse}#{pairing}#{synchronized} %R | #{username}#{root}@#{hostname} "

tmux_conf_theme_status_left_fg="$tmux_conf_theme_colour_1"
tmux_conf_theme_status_left_bg="$tmux_conf_theme_colour_4"
tmux_conf_theme_status_left_attr="bold"

tmux_conf_theme_status_right_fg="$tmux_conf_theme_colour_13"
tmux_conf_theme_status_right_bg="$tmux_conf_theme_colour_2"
tmux_conf_theme_status_right_attr="none"
```

Alt-first key bindings to reproduce:
```tmux
# use Alt shortcuts for daily work, keep C-b as the tmux prefix fallback
set -g prefix C-b #!important
set -gu prefix2 #!important
bind C-b send-prefix #!important

# no-prefix shortcuts for daily tmux work
# panes
bind -n M-h select-pane -L #!important
bind -n M-j select-pane -D #!important
bind -n M-k select-pane -U #!important
bind -n M-l select-pane -R #!important
bind -n M-o select-pane -t :.+ #!important
bind -n M-H resize-pane -L 2 #!important
bind -n M-J resize-pane -D 2 #!important
bind -n M-K resize-pane -U 2 #!important
bind -n M-L resize-pane -R 2 #!important
bind -n M-- split-window -v -c '#{pane_current_path}' #!important
bind -n M-\\ split-window -h -c '#{pane_current_path}' #!important
bind -n M-z resize-pane -Z #!important
bind -n M-x confirm-before -p 'kill-pane #P? (y/n)' kill-pane #!important
bind -n M-q display-panes #!important

# windows
bind -n M-c new-window -c '#{pane_current_path}' #!important
bind -n M-n next-window #!important
bind -n M-p previous-window #!important
bind -n M-Tab last-window #!important
bind -n M-, command-prompt -I '#W' { rename-window '%%' } #!important
bind -n M-w choose-tree -Zw #!important
bind -n M-1 select-window -t :=1 #!important
bind -n M-2 select-window -t :=2 #!important
bind -n M-3 select-window -t :=3 #!important
bind -n M-4 select-window -t :=4 #!important
bind -n M-5 select-window -t :=5 #!important
bind -n M-6 select-window -t :=6 #!important
bind -n M-7 select-window -t :=7 #!important
bind -n M-8 select-window -t :=8 #!important
bind -n M-9 select-window -t :=9 #!important

# sessions, copy mode, and config
bind -n M-d detach-client #!important
bind -n M-s choose-tree -Zs #!important
bind -n M-f command-prompt { find-window -Z '%%' } #!important
bind -n M-v copy-mode #!important
bind -n M-y paste-buffer -p #!important
bind -n M-b list-buffers #!important
bind -n M-m run "cut -c3- '#{TMUX_CONF}' | sh -s _toggle_mouse" \; display 'mouse #{?#{mouse},on,off}' #!important
bind -n M-r run "sh -c '\"\$TMUX_PROGRAM\" \${TMUX_SOCKET:+-S \"\$TMUX_SOCKET\"} source \"\$TMUX_CONF\"'" \; display '#{TMUX_CONF} sourced' #!important
bind -n M-e new-window -n '#{TMUX_CONF_LOCAL}' sh -c '_E=${VISUAL:-${EDITOR:-vim}}; case "$_E" in *vim*) $_E -c ":set syntax=tmux" "$TMUX_CONF_LOCAL";; *) $_E "$TMUX_CONF_LOCAL";; esac && "$TMUX_PROGRAM" ${TMUX_SOCKET:+-S "$TMUX_SOCKET"} source "$TMUX_CONF" \; display "$TMUX_CONF_LOCAL sourced"' #!important
```

Reload and verify:
```bash
tmux source-file ~/.tmux.conf
tmux show-options -g prefix
tmux show-options -g prefix2 2>/dev/null || true
tmux list-keys -T root | rg '^bind-key -T root M-'
```

Expected:
- `prefix C-b`
- `prefix2 None`
- Root-table Alt bindings for panes, windows, sessions, copy mode, mouse toggle, reload, and edit config.

Important daily shortcuts:
- `Alt+h/j/k/l`: switch panes
- `Alt+H/J/K/L`: resize panes
- `Alt+-`: vertical split
- `Alt+\`: horizontal split
- `Alt+z`: zoom current pane
- `Alt+c`: new window
- `Alt+n` / `Alt+p`: next/previous window
- `Alt+1..9`: select window
- `Alt+d`: detach
- `Alt+r`: reload tmux config
- `Ctrl+b`: fallback prefix for all standard tmux operations

Skill requirement:
- A personal Codex skill was created at `/home/ghy/.codex/skills/record-tmux-changes`.
- Use it after future tmux configuration edits so the change is recorded as another portable note under `/home/ghy/.codex/memories/extensions/ad_hoc/notes/`.
