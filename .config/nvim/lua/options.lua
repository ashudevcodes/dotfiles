-- Nvim 0.12 new ui
-- require('vim._core.ui2').enable {}

local VIM = vim

-- Show whitespace.
VIM.opt.list = true
VIM.wo.signcolumn = 'yes'

-- Use rounded borders for floating windows.
VIM.o.winborder = 'rounded'

-- Nvim 0.12 inbuilt undotree plugin
VIM.cmd.packadd 'nvim.undotree'

-- Set tab width
VIM.o.tabstop = 4
VIM.o.shiftwidth = 4
VIM.o.expandtab = true

-- c project code formationg
VIM.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.c", "*.cpp", "*.h" },
	callback = function()
		VIM.lsp.buf.format({ async = false })
	end,
})

-- changing the border color of split windows
VIM.api.nvim_set_hl(0, "WinSeparator", { fg = "#565f89", bg = "None" })

-- Activate treesitter bases on installed parcers
VIM.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function()
		pcall(VIM.treesitter.start)
	end,
})

-- Basic settings
VIM.opt.number = true
VIM.opt.relativenumber = true
VIM.opt.cursorline = true
VIM.opt.wrap = true
VIM.opt.scrolloff = 10
VIM.opt.sidescrolloff = 8

VIM.opt.wildignore:append { '.DS_Store' }
VIM.o.completeopt = 'menuone,noselect,preinsert,preview'
VIM.o.pumheight = 15
VIM.o.pumborder = 'rounded'

-- Indentation
VIM.opt.shiftwidth = 2
VIM.opt.softtabstop = 2
VIM.opt.expandtab = false
VIM.opt.smartindent = true
VIM.opt.autoindent = true

-- Search settings
VIM.opt.ignorecase = true
VIM.opt.smartcase = true
VIM.opt.hlsearch = false
VIM.opt.incsearch = true

-- Visual settings
VIM.opt.termguicolors = true
VIM.opt.showmatch = true
VIM.opt.matchtime = 2
VIM.opt.cmdheight = 1
VIM.opt.completeopt = "menuone,noinsert,noselect"
VIM.opt.showmode = false
VIM.opt.pumheight = 10
VIM.opt.pumblend = 10
VIM.opt.winblend = 0
VIM.opt.conceallevel = 0
VIM.opt.concealcursor = ""
VIM.opt.lazyredraw = true
VIM.opt.synmaxcol = 300

-- File handling
VIM.opt.backup = false
VIM.opt.writebackup = false
VIM.opt.swapfile = false
VIM.opt.undofile = true
VIM.opt.undodir = VIM.fn.expand("~/.vim/undodir")
VIM.opt.updatetime = 300
VIM.opt.timeoutlen = 500
VIM.opt.ttimeoutlen = 0
VIM.opt.autoread = true
VIM.opt.autowrite = false

-- Behavior settings
VIM.opt.hidden = true
VIM.opt.errorbells = false
VIM.opt.iskeyword:append("-")
VIM.opt.path:append("**")
VIM.opt.selection = "exclusive"
VIM.opt.mouse = "a"
VIM.o.clipboard = 'unnamedplus'
VIM.opt.modifiable = true
VIM.opt.encoding = "UTF-8"

-- Command-line completion
VIM.opt.wildmenu = true
VIM.opt.wildmode = "longest:full,full"
VIM.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
VIM.opt.diffopt:append("linematch:60")

-- Performance improvements
VIM.opt.redrawtime = 10000
VIM.opt.maxmempattern = 20000

-- Folding settings
VIM.opt.foldmethod = "expr"
VIM.opt.foldlevel = 99

-- Highlight yanked text
VIM.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		VIM.hl.on_yank()
	end,
})

-- Return to last edit position when opening files
VIM.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = VIM.api.nvim_buf_get_mark(0, '"')
		local lcount = VIM.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(VIM.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Create directories when saving files
VIM.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		local dir = VIM.fn.expand("<afile>:p:h")
		if VIM.fn.isdirectory(dir) == 0 then
			VIM.fn.mkdir(dir, "p")
		end
	end,
})


-- Create undo directory if it doesn't exist
local undodir = VIM.fn.expand("~/.vim/undodir")
if VIM.fn.isdirectory(undodir) == 0 then
	VIM.fn.mkdir(undodir, "p")
end
