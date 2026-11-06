local root_with_field = Config.root_with_field

---@type vim.lsp.Config
return {
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_markers = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' }
    local root = root_with_field(bufnr, root_markers, {
      ['package.json'] = 'oxlint',
      ['package.json5'] = 'oxlint',
    })
    if root then on_dir(root) end
  end,
}
