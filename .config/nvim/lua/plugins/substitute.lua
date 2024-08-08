-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/chrisgrieser/nvim-rip-substitute

---@type LazySpec
return {
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = { "RipSubstitute" },
    opts = {
      keymaps = {
        abort = "<esc>",
      },
      notificationOnSuccess = false,
    },
    keys = {
      {
        "<leader>s",
        ":RipSubstitute<cr>", -- if we are in visual mode, `:` will automatically insert '<,'>
        mode = { "n", "x", "v" },
        desc = " rip substitute",
      },
    },
  },
}
