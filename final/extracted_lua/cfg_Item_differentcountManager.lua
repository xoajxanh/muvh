local cfg_Item_differentcountManager = {}

function cfg_Item_differentcountManager:GetName()
  return "cfg_Item_differentcountManager"
end

function cfg_Item_differentcountManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_differentcount")
  end
  return self.dic
end

setmetatable(cfg_Item_differentcountManager, TableManagerBase)

function cfg_Item_differentcountManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_differentcountManager
