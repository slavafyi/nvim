_G.Config = {}

vim.pack.add { 'https://github.com/nvim-mini/mini.misc' }

local misc = require 'mini.misc'

---@param f fun()
Config.now = function(f)
  misc.safely('now', f)
end

---@param f fun()
Config.later = function(f)
  misc.safely('later', f)
end

---@param f fun()
Config.now_if_args = function(f)
  return (vim.fn.argc(-1) > 0 and Config.now or Config.later)(f)
end

---@param ev string|string[]
---@param f fun()
Config.on_event = function(ev, f)
  misc.safely('event:' .. ev, f)
end

---@param ft string|string[]
---@param f fun()
Config.on_filetype = function(ft, f)
  misc.safely('filetype:' .. ft, f)
end

local gr = vim.api.nvim_create_augroup('custom-config', { clear = true })

---@param event string|string[]
---@param callback fun(ev: table)|fun()
---@param desc string?
---@param pattern string|string[]?
---@param nested boolean?
Config.new_autocmd = function(event, callback, desc, pattern, nested)
  vim.api.nvim_create_autocmd(event, {
    group = gr,
    pattern = pattern,
    nested = nested,
    callback = callback,
    desc = desc,
  })
end

---@param plugin_name string
---@param kinds string[]
---@param callback fun()
---@param desc string?
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  ---@param ev { data: { spec: { name: string }, kind: string, active: boolean } }
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', f, desc, '*')
end

---@param lhs string
---@param rhs string|fun()
---@param desc string?
Config.nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs string|fun()
---@param desc string?
Config.imap = function(lhs, rhs, desc)
  vim.keymap.set('i', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs string|fun()
---@param desc string?
Config.vmap = function(lhs, rhs, desc)
  vim.keymap.set('v', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs string|fun()
---@param desc string?
Config.xmap = function(lhs, rhs, desc)
  vim.keymap.set('x', lhs, rhs, { desc = desc })
end

---@param lhs string
---@param rhs string|fun()
---@param desc string?
Config.smap = function(lhs, rhs, desc)
  vim.keymap.set('s', lhs, rhs, { desc = desc })
end

---@param suffix string
---@param rhs string|fun()
---@param desc string?
Config.nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs string|fun()
---@param desc string?
Config.imap_leader = function(suffix, rhs, desc)
  vim.keymap.set('i', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs string|fun()
---@param desc string?
Config.vmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('v', '<Leader>' .. suffix, rhs, { desc = desc })
end

---@param suffix string
---@param rhs string|fun()
---@param desc string?
Config.xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end
