local cfg_Map_trapManager = {}

function cfg_Map_trapManager:GetName()
  return "cfg_Map_trapManager"
end

function cfg_Map_trapManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_trap")
  end
  return self.dic
end

setmetatable(cfg_Map_trapManager, TableManagerBase)

function cfg_Map_trapManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Map_trapManager
