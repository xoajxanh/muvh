local cfg_equip_smeltManager = {}

function cfg_equip_smeltManager:GetName()
  return "cfg_equip_smeltManager"
end

function cfg_equip_smeltManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_equip_smelt")
  end
  return self.dic
end

setmetatable(cfg_equip_smeltManager, TableManagerBase)

function cfg_equip_smeltManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_equip_smeltManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_equip_smeltManager
