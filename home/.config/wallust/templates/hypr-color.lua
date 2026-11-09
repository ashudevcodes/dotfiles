-- Central desktop colour palette
-- Wallust replaces these template variables when generating the file.

local palette = {
    background = "{{background}}",
    foreground = "{{foreground}}",
    cursor     = "{{cursor}}",

    color0  = "{{color0}}",
    color1  = "{{color1}}",
    color2  = "{{color2}}",
    color3  = "{{color3}}",
    color4  = "{{color4}}",
    color5  = "{{color5}}",
    color6  = "{{color6}}",
    color7  = "{{color7}}",

    color8  = "{{color8}}",
    color9  = "{{color9}}",
    color10 = "{{color10}}",
    color11 = "{{color11}}",
    color12 = "{{color12}}",
    color13 = "{{color13}}",
    color14 = "{{color14}}",
    color15 = "{{color15}}",
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
