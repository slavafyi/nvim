local add = vim.pack.add

local apply_colorscheme = Config.apply_colorscheme
local new_autocmd = Config.new_autocmd
local later = Config.later
local now = Config.now

now(function()
  add { 'https://github.com/slavafyi/papercolor-theme-slim' }
  add { 'https://github.com/slavafyi/kintsugi.nvim' }

  apply_colorscheme()

  new_autocmd('ColorScheme', function()
    vim.g.terminal_color_0 = vim.o.background == 'dark' and '#20201f' or '#eee8dc'
  end, {
    desc = 'Override color palette for the kintsugi theme',
    pattern = 'kintsugi-*',
  })
end)

later(function()
  add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end)
