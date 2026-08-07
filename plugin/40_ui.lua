local add = vim.pack.add

local later = Config.later
local now = Config.now

now(function()
  add { 'https://github.com/oskarnurm/koda.nvim' }
  vim.cmd 'colorscheme koda'
end)

later(function()
  add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end)
