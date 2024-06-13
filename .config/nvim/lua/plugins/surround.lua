---@type LazySpec
return {
  {
    "kylechui/nvim-surround",
    dependencies = {},
    config = function()
      require("nvim-surround").setup {
        -- when i type something like ysiwf it will ask me for function name and surround text with that function
        delimiters = {
          pairs = {
            ["f"] = function()
              return {
                vim.fn.input {
                  prompt = "Enter the function name: ",
                } .. "(",
                ")",
              }
            end,
          },
        },
      }
    end,
    -- opts = {},
    event = "User AstroFile",
  },
}
