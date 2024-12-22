-- GENERIC OPTIONS
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.swapfile = false -- useless with auto-save.nvim
vim.opt.wrap = true
vim.opt.formatoptions:append("cro") -- continue comment when inserting new line
vim.opt.smartcase = true -- search for uppercase only if search word contains uppercase
vim.opt.tabstop = 4 -- tab 4 spaces
vim.opt.shiftwidth = 4 -- shift 4 spaces when << or >>
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.g.mapleader = " " -- leader key
