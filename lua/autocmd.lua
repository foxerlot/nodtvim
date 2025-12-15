vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argv(0) == "" then
                require('splash').setScreen()
        end
    end
})
