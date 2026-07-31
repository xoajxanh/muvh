local cfg_Warrior_taskManager = {}

function cfg_Warrior_taskManager:GetName()
  return "cfg_Warrior_taskManager"
end

function cfg_Warrior_taskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Warrior_task")
  end
  return self.dic
end

setmetatable(cfg_Warrior_taskManager, TableManagerBase)

function cfg_Warrior_taskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Warrior_taskManager
