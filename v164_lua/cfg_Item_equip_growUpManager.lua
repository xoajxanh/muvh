local cfg_Item_equip_growUpManager = {}

function cfg_Item_equip_growUpManager:GetName()
  return "cfg_Item_equip_growUpManager"
end

function cfg_Item_equip_growUpManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_growUp")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_growUpManager, TableManagerBase)

function cfg_Item_equip_growUpManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_growUpManager
