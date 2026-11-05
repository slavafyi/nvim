local add = vim.pack.add

local new_autocmd = Config.new_autocmd
local now = Config.now

now(function()
  add { 'https://github.com/oskarnurm/koda.nvim' }
  local koda = require 'koda'

  koda.setup {
    on_highlights = function(hl, c)
      local glow = c.success
      local string = koda.blend(c.keyword, c.fg, 0.5)

      for name, group in pairs(hl) do
        if type(group) == 'table' then
          local warning = name:find '[Ww]arn' or name:find 'Change' or name == 'DiffText'
          local accent = warning and c.warning or glow

          for _, attr in ipairs { 'fg', 'bg', 'sp' } do
            if group[attr] == c.const then group[attr] = accent end
          end
        end
      end

      hl.Character = { fg = string }
      hl.CursorLineNr = { fg = c.fg }
      hl.Identifier = { fg = c.fg }
      hl.Special = { fg = c.emphasis }
      hl.String = { fg = string }
      hl.WarningMsg = { fg = c.warning }

      for _, name in ipairs { 'CurSearch', 'MatchParen', 'PmenuMatch', 'Search' } do
        hl[name] = { fg = glow, bold = true }
      end
    end,
  }

  vim.cmd 'colorscheme koda'
end)

now(function()
  require('vim._core.ui2').enable {
    msg = {
      targets = { progress = 'msg' },
    },
  }

  new_autocmd('LspProgress', function(ev)
    local value = ev.data.params.value

    if type(value) ~= 'table' or not vim.tbl_contains({ 'begin', 'report', 'end' }, value.kind) then
      return
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local message = value.message or value.title or (value.kind == 'end' and 'Done' or 'Working…')

    if client then message = client.name .. ': ' .. message end

    vim.api.nvim_echo({ { message } }, false, {
      id = ('lsp.%d.%s'):format(ev.data.client_id, ev.data.params.token),
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind == 'end' and 'success' or 'running',
      percent = value.percentage,
    })

    vim.cmd.redrawstatus()
  end, { desc = 'Show LSP progress in the native UI' })
end)
