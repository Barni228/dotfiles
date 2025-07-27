-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/David-Kunz/gen.nvim

---@type LazySpec
return {
  {
    -- not so minimal configuration
    "David-Kunz/gen.nvim",
    opts = {
      model = "codeqwen:latest",
      retry_map = "r",
      show_model = true,
    },
    cmd = { "Gen" },
  },
}
