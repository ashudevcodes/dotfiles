require 'lsp'
require 'keybinds'
require 'options'
require("wallust").load()

if vim.fn.has('nvim-0.12') == 1 then
	require 'plugins'
end
