vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-S>", ":update<CR>", { noremap = true, silent = true, desc = "Save file if modified" })
