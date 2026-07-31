local cfg_Task_goalManager = {}

function cfg_Task_goalManager:GetName()
  return "cfg_Task_goalManager"
end

function cfg_Task_goalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Task_goal")
  end
  return self.dic
end

setmetatable(cfg_Task_goalManager, TableManagerBase)

function cfg_Task_goalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Task_goalManager
