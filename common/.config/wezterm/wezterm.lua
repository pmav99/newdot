-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.check_for_updates = false
config.color_scheme = 'Molokai'
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.freetype_load_target = "Mono"
config.freetype_load_target = "HorizontalLcd"
config.freetype_load_flags = 'NO_HINTING'


local act = wezterm.action

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

config.keys = {
  {
    key = '9',
    mods = 'ALT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  { key = 'n', mods = 'CTRL', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'CTRL', action = act.SwitchWorkspaceRelative(-1) },
}

return config
