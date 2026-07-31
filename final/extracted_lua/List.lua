List = {}
List.__index = List

function List:New(t)
  local o = {
    itemType = t,
    list = {}
  }
  setmetatable(o, self)
  return o
end

function List:NewTable(tbl)
  local o = {
    itemType = "table",
    list = {}
  }
  setmetatable(o, self)
  if tbl ~= nil then
    for k, v in pairs(tbl) do
      if type(v) == "function" then
        o[k] = v
      else
        o:Add(v)
      end
    end
  end
  return o
end

function List:Add(item)
  table.insert(self.list, item)
end

function List:Clear()
  local count = self:Count()
  for i = count, 1, -1 do
    table.remove(self.list)
  end
end

function List:Contains(item)
  local count = self:Count()
  for i = 1, count do
    if self.list[i] == item then
      return true
    end
  end
  return false
end

function List:Count()
  local count = 0
  for k, v in pairs(self.list) do
    count = count + 1
  end
  return count
end

function List:Find(predicate)
  if predicate == nil or type(predicate) ~= "function" then
    if isLocalTest then
      print("predicate is invalid!")
    end
    return
  end
  local count = self:Count()
  for i = 1, count do
    if predicate(self.list[i]) then
      return self.list[i]
    end
  end
  return nil
end

function List:FindIndex(predicate)
  if predicate == nil or type(predicate) ~= "function" then
    if isLocalTest then
      print("predicate is invalid!")
    end
    return
  end
  local count = self:Count()
  for i = 1, count do
    if predicate(self.list[i]) then
      return i
    end
  end
  return 0
end

function List:ForEach(action)
  if action == nil or type(action) ~= "function" then
    print("action is invalid!")
    return
  end
  local count = self:Count()
  for i = 1, count do
    action(self.list[i])
  end
end

function List:GetItemByIndex(index)
  return self.list[index]
end

function List:IndexOf(item)
  local count = self:Count()
  for i = 1, count do
    if self.list[i] == item then
      return i
    end
  end
  return 0
end

function List:LastIndexOf(item)
  local count = self:Count()
  for i = count, 1, -1 do
    if self.list[i] == item then
      return i
    end
  end
  return 0
end

function List:Insert(index, item)
  table.insert(self.list, index, item)
end

function List:ItemType()
  return self.itemType
end

function List:Remove(item)
  local index = self:LastIndexOf(item)
  if 0 < index then
    table.remove(self.list, index)
    self:Remove(item)
  end
end

function List:RemoveAt(index)
  table.remove(self.list, index)
end

function List:Sort(comparison)
  if comparison ~= nil and type(comparison) ~= "function" then
    if isLocalTest then
      print("comparison is invalid")
    end
    return
  end
  if comparison == nil then
    table.sort(self.list)
  else
    table.sort(self.list, comparison)
  end
end

function List:Push(item)
  table.insert(self.list, 1, item)
end

function List:Pop()
  local count = self:Count()
  for i = count, 1, -1 do
    if self.list[i] ~= nil then
      local item = self.list[i]
      self:Remove(item)
      return item
    end
  end
  return nil
end

function List:PopUp()
  local count = self:Count()
  for i = 1, count do
    if self.list[i] ~= nil then
      local item = self.list[i]
      self:Remove(item)
      return item
    end
  end
  return nil
end

function List:Top()
  local count = self:Count()
  for i = 1, count do
    if self.list[i] ~= nil then
      local item = self.list[i]
      return item
    end
  end
  return nil
end

function List:FindTopFitItem(callback)
  local count = self:Count()
  for i = 1, count do
    if self.list[i] ~= nil and callback(self.list[i]) then
      local item = self.list[i]
      return item
    end
  end
  return nil
end

function List:AddRange(temList)
  if temList == nil or temList:Count() <= 0 then
    return
  end
  for i = 1, temList:Count() do
    self:Add(temList.list[i])
  end
end

function List:DebugValue(str, action, isCopy)
  if isLocalTest then
    str = str ~= nil and str or ""
    LuaCSStringBuilder.Clear()
    LuaCSStringBuilder.Append(str, "\n")
    for i = 1, self:Count() do
      LuaCSStringBuilder.Append(i, "  ", action == nil and self.list[i] or action(self.list[i]), "\n")
    end
    local luaStr = LuaCSStringBuilder.ToString()
    if isCopy then
      local te = CS.UnityEngine.TextEditor()
      te.text = luaStr
      te:OnFocus()
      te:Copy()
    end
    print(luaStr)
  end
end

return List
