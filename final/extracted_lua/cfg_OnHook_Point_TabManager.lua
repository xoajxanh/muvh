local cfg_OnHook_Point_TabManager = {}

function cfg_OnHook_Point_TabManager:GetName()
  return "cfg_OnHook_Point_TabManager"
end

function cfg_OnHook_Point_TabManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_Point_Tab")
  end
  return self.dic
end

setmetatable(cfg_OnHook_Point_TabManager, TableManagerBase)

function cfg_OnHook_Point_TabManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_OnHook_Point_TabManager
