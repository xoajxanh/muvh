local cfg_Level_rankRewardManager = {}

function cfg_Level_rankRewardManager:GetName()
  return "cfg_Level_rankRewardManager"
end

function cfg_Level_rankRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Level_rankReward")
  end
  return self.dic
end

setmetatable(cfg_Level_rankRewardManager, TableManagerBase)

function cfg_Level_rankRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Level_rankRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Level_rankRewardManager
