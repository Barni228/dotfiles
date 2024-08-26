require("mini.move").setup()

vim.keymap.set(
  "n",
  "˙",
  function() MiniMove.move_line "left" end,
  { noremap = true, silent = true, desc = "Move line left" }
)

vim.keymap.set(
  "n",
  "∆",
  function() MiniMove.move_line "down" end,
  { noremap = true, silent = true, desc = "Move line down" }
)

vim.keymap.set(
  "n",
  "˚",
  function() MiniMove.move_line "up" end,
  { noremap = true, silent = true, desc = "Move line up" }
)

vim.keymap.set(
  "n",
  "¬",
  function() MiniMove.move_line "right" end,
  { noremap = true, silent = true, desc = "Move line right" }
)

vim.keymap.set(
  "v",
  "˙",
  function() MiniMove.move_selection "left" end,
  { noremap = true, silent = true, desc = "Move selection left" }
)

vim.keymap.set(
  "v",
  "∆",
  function() MiniMove.move_selection "down" end,
  { noremap = true, silent = true, desc = "Move selection down" }
)

vim.keymap.set(
  "v",
  "˚",
  function() MiniMove.move_selection "up" end,
  { noremap = true, silent = true, desc = "Move selection up" }
)

vim.keymap.set(
  "v",
  "¬",
  function() MiniMove.move_selection "right" end,
  { noremap = true, silent = true, desc = "Move selection right" }
)

return {}
