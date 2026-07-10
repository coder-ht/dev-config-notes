local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.keys = {
  -- tmux-like pane navigation.
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'o', mods = 'ALT', action = act.ActivatePaneDirection 'Next' },

  -- tmux-like pane resizing.
  { key = 'H', mods = 'ALT', action = act.AdjustPaneSize { 'Left', 2 } },
  { key = 'J', mods = 'ALT', action = act.AdjustPaneSize { 'Down', 2 } },
  { key = 'K', mods = 'ALT', action = act.AdjustPaneSize { 'Up', 2 } },
  { key = 'L', mods = 'ALT', action = act.AdjustPaneSize { 'Right', 2 } },

  -- Match ~/.tmux.conf.local: M-- splits top/bottom, M-\ splits left/right.
  { key = '-', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  { key = 'm', mods = 'ALT', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } },
  { key = 'v', mods = 'ALT', action = act.ActivateCopyMode },

  -- tmux-like tab navigation.
  { key = 'c', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'ALT', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = 'Tab', mods = 'ALT', action = act.ActivateLastTab },
}

return config
