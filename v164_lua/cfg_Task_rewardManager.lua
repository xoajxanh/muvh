local cfg_Task_rewardManager = {}

function cfg_Task_rewardManager:GetName()
  return "cfg_Task_rewardManager"
end

function cfg_Task_rewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Task_reward")
  end
  return self.dic
end

setmetatable(cfg_Task_rewardManager, TableManagerBase)

function cfg_Task_rewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Task_rewardManager
