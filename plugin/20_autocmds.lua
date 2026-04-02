local new_autocmd = Config.new_autocmd

new_autocmd('TextYankPost', function()
  vim.highlight.on_yank()
end, { desc = 'Highlight yanked text' })

new_autocmd('OptionSet', function()
  local schemes = vim.g.colorscheme or {}
  local scheme = schemes[vim.o.background]
  if scheme and scheme ~= '' then vim.cmd.colorscheme(scheme) end
end, {
  desc = 'Update colorscheme when background changes',
  pattern = 'background',
  nested = true,
})
