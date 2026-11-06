---@type vim.lsp.Config
return {
  filetypes = {
    'yaml',
    'yaml.ansible',
    'yaml.docker-compose',
    'yaml.gitlab',
    'yaml.helm-values',
  },
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' },
      schemas = require('schemastore').yaml.schemas(),
      format = { enable = true },
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
