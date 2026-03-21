return {
  "ludovicchabant/vim-gutentags",
  init = function()
    vim.g.gutentags_enabled = 1
    vim.g.gutentags_enabled_filetypes = { "go" }
    vim.g.gutentags_exclude_filetypes = { "markdown", "json", "yaml", "toml", "vim", "text" }
    vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/nvim/ctags")
    vim.g.gutentags_project_root = { ".git", "go.mod", "Makefile" }
    vim.g.gutentags_ctags_extra_args = {
      "--recurse=yes",
      "--tag-relative=yes",
      "--fields=+ailmnS",
    }
    vim.g.gutentags_ctags_exclude = {
      "*.pb.go",
      "*_generated.go",
      "dist/*",
      "build/*",
      ".git/*",
    }
    vim.g.gutentags_generate_on_new = 1
    vim.g.gutentags_generate_on_missing = 1
    vim.g.gutentags_generate_on_write = 1
    vim.g.gutentags_generate_on_empty_buffer = 0
  end,
}
