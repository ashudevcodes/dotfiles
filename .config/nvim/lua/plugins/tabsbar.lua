return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			auto_hide = true,
			animation = false,
			hide = { extensions = true },
			icons = {
				button = "",
				diagnostics = {
					[vim.diagnostic.severity.HINT] = { enabled = false },
				},
				separator = { left = "", right = "▕" },
				current = { buffer_index = false },
				inactive = { button = "", separator = { left = "", right = "▕" } },
			},
			highlight_visible = false,
		},

		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
}
