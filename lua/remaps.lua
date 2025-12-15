local map = vim.keymap.set

-- bracket autocomplete
map("i", "(", "()<Left>", { noremap = true, silent = true }) -- parenthesis
map("i", "{", "{}<Left>", { noremap = true, silent = true }) -- brace   / curly bracket
map("i", "[", "[]<Left>", { noremap = true, silent = true }) -- bracket / square bracket
map("i", ")", function()
    if vim.api.nvim_get_current_line():sub(vim.fn.col('.'), vim.fn.col('.')) == ')' then
        return "<Right>"
    else
        return ")"
    end
end, { noremap = true, expr = true, silent = true })
map("i", "}", function()
    if vim.api.nvim_get_current_line():sub(vim.fn.col('.'), vim.fn.col('.')) == '}' then
        return "<Right>" else
        return "}"
    end
end, { noremap = true, expr = true, silent = true })
map("i", "]", function()
    if vim.api.nvim_get_current_line():sub(vim.fn.col('.'), vim.fn.col('.')) == ']' then
        return "<Right>"
    else
        return "]"
    end
end, { noremap = true, expr = true, silent = true })

map("i", "<CR>", function()
    local char_under_cursor = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.'))
    if char_under_cursor == "}" then
        vim.api.nvim_feedkeys("\n\n\27ki\t", "n", false)
        return ""
    else
        return "\n"
    end
end, { noremap = true, expr = true })

-- navigate tabs
map("n", "<C-left>", ":tabprevious<CR>",    { noremap = true, silent = true })
map("n", "<C-right>", ":tabnext<CR>",       { noremap = true, silent = true })
-- create and close tabs
map("n", "<C-up>", ":tabedit<CR>",          { noremap = true, silent = true })
map("n", "<C-down>", ":tabclose<CR>",       { noremap = true, silent = true })
-- move tabs around
map("n", "<S-left>", ":tabmove-1<CR>",      { noremap = true, silent = true })
map("n", "<S-right>", ":tabmove+1<CR>",     { noremap = true, silent = true })

map("n", "<Leader>w", "<C-w>",              { noremap = true })
-- move lines around
map("n", "<C-j>", ":m+1<CR>",               { noremap = true, silent = true })
map("n", "<C-k>", ":m-2<CR>",               { noremap = true, silent = true })
-- change vertical window size
map("n", "<C-h>", ":vertical resize-2<CR>", { noremap = true, silent = true })
map("n", "<C-l>", ":vertical resize+2<CR>", { noremap = true, silent = true })
-- auto comment in lua
map("n", "<C-->", "0i--<ESC>",              { noremap = true })
-- adjust indentation of a line using < or >
map("n", "<", "<<",                         { noremap = true })
map("n", ">", ">>",                         { noremap = true })
-- if the line is empty then remap i to S
map("n", "i", function()
    local currentLine = vim.fn.getline('.')
    if currentLine == "" then
        return "S"
    else
        return "i"
    end
end, { noremap = true, expr = true })

-- <leader>h in visual mode to search for help of the highlighted area and <leader>/ to search the file
map("v", "<Leader>h", "y:<C-u>help <C-r>0<CR>", { noremap = true })
map("v", "<Leader>/", "y/<C-r>0<CR>",           { noremap = true })
