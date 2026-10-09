local gears = require('gears')

local stay_classes = {
  awesome
}

local function set_contains(set, key)
  return set[key] ~= nil
end

local mouseflow = function()
  gears.timer.weak_start_new(0.05, function()
	local c = client.focus
	if not c then return end
	local cgeometry = c:geometry()

	mouse.coords({
	  x = cgeometry.x + cgeometry.width / 2,
	  y = cgeometry.y + cgeometry.height / 2
	})
  end)
end
--+ relocate mouse after slightly waiting for focus to
--> complete. you can adjust the timer if you are on a slow
--> cpu to give more time for the client to appear.

---------------------------------------------------------------------> signal ;

client.connect_signal("focus", function(c)
  local focused_client = c
  --+ client the focus is going towards

  gears.timer.weak_start_new(0.15, function()
	local client_under_mouse = mouse.current_client

	if not client_under_mouse then
	  mouseflow()
	  return false
	end

	local should_stay = set_contains(stay_classes, client_under_mouse.class)

	if should_stay then return false end
	--+ exclusions

	--+ nothing under the mouse, move directly

	if focused_client:geometry().x ~= client_under_mouse:geometry().x
	  or focused_client:geometry().y ~= client_under_mouse:geometry().y
	then
	  mouseflow()
	  return false
	end
	--+ no need to relocate the mouse if already over
	--> the client.
  end)
  --+ mouse.current_client would point to the previous
  --> client without the callback.
end)

client.connect_signal("unmanage", function(c)
  local client_under_mouse = mouse.current_client

  local killed_client = c
  --+ client the focus is going towards

  if not client_under_mouse then
	return false
  end

  if client_under_mouse ~= c then
	mouseflow()
  end
  --+ no need for the callback here.
end)

return mouseflow
