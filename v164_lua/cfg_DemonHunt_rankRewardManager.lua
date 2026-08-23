local cfg_DemonHunt_rankRewardManager = {}

function cfg_DemonHunt_rankRewardManager:GetName()
  return "cfg_DemonHunt_rankRewardManager"
end

function cfg_DemonHunt_rankRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_DemonHunt_rankReward")
  end
  return self.dic
end

setmetatable(cfg_DemonHunt_rankRewardManager, TableManagerBase)

function cfg_DemonHunt_rankRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_DemonHunt_rankRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_DemonHunt_rankRewardManager
