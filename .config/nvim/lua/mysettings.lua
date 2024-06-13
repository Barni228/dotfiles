-- if true then return {} end -- WARN: COMMENT THIS LINE TO ACTIVATE THIS FILE

-- Enable spellcheck
vim.opt.spell = true

vim.cmd "set clipboard="
vim.cmd ":tnoremap <Esc> <C-\\><C-N>"

-- Function to get the terminal command based on file extension
local function get_run_cmd(args)
  local file = vim.fn.expand "%"
  local ext = vim.fn.expand "%:e"

  if ext == "zsh" then
    return "zsh " .. file .. " " .. args

  -- Compile with optimization level 2 and run c files
  elseif ext == "c" then
    return "clang -O2 " .. file .. " -o %< && ./%< " .. args

  -- Run python files
  elseif ext == "py" then
    return "python3 " .. file .. " " .. args

  -- Run cython files
  elseif ext == "pyx" then
    local module_name = file:gsub("%.pyx$", ""):gsub("/", ".") -- Remove the .pyx extension and replace / with .
    return 'python3 -c "import pyximport; pyximport.install(); import ' .. module_name .. '"'
  else
    return nil
  end
end

-- Create the Run command
vim.api.nvim_create_user_command("Run", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_run_cmd(args)
  if cmd then
    vim.cmd("!" .. cmd)
  else
    print "unknown file extension"
  end
end, { nargs = "*", complete = "file" })

-- Create the Runt command
vim.api.nvim_create_user_command("Runt", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_run_cmd(args)
  if cmd then
    vim.cmd("terminal " .. cmd)
    vim.cmd "norm i"
  else
    print "unknown file extension"
  end
end, { nargs = "*", complete = "file" })

vim.api.nvim_create_user_command("RunTf", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_run_cmd(args)
  if cmd then
    vim.cmd("TermExec cmd='" .. cmd .. "'")
  else
    print "unknown file extension"
  end
end, { nargs = "*", complete = "file" })

vim.api.nvim_create_user_command("RunTh", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_run_cmd(args)
  if cmd then
    vim.cmd("TermExec direction=horizontal go_back=0 cmd='" .. cmd .. "'")
  else
    print "unknown file extension"
  end
end, { nargs = "*", complete = "file" })

vim.api.nvim_create_user_command("RunTv", function(opts)
  local args = table.concat(opts.fargs, " ")
  vim.cmd "w"
  local cmd = get_run_cmd(args)
  if cmd then
    vim.cmd("TermExec direction=vertical go_back=0 size=50 cmd='" .. cmd .. "'")
  else
    print "unknown file extension"
  end
end, { nargs = "*", complete = "file" })

return {}
