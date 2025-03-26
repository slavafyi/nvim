return {
  {
    'folke/neodev.nvim',
    config = true,
    dependencies = {
      { 'folke/neoconf.nvim', config = true },
    },
  },

  {
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        'ansible-lint',
        'eslint_d',
        'prettierd',
        'shfmt',
        'stylelint',
        'stylua',
      },
      ui = {
        border = vim.g.border_chars,
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)

      local registry = require 'mason-registry'
      registry.refresh(function()
        for _, pkg_name in ipairs(opts.ensure_installed) do
          local pkg = registry.get_package(pkg_name)
          if not pkg:is_installed() then pkg:install() end
        end
      end)
    end,
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'folke/neodev.nvim',
      'VonHeikemen/lsp-zero.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'b0o/schemastore.nvim',
      'stevearc/conform.nvim',
      'j-hui/fidget.nvim',
    },
    config = function()
      local lsp_zero = require 'lsp-zero'
      lsp_zero.extend_lspconfig()

      -- stylua: ignore start
      lsp_zero.on_attach(function(_, bufnr)
        vim.keymap.set({ 'n', 'x' }, '<Leader>f', function()
          require('conform').format { async = true, lsp_fallback = true }
        end, { desc = 'LSP format document', buffer = bufnr })
        vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, { desc = 'LSP display signature information', buffer = bufnr })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP jump to the definition', buffer = bufnr })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP jump to the declaration', buffer = bufnr })
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, { desc = 'LSP jump to the definition of the type', buffer = bufnr })
        vim.keymap.set('n', 'gri', '<Cmd>Telescope lsp_implementations<Cr>', { desc = 'LSP lists all the implementations', buffer = bufnr })
        vim.keymap.set('n', 'grr', '<Cmd>Telescope lsp_references<Cr>', { desc = 'LSP lists all the references', buffer = bufnr })
        vim.keymap.set('n', 'gO', '<Cmd>Telescope lsp_document_symbols<Cr>', { desc = 'LSP lists all symbols', buffer = bufnr })
      end)

      vim.keymap.set('n', '<Leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostic quickfix list' })
      vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'Open float diagnostic' })
      -- stylua: ignore end

      local handlers = { lsp_zero.default_setup }
      local ensure_installed = {}
      local schemastore = require 'schemastore'
      local util = require 'lspconfig.util'
      local deno_config_exists = util.root_pattern('deno.json', 'deno.jsonc')
      local format_settings = {
        indentSize = 2,
        semicolons = 'remove',
      }
      local inlay_hints_settings = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'literal',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      }

      local servers = {
        ansiblels = {},
        astro = {},
        bashls = {
          filetypes = { 'sh', 'bash', 'zsh' },
        },
        cssls = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
            client.server_capabilities.documentRangeFormattingProvider = true
          end,
        },
        denols = {
          root_dir = deno_config_exists,
        },
        emmet_language_server = {
          filetypes = { 'html', 'css', 'liquid', 'javascriptreact', 'typescriptreact' },
        },
        eslint = {},
        html = {},
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, schemastore.json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              format = {
                enable = true,
              },
              workspace = {
                checkThirdParty = false,
              },
              hint = {
                enable = true,
              },
            },
          },
        },
        pylsp = {},
        ruby_lsp = {},
        shopify_theme_ls = {},
        stylelint_lsp = {
          filetypes = {
            'css',
            'postcss',
            'sass',
            'scss',
            'vue',
          },
        },
        svelte = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = false,
            },
          },
        },
        tailwindcss = {},
        taplo = {},
        ts_ls = {
          on_new_config = function(new_config, root_dir)
            if deno_config_exists(root_dir) then new_config.enabled = false end
          end,
          init_options = {
            preferences = {
              quotePreference = 'single',
            },
          },
          settings = {
            javascript = {
              format = format_settings,
              inlayHints = inlay_hints_settings,
            },
            typescript = {
              format = format_settings,
              inlayHints = inlay_hints_settings,
            },
          },
        },
        yamlls = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = true
            client.server_capabilities.documentRangeFormattingProvider = true
          end,
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, schemastore.yaml.schemas())
          end,
          filetypes = {
            'yaml',
            'yaml.docker-compose',
            'yaml.ansible',
          },
          settings = {
            yaml = {
              format = {
                enable = true,
              },
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
      }

      for server, server_opts in pairs(servers) do
        server_opts = server_opts == true and {} or server_opts
        if server_opts then lsp_zero.configure(server, server_opts) end
        table.insert(ensure_installed, server)
      end

      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        handlers = handlers,
      }
    end,
  },

  {
    'icholy/lsplinks.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lsplinks = require 'lsplinks'
      lsplinks.setup()
      vim.keymap.set('n', 'gx', lsplinks.gx, { desc = 'Open file using LSP document links' })
    end,
  },

  {
    'stevearc/conform.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    cmd = 'ConformInfo',
    opts = {
      default_format_opts = {
        lsp_format = 'fallback',
        stop_after_first = true,
      },
      formatters_by_ft = {
        css = { 'prettierd_css', 'stylelint' },
        scss = { 'prettierd_css', 'stylelint' },
        javascript = { 'prettierd_js' },
        javascriptreact = { 'prettierd_js' },
        typescript = { 'prettierd_js' },
        typescriptreact = { 'prettierd_js' },
        liquid = { 'prettierd' },
        lua = { 'stylua' },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        zsh = { 'shfmt' },
        yaml = { 'prettierd' },
      },
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2', '-s', '-ci', '-sr', '-ln', 'bash' },
        },
      },
      log_level = vim.log.levels.DEBUG,
    },
    config = function(_, opts)
      local conform = require 'conform'
      local conform_util = require 'conform.util'
      local lsp_util = require 'lspconfig.util'
      local prettierd = require 'conform.formatters.prettierd'

      opts.formatters.stylelint = {
        cwd = conform_util.root_file(lsp_util.insert_package_json({
          '.stylelintrc',
          '.stylelintrc.js',
          '.stylelintrc.cjs',
          '.stylelintrc.yaml',
          '.stylelintrc.yml',
          '.stylelintrc.json',
          'stylelint.config.js',
          'stylelint.config.cjs',
          'stylelint.config.mjs',
          'stylelint.config.ts',
        }, 'stylelint')),
        require_cwd = true,
      }

      opts.formatters.prettierd_js = vim.tbl_deep_extend('force', prettierd, {
        condition = conform_util.root_file {
          'node_modules/eslint-plugin-prettier',
          'node_modules/eslint-config-prettier',
        },
      })

      opts.formatters.prettierd_css = vim.tbl_deep_extend('force', prettierd, {
        condition = conform_util.root_file { 'node_modules/stylelint-prettier' },
      })

      conform.setup(opts)
    end,
  },
}
