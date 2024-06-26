-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- https://github.com/ray-x/lsp_signature.nvim

---@type LazySpec
return {
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").on_attach {
        bind = true,
        doc_lines = 0,
        hint_enable = false,
        hint_prefix = {
          above = "↙ ",
          current = "← ",
          below = "↖ ",
        },
      }
      require("lsp_signature").setup()
    end,
    event = {
      "InsertEnter", -- when entering insert mode
    },
  },
}
