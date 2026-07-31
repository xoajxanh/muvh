local cfg_Commerce_TimeLimitedoverviewManager = {}

function cfg_Commerce_TimeLimitedoverviewManager:GetName()
  return "cfg_Commerce_TimeLimitedoverviewManager"
end

function cfg_Commerce_TimeLimitedoverviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_TimeLimitedoverview")
  end
  return self.dic
end

setmetatable(cfg_Commerce_TimeLimitedoverviewManager, TableManagerBase)

function cfg_Commerce_TimeLimitedoverviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_TimeLimitedoverviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_TimeLimitedoverviewManager
