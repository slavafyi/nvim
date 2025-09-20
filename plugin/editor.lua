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
    view_options = {
      show_hidden = true,
    },
  }
end)

later(function()
  add 'stevearc/conform.nvim'
  local conform = require 'conform'
  conform.setup {
    default_format_opts = {
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    formatters_by_ft = {
      bash = { 'shfmt' },
      json = { 'prettierd' },
      liquid = { 'prettierd' },
      lua = { 'stylua' },
      python = { 'black' },
      sh = { 'shfmt' },
      yaml = { 'prettierd' },
      zsh = { 'shfmt' },
    },
    log_level = vim.log.levels.DEBUG,
  }
  vim.keymap.set({ 'n', 'x' }, '<Leader>f', function()
    conform.format { async = true }
  end, { desc = 'Format document' })
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

now(function()
  add 'ibhagwan/fzf-lua'
  require('fzf-lua').setup {
    keymap = {
      fzf = {
        ['alt-p'] = 'preview-page-up',
        ['alt-n'] = 'preview-page-down',
      },
    },
  }
end)

later(function()
  add 'wakatime/vim-wakatime'
end)
