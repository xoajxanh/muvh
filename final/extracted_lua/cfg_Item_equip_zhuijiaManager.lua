local cfg_Item_equip_zhuijiaManager = {}

function cfg_Item_equip_zhuijiaManager:GetName()
  return "cfg_Item_equip_zhuijiaManager"
end

function cfg_Item_equip_zhuijiaManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_zhuijia")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_zhuijiaManager, TableManagerBase)

function cfg_Item_equip_zhuijiaManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_zhuijiaManager
