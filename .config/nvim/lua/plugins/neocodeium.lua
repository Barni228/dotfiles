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
        "<M-a>",
        neocodeium.accept,
        { desc = "accept suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-w>",
        neocodeium.accept_word,
        { desc = "accept_word", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-s>",
        neocodeium.accept_line,
        { desc = "accept line", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-e>",
        neocodeium.clear,
        { desc = "clear suggestions", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>a",
        neocodeium.accept,
        { desc = "󰆉 accept suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>w",
        neocodeium.accept_word,
        { desc = " accept a word", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>s",
        neocodeium.accept_line,
        { desc = "󰦩 accept line", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>n",
        neocodeium.cycle_or_complete,
        { desc = "󰒭 next suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>r",
        function() neocodeium.cycle_or_complete(-1) end,
        { desc = "󰒮 previous suggestion", noremap = true, silent = true }
      )

      vim.keymap.set(
        "i",
        "<M-c>e",
        neocodeium.clear,
        { desc = " clear suggestions", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>cbe",
        ":<cmd>NeoCodeium enable_buffer<cr>",
        { desc = "󰚩 Enable Codeium in buffer", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>cbd",
        ":<cmd>NeoCodeium disable_buffer<cr>",
        { desc = "󱚧 Disable Codeium in buffer", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>ce",
        ":<cmd>NeoCodeium enable<cr>",
        { desc = "󰚩  Enable Codeium", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>cd",
        ":<cmd>NeoCodeium disable<cr>",
        { desc = "󱚧  Disable Codeium", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>ct",
        ":<cmd>NeoCodeium toggle<cr>",
        { desc = "  Toggle Codeium", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>cr",
        ":<cmd>NeoCodeium restart<cr>",
        { desc = " Restart Codeium", noremap = true, silent = true }
      )

      vim.keymap.set(
        { "i", "n" },
        "<M-c>cl",
        ":<cmd>NeoCodeium open_log<cr>",
        { desc = "󱂅  Open log", noremap = true, silent = true }
      )
    end,
  },
}
-- vim.keymap.set(
--   "i",
--   "ça",
--   neocodeium.accept,
--   { desc = "accept suggestion", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "å",
--   neocodeium.accept,
--   { desc = "accept suggestion", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "çw",
--   neocodeium.accept_word,
--   { desc = "accept a word", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "∑",
--   neocodeium.accept_word,
--   { desc = "accept_word", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "çs",
--   neocodeium.accept_line,
--   { desc = "accept line", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "ß",
--   neocodeium.accept_line,
--   { desc = "accept line", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "çn",
--   neocodeium.cycle_or_complete,
--   { desc = "next suggestion", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "çr",
--   function() neocodeium.cycle_or_complete(-1) end,
--   { desc = "cycle back", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "çq",
--   neocodeium.clear,
--   { desc = "clear suggestions", noremap = true, silent = true }
-- )
--
-- vim.keymap.set(
--   "i",
--   "œ",
--   neocodeium.clear,
--   { desc = "clear suggestions", noremap = true, silent = true }
-- )
