local cfg_Equip_redcloth_levelManager = {}

function cfg_Equip_redcloth_levelManager:GetName()
  return "cfg_Equip_redcloth_levelManager"
end

function cfg_Equip_redcloth_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Equip_redcloth_level")
  end
  return self.dic
end

setmetatable(cfg_Equip_redcloth_levelManager, TableManagerBase)

function cfg_Equip_redcloth_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Equip_redcloth_levelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Equip_redcloth_levelManager
