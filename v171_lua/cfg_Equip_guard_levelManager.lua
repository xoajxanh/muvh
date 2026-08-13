local cfg_Equip_guard_levelManager = {}

function cfg_Equip_guard_levelManager:GetName()
  return "cfg_Equip_guard_levelManager"
end

function cfg_Equip_guard_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Equip_guard_level")
  end
  return self.dic
end

setmetatable(cfg_Equip_guard_levelManager, TableManagerBase)

function cfg_Equip_guard_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Equip_guard_levelManager
