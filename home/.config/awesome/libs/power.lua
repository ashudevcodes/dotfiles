local power = {}

local AC_PATH = "/sys/class/power_supply/AC/online"

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local v = f:read("*all")
    f:close()
    return v
end

function power.is_on_ac()
    local v = read_file(AC_PATH)
    if not v then return true end -- fallback safe
    return tonumber(v) == 1
end

function power.get_fps()
    if power.is_on_ac() then
        return 60
    else
        return 30
    end
end

return power
