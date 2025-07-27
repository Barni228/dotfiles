-- if true then return {} end

---@type LazySpec
return {
  {
    "matze/vim-move",
    event = "User AstroFile",
    config = function()
      -- disable default mappings
      vim.g.move_map_keys = 0

      vim.keymap.set("n", "<C-j>", "<plug>MoveLineDown", { silent = true, noremap = true })
      vim.keymap.set("n", "<C-k>", "<plug>MoveLineUp", { silent = true, noremap = true })
      vim.keymap.set("v", "<C-j>", "<plug>MoveBlockDown", { silent = true, noremap = true })
      vim.keymap.set("v", "<C-k>", "<plug>MoveBlockUp", { silent = true, noremap = true })
    end,
  },
}
