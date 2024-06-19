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

vim.api.nvim_set_keymap(
  "n",
  "<Leader>y",
  'mzGVgg"+y`z<cr>',
  { noremap = true, silent = true, desc = " Copy content of the file" }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>R",
  ":Runt<cr>",
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
