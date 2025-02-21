if vim.g.godot_lsp_started then return end

vim.g.godot_lsp_started = true

-- TODO: REMOVE ME
vim.defer_fn(function() vim.cmd "NeoCodeium disable" end, 400) -- Delay in milliseconds (400 = 0.4 second)

local port = os.getenv "GDScript_Port" or "6005"
local cmd = vim.lsp.rpc.connect("127.0.0.1", port)
local pipe = "/tmp/godot.pipe" -- I use /tmp/godot.pipe

vim.lsp.start {
  name = "Godot",
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]),
  -- on_attach = function(client, bufnr)
  --   if not vim.g.neovide then vim.api.nvim_command('echo serverstart("' .. pipe .. '")') end
  -- end,
}
