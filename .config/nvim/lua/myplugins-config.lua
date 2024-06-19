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
