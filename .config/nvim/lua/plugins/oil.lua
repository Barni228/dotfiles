-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/stevearc/oil.nvim

---@type LazySpec
return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {
      delete_to_trash = false,
      skip_confirm_for_simple_edits = true,
      view_options = {
        natural_order = true,
      },
    }
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
