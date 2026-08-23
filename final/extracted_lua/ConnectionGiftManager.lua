local ConnectionGiftManager = {}
setmetatable(ConnectionGiftManager, LuaClass.HolidayActivity)
ConnectionGiftManager.ActivityData = nil

function ConnectionGiftManager:Init()
  self:InitData()
end

function ConnectionGiftManager:InitData()
  self.data = nil
end

function ConnectionGiftManager:ServerClientRefreshData(data)
  if not data then
    return
  end
  self.ActivityData = data
  EventManager.Dispatch(Event.ConnectionGift)
end

function ConnectionGiftManager:RefreshData()
  return self.ActivityData
end

function ConnectionGiftManager:ShowItemData(giftId)
  local itemData
  local gift = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 30)
  for i, v in pairs(gift) do
    if v.id == tonumber(giftId) then
      local box = ConfigManager.FindConfigs("cfg_Box_box", "boxId", v.reward)
      itemData = {}
      for n, m in pairs(box) do
        if m.condition == nil or ConditionManager.Check4D(m.condition) then
          itemData = {
            itemId = m.itemId,
            count = m.count
          }
        end
      end
      return itemData
    end
  end
  return itemData
end

function ConnectionGiftManager:RefreshRewardItemData(id)
  if not self.ActivityData then
    return false
  end
  local rewardEff = 0
  local reward = self:GetRewardConfig()
  if not reward then
    return
  end
  local str = string.split(reward[id].taskLine, "#")
  for i, v in pairs(str) do
    for j, k in pairs(self.ActivityData.goals) do
      if k == tonumber(v) then
        rewardEff = rewardEff + 1
      end
    end
  end
  if rewardEff >= #str then
    return true
  end
  return false
end

function ConnectionGiftManager:RefreshReceived(id)
  if self:RefreshRewardItemData(id) then
    local taskLineCfg = self:GetRewardConfig()
    for m, n in ipairs(self.ActivityData.getRewards) do
      if n == tonumber(taskLineCfg[id].id) then
        return true
      end
    end
  end
  return false
end

function ConnectionGiftManager:GetRewardConfig()
  if not self.ActivityData then
    return
  end
  table.sort(self.ActivityData.rewardConfig, function(a, b)
    return a < b
  end)
  local rewardConfig = {}
  for i, v in ipairs(self.ActivityData.rewardConfig) do
    local Commerce = ClientTable.cfg_Commerce_ConnectionGift_taskLineManager:TryGetValue(v, "id")
    if ConditionManager.Check4D(Commerce.condition) then
      table.insert(rewardConfig, Commerce)
    end
  end
  return rewardConfig
end

function ConnectionGiftManager:GetRewardRedPoint()
  if not self.ActivityData then
    return false
  end
  local ActivityRedPoint = false
  local RewardConfig = self:GetRewardConfig()
  for i = 1, #self:GetRewardConfig() do
    if self:RefreshRedPointRewardItemData(RewardConfig[i].id) then
      ActivityRedPoint = true
      for m, n in ipairs(self.ActivityData.getRewards) do
        if n == tonumber(RewardConfig[i].id) then
          ActivityRedPoint = false
        end
      end
      if ActivityRedPoint then
        return true
      end
    end
  end
  return false
end

function ConnectionGiftManager:RefreshRedPointRewardItemData(id)
  if not self.ActivityData then
    return false
  end
  local rewardEff = 0
  local reward = ClientTable.cfg_Commerce_ConnectionGift_taskLineManager:GetDic()
  if not reward then
    return
  end
  local str = string.split(reward[id].taskLine, "#")
  for i, v in pairs(str) do
    for j, k in pairs(self.ActivityData.goals) do
      if k == tonumber(v) then
        rewardEff = rewardEff + 1
      end
    end
  end
  if rewardEff >= #str then
    return true
  end
  return false
end

function ConnectionGiftManager:ResetActivityData()
end

return ConnectionGiftManager
