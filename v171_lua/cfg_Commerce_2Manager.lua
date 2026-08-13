local cfg_Commerce_2Manager = {}

function cfg_Commerce_2Manager:GetName()
  return "cfg_Commerce_2Manager"
end

function cfg_Commerce_2Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_2")
  end
  return self.dic
end

setmetatable(cfg_Commerce_2Manager, TableManagerBase)

function cfg_Commerce_2Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_2Manager
