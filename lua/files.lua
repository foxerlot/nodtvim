local M = {}
local map = vim.keymap.set
local screenSize = nil

function M:open(size)
    screenSize = size
    if size ~= nil then
        vim.cmd(size .. "vsplit")
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.b[buf].isSpecial = true
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    M:set(buf)
    vim.cmd("set nonumber norelativenumber")
end

function M:set(buf, path)
    vim.bo[buf].modifiable = true

    path = path or vim.fn.getcwd()
    local home = vim.fn.expand("~")

    local newPath = ""
    if string.sub(path, 1, #home) == home then
        newPath = "~" .. string.sub(path, #home+1)
    else
        newPath = path
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, { newPath })

    vim.api.nvim_buf_set_lines(buf, 1, 1, false, M:getFiles(newPath))
    vim.api.nvim_win_set_cursor(0, {1, 0})

    -- TODO: add more remaps
    map("n", "q", function()
        if #vim.api.nvim_list_bufs() > 1 then
            vim.api.nvim_buf_delete(buf, {force = true})
        else
            vim.cmd("quit")
        end
    end, { buffer = buf, noremap = true, silent = true })

    map("n", "<CR>", function()
        M:openFile(buf, path)
    end, { buffer = buf, noremap = true, silent = true })

    map("n", "p", function()
        M:preview(path)
    end, { buffer = buf, noremap = true })

    vim.bo[buf].modifiable = false
end

function M:getFiles(path, sort)
    path = M:expand(path, vim.fn.fnamemodify(path, ":h"))
    sort = sort or 0
    local filesInPath = vim.split(vim.fn.system("ls -a " .. path), "\n", { trimempty = true }) -- use vim.fn.system instead of vim.system because vim.system is gay (idk how to use it)
    for i = #filesInPath, 1, -1 do
        if filesInPath[i] == "." or filesInPath[i] == ".." then
            table.remove(filesInPath, i)
        end
    end

    local dirs = {}
    local files = {}

    for _, name in ipairs(filesInPath) do
        local fullPath = path .. "/" .. name
        if vim.fn.isdirectory(fullPath) == 1 then
            table.insert(dirs, name)
        else
            table.insert(files, name)
        end
    end

    local function applySort(tbl)
        if sort == 0 then     -- alphabetical
            table.sort(tbl, function(a, b)
                return a:lower() < b:lower()
            end)
        elseif sort == 1 then -- reverse alphabetical
            table.sort(tbl, function(a, b)
                return a:lower() > b:lower()
            end)
        elseif sort == 2 then -- name length shortest to longest
            table.sort(tbl, function(a, b)
                return #a < #b
            end)
        elseif sort == 3 then -- name length longest to shortest
            table.sort(tbl, function(a, b)
                return #a > #b
            end)
        end
    end
    for i, v in ipairs(files) do
        files[i] = M:returnLangs(path .. "/" .. v) .. " " .. v
    end

    applySort(dirs)
    applySort(files)
    local combined = {}
    vim.list_extend(combined, dirs)
    vim.list_extend(combined, files)

    return combined
end

function M:openFile(buf, path)
    vim.bo[buf].modifiable = true

    local line = vim.api.nvim_get_current_line()
    if not M:expand(line, path) then
        line = line:sub(5) -- remove icon
    end
    line = M:expand(line, path)

    if not vim.uv.fs_stat(line) then return end
    local type = vim.uv.fs_stat(line).type


    if type == "directory" then
        line = vim.api.nvim_win_get_cursor(0)[1] == 1 and vim.fs.dirname(line) or line
        M:set(buf, line)
    elseif type == "file" then
        local targetPath = line

        if string.sub(targetPath, 1, 1) == "~" then
            targetPath = vim.fn.expand(targetPath)
        end

        if #vim.api.nvim_list_bufs() > 1 then
            vim.cmd("quit")
        end
        if vim.api.nvim_buf_get_name(0) ~= "" and not vim.b[vim.api.nvim_get_current_buf()].isSpecial == true then
            vim.cmd("vsplit")
        end
        vim.cmd("edit " .. vim.fn.fnameescape(targetPath))
    end

    vim.bo[buf].modifiable = false
end

function M:preview(path)
    local name    = vim.api.nvim_get_current_line():sub(5)
    local lines   = vim.fn.readfile(path .. "/" .. name)
    local height  = 30
    local width   = 50

    local winOptions = {
        relative  = "editor",
        height    = height,
        width     = width,
        row       = vim.api.nvim_win_get_cursor(0)[1]-1,
        col       = screenSize + 1,
        style     = "",
        border    = "rounded",
        focusable = true,
        title     = name .. " : " .. #lines .. " lines",
        title_pos = "center",
    }

    name = M:expand(name, path)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local win = vim.api.nvim_open_win(buf, true, winOptions)

    if #lines > 15 then
        vim.api.nvim_win_set_cursor(0, {15, 0})
    end

    vim.bo[buf].modifiable = false
    vim.wo[win].scrolloff  = 100

    map("n", "q", ":q!<CR>", { buffer = buf, noremap = true, silent = true })
end


function M:expand(line, path)
    if string.sub(line, 1, 1) == "~" then
        return vim.fn.expand(line)
    end

    if vim.uv.fs_stat(line) ~= nil then
        return line
    end

    local fullPath = path .. "/" .. line
    fullPath = fullPath:gsub("//+", "/")

    if vim.uv.fs_stat(fullPath) ~= nil then
        return fullPath
    end

    return nil
end

function M:returnLangs(path)
    local ext = path:match("^.+(%..+)$")
    if not ext then return "" end

    ext = ext:sub(2):lower()
    local langs = {
        c   = "",
        h   = "",
        cpp = "",
        cc  = "",
        cxx = "",
        hpp = "",
        cs  = "",
        clj = "",
        coffee = "",
        dart = "",
        ex   = "",
        exs  = "",
        erl  = "",
        go   = "",
        hs   = "",
        java = "",
        js   = "",
        jsx  = "",
        kt   = "",
        lua  = "",
        m    = "",
        php  = "",
        pl   = "",
        py   = "",
        rb   = "",
        rs   = "",
        scala = "",
        swift = "",
        ts   = "",
        tsx  = "",
        vue  = "",
        r    = "",
        sh   = "",
        bash = "",
        zsh  = "",
    }

    return langs[ext] or ""
end

return M
