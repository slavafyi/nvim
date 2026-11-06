local resolve_typescript = Config.resolve_typescript

local preferences = Config.typescript_preferences

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local project = resolve_typescript(config.root_dir)
    assert(project and project.name == 'tsc', 'TypeScript installation changed; restart the LSP')
    return vim.lsp.rpc.start({ project.cmd, '--lsp', '--stdio' }, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  root_dir = function(bufnr, on_dir)
    local project = resolve_typescript(bufnr)
    if project and project.name == 'tsc' then on_dir(project.root_dir) end
  end,
  settings = {
    ['js/ts'] = {
      format = preferences.format,
      preferences = { quoteStyle = preferences.quote },
      inlayHints = {
        enumMemberValues = { enabled = preferences.hints.includeInlayEnumMemberValueHints },
        functionLikeReturnTypes = {
          enabled = preferences.hints.includeInlayFunctionLikeReturnTypeHints,
        },
        parameterTypes = { enabled = preferences.hints.includeInlayFunctionParameterTypeHints },
        parameterNames = {
          enabled = preferences.hints.includeInlayParameterNameHints,
          suppressWhenArgumentMatchesName = not preferences.hints.includeInlayParameterNameHintsWhenArgumentMatchesName,
        },
        propertyDeclarationTypes = {
          enabled = preferences.hints.includeInlayPropertyDeclarationTypeHints,
        },
        variableTypes = {
          enabled = preferences.hints.includeInlayVariableTypeHints,
          suppressWhenTypeMatchesName = not preferences.hints.includeInlayVariableTypeHintsWhenTypeMatchesName,
        },
      },
    },
  },
}
