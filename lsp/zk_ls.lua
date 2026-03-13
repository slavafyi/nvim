---@type vim.lsp.Config
return {
  cmd = { 'zk', 'lsp' },
  filetypes = { 'markdown' },
  root_markers = { '.zk' },
  workspace_required = true,
}
