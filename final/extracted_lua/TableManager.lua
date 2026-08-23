local TableManager = {}
TableManager.__index = TableManager
local tempTab = {}

function TableManager:BaseTryGetValue(id, key)
  if key ~= nil and key ~= "" then
    return self:BaseTryGetValue_specifyKey(key, id)
  end
  if self:GetDic()[id] ~= nil then
    if self:GetDic()[id] == nil and CS.Main.instance.IsShowLog then
      logError(self:GetName() .. "B\225\186\163ng ch\198\176a t\195\172m th\225\186\165y id d\225\187\175 li\225\187\135u n\195\160y: " .. tostring(id))
    end
    return self:GetDic()[id]
  else
    if CS.Main.instance.IsShowLog then
      logError(self:GetName() .. "B\225\186\163ng ch\198\176a t\195\172m th\225\186\165y id d\225\187\175 li\225\187\135u n\195\160y: " .. tostring(id))
    end
    return nil
  end
end

function TableManager:BaseGetTabListByType(type, typeKey)
  if typeKey == nil or typeKey == "" then
    typeKey = "id"
  end
  tempTab = {}
  for i, v in pairs(self:GetDic()) do
    if v ~= nil and v[typeKey] ~= nil and v[typeKey] == type then
      table.insert(tempTab, v)
    end
  end
  return tempTab
end

function TableManager:BaseTryGetValue_specifyKey(key, id)
  if key == nil or key == "" then
    return nil
  end
  if self.specifyKeyDic == nil then
    self.specifyKeyDic = {}
  end
  if self.specifyKeyDic[key] == nil then
    self.specifyKeyDic[key] = {}
    for i, v in pairs(self:GetDic()) do
      if v ~= nil and v[key] ~= nil then
        self.specifyKeyDic[key][v[key]] = v
      end
    end
  end
  if self.specifyKeyDic[key][id] ~= nil then
    return self.specifyKeyDic[key][id]
  else
    if CS.Main.instance.IsShowLog then
      logError(self:GetName() .. "B\225\186\163ng ch\198\176a t\195\172m th\225\186\165y id d\225\187\175 li\225\187\135u n\195\160y: " .. tostring(id) .. "  k:" .. tostring(key))
    end
    return nil
  end
end

function TableManager:GetTableCount()
  if self:GetDic() == nil then
    return 0
  end
  if self.TableCount == nil then
    local index = 0
    for i, v in pairs(self:GetDic()) do
      index = index + 1
    end
    self.TableCount = index
  end
  return self.TableCount
end

return TableManager
