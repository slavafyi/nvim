---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'oxfmt'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end
    end
    return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'toml',
    'json',
    'jsonc',
    'json5',
    'yaml',
    'html',
    'vue',
    'handlebars',
    'css',
    'scss',
    'less',
    'graphql',
    'markdown',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_markers = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }
    on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
  end,
}
