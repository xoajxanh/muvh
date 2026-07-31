local cfg_Guide_stepManager = {}

function cfg_Guide_stepManager:GetName()
  return "cfg_Guide_stepManager"
end

function cfg_Guide_stepManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Guide_step")
  end
  return self.dic
end

setmetatable(cfg_Guide_stepManager, TableManagerBase)

function cfg_Guide_stepManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Guide_stepManager
