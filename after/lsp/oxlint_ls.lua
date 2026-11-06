local root_with_field = Config.root_with_field

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'oxlint'
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
    'vue',
    'svelte',
    'astro',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_markers = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' }
    local root = root_with_field(bufnr, root_markers, {
      ['package.json'] = 'oxlint',
      ['package.json5'] = 'oxlint',
    })
    if root then on_dir(root) end
  end,
  before_init = function(params, config)
    local init_options = config.init_options or {}
    local settings = vim.tbl_extend('force', {}, init_options.settings or {}, config.settings or {})
    local has_tsgolint = vim.fn.executable 'tsgolint' == 1
    if not has_tsgolint and config.root_dir then
      has_tsgolint = vim.fn.executable(
        vim.fs.joinpath(config.root_dir, 'node_modules/.bin/tsgolint')
      ) == 1
    end
    if settings.typeAware == nil and has_tsgolint and config.root_dir then
      local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(config.root_dir, '.oxlintrc.json'))
      if ok and table.concat(lines, '\n'):find('typescript', 1, true) then
        settings.typeAware = true
      end
    end
    params.initializationOptions = vim.tbl_extend(
      'force',
      {},
      init_options,
      { settings = settings }
    )
  end,
}
