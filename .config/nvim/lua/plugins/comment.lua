return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "/", mode = "n", desc = "Comment toggle current line" },
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Toggle comment",
			},
			{
				"<leader>/",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
				mode = "v",
				desc = "Toggle comment",
			},
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
}
