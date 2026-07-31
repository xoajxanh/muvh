local cfg_union_taskManager = {}

function cfg_union_taskManager:GetName()
  return "cfg_union_taskManager"
end

function cfg_union_taskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_union_task")
  end
  return self.dic
end

setmetatable(cfg_union_taskManager, TableManagerBase)

function cfg_union_taskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_union_taskManager
