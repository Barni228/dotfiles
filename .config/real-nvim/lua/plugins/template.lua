if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/Username/pluginname

---@type LazySpec
return {
  {
    "Username/pluginname",
    dependencies = { "dependencies" },
    config = function()
      require("pluginname").setup {
        -- config
      }
    end,
    opts = {
      -- config
    },
    cmd = { "commands" },
    event = {
      "User AstroFile", -- when opening file
      "VeryLazy", -- when starting nvim
      "BufEnter *.lua", -- when opening lua file
      "InsertEnter", -- when entering insert mode
    },
    keys = {
      { "<leader>T", "<cmd>Command<cr>", desc = "Description" },
    },
    lazy = true, --> if false, load immediately
  },
}
