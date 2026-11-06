local function default_odin_root()
  local root = vim.env.ODIN_ROOT
  if root and root ~= '' then return vim.fs.normalize(root) end
  if vim.fn.executable 'odin' == 0 then return end
  local result = vim.system({ 'odin', 'root' }, { text = true }):wait()
  if result.code == 0 and result.stdout then
    root = vim.trim(result.stdout)
    if root ~= '' then return vim.fs.normalize(root) end
  end
end

local function library_root(fname)
  local root = default_odin_root()
  if not root then return end
  fname = vim.fs.normalize(fname)
  for _, library in ipairs { 'base', 'core', 'vendor' } do
    if vim.fs.relpath(vim.fs.joinpath(root, library), fname) then
      local clients = vim.lsp.get_clients { name = 'odin_ls' }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

---@type vim.lsp.Config
return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(bufnr, on_dir)
    local root = library_root(vim.api.nvim_buf_get_name(bufnr))
      or vim.fs.root(bufnr, {
        'ols.json',
        '.git',
        function(name)
          return name:match '%.odin$' ~= nil
        end,
      })
    on_dir(root)
  end,
  init_options = {
    checker_args = '-strict-style',
    collections = {
      { name = 'shared', path = vim.fn.expand '$HOME/odin-lib' },
    },
  },
  workspace_required = false,
}
