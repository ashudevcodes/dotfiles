vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>p", vim.cmd.Ex)

vim.keymap.set("n", "<C-S>", ":update<CR>", { noremap = true, silent = false, desc = "Save file if modif  ied" })

vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float()
end)

vim.keymap.set("n", "<A-l>", ":bnext<CR>")
vim.keymap.set("n", "<A-h>", ":bprev<CR>")

vim.keymap.set("n", "<A-c>", ":bd<CR>")

vim.keymap.set("n", "<A-s>", "<cmd>vsplit<cr>")

vim.keymap.set("n", "<A-q>", "<cmd>q<cr>")

vim.keymap.set({ "n", "t" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "t" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "t" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "t" }, "<C-l>", "<C-w>l")

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")


-- Find files keymaps. using native neovim `find`
vim.keymap.set("n", "<leader>ff", ":find ")

vim.keymap.set("n", "<leader>fg", function()
  vim.cmd("vimgrep /" .. vim.fn.input("Grep > ") .. "/gj **/*")
  vim.cmd("copen")
end)

-- Codecomment out plugins custom keymaps
vim.keymap.set('n', '<leader>/', '<Plug>(comment_toggle_linewise_current)')
vim.keymap.set('x', '<leader>/', '<Plug>(comment_toggle_blockwise_visual)')

-- nvim builtin UndotreeToggle keymaps set 
vim.keymap.set("n", "<leader>u", '<cmd>Undotree<cr>')
