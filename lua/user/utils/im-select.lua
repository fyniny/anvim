local M = {}

-- local Windows = {}
local Mac = {}

local defaultIM = "com.apple.keylayout.ABC"

Mac.en = defaultIM

local getChangeIM = function()
  local mode = vim.fn.mode()
  if mode == "m" then
    -- normal
    return Mac.en
  elseif mode == "i" then
    -- insert
    return nil
  elseif mode == "v" then
    -- visual
    return Mac.en
  else
    -- not above
    return Mac.en
  end
end

M.macFocusGained = function()
  local lang = getChangeIM()
  if lang == nil then return end
  vim.cmd ":silent :!im-select com.apple.keylayout.ABC"
end

M.macInsertLeave = function() vim.cmd ":silent :!im-select com.apple.keylayout.ABC" end

return M
