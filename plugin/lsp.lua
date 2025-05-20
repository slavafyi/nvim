local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

local lsp_mapping = {
  jsonls = 'json-lsp',
  lua_ls = 'lua-language-server',
}

local server_list = {}
for server in pairs(lsp_mapping) do
  table.insert(server_list, server)
end

vim.lsp.enable(server_list)

local function on_attach(client, bufnr)
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
  end

  keymap('n', 'gd', vim.lsp.buf.type_definition, 'LSP jump to the definition of the type')
  keymap('n', 'gD', vim.lsp.buf.declaration, 'LSP jump to the declaration')

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
    for _, pkg_name in pairs(lsp_mapping) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then pkg:install() end
    end
  end)
end)

later(function()
  add 'folke/lazydev.nvim'
  vim.lsp.config('lua_ls', {
    on_attach = function(_, bufnr)
      require('lazydev').find_workspace(bufnr)
    end,
  })

  add 'b0o/SchemaStore.nvim'
  local schemastore = require 'schemastore'
  vim.lsp.config('jsonls', {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
      },
    },
  })
end)
