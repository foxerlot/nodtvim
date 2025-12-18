local map = vim.keymap.set

map('i', "{", "{}<Left>", { noremap = true, silent = true }) -- brace   / curly bracket
map('i', "}", function()
    if vim.api.nvim_get_current_line():sub(vim.fn.col('.'), vim.fn.col('.')) == '}' then
        return "<Right>"
    else
        return "}"
    end
end, { noremap = true, expr = true, silent = true })
map('i', "<CR>", function()
    local char_under_cursor = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.'))
    if char_under_cursor == "}" then
        return "\n\n\27kS"
    else
        return "\n"
    end
end, { noremap = true, expr = true })
map('i', "<C-Space>", "<C-x><C-o>", { noremap = true })
map('i', "<C-h>", "<Left>", { noremap = true })
map('i', "<C-j>", "<C-n>", { noremap = true })
map('i', "<C-k>", "<C-p>", { noremap = true })
map('i', "<C-l>", "<Right>", { noremap = true })


map('n', "<C-left>", ":tabprevious<CR>", { noremap = true, silent = true })
map('n', "<C-right>", ":tabnext<CR>", { noremap = true, silent = true })
map('n', "<C-up>", ":tabedit<CR>", { noremap = true, silent = true })
map('n', "<C-down>", ":tabclose<CR>", { noremap = true, silent = true })
map('n', "<S-left>", ":tabmove-1<CR>", { noremap = true, silent = true })
map('n', "<S-right>", ":tabmove+1<CR>", { noremap = true, silent = true })

-- leader remaps
-- adhikmnopqrtuvxyz
-- map('n', "<Leader>b", "", {}) -- TODO: buffer remaps
-- map('n', "<Leader>c", "", {}) -- TODO: compile feature
-- map('n', "<Leader>g", "", {}) -- TODO: git remaps
map('n', "<Leader>j", function() vim.diagnostic.jump({ count = 1 }) end, { noremap = true })
map('n', "<Leader>l", ":lua vim.diagnostic.setqflist()<CR>", { noremap = true, silent = true })
-- map('n', "<Leader>r", "", {}) -- TODO: find and replace
-- map('n', "<Leader>s", "", {}) -- TODO: go back to splash page
map('n', "<Leader>w", "<C-w>", { noremap = true })

map('n', "<C-h>", ":vertical resize-2<CR>", { noremap = true, silent = true })
map('n', "<C-j>", ":m+1<CR>", { noremap = true, silent = true })
map('n', "<C-k>", ":m-2<CR>", { noremap = true, silent = true })
map('n', "<C-l>", ":vertical resize+2<CR>", { noremap = true, silent = true })
map('n', "<C-->", "0i--<ESC>", { noremap = true })
map('n', "<C-/>", "I//<ESC>", { noremap = true })
map('n', "<", "<<", { noremap = true })
map('n', ">", ">>", { noremap = true })
map('n', 'i', function()
    local currentLine = vim.fn.getline('.')
    if currentLine == "" then
        return "S"
    else
        return 'i'
    end
end, { noremap = true, expr = true })

map('v', "<Leader>h", "y:<C-u>help <C-r>0<CR>", { noremap = true })
map('v', "<Leader>/", "y/<C-r>0<CR>", { noremap = true })
