local new_autocmd = Config.new_autocmd

new_autocmd('TextYankPost', function()
  vim.highlight.on_yank()
end, { desc = 'Highlight yanked text' })

new_autocmd('TermOpen', function()
  vim.opt_local.spell = false
end, { desc = 'Disable spell checking in terminal buffers' })
