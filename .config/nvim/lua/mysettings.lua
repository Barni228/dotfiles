-- if true then return {} end -- WARN: COMMENT THIS LINE TO ACTIVATE THIS FILE

-- Enable spellcheck
vim.opt.spell = true

vim.cmd "set clipboard="
vim.cmd ":tnoremap <Esc> <C-\\><C-N>"

vim.cmd "cnoreabbrev Cody NeoCodeium"

-- Enable wrap for markdown files (and gen nvim)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.defer_fn(function() vim.opt.wrap = true end, 400) -- Delay in milliseconds (400 = 0.4 second)
  end,
})
-- it will not stop everything, only delay function execution, so that gen markdown has time to load

-- Function to get the terminal command based on file extension
---@type fun(args: string): string?
local function get_run_cmd(args)
  local file = vim.fn.shellescape(vim.fn.expand "%")
  local file_name = vim.fn.shellescape(vim.fn.expand "%:p:r")

  if vim.bo.ft == "zsh" then
    return "/usr/bin/env zsh " .. file .. " " .. args

  -- Compile with optimization level 2 and run c files
  elseif vim.bo.ft == "c" then
    return "/usr/bin/env clang -O2 " .. file .. " -o " .. file_name .. " && " .. file_name .. " " .. args

    -- Compile and run rust files
  elseif vim.bo.ft == "rust" then
    -- if cargo is available, use it, else use rustc
    -- return "cargo check && (cargo run -- " .. args .. ") || (rustc " .. file .. " -o " .. file_name .. " && " .. file_name .. " " .. args .. ")"
    -- if cargo is available, use it, else use cargo script
    return "/usr/bin/env cargo check && (/usr/bin/env cargo run --" .. args .. ") || (/usr/bin/env cargo script --debug " .. file .. " -- " .. args .. ")"

    -- Run python files
  elseif vim.bo.ft == "python" then
    return "/usr/bin/env python3 " .. file .. " " .. args

  -- Run lua files
  elseif vim.bo.ft == "lua" then
    return "/usr/bin/env luajit " .. file .. " " .. args

  -- Run cython files
  elseif vim.bo.ft == "pyrex" then
    local module_name = file:gsub("%.pyx$", ""):gsub("/", ".") -- Remove the .pyx extension and replace / with .
    return "/usr/bin/env python3 -c 'import pyximport; pyximport.install(); import " .. module_name .. "'"

  -- Show markdown files
  elseif vim.bo.ft == "markdown" then
    return "/usr/bin/env glow " .. file
  else
    return nil
  end
end

---@type fun(name: string, how: string, after?: string, another?: string)
local function run_cmd(name, how, after, another)
  after = after or ""
  another = another or ""
  vim.api.nvim_create_user_command(name, function(opts)
    local args = table.concat(opts.fargs, " ")
    vim.cmd "w"
    local cmd = get_run_cmd(args)
    if cmd then
      vim.cmd(how .. cmd .. after)
      vim.cmd(another)
      vim.cmd "setlocal nospell"
    else
      print "Unknown file extension"
    end
  end, { nargs = "*", complete = "file" })
end

-- Create the Run commands
run_cmd("Run", "!")
run_cmd("Runt", "terminal ", "", "startinsert")
run_cmd("RunTf", 'TermExec cmd="', '"')
run_cmd("RunTh", 'TermExec direction=horizontal go_back=0 cmd="', '"')
run_cmd("RunTv", 'TermExec direction=vertical go_back=0 size=50 cmd="', '"')


local function get_format_cmd(args)
  local file = vim.fn.expand "%"

  -- Format python files
  if vim.bo.ft == "python" then
    return "/usr/bin/env ruff format " .. args .. " " .. file

  -- Format zsh files
  elseif vim.bo.ft == "zsh" or vim.bo.ft == "sh" or vim.bo.ft == "bash" or vim.bo.ft == "fish" then
    return "/usr/bin/env shfmt -w -i 4 " .. args .. " " .. file

  -- Format c files
  elseif vim.bo.ft == "c" then
    return "/usr/bin/env clang-format -i " .. args .. " " .. file

  -- Format rust files
  elseif vim.bo.ft == "rust" then
    return "/usr/bin/env rustfmt " .. args .. " " .. file

  -- Format lua files
  elseif vim.bo.ft == "lua" then
    return "/usr/bin/env stylua " .. args .. " " .. file

  -- Format json files
  elseif vim.bo.ft == "json" then
    return "/usr/bin/env jsonrepair "
      .. file
      .. " --overwrite "
      .. "&& /usr/bin/env jq . "
      .. file
      .. " > "
      .. file
      .. ".tmp && mv "
      .. file
      .. ".tmp "
      .. file

  -- Format toml files
  elseif vim.bo.ft == "toml" then
    return "/usr/bin/env taplo fmt " .. args .. " " .. file

  -- Format yaml files
  elseif vim.bo.ft == "yaml" then
    return "/usr/bin/env prettier --write " .. args .. " " .. file

  -- Format markdown files
  elseif vim.bo.ft == "markdown" then
    return "/usr/bin/env prettier --write " .. args .. " " .. file
  else
    return nil
  end
end

-- Create the Format command
vim.api.nvim_create_user_command("Form", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_format_cmd(args)
  if cmd then
    vim.cmd("!" .. cmd)
  else
    print "Unknown file extension"
  end
end, {})

-- Create the Format Selection command
vim.api.nvim_create_user_command("Forms", function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  vim.lsp.buf.range_formatting({}, { start_pos[2] - 1, start_pos[3] - 1 }, { end_pos[2] - 1, end_pos[3] })
end, {})

return {}
