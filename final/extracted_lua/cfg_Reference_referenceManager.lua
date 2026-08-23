local cfg_Reference_referenceManager = {}

function cfg_Reference_referenceManager:GetName()
  return "cfg_Reference_referenceManager"
end

function cfg_Reference_referenceManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Reference_reference")
  end
  return self.dic
end

setmetatable(cfg_Reference_referenceManager, TableManagerBase)

function cfg_Reference_referenceManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Reference_referenceManager
