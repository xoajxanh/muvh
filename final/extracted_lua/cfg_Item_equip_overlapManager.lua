local cfg_Item_equip_overlapManager = {}

function cfg_Item_equip_overlapManager:GetName()
  return "cfg_Item_equip_overlapManager"
end

function cfg_Item_equip_overlapManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_overlap")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_overlapManager, TableManagerBase)

function cfg_Item_equip_overlapManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_overlapManager
