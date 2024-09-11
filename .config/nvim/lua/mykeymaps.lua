-- vim.keymap.set({ "n", "v" }, "x", "d")
-- vim.keymap.set({ "n", "v" }, "xx", "dd")
-- vim.keymap.set({ "n", "v" }, "X", "D")
-- vim.keymap.set({ "n", "v" }, "d", '"_d') -- deleted text is not copied
-- vim.keymap.set({ "n", "v" }, "dd", '"_dd')
-- vim.keymap.set({ "n", "v" }, "D", '"_D')
-- vim.keymap.set({ "n", "v" }, "c", '"_c')
-- vim.keymap.set({ "n", "v" }, "cc", '"_cc')
-- vim.keymap.set({ "n", "v" }, "C", '"_C')
-- vim.keymap.set({ "n", "v" }, "cC", '"_cC')
-- vim.keymap.set({ "n", "v" }, "s", '"_s')
-- vim.keymap.set({ "n", "v" }, "S", '"_S')
-- vim.keymap.set({ "n", "v" }, "p", "P")
-- vim.keymap.set({ "n", "v" }, "P", "p")
-- vim.keymap.set({ "n", "v" }, "ds", "ds")
-- vim.keymap.set({ "n", "v" }, "cs", "ds")

local notify = require "notify"
local function get_oil_path()
  local use, imported = pcall(require, "oil")
  if use then
    local entry = imported.get_cursor_entry()
    if entry then
      if entry["type"] == "file" then
        local dir = imported.get_current_dir()
        local fileName = entry["name"]
        local fullName = dir .. fileName
        return vim.fn.shellescape(fullName)
      end
    end
  end
  return ""
end

-- QuickLook in Oil {{{
vim.keymap.set("n", "gp", function()
  local fullName = get_oil_path()
  if fullName == "" then
    notify "No file selected"
    return
  end
  vim.cmd("silent !qlmanage -p " .. fullName)
end, { noremap = true, silent = true, desc = "Open file in QuickLook" })
-- }}}

-- git keymaps {{{
-- vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { noremap = true, silent = true, desc = "󰊢 Neogit" })
vim.keymap.set("n", "<leader>gg", function()
  -- vim.cmd("LazyGit")
  vim.cmd "LazyGitCurrentFile"
  vim.cmd "tnoremap <buffer> <esc> <esc>" -- disable escape key
end, { noremap = true, silent = true, desc = "󰊢 LazyGit" })
-- }}}

-- Formatting keymaps {{{
vim.keymap.set(
  "n",
  "<leader><leader>",
  "<cmd>Fmt<cr>",
  { noremap = true, silent = true, desc = "Format current buffer" }
)

vim.keymap.set(
  "v",
  "<leader><leader>",
  "<cmd>Fmts<cr>",
  { noremap = true, silent = true, desc = "Format current selection" }
)
-- }}}

-- LSP keymaps {{{
-- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename" })

vim.keymap.set(
  "n",
  "<leader>la",
  vim.lsp.buf.code_action,
  { noremap = true, silent = true, desc = "Code Action" }
)

vim.keymap.set(
  "n",
  "<leader>lt",
  vim.lsp.buf.type_definition,
  { noremap = true, silent = true, desc = "Type Definition" }
)

vim.keymap.set(
  "n",
  "<leader>lR",
  vim.lsp.buf.references,
  { noremap = true, silent = true, desc = "References" }
)
-- }}}

-- Clipboard keymaps {{{
vim.keymap.set(
  "n",
  "<Leader>y",
  'mzGVgg"+y`z',
  { noremap = true, silent = true, desc = " Copy content of the file" }
)
-- }}}

-- Motion keymaps {{{
vim.keymap.set({ "n", "v" }, "<S-left>", "H", { noremap = true, silent = true, desc = "Move down" })
vim.keymap.set({ "n", "v" }, "<S-right>", "L", { noremap = true, silent = true, desc = "Move up" })
-- }}}

-- Spell check keymaps {{{
vim.keymap.set(
  "i",
  "<C-q>", -- Ctrl q
  "<c-g>u<Esc>[s1z=`]a<c-g>u", -- will select first suggestion for previous misspelled word
  { noremap = true, silent = true, desc = "󰓆 Fix spelling" }
)

vim.keymap.set(
  "n",
  "<C-q>", -- Ctrl q
  "[s1z=`'", -- will select first suggestion for previous misspelled word
  { noremap = true, silent = true, desc = "󰓆 Fix spelling" }
)
-- }}}
-- Terminal keymaps {{{
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { noremap = true, silent = true, desc = "Escape terminal mode" })
vim.keymap.set("n", "<Leader>tp", function()
  vim.cmd "TermExec cmd='ipython; exit'"
  vim.cmd "tnoremap <buffer> <esc> <esc>"
end, { noremap = true, silent = true, desc = " ToggleTerm ipython" })
-- }}}

-- Run keymaps {{{
vim.keymap.set("n", "<Leader>R", "<cmd>Runt<cr>", { noremap = true, silent = true, desc = "Run file with !" })

-- <leader>r is in plugins/astrocore.lua
--[[
vim.keymap.set(
  "n",
  "<Leader>trf",
  "<cmd>RunTf<cr>",
  { noremap = true, silent = true, desc = "󰡖 ToggleTerm run float" }
)

vim.keymap.set(
  "n",
  "<Leader>trh",
  "<cmd>RunTh<cr>",
  { noremap = true, silent = true, desc = " ToggleTerm run horizontal" }
)

vim.keymap.set(
  "n",
  "<Leader>trv",
  "<cmd>RunTv<cr>",
  { noremap = true, silent = true, desc = " ToggleTerm run vertical" }
)
]]
-- }}}
