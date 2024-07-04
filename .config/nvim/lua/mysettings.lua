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
    vim.defer_fn(function() vim.opt.wrap = true end, 400) -- Delay in milliseconds (200 = 0.2 second)
  end,
})
-- it will not stop everything, only delay function execution, so that gen markdown has time to load

local function file_exists(file)
  local f = io.open(file, "r")
  if f then
    io.close(f)
    return true
  else
    return false
  end
end
-- Function to get the terminal command based on file extension
local function get_run_cmd(args)
  local file = vim.fn.expand "%"
  local dir = vim.fn.expand "%:p:h"
  local ext = vim.fn.expand "%:e"
  local file_name = vim.fn.expand "%:p:r"

  if ext == "zsh" then
    return "zsh " .. file .. " " .. args

  -- Compile with optimization level 2 and run c files
  elseif ext == "c" then
    return "clang -O2 " .. file .. " -o " .. file_name .. " && " .. file_name .. " " .. args

    -- Compile and run rust files
  elseif ext == "rs" then
    if file_exists(dir .. "/" .. "Cargo.toml") then --> if cargo is available
      return "cargo run " .. file .. " " .. args --> use it
    else
      return "rustc " .. file .. " && " .. file_name .. " " .. args --> compile and run
    end

  -- Run python files
  elseif ext == "py" then
    return "python3 " .. file .. " " .. args

  -- Run lua files
  elseif ext == "lua" then
    return "luajit " .. file .. " " .. args
  -- Run cython files
  elseif ext == "pyx" then
    local module_name = file:gsub("%.pyx$", ""):gsub("/", ".") -- Remove the .pyx extension and replace / with .
    return 'python3 -c "import pyximport; pyximport.install(); import ' .. module_name .. '"'
  else
    return nil
  end
end

local function get_format_cmd(args)
  local file = vim.fn.expand "%"
  local ext = vim.fn.expand "%:e"
  print('"' .. args .. '"')

  -- Format python files
  if ext == "py" then
    return "ruff format " .. args .. " " .. file

  -- Format zsh files
  elseif ext == "zsh" then
    return "shfmt -w -i 4 " .. args .. " " .. file

  -- Format c files
  elseif ext == "c" then
    return "clang-format -i " .. args .. " " .. file

  -- Format rust files
  elseif ext == "rs" then
    return "rustfmt " .. args .. " " .. file

  -- Format lua files
  elseif ext == "lua" then
    return "stylua " .. args .. " " .. file
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
    else
      print "Unknown file extension"
    end
  end, { nargs = "*", complete = "file" })
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
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  vim.lsp.buf.range_formatting({}, {start_pos[2] - 1, start_pos[3] - 1}, {end_pos[2] - 1, end_pos[3]})
end, {})

-- Create the Run commands
run_cmd("Run", "!")
run_cmd("Runt", "terminal ", "", "norm i")
run_cmd("RunTf", "TermExec cmd='", "'")
run_cmd("RunTh", "TermExec direction=horizontal go_back=0 cmd='", "'")
run_cmd("RunTv", "TermExec direction=vertical go_back=0 size=50 cmd='", "'")

return {}
