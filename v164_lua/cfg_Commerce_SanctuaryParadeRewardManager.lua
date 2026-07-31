local cfg_Commerce_SanctuaryParadeRewardManager = {}

function cfg_Commerce_SanctuaryParadeRewardManager:GetName()
  return "cfg_Commerce_SanctuaryParadeRewardManager"
end

function cfg_Commerce_SanctuaryParadeRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_SanctuaryParadeReward")
  end
  return self.dic
end

setmetatable(cfg_Commerce_SanctuaryParadeRewardManager, TableManagerBase)

function cfg_Commerce_SanctuaryParadeRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_SanctuaryParadeRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_SanctuaryParadeRewardManager
