local cfg_Commerce_niudantaskManager = {}

function cfg_Commerce_niudantaskManager:GetName()
  return "cfg_Commerce_niudantaskManager"
end

function cfg_Commerce_niudantaskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_niudantask")
  end
  return self.dic
end

setmetatable(cfg_Commerce_niudantaskManager, TableManagerBase)

function cfg_Commerce_niudantaskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_niudantaskManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_niudantaskManager
