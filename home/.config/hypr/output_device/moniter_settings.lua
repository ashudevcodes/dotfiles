local hour = tonumber(os.date("%H"))
local is_night = hour >= 22 or hour < 10

if is_night then
  hl.monitor({
    output = "eDP-1",
    mode = "1536x864@60",
    scale = 1,
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
    scale = 1.2,
  })
end
