vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-S>", ":update<CR>", { noremap = true, silent = true, desc = "Save file if modified" })

-- Remaps For Tabs Switching
vim.keymap.set("n", "<A-.>", ":BufferNext<CR>")
vim.keymap.set("n", "<A-,>", ":BufferPrevious<CR>")

-- Close the tab
vim.keymap.set("n", "<A-c>", ":BufferClose<CR>")
