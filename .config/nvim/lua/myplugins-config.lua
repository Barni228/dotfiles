-- Gen.nvim config
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

-- scrolling
local neoscroll = require "neoscroll"
vim.keymap.set(
  { "n", "v", "x" },
  "<ScrollWheelUp>",
  function() neoscroll.scroll(-3, { move_cursor = false, duration = 50 }) end
)

vim.keymap.set(
  { "n", "v", "x" },
  "<ScrollWheelDown>",
  function() neoscroll.scroll(3, { move_cursor = false, duration = 50 }) end
)

vim.keymap.set(
  { "n", "v", "x" },
  "<C-u>",
  function() neoscroll.ctrl_u { duration = 200, easing = "sine" } end
)

vim.keymap.set(
  { "n", "v", "x" },
  "<C-d>",
  function() neoscroll.ctrl_d { duration = 200, easing = "sine" } end
)

vim.keymap.set(
  { "n", "v", "x" },
  "<C-b>",
  function() neoscroll.ctrl_b { duration = 250, easing = "sine" } end
)

vim.keymap.set(
  { "n", "v", "x" },
  "<C-f>",
  function() neoscroll.ctrl_f { duration = 250, easing = "sine" } end
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
