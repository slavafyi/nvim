---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'ruby-lsp' }, dispatchers, {
      cwd = config.cmd_cwd or config.root_dir,
    })
  end,
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
  reuse_client = function(client, config)
    return client.name == config.name and client.config.root_dir == config.root_dir
  end,
}
