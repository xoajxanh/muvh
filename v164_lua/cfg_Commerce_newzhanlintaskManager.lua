local cfg_Commerce_newzhanlintaskManager = {}

function cfg_Commerce_newzhanlintaskManager:GetName()
  return "cfg_Commerce_newzhanlintaskManager"
end

function cfg_Commerce_newzhanlintaskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_newzhanlintask")
  end
  return self.dic
end

setmetatable(cfg_Commerce_newzhanlintaskManager, TableManagerBase)

function cfg_Commerce_newzhanlintaskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_newzhanlintaskManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_newzhanlintaskManager
