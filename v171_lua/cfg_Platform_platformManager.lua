local cfg_Platform_platformManager = {}

function cfg_Platform_platformManager:GetName()
  return "cfg_Platform_platformManager"
end

function cfg_Platform_platformManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Platform_platform")
  end
  return self.dic
end

setmetatable(cfg_Platform_platformManager, TableManagerBase)

function cfg_Platform_platformManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Platform_platformManager
