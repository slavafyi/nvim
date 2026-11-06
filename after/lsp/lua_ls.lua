---@type vim.lsp.Config
return {
  init_options = { codeLensViewReferences = true },
  on_attach = function(_, bufnr)
    require('lazydev').find_workspace(bufnr)
  end,
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
