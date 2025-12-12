local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

later(function()
  add {
    source = 'slavafyi/friendly-snippets',
    checkout = 'feature/liquid-update',
  }

  add {
    source = 'saghen/blink.cmp',
    depends = {
      'L3MON4D3/LuaSnip',
      'ribru17/blink-cmp-spell',
      'moyiz/blink-emoji.nvim',
    },
    checkout = 'v1.7.0',
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
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 10,
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
  local modes = { 'i', 's' }

  local function change_choice(delta)
    return function()
      if not ls.choice_active() then return end
      ls.change_choice(delta)
    end
  end

  vim.keymap.set(modes, '<C-n>', change_choice(1), { desc = 'Next choice' })
  vim.keymap.set(modes, '<C-p>', change_choice(-1), { desc = 'Prev choice' })
end)
