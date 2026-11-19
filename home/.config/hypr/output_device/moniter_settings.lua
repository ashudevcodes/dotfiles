local hour = tonumber(os.date("%H"))
local is_night = hour >= 22 or hour < 10

-- is_night = false
if is_night then
  hl.monitor({
    output = "eDP-1",
    mode = "1600x900@60",
    scale = 1,
    position = "1920x0",
  })

  hl.config({
    decoration = {
      blur = { enabled = false },
    },
  })

  hl.config({
    decoration = {
      screen_shader = '~/.config/hypr/low-light.frag'
    }
  })

else
  hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    scale = 1.20,
    position = "1920x0",
  })
end
