_G.Config = {}

---@alias Config.Callback fun()
---@alias Config.KeymapRhs string|function
---@alias Config.AutocmdCallback fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?|fun(): boolean?

---@class Config.AutocmdOpts: vim.api.keyset.create_autocmd
---@field callback? nil
---@field command? nil
---@field group? nil

---@class Config.PackChangedEvent: vim.api.keyset.create_autocmd.callback_args
---@field data { spec: { name: string }, kind: string, active: boolean }

local gr = vim.api.nvim_create_augroup('custom-config', { clear = true })

---@param event string|string[]
---@param callback Config.AutocmdCallback
---@param opts? Config.AutocmdOpts
---@return integer
Config.new_autocmd = function(event, callback, opts)
  return vim.api.nvim_create_autocmd(
    event,
    vim.tbl_extend('force', opts or {}, {
      group = gr,
      callback = callback,
    })
  )
end

local install_handlers = {}
---@type table<string, Config.PackChangedEvent>
local pending_installs = {}

---@param ev Config.PackChangedEvent
local remember_install = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if kind == 'delete' then
    pending_installs[name] = nil
  elseif kind == 'install' and not install_handlers[name] then
    pending_installs[name] = ev
  end
end

-- Lockfile installs can happen during the very first vim.pack.add().
Config.new_autocmd(
  'PackChanged',
  remember_install,
  { desc = 'Remember installs until their handlers are registered' }
)

vim.pack.add { 'https://github.com/nvim-mini/mini.misc' }

local misc = require 'mini.misc'

---@param f Config.Callback
Config.now = function(f)
  misc.safely('now', f)
end

---@param f Config.Callback
Config.later = function(f)
  misc.safely('later', f)
end

---@param f Config.Callback
Config.now_if_args = function(f)
  return (vim.fn.argc(-1) > 0 and Config.now or Config.later)(f)
end

---@param ev string|string[]
---@param f Config.Callback
Config.on_event = function(ev, f)
  misc.safely('event:' .. ev, f)
end

---@param ft string|string[]
---@param f Config.Callback
Config.on_filetype = function(ft, f)
  misc.safely('filetype:' .. ft, f)
end

Config.apply_colorscheme = function()
  local schemes = vim.g.colorscheme or {}
  local scheme = schemes[vim.o.background]
  if scheme and scheme ~= '' then vim.cmd.colorscheme(scheme) end
end

local quote_preference = 'single'
local format_settings = {
  indentSize = 2,
  semicolons = 'remove',
}

local inlay_hints_settings = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = 'literals',
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
}

Config.typescript_preferences =
  { quote = quote_preference, format = format_settings, hints = inlay_hints_settings }

---@param source integer|string Buffer number or directory
Config.resolve_typescript = function(source)
  local root_markers = {
    { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' },
  }
  local project_root = vim.fs.root(source, root_markers)
  local deno_root = vim.fs.root(source, { { 'deno.json', 'deno.jsonc' } })
  local deno_lock_root = vim.fs.root(source, { 'deno.lock' })

  -- Keep the selection rule in sync with denols.
  if
    (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
    or (deno_root and (not project_root or #deno_root >= #project_root))
  then
    return
  end

  local package_root = vim.fs.root(source, { 'node_modules/typescript/package.json' })
  local install_root = package_root and vim.fs.dirname(vim.fs.dirname(package_root))
  local root = project_root or vim.fs.root(source, { '.git' }) or install_root or vim.fn.getcwd()
  if not install_root then return { name = 'ts_ls', root_dir = root } end

  -- Package-local installations need separate clients in mixed-version monorepos.
  if vim.fs.relpath(root, install_root) then root = install_root end

  local package_path = vim.fs.joinpath(package_root, 'package.json')
  local ok, version = pcall(function()
    local package = vim.json.decode(table.concat(vim.fn.readfile(package_path), '\n'))
    return vim.version.parse(package.version)
  end)
  if not ok or not version then
    vim.notify_once('Cannot read TypeScript version: ' .. package_path, vim.log.levels.ERROR)
    return
  end

  if version.major >= 7 then
    local cmd = vim.fs.joinpath(install_root, 'node_modules/.bin/tsc')
    if vim.fn.executable(cmd) ~= 1 then cmd = 'tsc' end
    return { name = 'tsc', root_dir = root, cmd = cmd }
  end

  return {
    name = 'ts_ls',
    root_dir = root,
    tsserver_path = vim.fs.joinpath(package_root, 'lib/tsserver.js'),
  }
end

---@param source integer|string
---@param markers string[]
---@param fields table<string, string>
---@return string?
Config.root_with_field = function(source, markers, fields)
  local root = vim.fs.root(source, { markers })
  local field_root = vim.fs.root(source, function(name, path)
    local field = fields[name]
    if not field then return false end
    local file = io.open(vim.fs.joinpath(path, name), 'r')
    if not file then return false end
    local contents = file:read '*a'
    file:close()
    return contents ~= nil and contents:find(field, 1, true) ~= nil
  end)
  if field_root and (not root or #field_root > #root) then return field_root end
  return root
end

Config.lsp_includeexpr = function()
  local target = vim.ui._get_urls()[1]
  if target and not target:match '^%w+:' then return target end
  return vim.v.fname
end

Config.statusline_activity = function()
  local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local parts = {}

  if winid == tonumber(vim.g.actual_curwin or -1) then
    local progress = vim.trim(vim.ui.progress_status())
    if progress ~= '' then parts[#parts + 1] = progress end
  end

  if vim.bo[bufnr].busy > 0 then parts[#parts + 1] = '◐' end
  if next(vim.diagnostic.count(bufnr)) then parts[#parts + 1] = vim.diagnostic.status(bufnr) end

  if #parts == 0 then return '' end
  return table.concat(parts, ' ') .. ' '
end

---@param plugin_name string
---@param kinds string[]
---@param callback Config.Callback
---@param desc string?
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  ---@param ev Config.PackChangedEvent
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', f, { desc = desc, pattern = '*' })

  if vim.tbl_contains(kinds, 'install') then
    install_handlers[plugin_name] = true
    local ev = pending_installs[plugin_name]
    pending_installs[plugin_name] = nil
    if ev then f(ev) end
  end
end

---@param lhs string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.imap = function(lhs, rhs, desc)
  vim.keymap.set('i', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.vmap = function(lhs, rhs, desc)
  vim.keymap.set('v', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.xmap = function(lhs, rhs, desc)
  vim.keymap.set('x', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.smap = function(lhs, rhs, desc)
  vim.keymap.set('s', lhs, rhs, { desc = desc })
end

---@param suffix string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.imap_leader = function(suffix, rhs, desc)
  vim.keymap.set('i', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.vmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('v', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs Config.KeymapRhs
---@param desc string?
Config.xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end
