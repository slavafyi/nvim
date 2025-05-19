local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

local lsp_mapping = {
  jsonls = 'json-lsp',
  lua_ls = 'lua-language-server',
}

local server_list = {}
for server in pairs(lsp_mapping) do
  table.insert(server_list, server)
end

local function on_attach(_, bufnr)
  vim.keymap.set({ 'n', 'x' }, '<Leader>f', function()
    require('conform').format { async = true }
  end, { desc = 'LSP format document', buffer = bufnr })
  -- stylua: ignore start
  vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, { desc = 'LSP display signature information', buffer = bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP jump to the definition', buffer = bufnr })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP jump to the declaration', buffer = bufnr })
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, { desc = 'LSP jump to the definition of the type', buffer = bufnr })
  vim.keymap.set('n', '<Leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostic quickfix list' })
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'Open float diagnostic' })
  -- stylua: ignore end
end

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

  add 'folke/lazydev.nvim'
  vim.lsp.config('lua_ls', {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
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

vim.lsp.config('*', {
  on_attach = on_attach,
})

vim.lsp.enable(server_list)
