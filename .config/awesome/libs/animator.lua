local gears  = require("gears")
local power  = require("libs.power")

local animator = {}

local subscribers = {}
local running = false

timer = gears.timer {
    timeout   = 1 / power.get_fps(),
    autostart = false,
    callback  = function()
        local active = false

        for obj in pairs(subscribers) do
            if obj._destroyed then
                subscribers[obj] = nil
            else
                if obj:update() then
                    active = true
                end
            end
        end

        if not active then
            timer:stop()
            running = false
        end
    end
}

-------------------------------------------------
-- Internal
-------------------------------------------------

local function update_fps()
    timer.timeout = 1 / power.get_fps()
end

-------------------------------------------------
-- Public API
-------------------------------------------------

function animator.subscribe(obj)
    subscribers[obj] = true
end

function animator.activate()
    update_fps()

    if not running then
        timer:start()
        running = true
    end
end

function animator.unsubscribe(obj)
    subscribers[obj] = nil
end

return animator
