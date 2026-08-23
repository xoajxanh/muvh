local cfg_Activity_siegeManager = {}

function cfg_Activity_siegeManager:GetName()
  return "cfg_Activity_siegeManager"
end

function cfg_Activity_siegeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_siege")
  end
  return self.dic
end

setmetatable(cfg_Activity_siegeManager, TableManagerBase)

function cfg_Activity_siegeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_siegeManager
