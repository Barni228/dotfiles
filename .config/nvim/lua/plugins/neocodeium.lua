-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- https://github.com/monkoose/neocodeium
---@type LazySpec
return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require "neocodeium"
      neocodeium.setup {
        show_label = false,
        silent = true,
        -- max_lines = -1,
      }

      vim.keymap.set(
        "i",
        "ça",
        neocodeium.accept,
        { desc = "accept suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "å",
        neocodeium.accept,
        { desc = "accept suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "çw",
        neocodeium.accept_word,
        { desc = "accept a word", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "∑",
        neocodeium.accept_word,
        { desc = "accept_word", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "çs",
        neocodeium.accept_line,
        { desc = "accept line", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "ß",
        neocodeium.accept_line,
        { desc = "accept line", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "çn",
        neocodeium.cycle_or_complete,
        { desc = "next suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "çr",
        function() neocodeium.cycle_or_complete(-1) end,
        { desc = "cycle back", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "çq",
        neocodeium.clear,
        { desc = "clear suggestions", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "œ",
        neocodeium.clear,
        { desc = "clear suggestions", noremap = true, silent = true }
      )
    end,
  },
}
