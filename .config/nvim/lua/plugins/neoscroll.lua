-- if true then return {} end

---@type LazySpec
return {
  {
    "karb94/neoscroll.nvim",
    config = function() require("neoscroll").setup {} end,
    event = "User AstroFile",
  },
}
