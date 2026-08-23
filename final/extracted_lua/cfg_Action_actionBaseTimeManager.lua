local cfg_Action_actionBaseTimeManager = {}

function cfg_Action_actionBaseTimeManager:GetName()
  return "cfg_Action_actionBaseTimeManager"
end

function cfg_Action_actionBaseTimeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Action_actionBaseTime")
  end
  return self.dic
end

setmetatable(cfg_Action_actionBaseTimeManager, TableManagerBase)

function cfg_Action_actionBaseTimeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Action_actionBaseTimeManager
