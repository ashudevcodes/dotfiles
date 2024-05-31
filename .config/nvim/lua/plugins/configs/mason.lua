require("mason").setup({
	ensure_installed = {
		"gofumpt",
		"clangd",
		"goimports",
		"golines",
		"gopls",
		"lua-language-server",
	},
})
