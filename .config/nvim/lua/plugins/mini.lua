-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/echasnovski/mini.nvim

---@type LazySpec
return {
  {
    "echasnovski/mini.nvim",
    lazy = false,
    config = function()
      -- mini.animate

      -- highlight word under cursor
      require("mini.cursorword").setup()

      -- split/join lists like [1, 2, 3, 4]
      require("mini.splitjoin").setup { mappings = { toggle = "gs" } }

      -- move selected thing with `gk`, and `.` to confirm
      -- sort words by their first letter with `gS`
      -- evaluate selected math stuff with `g=` (ex. "(3 * 3) ^ .5")
      -- multiply selected stuff with `gm`
      require("mini.operators").setup {
        exchange = {
          prefix = "gk",
        },
        sort = {
          prefix = "gS",
        },
      }

      require("mini.ai").setup { n_lines = 1000000 }
    end,
  },
}
