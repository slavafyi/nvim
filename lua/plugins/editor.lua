return {
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = 'TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      auto_install = true,
      ensure_installed = {
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local telescope = require 'telescope'
      local telescope_config = require 'telescope.config'
      local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

      table.insert(vimgrep_arguments, '--hidden')
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')

      telescope.setup {
        defaults = {
          preview = {
            treesitter = false,
          },
          vimgrep_arguments = vimgrep_arguments,
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
        },
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
          git_files = {
            show_untracked = true,
          },
        },
      }

      telescope.load_extension 'ui-select'
    end,
  },

  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
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
    },
    config = function(_, opts)
      require('oil').setup(opts)
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        colors = false,
        mappings = false,
        separator = '',
      },
      preset = 'helix',
      win = {
        border = vim.g.border_chars,
        width = { min = 40 },
      },
    },
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {},
      image = {},
      words = {
        modes = { 'n' },
      },
    },
  },

  {
    'Exafunction/windsurf.vim',
    event = 'BufEnter',
  },
}
