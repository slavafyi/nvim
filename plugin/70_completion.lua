local add = vim.pack.add

local imap = Config.imap
local later = Config.later
local smap = Config.smap

later(function()
  add {
    {
      src = 'https://github.com/slavafyi/friendly-snippets',
      version = 'feature/liquid-update',
    },
  }
end)

later(function()
  add {
    {
      src = 'https://github.com/saghen/blink.cmp',
      version = 'v1.10.1',
    },
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/ribru17/blink-cmp-spell',
    'https://github.com/moyiz/blink-emoji.nvim',
  }

  require('blink.cmp').setup {
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      menu = {
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'kind' },
          },
          treesitter = { 'lsp' },
        },
      },
    },
    keymap = {
      preset = 'enter',
    },
    snippets = {
      preset = 'luasnip',
    },
    sources = {
      default = {
        'buffer',
        'lazydev',
        'lsp',
        'path',
        'snippets',
        'spell',
        'emoji',
      },
      providers = {
        emoji = {
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 15,
          opts = {
            insert = true,
            ---@type string|table|fun():table
            trigger = function()
              return { ':' }
            end,
          },
          should_show_items = function()
            return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.o.filetype)
          end,
        },
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 10,
        },
        lsp = {
          transform_items = function(ctx, items)
            if ctx.trigger.initial_kind ~= 'trigger_character' then return items end
            local snippet_kind = require('blink.cmp.types').CompletionItemKind.Snippet
            return vim.tbl_filter(function(item)
              return item.kind ~= snippet_kind
            end, items)
          end,
        },
        spell = {
          module = 'blink-cmp-spell',
          opts = {
            enable_in_context = function()
              local curpos = vim.api.nvim_win_get_cursor(0)
              local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
              local in_spell_capture = false
              for _, cap in ipairs(captures) do
                if cap.capture == 'spell' then
                  in_spell_capture = true
                elseif cap.capture == 'nospell' then
                  return false
                end
              end
              return in_spell_capture
            end,
          },
          score_offset = -35,
        },
      },
    },
  }

  local luasnip_vscode = require 'luasnip.loaders.from_vscode'
  luasnip_vscode.lazy_load()

  local ls = require 'luasnip'

  local function change_choice(delta)
    return function()
      if not ls.choice_active() then return end
      ls.change_choice(delta)
    end
  end

  imap('<C-n>', change_choice(1), 'Next choice')
  smap('<C-n>', change_choice(1), 'Next choice')
  imap('<C-p>', change_choice(-1), 'Prev choice')
  smap('<C-p>', change_choice(-1), 'Prev choice')
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
        accept = '<A-y>',
        accept_line = '<A-l>',
        accept_n_lines = '<A-z>',
        prev = '<A-[>',
        next = '<A-]>',
        dismiss = '<A-e>',
      },
    },
  }
end)
