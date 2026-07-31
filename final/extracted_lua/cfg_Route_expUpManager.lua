local cfg_Route_expUpManager = {}

function cfg_Route_expUpManager:GetName()
  return "cfg_Route_expUpManager"
end

function cfg_Route_expUpManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Route_expUp")
  end
  return self.dic
end

setmetatable(cfg_Route_expUpManager, TableManagerBase)

function cfg_Route_expUpManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Route_expUpManager
