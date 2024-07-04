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

vim.keymap.set("n", "gp", function()
  local fullName = get_oil_path()
  if fullName == "" then
    notify "No file selected"
    return
  end
  vim.cmd("silent !qlmanage -p " .. fullName)
end, { noremap = true, silent = true, desc = "Open file in QuickLook" })

vim.keymap.set(
  "n",
  "<leader><leader>",
  "<cmd>Form<cr>",
  { noremap = true, silent = true, desc = "Format current buffer" }
)

vim.keymap.set(
  "v",
  "<leader><leader>",
  ":Forms<cr>",
  { noremap = true, silent = true, desc = "Format current selection" }
)

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

vim.api.nvim_set_keymap(
  "n",
  "<Leader>y",
  'mzGVgg"+y`z',
  { noremap = true, silent = true, desc = " Copy content of the file" }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>R",
  ":Run<cr>",
  { noremap = true, silent = true, desc = " Run in terminal" }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>trf",
  ":RunTf<cr>",
  { noremap = true, silent = true, desc = "󰡖 ToggleTerm run float" }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>trh",
  ":RunTh<cr>",
  { noremap = true, silent = true, desc = " ToggleTerm run horizontal" }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>trv",
  ":RunTv<cr>",
  { noremap = true, silent = true, desc = " ToggleTerm run vertical" }
)
