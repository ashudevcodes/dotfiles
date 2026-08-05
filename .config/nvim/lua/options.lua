-- Nvim 0.12 new ui
--require('vim._core.ui2').enable {}

-- Show whitespace.
vim.opt.list = false
vim.wo.signcolumn = 'yes'

-- Use rounded borders for floating windows.
vim.o.winborder = 'rounded'

-- Nvim 0.12 inbuilt undotree plugin
vim.cmd.packadd 'nvim.undotree'

-- Set tab width
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local curpos = vim.api.nvim_win_get_cursor(0)

		vim.cmd([[keeppatterns %s/\s\+$//e]])

		vim.api.nvim_win_set_cursor(0, curpos)
	end
})

-- c project code formationg
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.*" },
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})

-- changing the border color of split windows
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#565f89", bg = "None" })

-- Activate treesitter bases on installed parcers
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.laststatus = 3

vim.opt.wildignore:append { '.DS_Store' }

vim.o.pumheight = 15
vim.o.pumborder = 'rounded'

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

-- Behavior settings
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "exclusive"
vim.opt.mouse = "a"
vim.o.clipboard = 'unnamedplus'
vim.opt.modifiable = true
vim.opt.encoding = "UTF-8"

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
