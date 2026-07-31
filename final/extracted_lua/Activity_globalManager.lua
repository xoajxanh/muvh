local Activity_globalManager = {}

function Activity_globalManager:GetName()
  return "Activity_globalManager"
end

function Activity_globalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_global")
  end
  return self.dic
end

setmetatable(Activity_globalManager, TableManagerBase)

function Activity_globalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_globalManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_globalManager
