local cfg_OnHook_PointManager = {}

function cfg_OnHook_PointManager:GetName()
  return "cfg_OnHook_PointManager"
end

function cfg_OnHook_PointManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_Point")
  end
  return self.dic
end

setmetatable(cfg_OnHook_PointManager, TableManagerBase)

function cfg_OnHook_PointManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_OnHook_PointManager
