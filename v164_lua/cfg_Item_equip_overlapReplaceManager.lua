local cfg_Item_equip_overlapReplaceManager = {}

function cfg_Item_equip_overlapReplaceManager:GetName()
  return "cfg_Item_equip_overlapReplaceManager"
end

function cfg_Item_equip_overlapReplaceManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_overlapReplace")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_overlapReplaceManager, TableManagerBase)

function cfg_Item_equip_overlapReplaceManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_overlapReplaceManager
