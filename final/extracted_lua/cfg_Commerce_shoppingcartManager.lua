local cfg_Commerce_shoppingcartManager = {}

function cfg_Commerce_shoppingcartManager:GetName()
  return "cfg_Commerce_shoppingcartManager"
end

function cfg_Commerce_shoppingcartManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_shoppingcart")
  end
  return self.dic
end

setmetatable(cfg_Commerce_shoppingcartManager, TableManagerBase)

function cfg_Commerce_shoppingcartManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_shoppingcartManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_shoppingcartManager
