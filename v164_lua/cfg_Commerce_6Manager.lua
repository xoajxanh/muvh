local cfg_Commerce_6Manager = {}

function cfg_Commerce_6Manager:GetName()
  return "cfg_Commerce_6Manager"
end

function cfg_Commerce_6Manager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_6")
  end
  return self.dic
end

setmetatable(cfg_Commerce_6Manager, TableManagerBase)

function cfg_Commerce_6Manager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Commerce_6Manager
