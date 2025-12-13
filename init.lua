package.path = package.path .. ";" .. vim.fn.expand("~/") .. ".config/nvim/?.lua;" .. vim.fn.expand("~/") .. ".config/nvim/src/?.lua"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number         = true
vim.o.relativenumber = true
vim.o.autoindent     = true
vim.o.smartindent    = true
vim.o.expandtab      = true
vim.o.tabstop        = 4
vim.o.shiftwidth     = 4
vim.o.softtabstop    = 4
vim.o.ruler          = true
vim.o.hlsearch       = false
vim.o.showmatch      = false
vim.o.backspace      = "indent,start"
vim.o.list           = true
vim.o.listchars      = "leadmultispace:│   ,trail:⋅"
vim.o.wrap           = false
vim.o.showmode       = false
vim.o.cursorline     = true
vim.o.cursorcolumn   = false
vim.o.sidescroll     = 5
vim.o.sidescrolloff  = 3
vim.o.scrolloff      = 3
vim.o.visualbell     = true
vim.o.numberwidth    = 4
vim.opt.fillchars    = { eob = " " }

vim.opt.termguicolors = true
vim.cmd("syntax on")

require('src.status')
require('src.remaps')
require('src.autocmd')
vim.keymap.set("n", "<Leader>e", function()
    require('src.files'):open(37)
end, { noremap = true })

