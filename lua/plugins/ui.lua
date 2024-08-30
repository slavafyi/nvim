return {
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'zenwritten'
    end,
  },

  {
    'j-hui/fidget.nvim',
    lazy = false,
    config = true,
  },
}
