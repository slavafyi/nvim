local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

later(function()
  add 'tpope/vim-fugitive'
end)

later(function()
  add 'lewis6991/gitsigns.nvim'
end)
