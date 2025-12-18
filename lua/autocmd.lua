-- splash-screen
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        if vim.fn.argv(0) == "" then
            require('splash').setScreen(nil)
        elseif vim.fn.argv(0) == "." then -- TODO: make this open a directory if argv == directory
            local bufnr = vim.api.nvim_get_current_buf()
            require('files').open(nil)
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end
})

-- autocomplete window automatically shows up       DON'T PUT A LOT OF CODE IN HERE!!!
vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function()
        if vim.bo.buftype == "" or vim.bo.omnifunc == "" then return end
        if vim.fn.pumvisible() == 0 then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), 'n')
        end
    end,
})

-- TODO: test this somehow
vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if vim.bo.buftype ~= "" then return end -- this for safety
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return end        -- this for safety

        for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider then
                vim.lsp.buf.format({
                    bufnr = 0,
                    async = true,
                    filter = function(c) return c.id == client.id end,
                })
                return
            end
        end
    end,
})
