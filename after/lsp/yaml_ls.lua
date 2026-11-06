---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'yaml-language-server'
    if config.root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    'yaml',
    'yaml.ansible',
    'yaml.docker-compose',
    'yaml.gitlab',
    'yaml.helm-values',
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = true
  end,
  root_markers = { '.git' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = { enable = true },
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
