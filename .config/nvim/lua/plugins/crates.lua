-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/saecki/crates.nvim

---@type LazySpec
return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },

    opts = {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          crates = {
            enabled = true, -- disabled by default
            max_results = 8, -- The maximum number of search results to display
            min_chars = 2, -- The minimum number of characters to type before completions begin appearing
          },
        },
      }
  },
}
