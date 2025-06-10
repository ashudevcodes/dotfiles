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

vim.keymap.set("n", "<leader>d", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
end, { desc = "Toggle diagnostic virtual_text" })
