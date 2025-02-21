-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/MeanderingProgrammer/render-markdown.nvim

---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    config = function()
      -- disable the default highlighting for todos, since it does not work well with icons
      vim.cmd [[
        hi @markup.list.unchecked guibg=NONE guifg=#20a6ef
        hi @markup.list.checked guibg=NONE guifg=#63af33
      ]]

      ---@type render.md.UserConfig
      local opts = {}
      require("render-markdown").setup(opts)
    end,
  },
}
