local nmap = Config.nmap
local imap = Config.imap
local vmap = Config.vmap
local xmap = Config.xmap
local nmap_leader = Config.nmap_leader
local vmap_leader = Config.vmap_leader
local xmap_leader = Config.xmap_leader

imap('jk', '<Esc>', 'Esc')
nmap('<Esc>', '<Cmd>noh<Cr><Esc>', 'Clear search')
imap('<Esc>', '<Cmd>noh<Cr><Esc>', 'Clear search')
nmap_leader('y', '"+y', 'Copy clipboard')
vmap_leader('y', '"+y', 'Copy clipboard')
nmap_leader('Y', '"+Y', 'Copy line clipboard')
vmap_leader('Y', '"+Y', 'Copy line clipboard')
xmap_leader('p', '"_dP', 'Paste keep register')
nmap('<Backspace>', '"_dh', 'Delete left (blackhole)')
xmap('<Backspace>', '"_d', 'Delete selection (blackhole)')
vmap('J', ":m '>+1<Cr>gv=gv", 'Move down')
vmap('K', ":m '>-2<Cr>gv=gv", 'Move up')

nmap('л', 'gk', 'Up')
nmap('о', 'gj', 'Down')
nmap('р', 'h', 'Left')
nmap('д', 'l', 'Right')
nmap('ш', 'i', 'Insert mode')
nmap('Ж', ':', 'Command-line mode')
nmap('нн', 'yy', 'Yank line')
nmap('нц', 'yw', 'Yank word')
nmap('вв', 'dd', 'Delete line')
nmap('вц', 'dw', 'Delete word')
imap('ол', '<Esc>', 'Escape')

nmap_leader('u', '<Cmd>UndotreeToggle<Cr>', 'UndoTree')
nmap('-', '<Cmd>Oil<Cr>', 'Oil')
nmap('_', '<Cmd>Oil --float<Cr>', 'Oil float')
nmap_leader('G', '<Cmd>Git<Cr>', 'Git status')
nmap_leader('P', '<Cmd>Git push<Cr>', 'Git push')
nmap_leader('hs', '<Cmd>Gitsigns stage_hunk<Cr>', 'Stage hunk')
nmap_leader('hr', '<Cmd>Gitsigns reset_hunk<Cr>', 'Reset hunk')
nmap_leader('hS', '<Cmd>Gitsigns stage_buffer<Cr>', 'Stage buffer')
nmap_leader('hR', '<Cmd>Gitsigns reset_buffer<Cr>', 'Reset buffer')
nmap_leader('hp', '<Cmd>Gitsigns preview_hunk_inline<Cr>', 'Preview hunk inline')
nmap_leader('hP', '<Cmd>Gitsigns preview_hunk<Cr>', 'Preview hunk')
nmap_leader('q', '<Cmd>lua vim.diagnostic.setqflist()<Cr>', 'Diagnostic quickfix list')
nmap_leader('l', '<Cmd>lua vim.diagnostic.setloclist()<Cr>', 'Diagnostic location list')
nmap_leader('d', '<Cmd>lua vim.diagnostic.open_float()<Cr>', 'Diagnostic float')

nmap('[h', '<Cmd>Gitsigns prev_hunk<Cr>', 'Prev hunk')
nmap(']h', '<Cmd>Gitsigns next_hunk<Cr>', 'Next hunk')
nmap('[r', '<Cmd>lua Snacks.words.jump(-vim.v.count1)<Cr>', 'Prev ref')
nmap(']r', '<Cmd>lua Snacks.words.jump(vim.v.count1)<Cr>', 'Next ref')
nmap_leader('p', '<Cmd>lua require("fff").find_files()<Cr>', 'Find files')
nmap_leader('/', '<Cmd>FFFLiveGrep<Cr>', 'Live grep')
nmap_leader('?', '<Cmd>FFFLiveGrep <cword><Cr>', 'Grep word')
nmap_leader('o', '<Cmd>lua Snacks.picker.recent()<Cr>', 'Recent files')
nmap_leader('r', '<Cmd>lua Snacks.picker.resume()<Cr>', 'Resume picker')
nmap_leader('<Leader>', '<Cmd>lua Snacks.picker.buffers()<Cr>', 'Buffers')

nmap_leader('n', '<Cmd>lua Snacks.notifier.show_history()<Cr>', 'Notification history')
nmap_leader('c', '<Cmd>Minuet virtualtext toggle<Cr>', 'Toggle completion')
