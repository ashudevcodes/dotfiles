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

	  local lspconfig = require("lspconfig")
	  local capabilities = require("cmp_nvim_lsp").default_capabilities()
	  capabilities.offsetEncoding = { "utf-16" }

	  require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls", "clangd" },
		automatic_enable = true,
		handlers = {
		  function(server_name)
			lspconfig[server_name].setup({
			  capabilities = capabilities,
			})
		  end,

		  ["lua_ls"] = function()
			lspconfig.lua_ls.setup({
			  capabilities = capabilities,
			  settings = {
				Lua = {
				  hint = { enable = false },
				  hover = { expandAlias = false },
				  workspace = {
					checkThirdParty = false, 
					maxPreload = 100,
					preloadFileSize = 100,
					ignoreDir = { ".git", "node_modules", "build" },
				  },
				  diagnostics = {
					libraryFiles = "Opened",
				  },
				  telemetry = { enable = false },
				},
			  },
			})
		  end,

		  ["clangd"] = function()
			lspconfig.clangd.setup({
			  capabilities = capabilities,
			  cmd = {
				"clangd",
				"--background-index=false",
				"--limit-references=10",
				"--limit-results=10",
				"--j=1",
				"--limit-references=1",
				"--ranking-model=decision_tree",
				"--malloc-trim",
				"--pch-storage=disk",
				"--header-insertion=never",
			  },
			})
		  end,
		},
	  })
	end,
  },
}
