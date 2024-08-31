-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/folke/noice.nvim

---@type LazySpec
return {
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- disable everything but cmd line
      messages = { enabled = false },
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
      },

      -- have / appear at the bottom
      presets = {
        bottom_search = true,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
  },
}
