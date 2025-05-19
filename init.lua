vim.g.mapleader = ' '
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0
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
  callback = function()
    if vim.o.background == 'dark' then
      vim.cmd.colorscheme 'PaperColorSlim'
    else
      vim.cmd.colorscheme 'PaperColorSlimLight'
    end
  end,
})

vim.cmd.packadd 'papercolor-theme-slim'
vim.cmd.colorscheme 'PaperColorSlim'

-- stylua: ignore start
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Escape' })
vim.keymap.set({ 'n', 'i' }, '<Esc>', '<Cmd>noh<Cr><Esc>', { desc = 'Clear the search highlight' })
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<Leader>Y', '"+Y', { desc = 'Copy a line to system clipboard' })
vim.keymap.set('x', '<Leader>p', '"_dP', { desc = 'Paste yanked text without affecting registers' })
vim.keymap.set('n', '<Backspace>', '"_dh', { desc = 'Delete character to the left without affecting registers' })
vim.keymap.set('x', '<Backspace>', '"_d', { desc = 'Delete selection without affecting registers' })
vim.keymap.set('v', 'J', ":m '>+1<Cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '>-2<Cr>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('n', '<Leader>p', '<Cmd>Ex<Cr>', { desc = 'Open Netrw' })
-- stylua: ignore end

vim.keymap.set('n', 'л', 'gk', { desc = 'Move cursor up' })
vim.keymap.set('n', 'о', 'gj', { desc = 'Move cursor down' })
vim.keymap.set('n', 'р', 'h', { desc = 'Move cursor left' })
vim.keymap.set('n', 'д', 'l', { desc = 'Move cursor right' })
vim.keymap.set('n', 'ш', 'i', { desc = 'Insert mode' })
vim.keymap.set('n', 'Ж', ':', { desc = 'Command-line mode' })
vim.keymap.set('n', 'нн', 'yy', { desc = 'Yank line' })
vim.keymap.set('n', 'нц', 'yw', { desc = 'Yank word' })
vim.keymap.set('n', 'вв', 'dd', { desc = 'Delete line' })
vim.keymap.set('n', 'вц', 'dw', { desc = 'Delete word' })
vim.keymap.set('i', 'ол', '<Esc>', { desc = 'Escape' })