local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()
config.keys = {}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

table.insert(config.keys,{
    key = 't',
    mods = 'ALT',
    action = act.SpawnTab 'DefaultDomain',
})

return config
