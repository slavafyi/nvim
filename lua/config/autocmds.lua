vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  desc = 'Automatically update colorscheme based on background option',
  group = vim.api.nvim_create_augroup('update-colorscheme', { clear = true }),
  pattern = 'background',
  callback = function()
    local colorscheme = vim.g.colorscheme[vim.o.background]
    vim.cmd.colorscheme(colorscheme)
  end,
})
