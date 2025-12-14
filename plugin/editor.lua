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
    grep = {
      hidden = true,
    },
    keymap = {
      builtin = {
        ['<M-p>'] = 'preview-page-up',
        ['<M-n>'] = 'preview-page-down',
        ['<M-S-p>'] = 'preview-up',
        ['<M-S-n>'] = 'preview-down',
      },
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
      },
    },
    oldfiles = {
      include_current_session = true,
    },
  }
end)

later(function()
  add 'wakatime/vim-wakatime'
end)

later(function()
  add {
    source = 'zbirenbaum/copilot.lua',
  }
  require('copilot').setup {
    filetypes = {
      ['*'] = true,
    },
    panel = {
      enabled = true,
    },
    suggestion = {
      enabled = true,
      keymap = {
        accept = '<Tab>',
        accept_line = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<Esc>',
      },
    },
    nes = {
      enabled = false,
    },
  }
end)

later(function()
  add {
    source = 'olimorris/codecompanion.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'j-hui/fidget.nvim',
    },
  }

  local codecompanion = require 'codecompanion'

  codecompanion.setup {
    adapters = {
      http = {
        openai_responses = function()
          local adapters = require 'codecompanion.adapters'

          ---@type CodeCompanion.HTTPAdapter.OpenAIResponses
          local config = {
            schema = {
              temperature = {
                enabled = function()
                  return false
                end,
              },
              top_p = {
                enabled = function()
                  return false
                end,
              },
            },
          }

          return adapters.extend('openai_responses', config)
        end,
      },
    },
    ignore_warnings = true,
    interactions = {
      chat = {
        adapter = 'opencode',
      },
      inline = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.2',
        },
      },
      cmd = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.2',
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

      local group = vim.api.nvim_create_augroup('codecompanion-spinner', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(args)
          local id = args.data.id
          handles[id] = progress.handle.create {
            title = '',
            message = messages.started,
            lsp_client = { name = adapter_label(args.data.adapter) },
          }
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = group,
        callback = function(args)
          local id = args.data.id
          local handle = handles[id]
          handles[id] = nil
          if handle then finish(handle, args.data.status) end
        end,
      })
    end,
  })

  vim.cmd 'cab cc CodeCompanion'
end)
