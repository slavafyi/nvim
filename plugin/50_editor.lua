local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later
local nmap_leader, xmap_leader = Config.nmap_leader, Config.xmap_leader

later(function()
  add { 'https://github.com/mbbill/undotree' }
  vim.g.undotree_SetFocusWhenToggle = 1
end)

now_if_args(function()
  add {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  }

  local ts_update = function()
    vim.cmd 'TSUpdate'
  end

  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  local languages = {
    'astro',
    'bash',
    'c',
    'cpp',
    'css',
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
    'liquid',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'ssh_config',
    'tmux',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
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

  Config.new_autocmd('FileType', ts_start, 'Start tree-sitter', filetypes)
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
  local conform_util = require 'conform.util'

  conform.formatters.prettierd_js = {
    inherit = 'prettierd',
    condition = conform_util.root_file {
      'node_modules/eslint-plugin-prettier',
      'node_modules/eslint-config-prettier',
    },
  }

  conform.formatters.prettierd_css = {
    inherit = 'prettierd',
    condition = conform_util.root_file { 'node_modules/stylelint-prettier' },
  }

  conform.setup {
    default_format_opts = {
      lsp_format = 'fallback',
      stop_after_first = true,
    },
    formatters_by_ft = {
      css = { 'prettierd_css', 'stylelint' },
      scss = { 'prettierd_css', 'stylelint' },
      javascript = { 'prettierd_js', 'eslint_d' },
      javascriptreact = { 'prettierd_js', 'eslint_d' },
      typescript = { 'prettierd_js', 'eslint_d' },
      typescriptreact = { 'prettierd_js', 'eslint_d' },
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

  local format = function()
    conform.format { async = true }
  end

  nmap_leader('f', format, 'Format document')
  xmap_leader('f', format, 'Format document')
end)

later(function()
  add { 'https://github.com/folke/which-key.nvim' }
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
    words = {
      modes = { 'n' },
    },
  }
end)

now(function()
  add { 'https://github.com/dmtrKovalenko/fff.nvim' }

  local fff_build = function()
    require('fff.download').download_or_build_binary()
  end

  Config.on_packchanged('fff', { 'install', 'update' }, fff_build, 'FFF build')

  require('fff').setup {
    lazy_sync = true,
  }

  vim.api.nvim_create_user_command('FFFLiveGrep', function(opts)
    local fff = require 'fff'
    local args = vim.trim(opts.args or '')
    local query

    if args == '' then
      fff.live_grep()
      return
    end

    query = args:match '^query=(.*)$'
    if not query then
      vim.notify('FFFLiveGrep: expected query=...', vim.log.levels.ERROR)
      return
    end

    query = vim.trim(query)
    if query == '<cword>' then query = vim.fn.expand '<cword>' end

    fff.live_grep { query = query }
  end, {
    nargs = '*',
    desc = 'Live grep with optional query=...',
    complete = function(ArgLead)
      local candidates = { 'query=', 'query=<cword>' }
      return vim.tbl_filter(function(item)
        return item:sub(1, #ArgLead) == ArgLead
      end, candidates)
    end,
  })
end)

later(function()
  add { 'https://github.com/wakatime/vim-wakatime' }
  vim.g.wakatime_ai_detected = 0
end)

later(function()
  add {
    'https://github.com/olimorris/codecompanion.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/j-hui/fidget.nvim',
  }

  local codecompanion = require 'codecompanion'

  codecompanion.setup {
    adapters = {
      http = {
        openai_responses = function()
          local adapters = require 'codecompanion.adapters'

          ---@param self CodeCompanion.HTTPAdapter.OpenAIResponses
          ---@return string
          local function model_name(self)
            local model = self.schema.model.default
            if type(model) == 'function' then model = model() end
            if type(model) ~= 'string' then return '' end
            return model
          end

          ---@param self CodeCompanion.HTTPAdapter.OpenAIResponses
          ---@return boolean
          local function allow_sampling(self)
            return model_name(self):match '^gpt%-5' == nil
          end

          local function make_reasoning_model(formatted_name)
            return {
              formatted_name = formatted_name,
              opts = {
                has_function_calling = true,
                has_vision = true,
                can_reason = true,
              },
            }
          end

          ---@type CodeCompanion.HTTPAdapter.OpenAIResponses
          local config = {
            schema = {
              model = {
                default = 'gpt-5.4',
                choices = {
                  ['gpt-5.3-codex'] = make_reasoning_model 'GPT-5.3 Codex',
                  ['gpt-5.4'] = make_reasoning_model 'GPT-5.4',
                  ['gpt-5.4-pro'] = make_reasoning_model 'GPT-5.4 Pro',
                },
              },
              ['reasoning.effort'] = {
                default = function(self)
                  local model = model_name(self)
                  if model == 'gpt-5-nano' then return 'minimal' end
                  return 'medium'
                end,
                choices = {
                  'none',
                  'minimal',
                  'low',
                  'medium',
                  'high',
                  'xhigh',
                },
              },
              ['reasoning.summary'] = {
                default = nil,
              },
              temperature = {
                enabled = allow_sampling,
              },
              top_p = {
                enabled = allow_sampling,
              },
              top_logprobs = {
                enabled = allow_sampling,
              },
            },
          }

          return adapters.extend('openai_responses', config)
        end,
      },
    },
    interactions = {
      chat = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.4',
        },
      },
      inline = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.3-codex',
        },
      },
      cmd = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.3-codex',
        },
      },
      background = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5-nano',
        },
      },
    },
  }

  codecompanion.register_extension('spinner', {
    setup = function()
      local progress = require 'fidget.progress'

      local messages = {
        started = ' Sending...',
        success = '✓ Completed',
        error = '✗ Error',
        cancelled = '- Cancelled',
      }

      local handles = {}

      ---Format the adapter name and model for display
      ---@param adapter CodeCompanion.ACPAdapter|CodeCompanion.HTTPAdapter
      ---@return string
      local function adapter_label(adapter)
        local model = adapter.model
        if model and model ~= '' then
          return string.format('%s (%s)', adapter.formatted_name, model)
        end
        return adapter.formatted_name
      end

      local function finish(handle, status)
        handle.message = messages[status] or messages.cancelled
        handle:finish()
      end

      Config.new_autocmd('User', function(args)
        local id = args.data.id
        handles[id] = progress.handle.create {
          title = '',
          message = messages.started,
          lsp_client = { name = adapter_label(args.data.adapter) },
        }
      end, nil, 'CodeCompanionRequestStarted')

      Config.new_autocmd('User', function(args)
        local id = args.data.id
        local handle = handles[id]
        handles[id] = nil
        if handle then finish(handle, args.data.status) end
      end, nil, 'CodeCompanionRequestFinished')
    end,
  })

  vim.cmd 'cab cc CodeCompanion'
end)

later(function()
  add {
    'https://github.com/milanglacier/minuet-ai.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
  }
  require('minuet').setup {
    context_window = 10000,
    debounce = 200,
    throttle = 500,
    provider = 'openai',
    provider_options = {
      openai = {
        model = 'gpt-5.4-mini',
      },
    },
    virtualtext = {
      auto_trigger_ft = {},
      keymap = {
        accept = '<Tab>',
        accept_line = '<A-l>',
        accept_n_lines = '<A-z>',
        prev = '<A-[>',
        next = '<A-]>',
        dismiss = '<A-e>',
      },
    },
  }
end)

later(function()
  add { 'https://github.com/folke/flash.nvim' }
  require('flash').setup {}
end)

later(function()
  add { 'https://github.com/zk-org/zk-nvim' }
  require('zk').setup {
    picker = 'snacks_picker',
    lsp = { config = { name = 'zk_ls' } },
  }
  vim.env.ZK_NOTEBOOK_DIR = vim.env.NOTES_DIR
end)
