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
]]

-- minimal_oil.lua
vim.loader.enable()

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup oil.nvim with lazy
-- require("lazy").setup({
--   {
--     "stevearc/oil.nvim",
--     opts = {},
--     dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
--   },
-- })
require("lazy").setup({
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["<CR>"] = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          if entry and entry.type == "file" then
            -- vim.fn.jobstart({ "code", entry.name }, { detach = true })
            local editor = os.getenv("EDITOR") or "vim"
            vim.fn.jobstart({ editor, entry.name }, { detach = true })
          elseif entry then
            oil.select()
          end
        end,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/which-key.nvim",
    opts = {},
  },
})


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
      vim.keymap.set('n', 'zg', spellfile_disabled)
      vim.keymap.set('n', 'zw', spellfile_disabled)
      vim.keymap.set('n', 'zG', spellfile_disabled)
      vim.keymap.set('n', 'zW', spellfile_disabled)
    end)
  end,
})

-- space space to save, of course
vim.keymap.set('n', '<Space><Space>', ':w<CR>', { noremap = true, silent = true })
