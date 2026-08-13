local cfg_Unit_unitManager = {}

function cfg_Unit_unitManager:GetName()
  return "cfg_Unit_unitManager"
end

function cfg_Unit_unitManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Unit_unit")
  end
  return self.dic
end

setmetatable(cfg_Unit_unitManager, TableManagerBase)

function cfg_Unit_unitManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Unit_unitManager
