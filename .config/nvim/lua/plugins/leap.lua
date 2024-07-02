-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/ggandor/leap.nvim

---@type LazySpec
return {
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").create_default_mappings() --> will overwrite "s", "S", "gs"
    end,
    lazy = false,
  },
}
