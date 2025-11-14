vim.g.colorscheme = { dark = 'PaperColorSlim', light = 'PaperColorSlimLight' }
vim.g.mapleader = ' '
vim.g.netrw_alto = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.opt.colorcolumn = { '+1' }
vim.opt.cursorline = true
vim.opt.formatoptions:remove('t')
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.list = true
vim.opt.listchars = { space = '·', tab = '▸ ' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.spell = true
vim.opt.spelllang = 'ru_ru,en_us'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = '%f %m %= %Y %p%% %l:%c'
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.textwidth = 80
vim.opt.undodir = os.getenv 'XDG_CACHE_HOME' .. '/nvim/undodir'
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.winborder = 'rounded'
vim.opt.wrap = false
