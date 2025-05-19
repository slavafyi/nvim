local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

later(function()
  add 'mbbill/undotree'
  vim.g.undotree_SetFocusWhenToggle = 1
end)

later(function()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function()
        vim.cmd.TSUpdate()
      end,
    },
  }

  require('nvim-treesitter.configs').setup {
    auto_install = true,
    ensure_installed = {
      'lua',
      'luadoc',
      'vim',
      'vimdoc',
    },
    highlight = { enable = true },
    indent = { enable = true },
  }
end)

later(function()
  add 'stevearc/oil.nvim'
  require('oil').setup {
    default_file_explorer = false,
    delete_to_trash = true,
    float = {
      max_width = 100,
      max_height = 20,
    },
    keymaps = {
      ['<C-f>'] = 'actions.preview_scroll_down',
      ['<C-b>'] = 'actions.preview_scroll_up',
    },
  }
end)

later(function()
  add 'folke/which-key.nvim'
  require('which-key').setup {
    icons = {
      colors = false,
      mappings = false,
      separator = '',
    },
    preset = 'helix',
    win = {
      width = { min = 40 },
    },
  }
end)

now(function()
  add 'folke/snacks.nvim'
  require('snacks').setup {
    bigfile = {},
    image = {},
    words = {
      modes = { 'n' },
    },
  }
end)
