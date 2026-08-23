local cfg_Equip_masterManager = {}

function cfg_Equip_masterManager:GetName()
  return "cfg_Equip_masterManager"
end

function cfg_Equip_masterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Equip_master")
  end
  return self.dic
end

setmetatable(cfg_Equip_masterManager, TableManagerBase)

function cfg_Equip_masterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Equip_masterManager
