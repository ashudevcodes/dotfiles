vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/saghen/blink.cmp"},
  { src = "https://github.com/numToStr/Comment.nvim"},
  { src = "https://github.com/catgoose/nvim-colorizer.lua"},
  { src = "https://github.com/windwp/nvim-autopairs"},
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

require("telescope").setup()

require("colorizer").setup()

require('Comment').setup()

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

require("tokyonight").setup({
  transparent = true,
  styles = { sidebars = "transparent", floats = "transparent" },
})
vim.cmd[[colorscheme tokyonight-night]]

require("blink.cmp").setup({
  keymap = { preset = 'enter' },
  appearance = {
	nerd_font_variant = 'mono'
  },
  completion = {
	documentation = { auto_show = true }
  },
  sources = {
	default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = {
	implementation = "lua"
  }
})

require("mason").setup({
  ui = {
    border  = "rounded",
    backdrop = 60,
    icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
	"clangd",
  },
  automatic_enable = true,
})

require("gitsigns").setup({
  signs = {
    add          = { text = "│" },
    change       = { text = "│" },
    delete       = { text = "󰍵" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "│" },
  },
})

