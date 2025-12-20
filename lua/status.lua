-------------------------------------------------------------
--      status.lua
--      contains configurations for tabline and statusline
--      maintainer: gregory palamas
-------------------------------------------------------------

function _G.statusLineMode()
    local m = vim.fn.mode()
    if m == 'n' then
        return "NORMAL"
    elseif m == 'v' then
        return "VISUAL"
    elseif m == 'V' then
        return "VISUAL LN"
    elseif m == '\22' then
        return "VISUAL BLK"
    elseif m == 's' then
        return "SELECT"
    elseif m == 'i' then
        return "INSERT"
    elseif m == 'R' then
        return "REPLACE"
    elseif m == 'c' then
        return "CMD-LN"
    elseif m == 'cv' then
        return "EX    "
    elseif m == 't' then
        return "TERMINAL"
    else
        return "OTHER "
    end
end

local langs = {
    c      = "",
    h      = "",
    cpp    = "",
    cc     = "",
    cxx    = "",
    hpp    = "",
    cs     = "",
    clj    = "",
    coffee = "",
    dart   = "",
    ex     = "",
    exs    = "",
    erl    = "",
    go     = "",
    hs     = "",
    java   = "",
    js     = "",
    jsx    = "",
    kt     = "",
    lua    = "",
    m      = "",
    php    = "",
    pl     = "",
    py     = "",
    rb     = "",
    rs     = "",
    scala  = "",
    swift  = "",
    ts     = "",
    tsx    = "",
    vue    = "",
    r      = "",
    sh     = "",
    bash   = "",
    zsh    = "",
}

function _G.languageIcon()
    local f = vim.bo.filetype
    return langs[f] or ""
end

local levels = vim.diagnostic.severity
function _G.diagnosticStatus()
    local bufnr = 0
    local errors = #vim.diagnostic.get(bufnr, { severity = levels.ERROR })
    local warns  = #vim.diagnostic.get(bufnr, { severity = levels.WARN })
    local parts = {}

    if errors > 0 then table.insert(parts, "✘ " .. errors) end
    if warns > 0 then table.insert(parts, "▲ " .. warns) end
    return table.concat(parts, " ")
end
function _G.gitBranch()
    local git_dir = vim.fn.finddir(".git", ".;")
    if git_dir == "" then return "" end

    local head = vim.fn.systemlist("git branch --show-current")[1]
    if not head or head == "" then return "" end
    return " " .. head
end

vim.api.nvim_set_hl(0, "modeGroup", { fg = "#000000", bg = "#ff8080", bold = true })
vim.api.nvim_set_hl(0, "tri1", { fg = "#ff8080", bg = "#8080ff" })
vim.api.nvim_set_hl(0, "fileGroup", { fg = "#000000", bg = "#8080ff", bold = true })
vim.api.nvim_set_hl(0, "tri2", { fg = "#8080ff", bg = "#80ffff" })
vim.api.nvim_set_hl(0, "midGroup", { fg = "#000000", bg = "#80ff80", bold = true })
vim.api.nvim_set_hl(0, "tri3", { fg = "#ffff80", bg = "#ffcc80" })
vim.api.nvim_set_hl(0, "rulerGroup", { fg = "#000000", bg = "#ffff80", bold = true })
vim.api.nvim_set_hl(0, "tri4", { fg = "#80ffff", bg = "#ffff80" })
vim.api.nvim_set_hl(0, "percentGroup", { fg = "#000000", bg = "#80ffff", bold = true })
vim.api.nvim_set_hl(0, "diagGroup",   { fg = "#000000", bg = "#ffcc80", bold = true })
vim.api.nvim_set_hl(0, "triDiag",     { fg = "#ffcc80", bg = "#80ff80" })
vim.api.nvim_set_hl(0, "gitGroup",    { fg = "#000000", bg = "#80ffff", bold = true })
vim.api.nvim_set_hl(0, "triGit",      { fg = "#80ffff", bg = "#80ff80" })


vim.o.laststatus = 2
vim.api.nvim_create_autocmd({ "BufEnter", "WinResized" }, {
    -- if window width <= 50 then make the statusline smaller
    pattern = "*",
    callback = function(args)
        -- args.buf is the buffer that triggered the autocmd
        -- args.win is the window (not always set for BufEnter, but we can use 0 = current)
        local width = vim.api.nvim_win_get_width(0)

        if width >= 50 then
            local wide_statusline =
                "%#modeGroup#%{v:lua.statusLineMode()}%*" .. -- mode
                "%#tri1#%*" ..
                "%#fileGroup# %{v:lua.languageIcon()} %f %m %*" .. -- filename
                "%#tri2#%*" ..
                "%#gitGroup# %{v:lua.gitBranch()} %*" .. -- git branch
                "%#triGit#%*" ..
                "%#midGroup# %h%r%w%=" .. -- filler
                "%#triDiag#%*" ..
                "%#diagGroup# %{v:lua.diagnosticStatus()} %*" .. -- diagnostics
                "%#tri3#%*" ..
                "%#rulerGroup# %l : %c %*" .. -- line number
                "%#tri4#%*" ..
                "%#percentGroup# %p%%/%L %*" -- file lines
            vim.api.nvim_buf_set_option(args.buf, 'statusline', wide_statusline)
        else
            vim.api.nvim_buf_set_option(args.buf, 'statusline', "%#fileGroup# %{v:lua.languageIcon()} %f %*%#tri2#%*%#midGroup# %m%h%r%w%=%*")
        end
    end
})

vim.api.nvim_set_hl(0, "tabMidGroup", { fg = "#000000", bg = "#2f2f3f" })
vim.api.nvim_set_hl(0, "inactiveGroup", { fg = "#c79978", bg = "#232332" })
vim.api.nvim_set_hl(0, "activeGroup", { fg = "#232332", bg = "#c79978" })

function _G.tabLineSettings()
    -- tabLineSettings() is called whenever Neovim redraws the tabline
    local t = ""
    local currentTab = vim.fn.tabpagenr()  -- (current) tab page number
    local tabCount = vim.fn.tabpagenr("$") -- (last) tab page number

    for i = 1, tabCount do
        local bufNumber = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)] -- number of buffer displayed in active window
        local bufName = vim.fn.bufname(bufNumber) -- name of buffer displayed in active window
        local icon = langs[vim.api.nvim_buf_get_option(bufNumber, "filetype")] or "" -- sets icon to language logo
        local modifiedFlag = vim.api.nvim_buf_get_option(bufNumber, "modified") and "  " or "   " -- sets modified flag
        bufName = bufName == "" and "[No Name]" or bufName -- if bufName is empty then make it = "[No Name]"

        if i == currentTab then
            t = t .. "%#activeGroup#"
        else
            t = t .. "%#inactiveGroup#"
        end
        t = t .. "│" .. icon .. " " .. bufName .. modifiedFlag
    end

    return t .. "%#tabMidGroup#"
end

vim.opt.tabline = "%!v:lua.tabLineSettings()"
