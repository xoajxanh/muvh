local cfg_Item_fashionManager = {}

function cfg_Item_fashionManager:GetName()
  return "cfg_Item_fashionManager"
end

function cfg_Item_fashionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_fashion")
  end
  return self.dic
end

setmetatable(cfg_Item_fashionManager, TableManagerBase)

function cfg_Item_fashionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_fashionManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Item_fashionManager
