local add = vim.pack.add

local later = Config.later
local new_autocmd = Config.new_autocmd
local now_if_args = Config.now_if_args

vim.diagnostic.config { virtual_lines = false }

local function on_attach(client, bufnr)
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr })
  end

  keymap('n', 'grd', vim.lsp.buf.declaration, 'LSP jump to the declaration')

  if client:supports_method 'textDocument/documentLink' then
    vim.bo[bufnr].includeexpr = 'v:lua.Config.lsp_includeexpr()'
  end

  if
    vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].buftype == ''
    and client:supports_method 'textDocument/inlayHint'
  then
    keymap('n', '<Leader>i', function()
      local enabled = not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
      vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
      vim.notify('Inlay hints ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
    end, 'LSP toggle inlay hint')
  end

  if client:supports_method 'textDocument/codeLens' then
    keymap('n', '<Leader>L', function()
      local enabled = not vim.lsp.codelens.is_enabled { bufnr = bufnr }
      vim.lsp.codelens.enable(enabled, { bufnr = bufnr })
      vim.notify('Code lenses ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
    end, 'LSP toggle code lenses')
  end

  keymap('n', '<Leader>v', function()
    local virtual_lines = vim.diagnostic.config().virtual_lines

    ---@type boolean | { current_line?: boolean }
    local next_state = false
    if virtual_lines == false or virtual_lines == nil then
      next_state = { current_line = true }
    elseif type(virtual_lines) == 'table' and virtual_lines.current_line then
      next_state = true
    end

    vim.diagnostic.config { virtual_lines = next_state }
  end, 'LSP cycle diagnostic virtual lines')
end

new_autocmd('LspAttach', function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client == nil then return end
  on_attach(client, args.buf)
end, { desc = 'Configure LSP clients' })

local open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  opts = vim.tbl_extend('keep', opts or {}, {
    max_width = math.floor(vim.o.columns * 0.85),
    max_height = math.floor(vim.o.lines * 0.85),
  })

  return open_floating_preview(contents, syntax, opts)
end

later(function()
  add { 'https://github.com/esmuellert/nvim-eslint' }
  require('nvim-eslint').setup {
    workingDirectory = function(bufnr)
      return { directory = vim.fs.root(bufnr, { 'package.json' }) }
    end,
  }
end)

now_if_args(function()
  add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/b0o/SchemaStore.nvim',
  }

  vim.lsp.enable {
    'ansiblels',
    'bashls',
    'cssls',
    'denols',
    'emmet_language_server',
    'fish_lsp',
    'gleam',
    'html',
    'jsonls',
    'lua_ls',
    'nixd',
    'ols',
    'oxfmt',
    'oxlint',
    'pylsp',
    'ruby_lsp',
    'shopify_theme_ls',
    'tailwindcss',
    'tombi',
    'ts_ls',
    'tsc',
    'yamlls',
    'zls',
    'zk',
  }
end)
