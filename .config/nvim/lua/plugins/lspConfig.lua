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
			workspace = {
			  checkThirdParty = false, --
			  maxPreload = 500,        --
			  preloadFileSize = 500,   --
			},
			telemetry = { enable = false }, --
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
		  "--limit-results=50",
		  "--j=1",
		  "--header-insertion=never",
		  "--index-file-size=2000000",
		},
	  })
	end,
  },
})
end,
},
}
