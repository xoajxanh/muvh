local cfg_Daily_TiankongRewardManager = {}

function cfg_Daily_TiankongRewardManager:GetName()
  return "cfg_Daily_TiankongRewardManager"
end

function cfg_Daily_TiankongRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Daily_TiankongReward")
  end
  return self.dic
end

setmetatable(cfg_Daily_TiankongRewardManager, TableManagerBase)

function cfg_Daily_TiankongRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Daily_TiankongRewardManager
