local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now

now(function()
  add 'pappasam/papercolor-theme-slim'

  local function overrides_hl_groups()
    local green = vim.g.terminal_color_2
    local yellow = vim.g.terminal_color_13
    local red = vim.g.terminal_color_1

    vim.cmd.highlight(string.format('DiffAdd guifg=%s guibg=NONE', green))
    vim.cmd.highlight(string.format('DiffChange guifg=%s guibg=NONE', yellow))
    vim.cmd.highlight(string.format('DiffDelete guifg=%s guibg=NONE', red))
  end

  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Override papercolor colorscheme highlight groups',
    group = vim.api.nvim_create_augroup('overrides-highlight-groups', { clear = true }),
    pattern = { 'PaperColorSlim', 'PaperColorSlimLight' },
    callback = overrides_hl_groups,
  })
end)

now(function()
  add 'j-hui/fidget.nvim'
  require('fidget').setup()
end)
