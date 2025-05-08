local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    -- Switch to tabs
    { key = '1', mods = 'ALT', action = act.ActivatePaneByIndex(0) },
    { key = '2', mods = 'ALT', action = act.ActivatePaneByIndex(1) },
    { key = '3', mods = 'ALT', action = act.ActivatePaneByIndex(2) },
    { key = '4', mods = 'ALT', action = act.ActivatePaneByIndex(3) },
    { key = '5', mods = 'ALT', action = act.ActivatePaneByIndex(4) },
    { key = '6', mods = 'ALT', action = act.ActivatePaneByIndex(5) },
    { key = '7', mods = 'ALT', action = act.ActivatePaneByIndex(6) },
    { key = '8', mods = 'ALT', action = act.ActivatePaneByIndex(7) },
    { key = '9', mods = 'ALT', action = act.ActivatePaneByIndex(8) },
    { key = '0', mods = 'ALT', action = act.ActivatePaneByIndex(9) },
    -- For creating new tab
    { key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain' },
  },
}
