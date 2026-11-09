-- Cascade appearance: window size and diagonal spacing.
local opts = {
    solo = 0.8,
    size = 0.7,
    step = 40,
}

-- Screen space reserved for panels and bars.
local margin = {
    top = 0,
    bottom = 0,
    left = 0,
    right = 0,
}

-- Window classes excluded from automatic cascading.
local skip = {
    mpv = true,
    bluetooth_status = true,
    wifi_status = true,
    QEMU = true,
    ["org.localsend.localsend_app"] = true,
    ["org.pwmt.zathura"] = true,
    ["org.gnome.Nautilus"] = true,
    pcmanfm = true,
    ["org.pulseaudio.pavucontrol"] = true,
}

-- Shared state: shortcuts use these to control cascade mode.
local dsp = hl.dsp.window
local enabled = {}
local queue = {}

-- Calculate the position and size of every window in the cascade.
local function cascade(area, count)
    local boxes = {}

    if count == 0 then return boxes end

    -- A single window gets more space than a group.
    local size = count == 1 and opts.solo or opts.size
    local width = area.w * ( size / 1.2 )
    local height = area.h * size

    -- Keep the entire cascade inside the available screen area.
    local room = math.max(0, math.min(
        area.w - width,
        area.h - height
    ))

    -- Reduce the diagonal offset when there are many windows.
    local step = count > 1
        and math.min(opts.step, room / (count - 1))
        or 0

    -- Center the complete cascade instead of centering each window.
    local offset = step * (count - 1)
    local x = area.x + (area.w - width - offset) / 2
    local y = area.y + (area.h - height - offset) / 2

    -- Each window occupies one slot along the diagonal.
    for i = 1, count do
        boxes[i] = {
            x = x + (i - 1) * step,
            y = y + (i - 1) * step,
            w = width,
            h = height,
        }
    end

    return boxes
end

-- Round fractional coordinates to physical pixel values.
local function round(value)
    return math.floor(value + 0.5)
end

local function get_monitor(workspace_id)
    for _, monitor in ipairs(hl.get_monitors()) do
        local workspace = monitor.active_workspace

        if workspace and workspace.id == workspace_id then
            return monitor
        end
    end
end

-- Calculate the usable screen area, accounting for scaling and margins.
local function get_area(monitor)
    local scale = monitor.scale or 1

    return {
        x = monitor.x + margin.left,
        y = monitor.y + margin.top,
        w = monitor.width / scale - margin.left - margin.right,
        h = monitor.height / scale - margin.top - margin.bottom,
    }
end

local function place_window(window, box)
    pcall(function()
        hl.dispatch(dsp.float({ window = window, action = "enable", }))

        if not box then return end
        hl.dispatch(dsp.resize({ window = window, x = round(box.w), y = round(box.h), relative = false, }))
        hl.dispatch(dsp.move({ window = window, x = round(box.x), y = round(box.y), relative = false, }))
    end)
end

-- Arrange selected windows into the final slots of the complete cascade.
local function fit_workspace(workspace_id, new_windows)
    local windows = hl.get_workspace_windows(workspace_id)
    local monitor = get_monitor(workspace_id)

    -- Without an active monitor, float windows without positioning them.
    local boxes = monitor and cascade(get_area(monitor), #windows) or {}

    -- When no selection is supplied, arrange every workspace window.
    new_windows = new_windows or windows

    -- New windows take the slots at the end of the cascade.
    local first_slot = #windows - #new_windows + 1

    for i, window in ipairs(new_windows) do
        place_window(window, boxes[first_slot + i - 1])
    end
end

-- Collect new windows and arrange them together after a short delay.
local function queue_window(window)
    local workspace = window.workspace or hl.get_active_workspace()

    -- Only workspaces with cascade mode enabled accept new windows.
    if not workspace or not enabled[workspace.id] then return end

    local id = workspace.id
    if not id then return end

    -- Schedule one timer per workspace, not one timer per window.
    local first = queue[id] == nil

    queue[id] = queue[id] or {}
    table.insert(queue[id], window)

    if not first then return end

    hl.timer(function()
        -- Take the pending windows and clear the queue.
        local windows = queue[id]
        queue[id] = nil

        -- The user may have switched layouts while the timer was waiting.
        if windows and enabled[id] then
            fit_workspace(id, windows)
        end
    end, {
        timeout = 50,
        type = "oneshot",
    })
end

-- New windows enter the cascade through the queue.
hl.on("window.open", function(window)
    if not window or skip[window.class] or skip[window.title] then return end

    queue_window(window)
end)

-- Expose the controls needed by the separate layout shortcut file.
_G.Cascade = {
    enabled = enabled,
    queue = queue,
    fit = fit_workspace,
}
