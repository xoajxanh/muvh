local Activity_livelyManager = {}

function Activity_livelyManager:GetName()
  return "Activity_livelyManager"
end

function Activity_livelyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_lively")
  end
  return self.dic
end

setmetatable(Activity_livelyManager, TableManagerBase)

function Activity_livelyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_livelyManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_livelyManager
