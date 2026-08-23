local cfg_Commerce_niudanManager = {}

function cfg_Commerce_niudanManager:GetName()
  return "cfg_Commerce_niudanManager"
end

function cfg_Commerce_niudanManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_niudan")
  end
  return self.dic
end

setmetatable(cfg_Commerce_niudanManager, TableManagerBase)

function cfg_Commerce_niudanManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_niudanManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_niudanManager
