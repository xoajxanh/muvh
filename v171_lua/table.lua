function table.contains(t, value)
  return table.getKey(t, value) ~= nil
end

function table.containsKey(t, key)
  if not t then
    return false
  end
  for i, v in pairs(t) do
    if i == key then
      return true
    end
  end
  return false
end

function table.count(t)
  if not t then
    return 0
  end
  local n = 0
  for _, _ in pairs(t) do
    n = n + 1
  end
  return n
end

function table.clone(t)
  local nt = {}
  for k, v in pairs(t) do
    nt[k] = v
  end
  return nt
end

function table.copy(t, copyFrom)
  t = t or {}
  for k, v in pairs(copyFrom) do
    t[k] = v
  end
  return t
end

function table.metatableCopy(t, copyFrom)
  t = t or {}
  for k, v in pairs(copyFrom) do
    t[k] = v
  end
  setmetatable(t, getmetatable(copyFrom))
  return t
end

function table.DeepCopy(t)
  local InTable = {}
  
  local function Func(t)
    if type(t) ~= "table" then
      return t
    end
    local NewTable = {}
    InTable[t] = NewTable
    for k, v in pairs(t) do
      NewTable[Func(k)] = Func(v)
    end
    return setmetatable(NewTable, getmetatable(t))
  end
  
  return Func(t)
end

function table.getKey(t, value)
  for k, v in pairs(t) do
    if v == value then
      return k
    end
  end
end

function table.isArray(t)
  for i = 1, table.count(t) do
    if not t[i] then
      return false
    end
  end
  return true
end

function table.isNullOrEmpty(t)
  return t == nil or next(t) == nil
end

function table.keys(t)
  local keys = {}
  for k, v in pairs(t) do
    table.insert(keys, k)
  end
  return keys
end

function table.merge(t1, t2)
  local t = t1 or {}
  for k, v in pairs(t2) do
    t[k] = v
  end
  return t
end

function table.combine(t1, t2)
  local t = t1 or {}
  for _, v in pairs(t2) do
    table.insert(t, v)
  end
  return t
end

local function tableToString(t, processed)
  if type(t) ~= "table" or processed and table.contains(processed, t) then
    return tostring(t)
  end
  if processed then
    table.insert(processed, t)
  end
  local str
  if table.isArray(t) then
    for _, v in ipairs(t) do
      local item = processed and table.toString(v, processed) or tostring(v)
      str = str and str .. ", " .. item or item
    end
  else
    for k, v in pairs(t) do
      local item = (processed and table.toString(k, processed) or tostring(k)) .. ":" .. (processed and table.toString(v, processed) or tostring(v))
      str = str and str .. ", " .. item or item
    end
  end
  return str and "{" .. str .. "}" or "{}"
end

function table.toString(t, recursive)
  return tableToString(t, recursive and {})
end

function table.values(t)
  local values = {}
  for k, v in pairs(t) do
    table.insert(values, v)
  end
  return values
end

function table.ReverseTable(reverseTab)
  local tmp = {}
  for i = 1, #reverseTab do
    local key = #reverseTab + 1 - i
    tmp[i] = reverseTab[key]
  end
  return tmp
end

function table.ToFormatTable(t, tabcount)
  return FormatTable(t, tabcount)
end

function FormatTable(t, tabcount)
  tabcount = tabcount or 0
  if 5 < tabcount then
    return "<table too deep>" .. tostring(t)
  end
  local str = ""
  if type(t) == "table" then
    for k, v in pairs(t) do
      local tab = string.rep("\t", tabcount)
      if type(v) == "table" then
        str = str .. tab .. string.format("[%s] = {", FormatValue(k)) .. "\n"
        str = str .. FormatTable(v, tabcount + 1) .. tab .. "}\n"
      else
        str = str .. tab .. string.format("[%s = %s", FormatValue(k), FormatValue(v)) .. "\n"
      end
    end
  else
    str = str .. tostring(t) .. "\n"
  end
  return str
end

function FormatValue(val)
  if type(val) == "string" then
    return string.format("%q", val)
  end
  return tostring(val)
end

function table.IsTruelyContainsKey(tbl, key)
  if tbl == nil or type(tbl) ~= "table" or key == nil then
    return false
  end
  return rawget(tbl, key) ~= nil
end

function table.ToNumber(tbl)
  if type(tbl) ~= "table" or next(tbl) == nil then
    return tbl
  end
  local newTbl = {}
  for k, v in pairs(tbl) do
    newTbl[k] = tonumber(v)
  end
  return newTbl
end

function table.Remove(tbl, item)
  if type(tbl) ~= "table" or next(tbl) == nil then
    return
  end
  local index = 0
  for k, v in pairs(tbl) do
    if v == item then
      index = k
    end
  end
  if 0 < index then
    table.remove(tbl, index)
  end
end

function table.pairsByKeys(t)
  local keysTab = {}
  for key, _ in pairs(t) do
    keysTab[table.count(keysTab) + 1] = key
  end
  table.sort(keysTab)
  local index = 0
  return function()
    index = index + 1
    return keysTab[index], t[keysTab[index]]
  end
end
