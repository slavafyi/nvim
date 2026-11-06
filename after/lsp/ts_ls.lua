local resolve_typescript = Config.resolve_typescript

local preferences = Config.typescript_preferences

---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local project = resolve_typescript(bufnr)
    if project and project.name == 'ts_ls' then on_dir(project.root_dir) end
  end,
  before_init = function(params, config)
    local project = resolve_typescript(config.root_dir)
    if project and project.tsserver_path then
      params.initializationOptions = params.initializationOptions or {}
      params.initializationOptions.tsserver = vim.tbl_extend(
        'force',
        params.initializationOptions.tsserver or {},
        { path = project.tsserver_path }
      )
    end
  end,
  init_options = {
    preferences = {
      quotePreference = preferences.quote,
    },
  },
  settings = {
    javascript = {
      format = preferences.format,
      inlayHints = preferences.hints,
    },
    typescript = {
      format = preferences.format,
      inlayHints = preferences.hints,
    },
  },
}
