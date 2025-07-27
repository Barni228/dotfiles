-- There are also cursor and background configurations in `plugins/astroui.lua`
vim.cmd "highlight Normal guifg=#acb0bc"
vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
vim.keymap.set("v", "<D-c>", '"+y') -- Copy
vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
vim.keymap.set("n", "ZZ", "<cmd>wqa<CR>") -- exit

vim.g.neovide_position_animation_length = 0       -- how long :split takes
vim.g.neovide_cursor_animation_length = 0.00    -- how long cursor animation is
vim.g.neovide_cursor_trail_size = 0.00           -- cursor trail size
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0 -- how far to animate scrolling (last 0 lines)
vim.g.neovide_scroll_animation_length = 0.1 -- how long scroll animation is
