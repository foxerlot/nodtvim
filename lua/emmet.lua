local M = {}

local function parse_tag(token)
  local tag = token:match("^[a-zA-Z][%w-]*") or "div"
  local id = token:match("#([%w-_]+)")
  local classes = {}
  for cls in token:gmatch("%.([%w-_]+)") do
    table.insert(classes, cls)
  end

  local attrs = {}
  local attr_block = token:match("%[(.-)%]")
  if attr_block then
    for k, v in attr_block:gmatch("([%w-]+)=([^%s]+)") do
      table.insert(attrs, string.format('%s="%s"', k, v))
    end
  end

  local text = token:match("{(.-)}")

  return {
    tag = tag,
    id = id,
    classes = classes,
    attrs = attrs,
    text = text,
  }
end

local function build_open(tag)
  local parts = { "<" .. tag.tag }

  if tag.id then
    table.insert(parts, 'id="' .. tag.id .. '"')
  end

  if #tag.classes > 0 then
    table.insert(parts, 'class="' .. table.concat(tag.classes, " ") .. '"')
  end

  for _, a in ipairs(tag.attrs) do
    table.insert(parts, a)
  end

  return table.concat(parts, " ") .. ">"
end

local function expand(expr, indent)
  indent = indent or ""
  local out = {}

  local siblings = vim.split(expr, "+", { plain = true })

  for _, sib in ipairs(siblings) do
    local mult = tonumber(sib:match("%*(%d+)$")) or 1
    sib = sib:gsub("%*%d+$", "")

    local parent, child = sib:match("(.+)>+(.-)$")

    for _ = 1, mult do
      if parent then
        local p = parse_tag(parent)
        table.insert(out, indent .. build_open(p))
        table.insert(out,
          expand(child, indent .. "  ")
        )
        table.insert(out, indent .. "</" .. p.tag .. ">")
      else
        local t = parse_tag(sib)
        table.insert(out, indent .. build_open(t))
        if t.text then
          table.insert(out, indent .. "  " .. t.text)
        end
        table.insert(out, indent .. "</" .. t.tag .. ">")
      end
    end
  end

  return table.concat(out, "\n")
end

function M.expand_abbreviation()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local before = line:sub(1, col)
  local after = line:sub(col + 1)

  local abbr = before:match("([%w%.#>%+%*%[%]{}=-]+)$")
  if not abbr then return end

  local expanded = expand(abbr)

  local new_before = before:gsub(vim.pesc(abbr) .. "$", "")
  local lines = vim.split(expanded, "\n", { plain = true })

  -- merge first and last lines with surrounding text
  lines[1] = new_before .. lines[1]
  lines[#lines] = lines[#lines] .. after

  vim.api.nvim_buf_set_lines(
    0,
    row - 1,
    row,
    false,
    lines
  )
  vim.api.nvim_win_set_cursor(0, {
    row - 1 + #lines,
    #lines[#lines]
  })
end

return M

