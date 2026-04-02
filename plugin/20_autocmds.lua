local apply_colorscheme = Config.apply_colorscheme
local new_autocmd = Config.new_autocmd

new_autocmd('TextYankPost', function()
  vim.highlight.on_yank()
end, { desc = 'Highlight yanked text' })

new_autocmd('OptionSet', apply_colorscheme, {
  desc = 'Update colorscheme when background changes',
  pattern = 'background',
  nested = true,
})
