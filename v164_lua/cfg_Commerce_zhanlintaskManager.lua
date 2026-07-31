local cfg_Commerce_zhanlintaskManager = {}

function cfg_Commerce_zhanlintaskManager:GetName()
  return "cfg_Commerce_zhanlintaskManager"
end

function cfg_Commerce_zhanlintaskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_zhanlintask")
  end
  return self.dic
end

setmetatable(cfg_Commerce_zhanlintaskManager, TableManagerBase)

function cfg_Commerce_zhanlintaskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_zhanlintaskManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_zhanlintaskManager
