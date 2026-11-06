local add = vim.pack.add

local later = Config.later
local new_autocmd = Config.new_autocmd
local nmap_leader = Config.nmap_leader
local now = Config.now
local now_if_args = Config.now_if_args
local on_packchanged = Config.on_packchanged
local xmap_leader = Config.xmap_leader

now_if_args(function()
  add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  }

  local ts_update = function()
    vim.cmd 'TSUpdate'
  end

  on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  local languages = {
    'astro',
    'bash',
    'c',
    'cpp',
    'css',
    'diff',
    'dockerfile',
    'ecma',
    'editorconfig',
    'fish',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'go',
    'html',
    'html_tags',
    'ini',
    'javascript',
    'jsdoc',
    'json',
    'jsx',
    'latex',
    'liquid',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'scss',
    'ssh_config',
    'svelte',
    'tmux',
    'toml',
    'tsx',
    'typescript',
    'typst',
    'vim',
    'vimdoc',
    'vue',
    'yaml',
  }

  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end

  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
  end

  new_autocmd('FileType', ts_start, { desc = 'Start tree-sitter', pattern = filetypes })
end)

later(function()
  add { 'https://github.com/stevearc/oil.nvim' }
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
  add { 'https://github.com/stevearc/conform.nvim' }

  local conform = require 'conform'

  conform.formatters.prettierd = {
    require_cwd = true,
  }

  conform.formatters.odinfmt = {
    command = 'odinfmt',
    args = { '-stdin' },
    stdin = true,
  }

  conform.setup {
    default_format_opts = {
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    formatters_by_ft = {
      css = { 'prettierd', 'oxfmt', 'stylelint' },
      scss = { 'prettierd', 'oxfmt', 'stylelint' },
      javascript = { 'prettierd', 'oxfmt', 'eslint_d' },
      javascriptreact = { 'prettierd', 'oxfmt', 'eslint_d' },
      typescript = { 'prettierd', 'oxfmt', 'eslint_d' },
      typescriptreact = { 'prettierd', 'oxfmt', 'eslint_d' },
      bash = { 'shfmt' },
      json = { 'prettierd', 'oxfmt' },
      liquid = { 'prettierd' },
      lua = { 'stylua' },
      odin = { 'odinfmt' },
      python = { 'black' },
      sh = { 'shfmt' },
      yaml = { 'prettierd' },
      zsh = { 'shfmt' },
    },
    log_level = vim.log.levels.DEBUG,
  }

  local format = function()
    conform.format { async = true }
  end

  nmap_leader('f', format, 'Format document')
  xmap_leader('f', format, 'Format document')
end)

now(function()
  add { 'https://github.com/folke/snacks.nvim' }
  require('snacks').setup {
    bigfile = {},
    input = {},
    image = {},
    notifier = {
      style = 'fancy',
    },
    picker = {
      layouts = {
        vertical = {
          layout = {
            min_height = 15,
          },
        },
      },
    },
    quickfile = {},
    words = {
      modes = { 'n' },
    },
  }
end)

later(function()
  add { 'https://github.com/dmtrKovalenko/fff.nvim' }

  local fff = require 'fff'
  local fff_build = function()
    require('fff.download').download_or_build_binary()
  end

  on_packchanged('fff.nvim', { 'install', 'update' }, fff_build, 'FFF build')

  fff.setup { lazy_sync = true }

  vim.api.nvim_create_user_command('FFFLiveGrep', function(opts)
    local query = vim.trim(opts.args)

    if query == '<cword>' then query = vim.fn.expand '<cword>' end
    if query == '' then
      fff.live_grep()
      return
    end

    fff.live_grep { query = query }
  end, { nargs = '*', desc = 'Live grep with optional query' })
end)

later(function()
  add { 'https://github.com/wakatime/vim-wakatime' }
  vim.g.wakatime_ai_detected = 0
end)

later(function()
  add { 'https://github.com/folke/flash.nvim' }
  require('flash').setup {}
end)

later(function()
  add { 'https://github.com/zk-org/zk-nvim' }
  require('zk').setup {
    picker = 'snacks_picker',
    lsp = { config = { name = 'zk' } },
  }
  vim.env.ZK_NOTEBOOK_DIR = vim.env.NOTES_DIR
end)

later(function()
  add { 'https://github.com/m4xshen/hardtime.nvim' }
  require('hardtime').setup {
    hints = {
      ['[dcyvV][ia][%(%)]'] = {
        message = function(keys)
          return 'Use ' .. keys:sub(1, 2) .. 'b instead of ' .. keys
        end,
        length = 3,
      },
      ['[dcyvV][ia][%{%}]'] = {
        message = function(keys)
          return 'Use ' .. keys:sub(1, 2) .. 'B instead of ' .. keys
        end,
        length = 3,
      },
    },
  }
end)
