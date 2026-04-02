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
  py_ls = 'python-lsp-server',
  ruby_ls = 'ruby-lsp',
  shopify_theme_ls = 'shopify-cli',
  tailwindcss_ls = 'tailwindcss-language-server',
  taplo_ls = 'taplo',
  ts_ls = 'typescript-language-server',
  yaml_ls = 'yaml-language-server',
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
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr },
        { bufnr = bufnr }
      )
    end, 'LSP toggle inlay hint')
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

later(function()
  add { 'https://github.com/williamboman/mason.nvim' }
  require('mason').setup()
  local registry = require 'mason-registry'
  local packages = { 'black', 'eslint_d', 'nixfmt', 'prettierd' }
  local excluded_packages = { 'deno', 'gleam', 'nixd', 'ruby-lsp', 'shopify-cli', 'zk' }

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

  local check_deno = function(bufnr)
    local root_markers = { 'deno.json', 'deno.jsonc' }
    return vim.fs.root(bufnr, root_markers)
  end

  local check_ts = function(bufnr)
    local root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' }
    return vim.fs.root(bufnr, root_markers)
  end

  vim.lsp.config('ts_ls', {
    init_options = {
      preferences = {
        quotePreference = 'single',
      },
    },
    root_dir = function(bufnr, on_dir)
      local deno_dir = check_deno(bufnr)
      local ts_dir = check_ts(bufnr) or vim.fn.getcwd()
      if deno_dir == nil then on_dir(ts_dir) end
    end,
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

  vim.lsp.config('deno_ls', {
    root_dir = function(bufnr, on_dir)
      local deno_dir = check_deno(bufnr)
      local ts_dir = check_ts(bufnr)
      if ts_dir == nil and deno_dir then on_dir(deno_dir) end
    end,
  })

  vim.lsp.enable(server_list)
end)
