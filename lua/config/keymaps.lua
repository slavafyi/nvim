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

vim.keymap.set('n', '<Leader>u', '<Cmd>UndotreeToggle<Cr>', { desc = 'Undotree toggle' })
vim.keymap.set('n', '<Leader>sf', '<Cmd>Telescope find_files<Cr>', { desc = 'Search files' })
vim.keymap.set('n', '<Leader>sg', '<Cmd>Telescope live_grep<Cr>', { desc = 'Search by live grep' })
vim.keymap.set({ 'n', 'v' }, '<Leader>sw', '<Cmd>Telescope grep_string<Cr>', { desc = 'Search current word or selection' })
vim.keymap.set('n', '<Leader>sb', '<Cmd>Telescope buffers<Cr>', { desc = 'Search buffers' })
vim.keymap.set('n', '<Leader>sh', '<Cmd>Telescope help_tags<Cr>', { desc = 'Search help' })
vim.keymap.set('n', '<Leader>so', '<Cmd>Telescope oldfiles<Cr>', { desc = 'Search old files' })
vim.keymap.set('n', '<Leader>sk', '<Cmd>Telescope keymaps<Cr>', { desc = 'Search keymaps' })
vim.keymap.set('n', '-', '<Cmd>Oil<Cr>', { desc = 'File explorer' })
vim.keymap.set('n', '_', '<Cmd>Oil --float<Cr>', { desc = 'File explorer in float window' })
vim.keymap.set('n', '<Leader>G', '<Cmd>Git<Cr>', { desc = 'Open git summary window' })
vim.keymap.set('n', '<Leader>P', '<Cmd>Git push<Cr>', { desc = 'Git push' })
vim.keymap.set('n', '<Leader>hs', '<Cmd>Gitsigns stage_hunk<Cr>', { desc = 'Gitsigns stage hunk' })
vim.keymap.set('n', '<Leader>hr', '<Cmd>Gitsigns reset_hunk<Cr>', { desc = 'Gitsigns reset hunk' })
vim.keymap.set('n', '<Leader>hS', '<Cmd>Gitsigns stage_buffer<Cr>', { desc = 'Gitsigns stage buffer' })
vim.keymap.set('n', '<Leader>hR', '<Cmd>Gitsigns reset_buffer<Cr>', { desc = 'Gitsigns reset buffer' })
vim.keymap.set('n', '<Leader>hp', '<Cmd>Gitsigns preview_hunk_inline<Cr>', { desc = 'Gitsigns preview hunk inline' })
vim.keymap.set('n', '<Leader>hP', '<Cmd>Gitsigns preview_hunk<Cr>', { desc = 'Gitsigns preview hunk' })

vim.keymap.set('n', '[h', '<Cmd>Gitsigns prev_hunk<Cr>', { desc = 'Gitsigns prev hunk' })
vim.keymap.set('n', ']h', '<Cmd>Gitsigns next_hunk<Cr>', { desc = 'Gitsigns next hunk' })
vim.keymap.set('n', '[r', '<Cmd>lua Snacks.words.jump(-vim.v.count1)<Cr>', { desc = 'Previous reference' })
vim.keymap.set('n', ']r', '<Cmd>lua Snacks.words.jump(vim.v.count1)<Cr>', { desc = 'Next reference' })
