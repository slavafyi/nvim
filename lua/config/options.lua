vim.g.mapleader = ' '
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0
vim.g.border_chars = 'rounded'
vim.opt.colorcolumn = { '+1' }
vim.opt.cursorline = true
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
vim.opt.textwidth = 80
vim.opt.undodir = os.getenv 'HOME' .. '/.cache/nvim/undodir'
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wrap = false

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  desc = 'Automatically update colorscheme based on background option',
  group = vim.api.nvim_create_augroup('update-colorscheme', { clear = true }),
  pattern = 'background',
  nested = true,
  callback = function()
    if vim.o.background == 'dark' then
      vim.cmd.colorscheme 'PaperColorSlim'
    else
      vim.cmd.colorscheme 'PaperColorSlimLight'
    end
  end,
})
