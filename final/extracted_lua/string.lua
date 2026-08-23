function string.contains(str, subStr)
  return string.find(str, subStr) ~= nil
end

function string.endsWith(str, subStr)
  local len1 = #str
  local len2 = #subStr
  if len1 < len2 then
    return false
  end
  return string.find(str, subStr, len1 - len2 + 1) ~= nil
end

function string.isNullOrEmpty(str)
  return str == nil or str == ""
end

function string.replace(str, oldStr, newStr)
  local i, j = string.find(str, oldStr, 1, true)
  if i and j then
    local ret = {}
    local start = 1
    while i and j do
      table.insert(ret, string.sub(str, start, i - 1))
      table.insert(ret, newStr)
      start = j + 1
      i, j = string.find(str, oldStr, start, true)
    end
    table.insert(ret, string.sub(str, start))
    return table.concat(ret)
  end
  return str
end

function string.split(str, sep)
  sep = sep or " "
  local items = {}
  local pattern = string.format("([^%s]+)", sep)
  string.gsub(str, pattern, function(c)
    table.insert(items, c)
  end)
  return items
end

function string.startsWith(str, subStr)
  return string.find(str, subStr) == 1
end

local EMPTY_CHARS = " \t\n\r"

function string.trim(str, chars)
  chars = chars or EMPTY_CHARS
  return str:match(string.format("^[%s]*(.-)[%s]*$", chars, chars))
end

function string.trimLeft(str, chars)
  chars = chars or EMPTY_CHARS
  return str:match(string.format("^[%s]*(.*)", chars))
end

function string.trimRight(str, chars)
  chars = chars or EMPTY_CHARS
  return str:match(string.format("(.-)[%s]*$", chars))
end

function string.indexOf(str, char)
  local b = string.byte(char, 1)
  for i = 1, #str do
    if string.byte(str, i) == b then
      return i
    end
  end
  return nil
end

function string.lastIndexOf(str, char)
  local b = string.byte(char, 1)
  for i = #str, 1, -1 do
    if string.byte(str, i) == b then
      return i
    end
  end
  return nil
end

function string.GetWithoutColorText(msg)
  return string.gsub(string.gsub(msg, "<color=(#%x*)>", ""), "</color>", "")
end

function string.GetColorText(msg, color)
  return string.format("<color=%s>%s</color>", color, msg)
end

function string.GetSizeText(msg, size)
  return string.format("<size=%d>%s</size>", size, msg)
end

local hzUnit = {
  "",
  "Ch\225\187\165c",
  "Tr\196\131m",
  "Ng\195\160n",
  " v\225\186\161n",
  "Ch\225\187\165c",
  "Tr\196\131m",
  "Ng\195\160n",
  " tr\196\131m tri\225\187\135u",
  "Ch\225\187\165c",
  "Tr\196\131m",
  "Ng\195\160n",
  " v\225\186\161n",
  "Ch\225\187\165c",
  "Tr\196\131m",
  "Ng\195\160n"
}
local hzNum = {
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9"
}

local function removeZero(num, szNum)
  num = tostring(num)
  local szLen = string.len(num)
  local zero_num = 0
  for i = szLen, 1, -3 do
    szNum = string.sub(num, i - 2, i)
    if szNum == hzNum[1] then
      zero_num = zero_num + 1
    else
      break
    end
  end
  num = string.sub(num, 1, szLen - zero_num * 3)
  szNum = string.sub(num, 1, 6)
  if szNum == hzNum[2] .. hzUnit[2] then
    num = string.sub(num, 4, string.len(num))
  end
  return num
end

function string.NumberSwitchChinese(szNum)
  local szChMoney = ""
  local iLen = 0
  local iNum = 0
  local iAddZero = 0
  if nil == tonumber(szNum) then
    return tostring(szNum)
  end
  iLen = string.len(szNum)
  if 10 < iLen or iLen == 0 or 0 > tonumber(szNum) then
    return tostring(szNum)
  end
  for i = 1, iLen do
    iNum = string.sub(szNum, i, i)
    if iNum == 0 and i ~= iLen then
      iAddZero = iAddZero + 1
    else
      if 0 < iAddZero then
        szChMoney = szChMoney .. hzNum[1]
      end
      szChMoney = szChMoney .. hzNum[iNum + 1]
      iAddZero = 0
    end
    if iAddZero < 4 and (0 == (iLen - i) % 4 or 0 ~= tonumber(iNum)) then
      szChMoney = szChMoney .. hzUnit[iLen - i + 1]
    end
  end
  return removeZero(szChMoney, szNum)
end

local tempNumbers = {}
local NUMBER_0 = string.byte("0")
local NUMBER_9 = NUMBER_0 + 9
local MINUS_SIGN = string.byte("-")
local DOT = string.byte(".")

function string.splitToNumbers(str, index1, index2)
  local index = 1
  local count = #tempNumbers
  local current, dot, minusSign
  for i = index1 or 1, index2 or #str do
    local b = string.byte(str, i)
    if b == MINUS_SIGN and not current then
      minusSign = true
    elseif b == DOT then
      dot = 0.1
    elseif b >= NUMBER_0 and b <= NUMBER_9 then
      b = b - NUMBER_0
      if dot then
        current = current and current + b * dot or b * dot
        dot = dot * 0.1
      else
        current = current and current * 10 + b or b
      end
    else
      if current then
        tempNumbers[index] = minusSign and -current or current
        index = index + 1
        current = nil
      end
      dot = nil
      minusSign = nil
    end
  end
  if current then
    tempNumbers[index] = minusSign and -current or current
    index = index + 1
  end
  for i = index, count do
    tempNumbers[i] = nil
  end
  return tempNumbers
