local M = {}

local palette_file = vim.fn.expand("~/.cache/wallust/generated/nvim.lua")

-- Tuning knobs --------------------------------------------------------------
local MIN_CONTRAST = 4.5  -- colourful palettes: minimum accent contrast vs background
local MONO_SAT     = 0.10 -- if every accent is below this saturation, treat palette as greyscale

-- Greyscale palettes only: contrast ratio each accent is placed at vs the
-- background. Higher = brighter. Spread out so roles stay distinguishable.
local MONO_CONTRAST = {
    red    = 14,  -- builtin variables (self/this), errors
    blue   = 12,  -- functions
    yellow = 10,  -- types
    purple = 8.5, -- keywords
    orange = 7,   -- numbers, constants
    cyan   = 5.8, -- properties, identifiers
    green  = 4.8, -- strings
}

-- Color helpers -------------------------------------------------------------
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16) / 255,
           tonumber(hex:sub(3, 4), 16) / 255,
           tonumber(hex:sub(5, 6), 16) / 255
end

local function rgb_to_hex(r, g, b)
    local function ch(x)
        return math.floor(math.max(0, math.min(1, x)) * 255 + 0.5)
    end
    return string.format("#%02x%02x%02x", ch(r), ch(g), ch(b))
end

local function rgb_to_hsl(r, g, b)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local l = (max + min) / 2
    if max == min then return 0, 0, l end
    local d = max - min
    local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    local h
    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    return h * 60, s, l
end

