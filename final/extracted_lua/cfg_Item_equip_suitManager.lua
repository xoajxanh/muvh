local cfg_Item_equip_suitManager = {}

function cfg_Item_equip_suitManager:GetName()
  return "cfg_Item_equip_suitManager"
end

function cfg_Item_equip_suitManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_suit")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_suitManager, TableManagerBase)

function cfg_Item_equip_suitManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_suitManager:TryGetValueFromIdAndLevel(suitId, level)
  local dic = self:BaseGetTabListByType(suitId, "suitId")
  for i, v in pairs(dic) do
    if v.level == level then
      return v
    end
  end
  return nil
end

return cfg_Item_equip_suitManager
