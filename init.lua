_G.Config = {}

vim.pack.add { 'https://github.com/nvim-mini/mini.misc' }

local misc = require 'mini.misc'

---@alias Config.Callback fun()
---@alias Config.KeymapRhs string|function
---@alias Config.AutocmdCallback fun(ev: vim.api.keyset.create_autocmd.callback_args): boolean?|fun(): boolean?

---@class Config.AutocmdOpts: vim.api.keyset.create_autocmd
---@field callback? nil
---@field command? nil
---@field group? nil

---@class Config.PackChangedEvent: vim.api.keyset.create_autocmd.callback_args
---@field data { spec: { name: string }, kind: string, active: boolean }

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

Config.lsp_includeexpr = function()
  local target = vim.ui._get_urls()[1]
  if target and not target:match '^%w+:' then return target end
  return vim.v.fname
end

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
