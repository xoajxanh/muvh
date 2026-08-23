local cfg_Commerce_RegularUpdatesManager = {}

function cfg_Commerce_RegularUpdatesManager:GetName()
  return "cfg_Commerce_RegularUpdatesManager"
end

function cfg_Commerce_RegularUpdatesManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_RegularUpdates")
  end
  return self.dic
end

setmetatable(cfg_Commerce_RegularUpdatesManager, TableManagerBase)

function cfg_Commerce_RegularUpdatesManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_RegularUpdatesManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_RegularUpdatesManager
