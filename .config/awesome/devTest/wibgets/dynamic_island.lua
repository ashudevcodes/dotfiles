local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local dynamic_island = {}

-- Island state
local island_wibox = nil
local current_content = nil
local is_expanded = false
local animation_timer = nil
local hide_timer = nil

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber(hex:sub(1, 2), 16) / 255,
        tonumber(hex:sub(3, 4), 16) / 255,
        tonumber(hex:sub(5, 6), 16) / 255
    }
end

-- Create the island wibox
local function create_island()
    local screen = awful.screen.focused()
    
    island_wibox = wibox({
        screen = screen,
        x = screen.geometry.width / 2 - 75,
        y = 8,
        width = 150,
        height = 36,
        bg = "#000000",
        fg = "#ffffff",
        ontop = true,
        visible = false,
        type = "dock"
    })
    
    island_wibox.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, h / 2)
    end
    
    island_wibox:setup({
        layout = wibox.layout.stack,
        {
            id = "content",
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = "JetBrainsMono Nerd Font 10"
        }
    })
end

-- Expand animation
function dynamic_island.expand(content, duration)
    if not island_wibox then create_island() end
    
    -- Cancel hide timer
    if hide_timer then
        hide_timer:stop()
        hide_timer = nil
    end
    
    local content_widget = island_wibox:get_children_by_id("content")[1]
    content_widget.text = content
    
    island_wibox.visible = true
    
    -- Animate width expansion
    local target_width = 250
    local start_width = 150
    local step = 0
    local max_steps = 10
    
    if animation_timer then animation_timer:stop() end
    
    animation_timer = gears.timer {
        timeout = 0.02,
        autostart = true,
        callback = function()
            step = step + 1
            local progress = step / max_steps
            local ease = 1 - math.pow(1 - progress, 3) -- ease-out cubic
            
            local new_width = start_width + (target_width - start_width) * ease
            local screen = awful.screen.focused()
            island_wibox.x = screen.geometry.width / 2 - new_width / 2
            island_wibox.width = new_width
            
            if step >= max_steps then
                animation_timer:stop()
                is_expanded = true
                
                -- Auto hide after duration
                hide_timer = gears.timer {
                    timeout = duration or 3,
                    autostart = true,
                    single_shot = true,
                    callback = function()
                        dynamic_island.collapse()
                    end
                }
            end
        end
    }
end

-- Collapse animation
function dynamic_island.collapse()
    if not island_wibox or not is_expanded then return end
    
    local target_width = 150
    local start_width = island_wibox.width
    local step = 0
    local max_steps = 10
    
    if animation_timer then animation_timer:stop() end
    
    animation_timer = gears.timer {
        timeout = 0.02,
        autostart = true,
        callback = function()
            step = step + 1
            local progress = step / max_steps
            local ease = 1 - math.pow(1 - progress, 3)
            
            local new_width = start_width + (target_width - start_width) * ease
            local screen = awful.screen.focused()
            island_wibox.x = screen.geometry.width / 2 - new_width / 2
            island_wibox.width = new_width
            
            if step >= max_steps then
                animation_timer:stop()
                is_expanded = false
                island_wibox.visible = false
            end
        end
    }
end

-- Quick status update (compact mode)
function dynamic_island.show_status(icon, duration)
    if not island_wibox then create_island() end
    
    local content_widget = island_wibox:get_children_by_id("content")[1]
    content_widget.text = icon
    
    island_wibox.width = 150
    local screen = awful.screen.focused()
    island_wibox.x = screen.geometry.width / 2 - 75
    island_wibox.visible = true
    
    gears.timer {
        timeout = duration or 2,
        autostart = true,
        single_shot = true,
        callback = function()
            island_wibox.visible = false
        end
    }
end

-- Notification handler
naughty.connect_signal("added", function(n)
    dynamic_island.expand(n.title .. " - " .. n.message, 4)
end)

return dynamic_island
