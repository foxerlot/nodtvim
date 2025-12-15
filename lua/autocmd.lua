vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argv(0) == "" then
            require('files').open()
            vim.api.nvim_buf_delete(1, { force = true })
        end
    end
})
