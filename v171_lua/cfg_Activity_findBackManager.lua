local cfg_Activity_findBackManager = {}

function cfg_Activity_findBackManager:GetName()
  return "cfg_Activity_findBackManager"
end

function cfg_Activity_findBackManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_findBack")
  end
  return self.dic
end

setmetatable(cfg_Activity_findBackManager, TableManagerBase)

function cfg_Activity_findBackManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_findBackManager
