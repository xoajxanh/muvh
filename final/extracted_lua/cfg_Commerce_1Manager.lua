local cfg_Commerce_1Manager = {}

function cfg_Commerce_1Manager:GetName()
  return "cfg_Commerce_1Manager"
end

function cfg_Commerce_1Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_1")
  end
  return self.dic
end

setmetatable(cfg_Commerce_1Manager, TableManagerBase)

function cfg_Commerce_1Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_1Manager
