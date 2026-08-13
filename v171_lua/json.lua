local math = require("math")
local string = require("string")
local table = require("table")
local rapidjson = require("rapidjson")
local base = _G
json = {}
local decode_scanArray, decode_scanComment, decode_scanConstant, decode_scanNumber, decode_scanObject, decode_scanString, decode_scanWhitespace, encodeString, isArray, isEncodable

function json.encode(s)
  return rapidjson.encode(s)
end

function json.decode(s)
  return rapidjson.decode(s)
end

function json.null()
  return null
end

function decode_scanArray(s, startPos)
  local array = {}
  local stringLen = string.len(s)
  base.assert(string.sub(s, startPos, startPos) == "[", "decode_scanArray called but array does not start at position " .. startPos .. " in string:\n" .. s)
  startPos = startPos + 1
  repeat
    startPos = decode_scanWhitespace(s, startPos)
    base.assert(stringLen >= startPos, "JSON String ended unexpectedly scanning array.")
    local curChar = string.sub(s, startPos, startPos)
    if curChar == "]" then
      return array, startPos + 1
    end
    if curChar == "," then
      startPos = decode_scanWhitespace(s, startPos + 1)
    end
    base.assert(stringLen >= startPos, "JSON String ended unexpectedly scanning array.")
    object, startPos = json.decode(s, startPos)
    table.insert(array, object)
  until false
end

function decode_scanComment(s, startPos)
  base.assert(string.sub(s, startPos, startPos + 1) == "/*", "decode_scanComment called but comment does not start at position " .. startPos)
  local endPos = string.find(s, "*/", startPos + 2)
  base.assert(endPos ~= nil, "Unterminated comment in string at " .. startPos)
  return endPos + 2
end

function decode_scanConstant(s, startPos)
  local consts = {
    ["true"] = true,
    ["false"] = false,
    null = nil
  }
  local constNames = {
    "true",
    "false",
    "null"
  }
  for i, k in base.pairs(constNames) do
    if string.sub(s, startPos, startPos + string.len(k) - 1) == k then
      return consts[k], startPos + string.len(k)
    end
  end
  base.assert(nil, "Failed to scan constant from string " .. s .. " at starting position " .. startPos)
end

function decode_scanNumber(s, startPos)
  local endPos = startPos + 1
  local stringLen = string.len(s)
  local acceptableChars = "+-0123456789.e"
  while string.find(acceptableChars, string.sub(s, endPos, endPos), 1, true) and endPos <= stringLen do
    endPos = endPos + 1
  end
  local stringValue = string.sub(s, startPos, endPos - 1)
  base.assert(stringValue, "Failed to scan number [ " .. stringValue .. "] in JSON string at position " .. startPos .. " : " .. endPos)
  return tonumber(stringValue), endPos
end

function decode_scanObject(s, startPos)
  local object = {}
  local stringLen = string.len(s)
  local key, value
  base.assert(string.sub(s, startPos, startPos) == "{", "decode_scanObject called but object does not start at position " .. startPos .. " in string:\n" .. s)
  startPos = startPos + 1
  repeat
    startPos = decode_scanWhitespace(s, startPos)
    base.assert(stringLen >= startPos, "JSON string ended unexpectedly while scanning object.")
    local curChar = string.sub(s, startPos, startPos)
    if curChar == "}" then
      return object, startPos + 1
    end
    if curChar == "," then
      startPos = decode_scanWhitespace(s, startPos + 1)
    end
    base.assert(stringLen >= startPos, "JSON string ended unexpectedly scanning object.")
    key, startPos = json.decode(s, startPos)
    base.assert(stringLen >= startPos, "JSON string ended unexpectedly searching for value of key " .. key)
    startPos = decode_scanWhitespace(s, startPos)
    base.assert(stringLen >= startPos, "JSON string ended unexpectedly searching for value of key " .. key)
    base.assert(string.sub(s, startPos, startPos) == ":", "JSON object key-value assignment mal-formed at " .. startPos)
    startPos = decode_scanWhitespace(s, startPos + 1)
    base.assert(stringLen >= startPos, "JSON string ended unexpectedly searching for value of key " .. key)
    value, startPos = json.decode(s, startPos)
    object[key] = value
  until false
end

local escapeSequences = {
  ["\\t"] = "\t",
  ["\\f"] = "\f",
  ["\\r"] = "\r",
  ["\\n"] = "\n",
  ["\\b"] = "\b"
}
base.setmetatable(escapeSequences, {
  __index = function(t, k)
    return string.sub(k, 2)
  end
})

function decode_scanString(s, startPos)
  base.assert(startPos, "decode_scanString(..) called without start position")
  local startChar = string.sub(s, startPos, startPos)
  base.assert(startChar == "\"" or startChar == "'", "decode_scanString called for a non-string")
  local t = {}
  local i, j = startPos, startPos
  while string.find(s, startChar, j + 1) ~= j + 1 do
    local oldj = j
    i, j = string.find(s, "\\.", j + 1)
    local x, y = string.find(s, startChar, oldj + 1)
    if not i or i > x then
      i, j = x, y - 1
      if not x then
        base.print(s, startPos, string.sub(s, startPos, oldj))
      end
    end
    table.insert(t, string.sub(s, oldj + 1, i - 1))
    if string.sub(s, i, j) == "\\u" then
      local a = string.sub(s, j + 1, j + 4)
      j = j + 4
      local n = base.tonumber(a, 16)
      base.assert(n, "String decoding failed: bad Unicode escape " .. a .. " at position " .. i .. " : " .. j)
      local x
      if n < 128 then
        x = string.char(n % 128)
      elseif n < 2048 then
        x = string.char(192 + math.floor(n / 64) % 32, 128 + n % 64)
      else
        x = string.char(224 + math.floor(n / 4096) % 16, 128 + math.floor(n / 64) % 64, 128 + n % 64)
      end
      table.insert(t, x)
    else
      table.insert(t, escapeSequences[string.sub(s, i, j)])
    end
  end
  table.insert(t, string.sub(j, j + 1))
  base.assert(string.find(s, startChar, j + 1), "String decoding failed: missing closing " .. startChar .. " at position " .. j .. "(for string at position " .. startPos .. ")")
  return table.concat(t, ""), j + 2
end

function decode_scanWhitespace(s, startPos)
  local whitespace = " \n\r\t"
  local stringLen = string.len(s)
  while string.find(whitespace, string.sub(s, startPos, startPos), 1, true) and startPos <= stringLen do
    startPos = startPos + 1
  end
  return startPos
end

local escapeList = {
  ["\""] = "\\\"",
  ["\\"] = "\\\\",
  ["/"] = "\\/",
  ["\b"] = "\\b",
  ["\f"] = "\\f",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t"
}

function encodeString(s)
  s = tostring(s)
  return s:gsub(".", function(c)
    return escapeList[c]
  end)
end

function isArray(t)
  local maxIndex = 0
  for k, v in base.pairs(t) do
    if base.type(k) == "number" and math.floor(k) == k and 1 <= k then
      if not isEncodable(v) then
        return false
      end
      maxIndex = math.max(maxIndex, k)
    elseif k == "n" then
      if v ~= table.getn(t) then
        return false
      end
    elseif isEncodable(v) then
      return false
    end
  end
  return true, maxIndex
end

function isEncodable(o)
  local t = base.type(o)
  return t == "string" or t == "boolean" or t == "number" or t == "nil" or t == "table" or t == "function" and o == null
end
