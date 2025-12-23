local util = require("lspconfig.util")

local function switch_source_header(bufnr, client)
    local method = "textDocument/switchSourceHeader"
    if not client or not client:supports_method(method) then
        vim.notify("clangd does not support switchSourceHeader", vim.log.levels.ERROR)
        return
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method, params, function(err, result)
        if err then
            vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
            return
        end
        if not result then
            vim.notify("No corresponding file")
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info(bufnr, client)
    local method = "textDocument/symbolInfo"
    if not client or not client:supports_method(method) then
        vim.notify("clangd client not found", vim.log.levels.ERROR)
        return
    end
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request(method, params, function(_, res)
        if not res or #res == 0 then
            return
        end
        local lines = {
            "name: " .. res[1].name,
            "container: " .. res[1].containerName,
        }
        vim.lsp.util.open_floating_preview(lines, "markdown", {
            focusable = false,
            border = "single",
            title = "Symbol Info",
        })
    end, bufnr)
end

-- clangd setup

vim.lsp.config("c_ls", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_dir = util.root_pattern(
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git"
    ),
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { "utf-8", "utf-16" },
    },
    on_init = function(client, init_result)
        if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
            switch_source_header(bufnr, client)
        end, {})

        vim.api.nvim_buf_create_user_command(bufnr, "ClangdSymbolInfo", function()
            symbol_info(bufnr, client)
        end, {})
    end,
})
