local awful = require("awful")

local function run_once_ps(cmd)
    local process = cmd:match("^(%S+)")
    local check_cmd = "ps -u $USER -o args= | grep -w '" .. process .. "' | grep -v grep"
    local handle = io.popen(check_cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result == nil or result == "" then
            awful.spawn(cmd, false)
        end
    end
end

local autorunApps = {
    "picom -b",
    "wezterm",
}

for _, app in ipairs(autorunApps) do
    run_once_ps(app)
end
