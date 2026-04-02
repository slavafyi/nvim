local add = vim.pack.add

local later = Config.later
local new_autocmd = Config.new_autocmd
local now = Config.now

now(function()
  add { 'https://github.com/pappasam/papercolor-theme-slim' }
  new_autocmd('ColorScheme', function()
    local green = vim.g.terminal_color_2
    local yellow = vim.g.terminal_color_13
    local red = vim.g.terminal_color_1
    vim.cmd.highlight(string.format('DiffAdd guifg=%s guibg=NONE', green))
    vim.cmd.highlight(string.format('DiffChange guifg=%s guibg=NONE', yellow))
    vim.cmd.highlight(string.format('DiffDelete guifg=%s guibg=NONE', red))
  end, {
    desc = 'Override PaperColor diff highlights',
    pattern = { 'PaperColorSlim', 'PaperColorSlimLight' },
  })
end)

later(function()
  add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end)
