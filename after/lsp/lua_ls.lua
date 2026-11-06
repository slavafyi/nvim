---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  init_options = { codeLensViewReferences = true },
  root_markers = {
    { '.emmyrc.json', '.luarc.json', '.luarc.jsonc' },
    { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
    { '.git' },
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
    },
  },
  commands = {
    ['lua.showReferences'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local references = command.arguments[3]
      vim.fn.setqflist({}, ' ', {
        title = command.title,
        items = vim.lsp.util.locations_to_items(references, client.offset_encoding),
      })
      vim.cmd 'botright copen'
    end,
  },
}
