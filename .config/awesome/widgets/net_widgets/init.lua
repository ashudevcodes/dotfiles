local module_path = (...):match("(.+/)[^/]+$") or ""

package.loaded.net_widgets = nil

local net_widgets = {
    wireless = require(module_path .. "net_widgets.wireless"),
}

return net_widgets
