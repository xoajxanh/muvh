local cfg_Commerce_SanctuaryParadeTaskManager = {}

function cfg_Commerce_SanctuaryParadeTaskManager:GetName()
  return "cfg_Commerce_SanctuaryParadeTaskManager"
end

function cfg_Commerce_SanctuaryParadeTaskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_SanctuaryParadeTask")
  end
  return self.dic
end

setmetatable(cfg_Commerce_SanctuaryParadeTaskManager, TableManagerBase)

function cfg_Commerce_SanctuaryParadeTaskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_SanctuaryParadeTaskManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_SanctuaryParadeTaskManager