local function hsl_to_rgb(h, s, l)
    h = (h % 360) / 360
    if s == 0 then return l, l, l end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    local function hue(t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end
    return hue(h + 1 / 3), hue(h), hue(h - 1 / 3)
end

local function luminance(hex)
    local r, g, b = hex_to_rgb(hex)
    local function lin(c)
        return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
    end
    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
end

local function contrast(a, b)
    local la, lb = luminance(a), luminance(b)
    if la < lb then la, lb = lb, la end
    return (la + 0.05) / (lb + 0.05)
end

local function is_dark(hex)
    return luminance(hex) < 0.179
end

local function mix(a, b, t)
    local ar, ag, ab = hex_to_rgb(a)
    local br, bgc, bb = hex_to_rgb(b)
    return rgb_to_hex(ar + (br - ar) * t, ag + (bgc - ag) * t, ab + (bb - ab) * t)
end

-- Only move lightness (hue + saturation stay from the wallpaper) until the
-- color reaches at least `min_ratio` contrast against `against`.
local function ensure_contrast(hex, against, min_ratio)
    if contrast(hex, against) >= min_ratio then return hex end
    local h, s, l = rgb_to_hsl(hex_to_rgb(hex))
    local dark = is_dark(against)
    local step = dark and 0.02 or -0.02
    for _ = 1, 50 do
        l = math.max(0, math.min(1, l + step))
        local cand = rgb_to_hex(hsl_to_rgb(h, s, l))
        if contrast(cand, against) >= min_ratio then return cand end
    end
    return dark and "#ffffff" or "#000000"
end

-- Same idea, but lands on an exact contrast ratio (used for greyscale spread).
local function at_contrast(hex, against, target)
    local h, s = rgb_to_hsl(hex_to_rgb(hex))
    local dark = is_dark(against)
    local lo, hi = 0, 1
    for _ = 1, 24 do
        local mid = (lo + hi) / 2
        local ratio = contrast(rgb_to_hex(hsl_to_rgb(h, s, mid)), against)
        if (ratio < target) == dark then lo = mid else hi = mid end
    end
    return rgb_to_hex(hsl_to_rgb(h, s, (lo + hi) / 2))
end

local function is_monochrome(list)
    for _, hex in pairs(list) do
        local _, s = rgb_to_hsl(hex_to_rgb(hex))
        if s > MONO_SAT then return false end
    end
    return true
end

-- Theme ---------------------------------------------------------------------
function M.load()
    local ok, c = pcall(dofile, palette_file)

    if not ok then
        vim.notify("Wallust palette unavailable", vim.log.levels.WARN)
        return
    end

    local base = c.background
    local fg_primary = ensure_contrast(c.foreground, base, 7)

    local bg = {
        base = base,
        surface = mix(base, fg_primary, 0.07),
        overlay = mix(base, fg_primary, 0.16),
    }

    local fg = {
        primary = fg_primary,
        muted = ensure_contrast(c.color8, base, 3.5),
        subtle = ensure_contrast(c.color7, base, 5),
    }

    -- Same wallust slots as your original theme.
    local source = {
        blue   = c.color4,
        cyan   = c.color6,
        purple = c.color5,
        green  = c.color2,
        yellow = c.color3,
        red    = c.color1,
        orange = c.color9,
    }

    local mono = is_monochrome(source)
    local accent = {}
    for name, hex in pairs(source) do
        if mono then
            accent[name] = at_contrast(hex, base, MONO_CONTRAST[name])
        else
            accent[name] = ensure_contrast(hex, base, MIN_CONTRAST)
        end
    end

    vim.o.termguicolors = true
    vim.o.background = is_dark(base) and "dark" or "light"
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "wallust"

    local groups = {
        -- Editor
        Normal          = { fg = fg.primary, bg = bg.base },
        NormalNC        = { fg = fg.primary, bg = bg.base },
        EndOfBuffer     = { fg = bg.overlay },
        NonText         = { fg = bg.overlay },
        SignColumn      = { bg = bg.base },
        FoldColumn      = { fg = fg.muted, bg = bg.base },

        -- Lines and cursor
        CursorLine      = { bg = bg.base, underline = true, sp = accent.blue },
        CursorColumn    = { bg = bg.surface },
        ColorColumn     = { bg = bg.surface },
        LineNr          = { fg = fg.muted },
        CursorLineNr    = { fg = accent.blue, bold = true },

        -- Blink completion
        BlinkCmpMenu             = { fg = fg.primary },
        BlinkCmpMenuBorder       = { fg = accent.cyan },
        BlinkCmpMenuSelection    = { fg = bg.base, bg = accent.green, bold = true },
        BlinkCmpLabel            = { fg = fg.primary },
        BlinkCmpLabelDescription = { fg = fg.muted },
        BlinkCmpLabelMatch       = { fg = accent.blue, bold = true },

        -- Netrw
        Directory       = { fg = accent.blue, bold = true },
        netrwDir        = { fg = accent.blue, bold = true },
        netrwClassify   = { fg = accent.cyan },
        netrwLink       = { fg = accent.cyan, italic = true },
        netrwExe        = { fg = accent.green, bold = true },
        netrwPlain      = { fg = fg.primary },
        netrwSpecial    = { fg = accent.orange },
        netrwSymLink    = { fg = accent.cyan },
        netrwTreeBar    = { fg = bg.overlay },
        netrwVersion    = { fg = fg.muted },
        netrwComment    = { fg = fg.muted, italic = true },
        netrwList       = { fg = fg.primary },
        netrwHelpCmd    = { fg = accent.blue },
        netrwHelpKey    = { fg = accent.yellow },
        netrwMarkFile   = { fg = accent.green, bold = true },
        netrwHide       = { fg = fg.muted },
        netrwGray       = { fg = fg.muted },

        -- Selection and search
        Visual          = { bg = bg.overlay },
        Search          = { fg = bg.base, bg = accent.yellow },
        IncSearch       = { fg = bg.base, bg = accent.orange },
        CurSearch       = { fg = bg.base, bg = accent.orange, bold = true },
        MatchParen      = { fg = accent.cyan, bold = true, underline = true },

        -- Floating windows
        NormalFloat     = { fg = fg.primary },
        FloatBorder     = { fg = accent.blue },
        FloatTitle      = { fg = accent.blue, bold = true },
        WinSeparator    = { fg = bg.overlay },

        -- Popup menu
        Pmenu           = { fg = fg.primary },
        PmenuSel        = { fg = bg.base, bg = accent.blue, bold = true },

        -- Statusline and tabline
        StatusLine      = { fg = fg.primary, bg = bg.surface },
        StatusLineNC    = { fg = fg.muted, bg = bg.base },
        WinBar          = { fg = fg.primary, bg = bg.base },
        WinBarNC        = { fg = fg.muted, bg = bg.base },
        TabLine         = { fg = fg.muted, bg = bg.surface },
        TabLineSel      = { fg = accent.blue, bg = bg.base, bold = true },
        TabLineFill     = { bg = bg.base },

        -- Folds
        Folded          = { fg = fg.muted, bg = bg.surface, italic = true },

        -- Syntax
        Comment         = { fg = fg.muted, italic = true },
        String          = { fg = accent.green },
        Character       = { fg = accent.green },
        Number          = { fg = accent.orange },
        Boolean         = { fg = accent.orange },
        Constant        = { fg = accent.orange },

        Function        = { fg = accent.blue, bold = true },
        Identifier      = { fg = accent.cyan },
        Statement       = { fg = accent.purple },
        Keyword         = { fg = accent.purple, italic = true },
        Operator        = { fg = fg.primary },
        Type            = { fg = accent.yellow },
        Special         = { fg = accent.cyan },
        SpecialChar     = { fg = accent.orange },
        Delimiter       = { fg = fg.subtle },
        PreProc         = { fg = accent.purple },
        Include         = { fg = accent.purple },
        Define          = { fg = accent.purple },
        Macro           = { fg = accent.cyan },
        Todo            = { fg = accent.yellow, bold = true },
        Title           = { fg = accent.blue, bold = true },

        -- Treesitter
        ["@function"]              = { fg = accent.blue, bold = true },
        ["@function.call"]         = { fg = accent.blue },
        ["@function.builtin"]      = { fg = accent.cyan },
        ["@method"]                = { fg = accent.blue },
        ["@constructor"]           = { fg = accent.yellow },
        ["@keyword"]               = { fg = accent.purple, italic = true },
        ["@keyword.function"]      = { fg = accent.purple, italic = true },
        ["@keyword.operator"]      = { fg = accent.purple },
        ["@keyword.return"]        = { fg = accent.purple, bold = true },
        ["@string"]                = { fg = accent.green },
        ["@string.escape"]         = { fg = accent.orange },
        ["@number"]                = { fg = accent.orange },
        ["@boolean"]               = { fg = accent.orange },
        ["@type"]                  = { fg = accent.yellow },
        ["@type.builtin"]          = { fg = accent.yellow, italic = true },
        ["@variable"]              = { fg = fg.primary },
        ["@variable.builtin"]      = { fg = accent.red, italic = true },
        ["@variable.parameter"]    = { fg = accent.orange },
        ["@property"]              = { fg = accent.cyan },
        ["@constant"]              = { fg = accent.orange },
        ["@constant.builtin"]      = { fg = accent.orange, italic = true },
        ["@comment"]               = { fg = fg.muted, italic = true },
        ["@operator"]              = { fg = fg.primary },
        ["@punctuation.bracket"]   = { fg = fg.subtle },
        ["@punctuation.delimiter"] = { fg = fg.subtle },

        -- Diagnostics
        Error           = { fg = accent.red },
        WarningMsg      = { fg = accent.yellow },
        DiagnosticError = { fg = accent.red },
        DiagnosticWarn  = { fg = accent.yellow },
        DiagnosticInfo  = { fg = accent.cyan },
        DiagnosticHint  = { fg = accent.blue },

        -- Diff
        DiffAdd         = { fg = accent.green },
        DiffChange      = { fg = accent.yellow },
        DiffDelete      = { fg = accent.red },
        DiffText        = { fg = accent.blue, bold = true },
    }

    for name, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

return M
