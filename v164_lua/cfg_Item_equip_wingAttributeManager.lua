local cfg_Item_equip_wingAttributeManager = {}

function cfg_Item_equip_wingAttributeManager:GetName()
  return "cfg_Item_equip_wingAttributeManager"
end

function cfg_Item_equip_wingAttributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_wingAttribute")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_wingAttributeManager, TableManagerBase)

function cfg_Item_equip_wingAttributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_wingAttributeManager
