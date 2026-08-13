local cfg_Member_taskManager = {}

function cfg_Member_taskManager:GetName()
  return "cfg_Member_taskManager"
end

function cfg_Member_taskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Member_task")
  end
  return self.dic
end

setmetatable(cfg_Member_taskManager, TableManagerBase)

function cfg_Member_taskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Member_taskManager
