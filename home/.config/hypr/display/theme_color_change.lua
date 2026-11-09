-- Central desktop colour palette
-- Wallust replaces these template variables when generating the file.

local palette = {
    background = "#0E0E0E",
    foreground = "#F1F1F1",
    cursor     = "#969696",

    color0  = "#393939",
    color1  = "#474747",
    color2  = "#676767",
    color3  = "#7C7C7C",
    color4  = "#7E7E7E",
    color5  = "#A4A4A4",
    color6  = "#D7D7D7",
    color7  = "#E3E3E3",

    color8  = "#9F9F9F",
    color9  = "#474747",
    color10 = "#676767",
    color11 = "#7C7C7C",
    color12 = "#7E7E7E",
    color13 = "#A4A4A4",
    color14 = "#D7D7D7",
    color15 = "#E3E3E3",
}

-- Global colour definitions
Colors = {
    palette = palette,

    -- General UI colours
    ui = {
        background = palette.background,
        foreground = palette.foreground,

        surface     = palette.color0,
        surface_alt = palette.color8,

        text       = palette.foreground,
        text_muted = palette.color7,

        accent     = palette.color4,
        accent_alt = palette.color5,

        selection = palette.color4 .. "33",

        success = palette.color2,
        warning = palette.color3,
        error   = palette.color1,
        info    = palette.color6,
    },

    -- Window appearance
    window = {
        active_border   = palette.color4 .. "66",
        inactive_border = palette.foreground .. "22",

        -- Neutral shadows
        active_shadow   = "#00000055",
        inactive_shadow = "#00000030",

        -- Accent glow
        active_glow   = palette.color4 .. "1A",
        inactive_glow = palette.color4 .. "08",

        -- Subtle edge lighting
        edge_highlight = palette.foreground .. "22",
        edge_lowlight  = palette.color0 .. "66",
    },
}

-- Make colours globally accessible
_G.Colors = Colors

return Colors
