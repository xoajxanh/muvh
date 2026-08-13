Dictionary = {}
Dictionary.__index = Dictionary

function Dictionary:New(tk, tv)
  local o = {
    keyType = tk,
    valueType = tv,
    keyList = {}
  }
  setmetatable(o, self)
  return o
end

function Dictionary:Add(key, value)
  if key == nil then
    return
  end
  if self[key] == nil then
    self[key] = value
    table.insert(self.keyList, key)
  else
    self[key] = value
  end
end

function Dictionary:Clear()
  local count = self:Count()
  for i = count, 1, -1 do
    self[self.keyList[i]] = nil
    table.remove(self.keyList)
  end
end

function Dictionary:ContainsKey(key)
  if self[key] == nil then
    return false
  else
    return true
  end
end

function Dictionary:ContainsValue(value)
  local count = self:Count()
  for i = 1, count do
    if self[self.keyList[i]] == value then
      return true
    end
  end
  return false
end

function Dictionary:Count()
  local count = 0
  for k, v in pairs(self.keyList) do
    count = count + 1
  end
  return count
end

function Dictionary:Remove(key)
  if self:ContainsKey(key) then
    local count = self:Count()
    for i = 1, count do
      if self.keyList[i] == key then
        table.remove(self.keyList, i)
        break
      end
    end
    self[key] = nil
  end
end

function Dictionary:KeyToArrayList()
  local n = self:Count()
  local li = List:New(self:KeyType())
  for i = 1, n do
    li:Add(self.keyList[i])
  end
  return li
end

function Dictionary:ValueToArrayList()
  local n = self:Count()
  local li = List:New(self:ValueType())
  for i = 1, n do
    li:Add(self[self.keyList[i]])
  end
  return li
end

function Dictionary:KeyType()
  return self.keyType
end

function Dictionary:ValueType()
  return self.valueType
end

return Dictionary
