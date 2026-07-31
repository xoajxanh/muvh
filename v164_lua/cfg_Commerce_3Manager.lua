local cfg_Commerce_3Manager = {}

function cfg_Commerce_3Manager:GetName()
  return "cfg_Commerce_3Manager"
end

function cfg_Commerce_3Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_3")
  end
  return self.dic
end

setmetatable(cfg_Commerce_3Manager, TableManagerBase)

function cfg_Commerce_3Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_3Manager
