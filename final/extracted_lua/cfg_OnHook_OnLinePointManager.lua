local cfg_OnHook_OnLinePointManager = {}

function cfg_OnHook_OnLinePointManager:GetName()
  return "cfg_OnHook_OnLinePointManager"
end

function cfg_OnHook_OnLinePointManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_OnLinePoint")
  end
  return self.dic
end

setmetatable(cfg_OnHook_OnLinePointManager, TableManagerBase)

function cfg_OnHook_OnLinePointManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_OnHook_OnLinePointManager
