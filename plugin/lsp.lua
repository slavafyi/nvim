local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

local ls_mapping = {
  bash_ls = 'bash-language-server',
  fish_ls = 'fish-lsp',
  json_ls = 'json-lsp',
  lua_ls = 'lua-language-server',
  yaml_ls = 'yaml-language-server',
}

local server_list = {}
for server in pairs(ls_mapping) do
  table.insert(server_list, server)
end

---@param opts? vim.diagnostic.Opts
local function setup_diagnostic(opts)
  ---@type vim.diagnostic.Opts
  local default_opts = {
    virtual_lines = { current_line = true },
  }

  if opts and opts.virtual_lines == false then default_opts.virtual_lines = false end
  local merged_opts = vim.tbl_deep_extend('force', default_opts, opts or {})
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

  if
    vim.lsp.inlay_hint
    and vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].buftype == ''
    and client:supports_method 'textDocument/inlayHint'
  then
    keymap('n', '<Leader>i', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr },
        { buf = bufnr }
      )
    end, 'LSP toggle inlay hint')
  end

  keymap('n', '<Leader>v', function()
    local virtual_lines_enabled = not vim.diagnostic.config().virtual_lines
    setup_diagnostic { virtual_lines = virtual_lines_enabled }
  end, 'LSP toggle diagnostic virtual lines')

  setup_diagnostic()
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP clients',
  group = vim.api.nvim_create_augroup('configure-lsp-clients', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end
    on_attach(client, args.buf)
  end,
})

later(function()
  add 'williamboman/mason.nvim'
  require('mason').setup()
  local registry = require 'mason-registry'
  registry.refresh(function()
    for _, pkg_name in pairs(ls_mapping) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then pkg:install() end
    end
  end)
end)

later(function()
  add 'folke/lazydev.nvim'
  add 'b0o/SchemaStore.nvim'

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

  vim.lsp.enable(server_list)
end)
