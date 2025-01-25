-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/ggandor/leap.nvim

--- you press s (or S to search backward)
--- you press first character of the search
--- you press second character of the search, if your cursor is where you wanted it to be, start editing
--- if it isn't, press the label that marks where you want to be
--- if the character you is last character on the line, press space 
--- (e.g. | = cursor, "|  hello, worldo" pressing "so<space>" will "  hello, world|o")

---@type LazySpec
return {
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      -- require("leap").create_default_mappings() --> will overwrite "s", "S", "gs"
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      -- vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)') dont create gs
    end,
    lazy = false,
  },
}
