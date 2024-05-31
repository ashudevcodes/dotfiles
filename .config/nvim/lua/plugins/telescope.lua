return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter","nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    init = function()
      local builtin = require('telescope.builtin')
      local wk = require('which-key')
      wk.register({
        ['ff'] = { builtin.find_files, "Find File" },
        ['fb'] = { builtin.buffers, "Find Buffer" },
        ['fg'] = { builtin.live_grep, "Find with Grep" },
        ['fh'] = { builtin.help_tags, "Find Help" },
        ['fn'] = { ":Telescope file_browser path=%:p:h select_buffer=true<CR>", "File Browser" },
      }, { prefix = "<leader>" })
    end,
    opts = function()
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          previewer = true,
          file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
    end,
  },
}
