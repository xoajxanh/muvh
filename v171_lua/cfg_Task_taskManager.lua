local cfg_Task_taskManager = {}

function cfg_Task_taskManager:GetName()
  return "cfg_Task_taskManager"
end

function cfg_Task_taskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Task_task")
  end
  return self.dic
end

setmetatable(cfg_Task_taskManager, TableManagerBase)

function cfg_Task_taskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Task_taskManager:GetTabListByType(id, key)
  return self:BaseGetTabListByType(id, key)
end

return cfg_Task_taskManager
