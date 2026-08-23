local cfg_Commerce_5Manager = {}

function cfg_Commerce_5Manager:GetName()
  return "cfg_Commerce_5Manager"
end

function cfg_Commerce_5Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_5")
  end
  return self.dic
end

setmetatable(cfg_Commerce_5Manager, TableManagerBase)

function cfg_Commerce_5Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_5Manager
