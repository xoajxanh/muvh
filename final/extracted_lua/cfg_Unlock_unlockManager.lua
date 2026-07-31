local cfg_Unlock_unlockManager = {}

function cfg_Unlock_unlockManager:GetName()
  return "cfg_Unlock_unlockManager"
end

function cfg_Unlock_unlockManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Unlock_unlock")
  end
  return self.dic
end

setmetatable(cfg_Unlock_unlockManager, TableManagerBase)

function cfg_Unlock_unlockManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Unlock_unlockManager
