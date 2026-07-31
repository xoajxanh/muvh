local cfg_Commerce_CombinedglobalManager = {}

function cfg_Commerce_CombinedglobalManager:GetName()
  return "cfg_Commerce_CombinedglobalManager"
end

function cfg_Commerce_CombinedglobalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Combinedglobal")
  end
  return self.dic
end

setmetatable(cfg_Commerce_CombinedglobalManager, TableManagerBase)

function cfg_Commerce_CombinedglobalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_CombinedglobalManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_CombinedglobalManager
