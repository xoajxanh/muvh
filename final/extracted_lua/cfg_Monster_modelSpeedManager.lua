local cfg_Monster_modelSpeedManager = {}

function cfg_Monster_modelSpeedManager:GetName()
  return "cfg_Monster_modelSpeedManager"
end

function cfg_Monster_modelSpeedManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_modelSpeed")
  end
  return self.dic
end

setmetatable(cfg_Monster_modelSpeedManager, TableManagerBase)

function cfg_Monster_modelSpeedManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_modelSpeedManager