end

function string.filter_vietnamese_text(s, additional_chars)
  additional_chars = additional_chars or {}
  local vietnamese_patterns = {
    "[\194-\223][\128-\191]",
    "[\224-\239][\128-\191][\128-\191]",
    "[dD]\204\131"
  }
  local patterns = {
    "%a",
    "%d",
    "%s"
  }
  for _, pattern in ipairs(vietnamese_patterns) do
    table.insert(patterns, pattern)
  end
  for char in pairs(additional_chars) do
    table.insert(patterns, "%" .. char)
  end
  local result = {}
  local pos = 1
  local len = #s
  while pos <= len do
    local matched = false
    for _, pattern in ipairs(vietnamese_patterns) do
      local match = string.match(string.sub(s, pos), "^" .. pattern)
      if match then
        table.insert(result, match)
        pos = pos + #match
        matched = true
        break
      end
    end
    if not matched then
      local byte = string.byte(s, pos)
      if byte then
        if 65 <= byte and byte <= 90 or 97 <= byte and byte <= 122 then
          table.insert(result, string.char(byte))
        elseif 48 <= byte and byte <= 57 then
          table.insert(result, string.char(byte))
        elseif byte == 32 then
          table.insert(result, " ")
        elseif additional_chars[string.char(byte)] then
          table.insert(result, string.char(byte))
        end
      end
      pos = pos + 1
    end
  end
  return table.concat(result)
end

function string.vietnamese_length(s)
  local length = 0
  local pos = 1
  local len = #s
  while pos <= len do
    local byte = string.byte(s, pos)
    if not byte then
      break
    end
    if byte < 128 then
      length = length + 1
      pos = pos + 1
    else
      local char_len = 0
      if 194 <= byte and byte < 224 then
        char_len = 2
      elseif 224 <= byte and byte < 240 then
        char_len = 3
      elseif 240 <= byte and byte < 248 then
        char_len = 4
      else
        char_len = 1
      end
      if 2 <= char_len and len >= pos + char_len - 1 then
        length = length + 1
      else
        length = length + 1
      end
      pos = pos + char_len
    end
  end
  return length
end

function string.filter_spec_chars(s)
  local ss = {}
  local k = 1
  while not (k > #s) do
    local c = string.byte(s, k)
    if not c then
      break
    end
    if c < 192 then
      if 48 <= c and c <= 57 or 65 <= c and c <= 90 or 97 <= c and c <= 122 then
        table.insert(ss, string.char(c))
      end
      k = k + 1
    elseif c < 224 then
      k = k + 2
    elseif c < 240 then
      if 228 <= c and c <= 233 then
        local c1 = string.byte(s, k + 1)
        local c2 = string.byte(s, k + 2)
        if c1 and c2 then
          local a1, a2, a3, a4 = 128, 191, 128, 191
          if c == 228 then
            a1 = 184
          elseif c == 233 then
            a2, a4 = 190, c1 ~= 190 and 191 or 165
          end
          if c1 >= a1 and c1 <= a2 and c2 >= a3 and c2 <= a4 then
            table.insert(ss, string.char(c, c1, c2))
          end
        end
      elseif 233 < c then
        local c1 = string.byte(s, k + 1)
        local c2 = string.byte(s, k + 2)
        table.insert(ss, string.char(c, c1, c2))
      end
      k = k + 3
    elseif c < 248 then
      k = k + 4
    elseif c < 252 then
      k = k + 5
    elseif c < 254 then
      k = k + 6
    end
  end
  return table.concat(ss)
end

function string.GetKoreanStrCount(str)
  local count = 0
  local i = 1
  local len = #str
  while i <= len do
    local byte = str:byte(i)
    local char_len
    if 0 <= byte and byte <= 127 then
      char_len = 1
    elseif 192 <= byte and byte <= 223 then
      char_len = 2
    elseif 224 <= byte and byte <= 239 then
      char_len = 3
    elseif 240 <= byte and byte <= 247 then
      char_len = 4
    else
      error("Invalid UTF-8 byte sequence")
    end
    i = i + char_len
    count = count + 1
  end
  return count
end

function string.KoreanStrSub(str, start_pos, length)
  local start_index = 1
  local end_index = 1
  local current_pos = 1
  local char_count = 0
  while current_pos <= #str do
    local byte = str:byte(current_pos)
    local char_len
    if 0 <= byte and byte <= 127 then
      char_len = 1
    elseif 192 <= byte and byte <= 223 then
      char_len = 2
    elseif 224 <= byte and byte <= 239 then
      char_len = 3
    elseif 240 <= byte and byte <= 247 then
      char_len = 4
    else
      error("Invalid UTF-8 byte sequence")
    end
    if char_count == start_pos - 1 then
      start_index = current_pos
    end
    if char_count == start_pos + length - 1 then
      end_index = current_pos + char_len - 1
      break
    end
    current_pos = current_pos + char_len
    char_count = char_count + 1
  end
  return str:sub(start_index, end_index)
end
