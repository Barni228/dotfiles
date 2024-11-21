-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/pocco81/auto-save.nvim

---@type LazySpec
return {
  {
    "pocco81/auto-save.nvim",
    -- Turn it off by default
    config = function() require("auto-save").off() end,
  },
}
