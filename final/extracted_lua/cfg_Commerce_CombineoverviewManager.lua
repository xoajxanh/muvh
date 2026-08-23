local cfg_Commerce_CombineoverviewManager = {}

function cfg_Commerce_CombineoverviewManager:GetName()
  return "cfg_Commerce_CombineoverviewManager"
end

function cfg_Commerce_CombineoverviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Combineoverview")
  end
  return self.dic
end

setmetatable(cfg_Commerce_CombineoverviewManager, TableManagerBase)

function cfg_Commerce_CombineoverviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_CombineoverviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_CombineoverviewManager
