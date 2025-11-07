vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>p", vim.cmd.Ex)
vim.keymap.set("n", "<C-S>", ":update<CR>", { noremap = true, silent = true, desc = "Save file if modified" })

-- Remaps For Tabs Switching
vim.keymap.set("n", "<A-l>", ":BufferNext<CR>")
vim.keymap.set("n", "<A-h>", ":BufferPrevious<CR>")

-- Close the tab
vim.keymap.set("n", "<A-c>", ":BufferClose<CR>")

vim.keymap.set("n", "<A-s>", "<cmd>vsplit<cr>")

vim.keymap.set("n", "<A-q>", "<cmd>q<cr>")

vim.keymap.set({ "n", "t" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "t" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "t" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "t" }, "<C-l>", "<C-w>l")

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
