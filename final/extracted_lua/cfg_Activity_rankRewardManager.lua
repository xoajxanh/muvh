local cfg_Activity_rankRewardManager = {}

function cfg_Activity_rankRewardManager:GetName()
  return "cfg_Activity_rankRewardManager"
end

function cfg_Activity_rankRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_rankReward")
  end
  return self.dic
end

setmetatable(cfg_Activity_rankRewardManager, TableManagerBase)

function cfg_Activity_rankRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_rankRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Activity_rankRewardManager
