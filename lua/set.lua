vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.breakindent = true

vim.o.wrap = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.undofile = true

-- case insensitive searching (unless search pattern contains capitals or \C)
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.o.signcolumn = 'yes'

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- settings for list mode (which can be turned on with :set list)
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.scrolloff = 8

vim.o.hlsearch = false

vim.o.termguicolors = true

vim.opt.colorcolumn = '80'
