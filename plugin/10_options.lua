vim.g.colorscheme = { dark = 'kintsugi-dark-flared', light = 'kintsugi-light' }
vim.g.mapleader = ' '
vim.g.netrw_alto = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.opt.colorcolumn = { '+1' }
vim.opt.cursorline = true
vim.opt.formatoptions:remove 't'
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.langmap = table.concat({
  [[ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЁХЪЖЭБЮ±;ABCDEFGHIJKLMNOPQRSTUVWXYZ~{}:\"<>~]],
  [[фисвуапршолдьтщзйкыегмцчняёхъжэбю§;abcdefghijklmnopqrstuvwxyz`[]\;'\,.`]],
}, ',')
vim.opt.list = true
vim.opt.listchars = { space = '·', tab = '▸ ' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.showcmdloc = 'statusline'
vim.opt.sidescrolloff = 4
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.spell = true
vim.opt.spelllang = 'ru_ru,en_us'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = '%f %m %= %{%v:lua.Config.statusline_activity()%}%S %Y %p%% %l:%c'
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.textwidth = 80
local undodir = vim.fn.stdpath 'cache' .. '/undodir'
vim.fn.mkdir(undodir, 'p')
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.winborder = 'rounded'
vim.opt.wrap = false
