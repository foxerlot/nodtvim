local M = {}
local map = vim.keymap.set

function M:open()
    local searchHeight = 1
    local searchWidth = 50
    local resultHeight = 20
    local resultWidth = 50
    local searchOpt = {
        relative  = "editor",
        height    = searchHeight,
        width     = searchWidth,
        row       = math.floor((vim.api.nvim_win_get_height(0)-resultHeight-5)/2),
        col       = math.floor((vim.api.nvim_win_get_width(0) - searchWidth)/2),
        style     = "minimal",
        border    = "rounded",
        focusable = true,
        title     = "find text",
        title_pos = "center",
    }
    local resultOpt = {
        relative  = "editor",
        height    = resultHeight,
        width     = resultWidth,
        row       = math.floor((vim.api.nvim_win_get_height(0)-resultHeight)/2),
        col       = math.floor((vim.api.nvim_win_get_width(0) - resultWidth)/2),
        style     = "minimal",
        border    = "rounded",
        focusable = true,
        title     = "results",
        title_pos = "center",
    }

    local curBuf = vim.api.nvim_get_current_buf()
    local searchBuf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(searchBuf, 0, -1, false, { ">" })
    vim.bo[searchBuf].buftype = "nofile"
--    vim.bo[searchBuf].bufhidden = "wipe" -- TODO: when done with main search functionality see if you can get this working
    vim.bo[searchBuf].swapfile = false
    vim.bo[searchBuf].filetype = "search"
    vim.b[searchBuf].is_search_buf = true

    local resultBuf = vim.api.nvim_create_buf(false, true)
    vim.bo[resultBuf].buftype = "nofile"
    vim.bo[resultBuf].swapfile = false
    vim.bo[resultBuf].filetype = "result" -- is this needed?
    vim.bo[resultBuf].modifiable = false

    local resultWin = vim.api.nvim_open_win(resultBuf, true, resultOpt)
    local searchWin = vim.api.nvim_open_win(searchBuf, true, searchOpt)
    vim.fn.feedkeys('a', 'n')

    map({'i', 'n'}, "<C-c>", function()
        vim.api.nvim_win_close(resultWin, true)
        vim.api.nvim_win_close(searchWin, true)
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), 'n')
    end, { buffer = searchBuf, noremap = true, silent = true }) -- CTRL-C to exit

    map({'i', 'n'}, "<C-c>", function()
        vim.api.nvim_win_close(resultWin, true)
        vim.api.nvim_win_close(searchWin, true)
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), 'n')
    end, { buffer = resultBuf, noremap = true, silent = true }) -- CTRL-C to exit

    map("i", "<BS>", function()
        if vim.fn.col('.') <= 2 then return "" end
        return "<BS>"
    end, { buffer = searchBuf, expr = true })

    map({'i', 'n'}, "<CR>", function()
        vim.api.nvim_set_current_win(resultWin)
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), 'n')
    end, { buffer = searchBuf, noremap = true })

    map('n', "/", function()
        vim.api.nvim_set_current_win(searchWin)
        vim.fn.feedkeys('a', 'n')
    end, { buffer = resultBuf, noremap = true })

    map('n', "<CR>", function()
        local linenr = string.sub(vim.api.nvim_get_current_line(), 0, string.find(vim.api.nvim_get_current_line(), ':', 1, true))
        vim.api.nvim_win_close(resultWin, true)
        vim.api.nvim_win_close(searchWin, true)
        vim.fn.feedkeys(':' .. linenr .. "\n")
    end, { buffer = resultBuf, noremap = true, silent = true })

    vim.api.nvim_create_autocmd({"TextChangedI", "TextChanged"}, {
        buffer = searchBuf,
        callback = function(ev)
            if vim.b[ev.buf].is_search_buf then
                vim.bo[resultBuf].modifiable = true
                local query = string.sub(vim.api.nvim_get_current_line(), 2, -1)
                if query == "" then return end
                vim.api.nvim_buf_set_lines(resultBuf, 0, -1, false, M:search(query, curBuf))
                vim.bo[resultBuf].modifiable = false
            end
        end,
    })
end

function M:search(text, bufnr)
    local results = {}
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for n, i in ipairs(lines) do
        if string.find(i, text, 1, true) then
            table.insert(results, n .. ":" .. vim.fn.trim(i))
        end
    end

    return results
end

return M
