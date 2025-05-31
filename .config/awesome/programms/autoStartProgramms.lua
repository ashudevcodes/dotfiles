local awful = require("awful")

-- Autorun programs
autorun = true
autorunApps = {
    "picom -b",
    "wezterm",
}
if autorun then
    for app = 1, #autorunApps do
        awful.spawn(autorunApps[app])
    end
end
