local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

local lsp_mapping = { lua_ls = 'lua-language-server' }
local server_list = {}

for server in pairs(lsp_mapping) do
  table.insert(server_list, server)
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
end)

later(function()
  add 'folke/lazydev.nvim'
  vim.lsp.config('lua_ls', {
    on_attach = function(_, bufnr)
      require('lazydev').find_workspace(bufnr)
    end,
  })
end)

vim.lsp.config('*', {
  on_init = function()
    print 'this will be everywhere'
    print 'this will be everywhere'
    print 'this will be everywhere'
    print 'this will be everywhere'
  end,
})

vim.lsp.enable(server_list)
