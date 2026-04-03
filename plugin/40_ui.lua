local add = vim.pack.add

local apply_colorscheme = Config.apply_colorscheme
local later = Config.later
local now = Config.now

now(function()
  add { 'https://github.com/slavafyi/papercolor-theme-slim' }
  apply_colorscheme()
end)

later(function()
  add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end)
