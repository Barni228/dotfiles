-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- https://github.com/mattn/emmet-vim

-- disable defaults
-- vim.g.user_emmet_install_global = 0

-- only enable for insert mode
vim.g.user_emmet_mode = 'i'

-- pressing <Ctrl+h> to expand emmet abbreviation
-- div>h1|
-- Ctrl h
-- <div>
--   <h1>|</h1>
-- </div>
vim.g.user_emmet_expandabbr_key = '<C-h>'

-- disable all other mappings
vim.g.user_emmet_expandword_key = '<Nop>'
vim.g.user_emmet_update_tag = '<Nop>'
vim.g.user_emmet_balancetaginward_key = '<Nop>'
vim.g.user_emmet_balancetagoutward_key = '<Nop>'
vim.g.user_emmet_next_key = '<Nop>'
vim.g.user_emmet_prev_key = '<Nop>'
vim.g.user_emmet_imagesize_key = '<Nop>'
vim.g.user_emmet_togglecomment_key = '<Nop>'
vim.g.user_emmet_splitjointag_key = '<Nop>'
vim.g.user_emmet_removetag_key = '<Nop>'
vim.g.user_emmet_anchorizeurl_key = '<Nop>'
vim.g.user_emmet_anchorizesummary_key = '<Nop>'
vim.g.user_emmet_mergelines_key = '<Nop>'
vim.g.user_emmet_codepretty_key = '<Nop>'

---@type LazySpec
return {
  {
    "mattn/emmet-vim",
  },
}
