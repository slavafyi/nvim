local root_with_field = Config.root_with_field

---@type vim.lsp.Config
return {
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_files = {
      -- Generic
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
      -- Django
      'theme/static_src/tailwind.config.js',
      'theme/static_src/tailwind.config.cjs',
      'theme/static_src/tailwind.config.mjs',
      'theme/static_src/tailwind.config.ts',
      'theme/static_src/postcss.config.js',
      -- Fallback for tailwind v4, where tailwind.config.* is not required anymore
      '.git',
    }
    local root = root_with_field(bufnr, root_files, {
      ['package.json'] = 'tailwindcss',
      ['package.json5'] = 'tailwindcss',
      ['Gemfile.lock'] = 'tailwind',
      ['mix.lock'] = 'tailwind',
    })
    if root then on_dir(root) end
  end,
}
