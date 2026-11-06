local add = vim.pack.add

local later = Config.later
local new_autocmd = Config.new_autocmd
local nmap = Config.nmap
local now_if_args = Config.now_if_args

local ls_mapping = {
  ansible_ls = 'ansible-language-server',
  bash_ls = 'bash-language-server',
  css_ls = 'css-lsp',
  deno_ls = 'deno',
  emmet_ls = 'emmet-language-server',
  fish_ls = 'fish-lsp',
  gleam_ls = 'gleam',
  html_ls = 'html-lsp',
  json_ls = 'json-lsp',
  lua_ls = 'lua-language-server',
  nix_ls = 'nixd',
  odin_ls = 'ols',
  oxfmt_ls = 'oxfmt',
  oxlint_ls = 'oxlint',
  py_ls = 'python-lsp-server',
  ruby_ls = 'ruby-lsp',
  shopify_theme_ls = 'shopify-cli',
  tailwindcss_ls = 'tailwindcss-language-server',
  tombi_ls = 'tombi',
  ts_ls = 'typescript-language-server',
  tsc_ls = 'tsc',
  yaml_ls = 'yaml-language-server',
  zig_ls = 'zls',
  zk_ls = 'zk',
}

local server_list = {}
for server in pairs(ls_mapping) do
  table.insert(server_list, server)
end

---@param opts? vim.diagnostic.Opts
local function setup_diagnostic(opts)
  ---@type vim.diagnostic.Opts
  local default_opts = {
    virtual_lines = false,
  }

  local merged_opts = vim.tbl_deep_extend('force', {}, default_opts, opts or {})
  vim.diagnostic.config(merged_opts)
end

local function on_attach(client, bufnr)
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
  end

  keymap('n', 'grd', vim.lsp.buf.declaration, 'LSP jump to the declaration')

  if client:supports_method 'textDocument/formatting' then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end

  if client:supports_method 'textDocument/documentLink' then
    vim.bo[bufnr].includeexpr = 'v:lua.Config.lsp_includeexpr()'
  end

  if
    vim.lsp.inlay_hint
    and vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].buftype == ''
    and client:supports_method 'textDocument/inlayHint'
  then
    keymap('n', '<Leader>i', function()
      local enabled = not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
      vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
      vim.notify('Inlay hints ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
    end, 'LSP toggle inlay hint')
  end

  if client:supports_method 'textDocument/codeLens' then
    keymap('n', '<Leader>L', function()
      local enabled = not vim.lsp.codelens.is_enabled { bufnr = bufnr }
      vim.lsp.codelens.enable(enabled, { bufnr = bufnr })
      vim.notify('Code lenses ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
    end, 'LSP toggle code lenses')
  end

  keymap('n', '<Leader>v', function()
    local virtual_lines = vim.diagnostic.config().virtual_lines

    ---@type boolean | { current_line?: boolean }
    local next_state = false
    if virtual_lines == false or virtual_lines == nil then
      next_state = { current_line = true }
    elseif type(virtual_lines) == 'table' and virtual_lines.current_line then
      next_state = true
    end

    setup_diagnostic { virtual_lines = next_state }
  end, 'LSP cycle diagnostic virtual lines')

  setup_diagnostic()
end

new_autocmd('LspAttach', function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client == nil then return end
  on_attach(client, args.buf)
end, { desc = 'Configure LSP clients' })

local open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  opts = vim.tbl_extend('keep', opts or {}, {
    max_width = math.floor(vim.o.columns * 0.85),
    max_height = math.floor(vim.o.lines * 0.85),
  })

  return open_floating_preview(contents, syntax, opts)
end

later(function()
  add { 'https://github.com/williamboman/mason.nvim' }
  require('mason').setup()
  local registry = require 'mason-registry'
  local packages = { 'black', 'eslint_d', 'nixfmt', 'prettierd' }
  local excluded_packages =
    { 'deno', 'gleam', 'nixd', 'ols', 'oxlint', 'ruby-lsp', 'shopify-cli', 'zk' }

  local ensure_installed = vim.tbl_values(ls_mapping)
  vim.list_extend(ensure_installed, packages)
  ensure_installed = vim.tbl_filter(function(name)
    return not vim.tbl_contains(excluded_packages, name)
  end, ensure_installed)
  table.sort(ensure_installed)

  registry.refresh(function()
    for _, pkg_name in ipairs(ensure_installed) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then pkg:install() end
    end
  end)
end)

later(function()
  add { 'https://github.com/esmuellert/nvim-eslint' }
  require('nvim-eslint').setup {
    workingDirectory = function(bufnr)
      return { directory = vim.fs.root(bufnr, { 'package.json' }) }
    end,
  }
end)

now_if_args(function()
  add {
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/b0o/SchemaStore.nvim',
  }

  local lazydev = require 'lazydev'
  local schemastore = require 'schemastore'

  vim.lsp.config('lua_ls', {
    on_attach = function(_, bufnr)
      lazydev.find_workspace(bufnr)
    end,
  })

  vim.lsp.config('json_ls', {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
      },
    },
  })

  vim.lsp.config('yaml_ls', {
    settings = {
      yaml = {
        schemaStore = { enable = false, url = '' },
        schemas = schemastore.yaml.schemas(),
      },
    },
  })

  local quote_preference = 'single'
  local format_settings = {
    indentSize = 2,
    semicolons = 'remove',
  }

  local inlay_hints_settings = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = 'literals',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = false,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  }

  vim.lsp.config('ts_ls', {
    init_options = {
      preferences = {
        quotePreference = quote_preference,
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
  })

  vim.lsp.config('tsc_ls', {
    settings = {
      ['js/ts'] = {
        format = format_settings,
        preferences = { quoteStyle = quote_preference },
        inlayHints = {
          enumMemberValues = { enabled = inlay_hints_settings.includeInlayEnumMemberValueHints },
          functionLikeReturnTypes = {
            enabled = inlay_hints_settings.includeInlayFunctionLikeReturnTypeHints,
          },
          parameterTypes = { enabled = inlay_hints_settings.includeInlayFunctionParameterTypeHints },
          parameterNames = {
            enabled = inlay_hints_settings.includeInlayParameterNameHints,
            suppressWhenArgumentMatchesName = not inlay_hints_settings.includeInlayParameterNameHintsWhenArgumentMatchesName,
          },
          propertyDeclarationTypes = {
            enabled = inlay_hints_settings.includeInlayPropertyDeclarationTypeHints,
          },
          variableTypes = {
            enabled = inlay_hints_settings.includeInlayVariableTypeHints,
            suppressWhenTypeMatchesName = not inlay_hints_settings.includeInlayVariableTypeHintsWhenTypeMatchesName,
          },
        },
      },
    },
  })

  vim.lsp.enable(server_list)
end)
