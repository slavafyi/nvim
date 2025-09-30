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
      },
      providers = {
        buffer = {
          score_offset = 6,
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 8,
        },
        lsp = {
          score_offset = 9,
        },
        path = {
          score_offset = 7,
        },
        snippets = {
          score_offset = 10,
        },
        spell = {
          name = 'Spell',
          module = 'blink-cmp-spell',
          score_offset = 0,
        },
      },
    },
  }
  require('luasnip.loaders.from_vscode').lazy_load()
end)
