local M = {}

local state = {
  win = nil,
  buf = nil,
}

local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

local function open_window(lines)
  close_window()

  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.min(#lines, 8)

  -- Position window just above cmdline
  local row = vim.o.lines - height - vim.o.cmdheight - 1

  state.win = vim.api.nvim_open_win(state.buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    focusable = false,
  })

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
end

local function search(pattern)
  if pattern == "" then
    close_window()
    return
  end

  if vim.fn.executable("rg") == 0 then
    open_window({ "ERROR: ripgrep (rg) not found" })
    return
  end

  local results = vim.fn.systemlist({
    "rg",
    "--vimgrep",
    "--max-count", "50",
    pattern,
  })

  if #results == 0 then
    open_window({ "No matches" })
    return
  end

  -- Trim and format
  local lines = {}
  for i = 1, math.min(#results, 20) do
    table.insert(lines, results[i])
  end

  open_window(lines)
end

function M.prompt_search()
  local ok, pattern = pcall(vim.fn.input, "Search: ")
  if not ok then
    close_window()
    return
  end

  search(pattern)

  -- Auto-close on next command
  vim.defer_fn(close_window, 3000)
end

return M

