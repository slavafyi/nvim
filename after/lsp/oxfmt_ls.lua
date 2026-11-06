local root_with_field = Config.root_with_field

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
    'svelte',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_markers = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' }
    local root = root_with_field(bufnr, root_markers, {
      ['package.json'] = 'oxfmt',
      ['package.json5'] = 'oxfmt',
    })
    if root then on_dir(root) end
  end,
}
