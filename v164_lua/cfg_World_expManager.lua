local cfg_World_expManager = {}

function cfg_World_expManager:GetName()
  return "cfg_World_expManager"
end

function cfg_World_expManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_World_exp")
  end
  return self.dic
end

setmetatable(cfg_World_expManager, TableManagerBase)

function cfg_World_expManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_World_expManager
