local opts = {
  size = 0.65,
  solo = 0.80,
  step = 48,

  inset = { top = 0, bottom = 0, left = 0, right = 0 },
}

local function round(v) return math.floor(v + 0.5) end

local function cascade(a, n)
  local boxes = {}
  if n == 0 then return boxes end

  local frac = (n == 1) and opts.solo or opts.size
  local w = a.w * frac
  local h = a.h * frac

  local room = math.max(0, math.min(a.w - w, a.h - h))
  local step = (n > 1) and math.min(opts.step, room / (n - 1)) or 0

  local x0 = a.x + (a.w - w - step * (n - 1)) / 2
  local y0 = a.y + (a.h - h - step * (n - 1)) / 2

  for i = 1, n do
    boxes[i] = {
      x = x0 + (i - 1) * step,
      y = y0 + (i - 1) * step,
      w = w,
      h = h,
    }
  end
  return boxes
end

hl.layout.register("floating", {
  recalculate = function(ctx)
    local targets = ctx.targets
    local boxes = cascade(ctx.area, #targets)
    for i, target in ipairs(targets) do
      target:place(boxes[i])
    end
  end,
})

function Float_cascade(workspace)
  local windows = hl.get_workspace_windows(workspace)
  if #windows == 0 then return end

  local m = hl.get_active_monitor()
  if m == nil then return end

  local scale = m.scale or 1
  local inset = opts.inset

  local area = {
    x = m.x + inset.left,
    y = m.y + inset.top,
    w = m.width / scale - inset.left - inset.right,
    h = m.height / scale - inset.top - inset.bottom,
  }

  local boxes = cascade(area, #windows)

  for i, win in ipairs(windows) do
    local b = boxes[i]
    hl.dispatch(hl.dsp.window.float({ action = "set", window = win }))
    hl.dispatch(hl.dsp.window.resize({ x = round(b.w), y = round(b.h), window = win }))
    hl.dispatch(hl.dsp.window.move({ x = round(b.x), y = round(b.y), window = win }))
  end
end

hl.on("window.open", function(win)
  local ws = win.workspace or hl.get_active_workspace()

  if ws and ws.tiled_layout == "lua:floating" then
    local m = hl.get_active_monitor()
    if m == nil then return end
    local scale = m.scale or 1

    local w = math.floor(m.width / scale * 0.65 + 0.5)
    local h = math.floor(m.height / scale * 0.65 + 0.5)

    hl.dispatch(hl.dsp.window.float({ action = "set", window = win }))
    hl.dispatch(hl.dsp.window.resize({ x = w, y = h, window = win }))
    hl.dispatch(hl.dsp.window.center({ window = win }))
  end
end)
