-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/michaelrommel/nvim-silicon

--WARN: run `brew install silicon` to install silicon

---@type LazySpec
return {
  {
    "michaelrommel/nvim-silicon",
    cmd = "Silicon",
    config = function()
      require("nvim-silicon").setup {
        command = "silicon", -- silicon executable path
        output = nil, -- do not save any file with this
        to_clipboard = true, -- copy output to clipboard
        theme = "TwoDark",
        window_title = function() -- comment out to net see the window title
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
        end,
        font = "Hack Nerd Font=20",
        -- <FontName>=<FontSize>;<FallbackFont>, but fallback doesnt work for some reason
        shadow_color = "#100808",
        shadow_offset_y = 8,
        shadow_offset_x = 8,
      }
    end,
  },
}
