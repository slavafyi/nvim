local add = vim.pack.add
local later = Config.later

later(function()
  add { 'https://github.com/tpope/vim-fugitive' }
end)

later(function()
  add { 'https://github.com/lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    on_attach = function(bufnr)
      if vim.bo[bufnr].filetype == 'netrw' then return false end
    end,
  }
end)
