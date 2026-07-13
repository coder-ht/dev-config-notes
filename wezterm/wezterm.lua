local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- Keep the plugin and saved workspace state under WezTerm's config directory
-- so this file can be reused on another machine without changing paths.
local config_dir = wezterm.config_dir
local plugin_root = config_dir .. '/plugins/resurrect.wezterm/plugin'
package.path = plugin_root .. '/?.lua;' .. package.path

local resurrect = {
  workspace_state = require 'resurrect.workspace_state',
  window_state = require 'resurrect.window_state',
  tab_state = require 'resurrect.tab_state',
  fuzzy_loader = require 'resurrect.fuzzy_loader',
  state_manager = require 'resurrect.state_manager',
}

resurrect.state_manager.change_state_save_dir(config_dir .. '/resurrect-state/')

config.default_prog = { '/bin/zsh', '-l' }

local function save_workspace()
  local workspace = resurrect.workspace_state.get_workspace_state()
  resurrect.state_manager.save_state(workspace)
  resurrect.state_manager.write_current_state(workspace.workspace, 'workspace')
end

local function schedule_periodic_save()
  wezterm.time.call_after(15 * 60, function()
    save_workspace()
    schedule_periodic_save()
  end)
end

schedule_periodic_save()
wezterm.on('gui-startup', resurrect.state_manager.resurrect_on_gui_startup)

config.keys = {
  -- Save/restore the current workspace layout.
  {
    key = 's',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      save_workspace()
    end),
  },
  {
    key = 'r',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      resurrect.fuzzy_loader.fuzzy_load(window, pane, function(id, label)
        local state_type = string.match(id, '^([^/]+)')
        local state_id = string.match(id, '([^/]+)$')
        state_id = string.match(state_id, '(.+)%..+$')

        if state_type == 'workspace' then
          local state = resurrect.state_manager.load_state(state_id, 'workspace')
          resurrect.workspace_state.restore_workspace(state, {
            window = window,
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        end
      end)
    end),
  },

  -- Pane navigation.
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'o', mods = 'ALT', action = act.ActivatePaneDirection 'Next' },

  -- Pane resizing and layout.
  { key = 'H', mods = 'ALT', action = act.AdjustPaneSize { 'Left', 2 } },
  { key = 'J', mods = 'ALT', action = act.AdjustPaneSize { 'Down', 2 } },
  { key = 'K', mods = 'ALT', action = act.AdjustPaneSize { 'Up', 2 } },
  { key = 'L', mods = 'ALT', action = act.AdjustPaneSize { 'Right', 2 } },
  { key = '-', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'm', mods = 'ALT', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } },
  { key = 'v', mods = 'ALT', action = act.ActivateCopyMode },

  -- Rename the current tab.
  {
    key = 't',
    mods = 'ALT',
    action = act.PromptInputLine {
      description = 'Set tab title',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- Tab navigation.
  { key = 'c', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'ALT', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = 'Tab', mods = 'ALT', action = act.ActivateLastTab },
}

return config
