return {
	{
		"folke/tokyonight.nvim",
	
		opts = function()
     			 return require("plugins.configs.tokyonight")
   		 end,
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
}
