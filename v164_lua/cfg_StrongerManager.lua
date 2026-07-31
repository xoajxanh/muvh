local cfg_StrongerManager = {}

function cfg_StrongerManager:GetName()
  return "cfg_StrongerManager"
end

function cfg_StrongerManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Stronger")
  end
  return self.dic
end

setmetatable(cfg_StrongerManager, TableManagerBase)

function cfg_StrongerManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_StrongerManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_StrongerManager
