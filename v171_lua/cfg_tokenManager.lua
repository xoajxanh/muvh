local cfg_tokenManager = {}

function cfg_tokenManager:GetName()
  return "cfg_tokenManager"
end

function cfg_tokenManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_token")
  end
  return self.dic
end

setmetatable(cfg_tokenManager, TableManagerBase)

function cfg_tokenManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_tokenManager
