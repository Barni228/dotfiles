---@type LazySpec
return {
  {
    "matze/vim-move",
    event = "User AstroFile",
    config = function()
      vim.g.move_key_modifier = "M"
      vim.g.move_key_modifier_visualmode = "M"

      vim.keymap.set("n", "∆", "<plug>MoveLineDown", { silent = true, noremap = true })
      vim.keymap.set("n", "˚", "<plug>MoveLineUp", { silent = true, noremap = true })
      vim.keymap.set("n", "˙", "<plug>MoveCharLeft", { silent = true, noremap = true })
      vim.keymap.set("n", "¬", "<plug>MoveCharRight", { silent = true, noremap = true })

      vim.keymap.set("v", "∆", "<plug>MoveBlockDown", { silent = true, noremap = true })
      vim.keymap.set("v", "˚", "<plug>MoveBlockUp", { silent = true, noremap = true })
      vim.keymap.set("v", "˙", "<plug>MoveBlockLeft", { silent = true, noremap = true })
      vim.keymap.set("v", "¬", "<plug>MoveBlockRight", { silent = true, noremap = true })
    end,
  },
}
