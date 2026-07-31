local cfg_Activity_overviewManager = {}

function cfg_Activity_overviewManager:GetName()
  return "cfg_Activity_overviewManager"
end

function cfg_Activity_overviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_overview")
  end
  return self.dic
end

setmetatable(cfg_Activity_overviewManager, TableManagerBase)

function cfg_Activity_overviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_overviewManager
