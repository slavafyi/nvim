local root_with_field = Config.root_with_field

---@type vim.lsp.Config
return {
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
