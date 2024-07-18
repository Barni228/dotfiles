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

      ---@type fun(mode: string|string[], keys: string[], func: string|function, desc: string)
      local function map(mode, keys, func, desc)
        for _, key in ipairs(keys) do
          vim.keymap.set(
            mode,
            key,
            func,
            { desc = desc, noremap = true, silent = true }
          )
        end
      end

      map("i", { "<M-a>", "<M-c>a", "å", "ça" }, neocodeium.accept, "󰆉 accept suggestion")
      map("i", { "<M-w>", "<M-c>w", "çw", "∑" }, neocodeium.accept_word, " accept a word")
      map("i", { "<M-s>", "<M-c>s", "çs", "ß" }, neocodeium.accept_line, "󰦩 accept line")
      map("i", { "<M-q>", "<M-c>q", "çq", "œ" }, neocodeium.clear, " clear suggestions")
      map("i", { "<M-c>n", "çn" }, neocodeium.cycle_or_complete, "󰒭 next suggestion")
      map("i", { "<M-c>r", "çr" }, function() neocodeium.cycle_or_complete(-1) end, "󰒮 previous suggestion")
      map({ "i", "n" }, { "<M-c>cbe", "çcbe" }, "<cmd>NeoCodeium enable_buffer<cr>", "󰚩 Enable Codeium in buffer")
      map({ "i", "n" }, { "<M-c>cbd", "çcbd" }, "<cmd>NeoCodeium disable_buffer<cr>", "󱚧 Disable Codeium in buffer")
      map({ "i", "n" }, { "<M-c>ce", "çce" }, "<cmd>NeoCodeium enable<cr>", "󰚩  Enable Codeium")
      map({ "i", "n" }, { "<M-c>cd", "çcd" }, "<cmd>NeoCodeium disable<cr>", "󱚧  Disable Codeium")
      map({ "i", "n" }, { "<M-c>ct", "çct" }, "<cmd>NeoCodeium toggle<cr>", "  Toggle Codeium")
      map({ "i", "n" }, { "<M-c>cr", "çcr" }, "<cmd>NeoCodeium restart<cr>", " Restart Codeium")
      map({ "i", "n" }, { "<M-c>cl", "çcl" }, "<cmd>NeoCodeium open_log<cr>", "󱂅  Open log")
    end,
  },
}
