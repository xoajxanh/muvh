local cfg_Commerce_worldcupManager = {}

function cfg_Commerce_worldcupManager:GetName()
  return "cfg_Commerce_worldcupManager"
end

function cfg_Commerce_worldcupManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_worldcup")
  end
  return self.dic
end

setmetatable(cfg_Commerce_worldcupManager, TableManagerBase)

function cfg_Commerce_worldcupManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_worldcupManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_worldcupManager
