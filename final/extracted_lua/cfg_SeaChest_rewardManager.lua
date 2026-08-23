local cfg_SeaChest_rewardManager = {}

function cfg_SeaChest_rewardManager:GetName()
  return "cfg_SeaChest_rewardManager"
end

function cfg_SeaChest_rewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_SeaChest_reward")
  end
  return self.dic
end

setmetatable(cfg_SeaChest_rewardManager, TableManagerBase)

function cfg_SeaChest_rewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_SeaChest_rewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_SeaChest_rewardManager:GetTier(id)
  local data = self:TryGetValue(id, "cost")
  if data then
    return data.type
  end
  return nil
end

return cfg_SeaChest_rewardManager
