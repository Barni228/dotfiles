--[[
  Minimal Neovim config with:
  - oil.nvim as file explorer
  - which-key.nvim to show key suggestions
  - spell checking
  - <Space><Space> to save current buffer

  Some keybindings:
  - `]s` : next misspelled word
  - `[s` : previous misspelled word
  - `z=` : show spelling suggestions
  - `g.` : show hidden files
  - `Tab` : open the entry under cursor in nvim
]]

-- spell:enableCompoundWords
-- spell:ignore fnamemodify, autocmd, noremap

local help_message = [[
`]s`    : next misspelled word
`[s`    : previous misspelled word
`z=`    : show spelling suggestions
`g.`    : show hidden files
`Tab`   : open the entry under cursor in nvim
`Enter` : open the entry under cursor with `open` cmd
`g?`    : show oil help message
]]

vim.api.nvim_create_user_command("Help", function()
  vim.notify(help_message, vim.log.levels.INFO)
end, {})

vim.opt.number = true
vim.opt.relativenumber = true

vim.loader.enable()

local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
vim.opt.runtimepath:prepend(config_dir .. "/pack/start/oil.nvim")
vim.opt.runtimepath:prepend(config_dir .. "/pack/start/nvim-web-devicons")
vim.opt.runtimepath:prepend(config_dir .. "/pack/start/which-key.nvim")

-- oil.nvim setup
require("oil").setup({
  keymaps = {
    ["<CR>"] = function()
      local oil = require("oil")
      local entry = oil.get_cursor_entry()
      if entry and entry.type == "file" then
        vim.fn.jobstart({ "open", oil.get_current_dir() .. entry.name }, { detach = true })
      elseif entry then
        oil.select()
      end
    end,
    ["<Tab>"] = "actions.select",
  },
})

-- which-key.nvim setup
require("which-key").setup({})

-- Open oil.nvim on startup
if vim.fn.argc() == 0 then
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      vim.schedule(function()
        require("oil").open()
      end)
    end,
  })
end

-- enable spell check (z= for suggestions)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.schedule(function()
      vim.opt.spell = true
      -- vim.opt.spelllang = { "en" }
      -- Disable spellfile-related normal mode commands, show warning message if used
      local function spellfile_disabled()
        vim.notify("Spellfile editing is disabled", vim.log.levels.WARN)
      end
      vim.keymap.set("n", "zg", spellfile_disabled)
      vim.keymap.set("n", "zw", spellfile_disabled)
      vim.keymap.set("n", "zG", spellfile_disabled)
      vim.keymap.set("n", "zW", spellfile_disabled)
    end)
  end,
})

-- space space to save, of course
vim.keymap.set("n", "<Space><Space>", ":w<CR>", { noremap = true, silent = true })

-- since enter will open a file under cursor, I make shift enter do what enter does
vim.keymap.set({ "n", "i", "v" }, "<S-CR>", "<CR>", { noremap = true })

-- esc in normal mode will clear search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')
