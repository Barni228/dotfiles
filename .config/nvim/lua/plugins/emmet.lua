-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/mattn/emmet-vim

-- disable defaults
vim.g.user_emmet_install_global = 0

---@type LazySpec
return {
  {
    "mattn/emmet-vim",

    config = function()
      -- pressing <Ctrl+h> to expand emmet abbreviation
      -- div>h1|
      -- Ctrl h
      -- <div>
      --   <h1>|</h1>
      -- </div>
      vim.keymap.set(
        "i",
        "<C-h>",
        "<c-r>=emmet#util#closePopup()<cr><c-r>=emmet#expandAbbr(0,'')<cr>",
        { silent = true, desc = "expand emmet abbreviation" }
      )
    end,
  },
}
