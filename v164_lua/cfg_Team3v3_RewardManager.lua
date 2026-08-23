local cfg_Team3v3_RewardManager = {}

function cfg_Team3v3_RewardManager:GetName()
  return "cfg_Team3v3_RewardManager"
end

function cfg_Team3v3_RewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Team3v3_Reward")
  end
  return self.dic
end

setmetatable(cfg_Team3v3_RewardManager, TableManagerBase)

function cfg_Team3v3_RewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Team3v3_RewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Team3v3_RewardManager:GetSortTabListByType(type, typeKey)
  local tbl = self:BaseGetTabListByType(type, typeKey)
  local rewards = {}
  for i, v in pairs(tbl) do
    if v.rewardPreview and v.rewardPreview ~= 0 then
      table.insert(rewards, v)
    end
  end
  table.sort(rewards, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    else
      return false
    end
  end)
  return rewards
end

return cfg_Team3v3_RewardManager
