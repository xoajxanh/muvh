local cfg_Activity_livelyManager = {}

function cfg_Activity_livelyManager:GetName()
  return "cfg_Activity_livelyManager"
end

function cfg_Activity_livelyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_lively")
  end
  return self.dic
end

setmetatable(cfg_Activity_livelyManager, TableManagerBase)

function cfg_Activity_livelyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_livelyManager
