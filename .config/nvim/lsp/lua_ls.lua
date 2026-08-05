return {
	filetypes = { 'lua' },
	cmd = {
		'lua-language-server',
		'--memory-limit=256',
	},

	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			codeLens = { enable = true },
			hint = { enable = true, semicolon = 'Disable' },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
}
