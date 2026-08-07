local add = vim.pack.add

local later = Config.later
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

      hl.WarningMsg = { fg = c.warning }
      hl.String = { fg = string }
      hl.Character = { fg = string }
      hl.Identifier = { fg = c.fg }
      hl.Special = { fg = c.emphasis }

      for _, name in ipairs { 'CursorLineNr', 'PmenuMatch', 'Search', 'MatchParen' } do
        hl[name] = { fg = glow, bold = true }
      end
    end,
  }

  vim.cmd 'colorscheme koda'
end)

later(function()
  add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}
end)
