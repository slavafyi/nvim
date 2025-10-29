local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

later(function()
  add {
    source = 'saghen/blink.cmp',
    depends = {
      'rafamadriz/friendly-snippets',
      'ways-agency/shopify-liquid-snippets',
      'L3MON4D3/LuaSnip',
      'ribru17/blink-cmp-spell',
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
      ['<Tab>'] = {
        function(cmp)
          local nes = require 'copilot-lsp.nes'
          if vim.b[vim.api.nvim_get_current_buf()].nes_state then
            cmp.hide()
            return (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
          end
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
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
      },
      providers = {
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
  require('luasnip.loaders.from_vscode').lazy_load()
end)
