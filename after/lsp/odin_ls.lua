---@type vim.lsp.Config
return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_markers = { 'ols.json', '.git' },
  init_options = {
    checker_args = '-strict-style',
    collections = {
      { name = 'shared', path = vim.fn.expand '$HOME/odin-lib' },
    },
  },
  workspace_required = false,
}
