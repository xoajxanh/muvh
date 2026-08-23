local cfg_Commerce_pandorapoolManager = {}

function cfg_Commerce_pandorapoolManager:GetName()
  return "cfg_Commerce_pandorapoolManager"
end

function cfg_Commerce_pandorapoolManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_pandorapool")
  end
  return self.dic
end

setmetatable(cfg_Commerce_pandorapoolManager, TableManagerBase)

function cfg_Commerce_pandorapoolManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_pandorapoolManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_pandorapoolManager
