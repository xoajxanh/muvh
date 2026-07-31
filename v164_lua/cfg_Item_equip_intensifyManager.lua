local cfg_Item_equip_intensifyManager = {}

function cfg_Item_equip_intensifyManager:GetName()
  return "cfg_Item_equip_intensifyManager"
end

function cfg_Item_equip_intensifyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_intensify")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_intensifyManager, TableManagerBase)

function cfg_Item_equip_intensifyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_intensifyManager
