local cfg_Item_equip_liuguangManager = {}

function cfg_Item_equip_liuguangManager:GetName()
  return "cfg_Item_equip_liuguangManager"
end

function cfg_Item_equip_liuguangManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_liuguang")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_liuguangManager, TableManagerBase)

function cfg_Item_equip_liuguangManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_liuguangManager
