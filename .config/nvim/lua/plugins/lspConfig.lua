return {
	{
		"neovim/nvim-lspconfig",

		event = { "BufReadPre", "BufNewFile" },

		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "clangd", "ts_ls", "pylsp", "gopls" },
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["clangd"] = function()
					lspconfig.clangd.setup({
						init_options = {
							fallbackFlags = { "-std=c++17" },
						},
						root_markers = { ".clangd-format" },
					})
				end,

				["gopls"] = function()
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
				end,

				["lua_ls"] = function()
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
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
	},
}
