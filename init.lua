-- disable netrw
vim.g.loaded_netrw   = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

vim.cmd("syntax on")
vim.o.termguicolors  = true
vim.o.number         = true
vim.o.relativenumber = true
vim.o.autoindent     = true
vim.o.smartindent    = true
vim.o.copyindent     = true
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
vim.o.errorbells     = false
vim.o.icon           = true
vim.o.iconstring     = "Neovim"
vim.o.mousehide      = true
vim.opt.completeopt  = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
    virtual_text     = true,
    signs            = true,
    underline        = true,
})

require("status")
require("remaps")
require("autocmd")
require("lsp.lua_ls")
vim.lsp.enable("lua_ls")

vim.keymap.set("n", "<Leader>e", function()
    require("files"):open(37)
end, { noremap = true })

vim.keymap.set('n', "<Leader>f", function()
    require("find").open()
end, { noremap = true })

-- plugin settings
vim.cmd([[
    call plug#begin()

    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    Plug 'neovim/nvim-lspconfig'

    call plug#end()
]])


-- colorscheme settings
vim.cmd [[ colorscheme catppuccin ]]
vim.api.nvim_set_hl(0, "LineNr",       { fg = "#c79978", bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c79978", bg = "NONE" })

