local cfg_Monster_boss_rewardsManager = {}

function cfg_Monster_boss_rewardsManager:GetName()
  return "cfg_Monster_boss_rewardsManager"
end

function cfg_Monster_boss_rewardsManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_boss_rewards")
  end
  return self.dic
end

setmetatable(cfg_Monster_boss_rewardsManager, TableManagerBase)

function cfg_Monster_boss_rewardsManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Monster_boss_rewardsManager
