local cfg_Navigation_barManager = {}

function cfg_Navigation_barManager:GetName()
  return "cfg_Navigation_barManager"
end

function cfg_Navigation_barManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Navigation_bar")
  end
  return self.dic
end

setmetatable(cfg_Navigation_barManager, TableManagerBase)

function cfg_Navigation_barManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Navigation_barManager
