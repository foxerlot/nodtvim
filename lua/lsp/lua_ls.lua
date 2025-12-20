vim.lsp.config("lua_ls", {
    cmd = { "opt/lua-language-server/bin/lua-language-server" },
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then return end
        end

        client.config.settings.lua = vim.tbl_deep_extend("force", client.config.settings.lua, {
            runtime = {
                version = "LuaJIT",
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    library = vim.api.nvim_get_runtime_file("", true),
                }
            }
        })
    end,
    settings = {
        lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
            telemetry = { enable = false },
        }
    }
})
