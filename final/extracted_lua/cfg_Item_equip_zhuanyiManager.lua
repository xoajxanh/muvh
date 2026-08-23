local cfg_Item_equip_zhuanyiManager = {}

function cfg_Item_equip_zhuanyiManager:GetName()
  return "cfg_Item_equip_zhuanyiManager"
end

function cfg_Item_equip_zhuanyiManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_zhuanyi")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_zhuanyiManager, TableManagerBase)

function cfg_Item_equip_zhuanyiManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_zhuanyiManager
