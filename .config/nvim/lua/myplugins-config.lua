-- Gen.nvim config {{{
local gen = require "gen"
gen.prompts["Fix_Code"] = {
  prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

gen.prompts["Annotate"] = {
  prompt = "Add type annotations to the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

gen.prompts["Improve"] = {
  prompt = "Improve the following code according to all naming conventions, style, and best practices. Only ouput the result in format ```$filetype\n...\n``` and dont explain what you did:\n```$filetype\n$text\n```",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

gen.prompts["Explain"] = {
  prompt = "Explain the following code:\n```$filetype\n$text\n```",
  replace = false,
}

gen.prompts["Custom"] = {
  prompt = "$input. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

gen.prompts["Generate"] = {
  prompt = "Generate code that $input. Only ouput a single result in format ```$filetype\n...\n```",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

gen.prompts["Document"] = {
  prompt = "Add documentation to the following code in form of comments, doc strings, etc. Only ouput the result in format ```$filetype\n...\n``` And nothing should be outside this format. Code is:\n```$filetype\n$text\n``` (include it with documentation)",
  replace = true,
  extract = "```$filetype\n(.-)```",
}

-- }}} Gen.nvim end

-- Gen keymaps {{{
vim.keymap.set({ "n", "v", "x" }, "<leader>a", ":Gen<cr>", { noremap = true, silent = true, desc = "Gen ai" })

vim.keymap.set(
  { "n", "v", "x" },
  "<leader>]",
  ":Gen Custom<cr>",
  { noremap = true, silent = true, desc = "Gen custom" }
)
-- }}} Gen keymaps end

-- vim move modifier {{
vim.g.move_key_modifier = "M"
vim.g.move_key_modifier_visualmode = "M"
-- }}
-- scrolling {{{
if not vim.g.neovide then
  local neoscroll = require "neoscroll"
  vim.keymap.set(
    { "n", "v", "x", "i" },
    "<ScrollWheelUp>",
    function() neoscroll.scroll(-3, { move_cursor = false, duration = 50 }) end
  )

  vim.keymap.set(
    { "n", "v", "x", "i" },
    "<ScrollWheelDown>",
    function() neoscroll.scroll(3, { move_cursor = false, duration = 50 }) end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-u>",
    function() neoscroll.ctrl_u { duration = 200, easing = "linear" } end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-d>",
    function() neoscroll.ctrl_d { duration = 200, easing = "linear" } end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-b>",
    function() neoscroll.ctrl_b { duration = 250, easing = "linear" } end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-f>",
    function() neoscroll.ctrl_f { duration = 250, easing = "linear" } end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-y>",
    function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 }) end
  )

  vim.keymap.set(
    { "n", "v", "x" },
    "<C-e>",
    function() neoscroll.scroll(0.1, { move_cursor = false, duration = 50 }) end
  )

  vim.keymap.set({ "n", "v", "x" }, "zt", function() neoscroll.zt { half_win_duration = 150 } end)
  vim.keymap.set({ "n", "v", "x" }, "zz", function() neoscroll.zz { half_win_duration = 150 } end)
  vim.keymap.set({ "n", "v", "x" }, "zb", function() neoscroll.zb { half_win_duration = 150 } end)
end
-- }}}
