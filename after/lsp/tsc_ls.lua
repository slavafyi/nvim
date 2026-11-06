local resolve_typescript = Config.resolve_typescript

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local project = resolve_typescript(config.root_dir)
    assert(project and project.name == 'tsc_ls', 'TypeScript installation changed; restart the LSP')
    return vim.lsp.rpc.start({ project.cmd, '--lsp', '--stdio' }, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(bufnr, on_dir)
    local project = resolve_typescript(bufnr)
    if project and project.name == 'tsc_ls' then on_dir(project.root_dir) end
  end,
}
