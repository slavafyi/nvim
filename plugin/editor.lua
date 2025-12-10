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
              ['reasoning.effort'] = 'none',
              top_p = {
                condition = function(self)
                  local model = self.schema.model.default
                  if type(model) == 'function' then model = model() end
                  return not model == 'gpt-5.1-codex-max'
                end,
              },
            },
          }

          return adapters.extend('openai_responses', config)
        end,
      },
    },
    strategies = {
      chat = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.1-codex-max',
        },
      },
      inline = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.1-codex',
        },
      },
      cmd = {
        adapter = {
          name = 'openai_responses',
          model = 'gpt-5.1-codex-mini',
        },
      },
    },
  }

  codecompanion.register_extension('spinner', {
    setup = function()
      local progress = require 'fidget.progress'

      local spinner = {
        completed = '✓ Completed',
        error = '✗ Error',
        cancelled = '- Cancelled',
      }

      spinner.handles = {}

      ---Format the adapter name and model for display with the spinner
      ---@param adapter CodeCompanion.ACPAdapter|CodeCompanion.HTTPAdapter
      ---@return string
      local function format_adapter(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= '' then
          table.insert(parts, '(' .. adapter.model .. ')')
        end
        return table.concat(parts, ' ')
      end

      local group = vim.api.nvim_create_augroup('codecompanion-spinner', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(args)
          local handle = progress.handle.create {
            title = '',
            message = ' Sending...',
            lsp_client = {
              name = format_adapter(args.data.adapter),
            },
          }
          spinner.handles[args.data.id] = handle
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = group,
        callback = function(args)
          local handle = spinner.handles[args.data.id]
          spinner.handles[args.data.id] = nil
          if handle then
            if args.data.status == 'success' then
              handle.message = spinner.completed
            elseif args.data.status == 'error' then
              handle.message = spinner.error
            else
              handle.message = spinner.cancelled
            end
            handle:finish()
          end
        end,
      })
    end,
  })

  vim.cmd 'cab cc CodeCompanion'
end)
