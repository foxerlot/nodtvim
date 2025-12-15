local M = {}
local map = vim.keymap.set
local lines = vim.fn.readfile("~/.config/nvim/lua/splash.txt")
local oldfiles = vim.v.oldfiles
local home = vim.fn.expand("~")

function M:setScreen()
    local last5 = {}

    -- TODO: add language icons
    for i = 1, math.min(5, #oldfiles) do
        if string.sub(oldfiles[i], 1, #home) == home then
            local temp = string.sub(oldfiles[i], #home + 1, -1)
            table.insert(last5, "[" .. i .. "] " .. "~" .. temp)
        else
            table.insert(last5, "[" .. i .. "] " .. oldfiles[i])
        end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_lines(buf, 16, 21, false, last5)

    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
    vim.api.nvim_buf_delete(1, { force = true })
    vim.bo[buf].modifiable = false

    map("n", "q", ":q<CR>", { buffer = buf, noremap = true, silent = true })

    map("n", "n", ":edit ", { buffer = buf, noremap = true }) -- TODO: add a popup window that takes input and edits that file

    map("n", "f", "", { buffer = buf, noremap = true, silent = true }) -- TODO: add fuzzy finder for files

    map("n", "u", ":PlugUpdate<CR>", { buffer = buf, noremap = true, silent = true })

    map("n", "e", function()
        require('files').open()
    end, { buffer = buf, noremap = true })

    map("n", "1", function() M:addoldfiles(1) end, { buffer = buf, noremap = true })
    map("n", "2", function() M:addoldfiles(2) end, { buffer = buf, noremap = true })
    map("n", "3", function() M:addoldfiles(3) end, { buffer = buf, noremap = true })
    map("n", "4", function() M:addoldfiles(4) end, { buffer = buf, noremap = true })
    map("n", "5", function() M:addoldfiles(5) end, { buffer = buf, noremap = true })
end

function M:addoldfiles(n)
    vim.cmd("edit " .. oldfiles[n])
    vim.api.nvim_buf_delete(2, { force = true })
end

return M
