-- r = ]
-- t = html tag
-- i = interactively (ask for left and right delimiters)
-- a = >
-- f = function
-- c = custom delimiter
-- b = )

---@type LazySpec
return {
  {
    "kylechui/nvim-surround",
    dependencies = {},
    config = function()
      ---@diagnostic disable-next-line
      require("nvim-surround").setup {
        surrounds = {
          ["c"] = {
            add = function()
              local delimiters = {
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
                ["<"] = ">",
                -- ["'"] = "'",
                -- ['"'] = '"',
                -- ["`"] = "`",
              }
              local input = vim.fn.input {
                prompt = "Enter delimiters: ",
              }
              local new = ""
              for i = #input, 1, -1 do
                new = new .. (delimiters[input:sub(i, i)] or input:sub(i, i))
              end
              return {
                { input },
                { new },
              }
            end,
            find = function() end,
            delete = function() end,
            change = false,
          },
        },
      }
    end,
    event = "User AstroFile",
  },
}
