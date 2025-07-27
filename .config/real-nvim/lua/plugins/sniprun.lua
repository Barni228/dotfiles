if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
--- It has some issues with Classic display, where it ignores first line

--- https://github.com/michaelb/sniprun

---@type LazySpec
return {
  {
    "michaelb/sniprun",
    branch = "master",

    build = "sh install.sh",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require("sniprun").setup({
        display = {
          "Classic",
          "VirtualTextErr",
        },
      })
    end,
  },
}
