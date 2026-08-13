local cfg_Item_equip_breachManager = {}

function cfg_Item_equip_breachManager:GetName()
  return "cfg_Item_equip_breachManager"
end

function cfg_Item_equip_breachManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_breach")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_breachManager, TableManagerBase)

function cfg_Item_equip_breachManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_breachManager
