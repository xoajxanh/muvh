local cfg_Commerce_7Manager = {}

function cfg_Commerce_7Manager:GetName()
  return "cfg_Commerce_7Manager"
end

function cfg_Commerce_7Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_7")
  end
  return self.dic
end

setmetatable(cfg_Commerce_7Manager, TableManagerBase)

function cfg_Commerce_7Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_7Manager
