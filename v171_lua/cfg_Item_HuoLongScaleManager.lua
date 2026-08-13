local cfg_Item_HuoLongScaleManager = {}

function cfg_Item_HuoLongScaleManager:GetName()
  return "cfg_Item_HuoLongScaleManager"
end

function cfg_Item_HuoLongScaleManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_HuoLongScale")
  end
  return self.dic
end

setmetatable(cfg_Item_HuoLongScaleManager, TableManagerBase)

function cfg_Item_HuoLongScaleManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_HuoLongScaleManager
