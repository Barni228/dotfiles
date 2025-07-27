-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/kdheepak/lazygit.nvim

---@type LazySpec
return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
