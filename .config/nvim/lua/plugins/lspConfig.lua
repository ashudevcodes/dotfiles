return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
						disable = { "different-requires" },
					},
				},
			},
		})

		lspconfig.gopls.setup({
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		lspconfig.pylsp.setup({
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = { "W391" },
							maxLineLength = 100,
						},
					},
				},
			},
		})
		
		lspconfig.clangd.setup({
           		 cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
            			init_options = {
                			fallbackFlags = { '-std=c++17' },
            			},
            			root_markers = { ".clangd-format" },
        	})

		lspconfig.ts_ls.setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			cmd = { "typescript-language-server", "--stdio" },
		})
	end,
}
