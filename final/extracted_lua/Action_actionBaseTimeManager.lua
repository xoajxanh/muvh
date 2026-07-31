local Action_actionBaseTimeManager = {}

function Action_actionBaseTimeManager:GetName()
  return "Action_actionBaseTimeManager"
end

function Action_actionBaseTimeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Action_actionBaseTime")
  end
  return self.dic
end

setmetatable(Action_actionBaseTimeManager, TableManagerBase)

function Action_actionBaseTimeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Action_actionBaseTimeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Action_actionBaseTimeManager
