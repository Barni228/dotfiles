-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/Username/pluginname

---@type LazySpec
return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require("neogit").setup {
        graph_style = "unicode",
        disable_line_numbers = false,
        signs = {
          hunk = { "", "" },
          item = { "", "" },
          section = { "", "" },
        },
        mappings = {
          commit_editor = {
            ["ZZ"] = "Submit",
          },
          status = {
            ["j"] = false,
            ["k"] = false,
          },

          popup = {
            ["Z"] = false,
            ["z"] = "StashPopup",
          },
        }
      }
    end,
  },
}
