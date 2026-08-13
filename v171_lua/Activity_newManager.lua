local Activity_newManager = {}

function Activity_newManager:GetName()
  return "Activity_newManager"
end

function Activity_newManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_new")
  end
  return self.dic
end

setmetatable(Activity_newManager, TableManagerBase)

function Activity_newManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_newManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_newManager
