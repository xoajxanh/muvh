local cfg_Item_equip_luckyManager = {}

function cfg_Item_equip_luckyManager:GetName()
  return "cfg_Item_equip_luckyManager"
end

function cfg_Item_equip_luckyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_lucky")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_luckyManager, TableManagerBase)

function cfg_Item_equip_luckyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_luckyManager
