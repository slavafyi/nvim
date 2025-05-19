local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

later(function()
  add 'tpope/vim-fugitive'
end)

later(function()
  add 'lewis6991/gitsigns.nvim'
  require('gitsigns').setup {
    on_attach = function(bufnr)
      if vim.bo[bufnr].filetype == 'netrw' then return false end
    end,
  }
end)
