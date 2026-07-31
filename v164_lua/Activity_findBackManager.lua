local Activity_findBackManager = {}

function Activity_findBackManager:GetName()
  return "Activity_findBackManager"
end

function Activity_findBackManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_findBack")
  end
  return self.dic
end

setmetatable(Activity_findBackManager, TableManagerBase)

function Activity_findBackManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_findBackManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_findBackManager
