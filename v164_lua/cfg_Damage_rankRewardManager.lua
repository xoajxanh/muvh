local cfg_Damage_rankRewardManager = {}

function cfg_Damage_rankRewardManager:GetName()
  return "cfg_Damage_rankRewardManager"
end

function cfg_Damage_rankRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Damage_rankReward")
  end
  return self.dic
end

setmetatable(cfg_Damage_rankRewardManager, TableManagerBase)

function cfg_Damage_rankRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Damage_rankRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Damage_rankRewardManager
