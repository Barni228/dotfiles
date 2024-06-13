-- use option h j k l to move lines or blocks
local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set("n", "∆", ":MoveLine(1)<CR>", opts) -- option (⌥) j
vim.keymap.set("n", "˚", ":MoveLine(-1)<CR>", opts) -- option (⌥) k
vim.keymap.set("n", "˙", ":MoveHChar(-1)<CR>", opts) -- option (⌥) h
vim.keymap.set("n", "¬", ":MoveHChar(1)<CR>", opts) -- option (⌥) l
-- vim.keymap.set("n", "<leader>wf", ":MoveWord(1)<CR>", opts)
-- vim.keymap.set("n", "<leader>wb", ":MoveWord(-1)<CR>", opts)

-- Visual-mode commands
vim.keymap.set("v", "∆", ":MoveBlock(1)<CR>", opts) -- option (⌥) j
vim.keymap.set("v", "˚", ":MoveBlock(-1)<CR>", opts) -- option (⌥) k
vim.keymap.set("v", "˙", ":MoveHBlock(-1)<CR>", opts) -- option (⌥) h
vim.keymap.set("v", "¬", ":MoveHBlock(1)<CR>", opts) -- option (⌥) l

---@type LazySpec
return {
  {
    "fedepujol/move.nvim",
    opts = {
      --- Config
    },
    event = "User AstroFile",
  },
}
