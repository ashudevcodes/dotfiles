return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre", -- or choose when you want it to load
    opts = {
      -- Any setup options you want, for example:
      user_default_options = {
        mode = "background",
        names = false,
      },
    },
  },
}

