local cfg_OnHook_Point_thirdManager = {}

function cfg_OnHook_Point_thirdManager:GetName()
  return "cfg_OnHook_Point_thirdManager"
end

function cfg_OnHook_Point_thirdManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_Point_third")
  end
  return self.dic
end

setmetatable(cfg_OnHook_Point_thirdManager, TableManagerBase)

function cfg_OnHook_Point_thirdManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_OnHook_Point_thirdManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_OnHook_Point_thirdManager
