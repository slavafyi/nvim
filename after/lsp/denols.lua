---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local root_markers = {
      { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' },
    }
    local project_root = vim.fs.root(bufnr, root_markers)
    local deno_root = vim.fs.root(bufnr, { { 'deno.json', 'deno.jsonc' } })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })

    -- Use the same selection rule as ts_ls so only one server starts.
    if
      (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
      or (deno_root and (not project_root or #deno_root >= #project_root))
    then
      on_dir(vim.fs.root(bufnr, { { 'deno.json', 'deno.jsonc', 'deno.lock' } }))
    end
  end,
}
