local RewriteNamingData = {}
RewriteNamingData.RankListData = {}
RewriteNamingData.NamingMyData = {}
RewriteNamingData.OnePlayerData = {}
RewriteNamingData.NamingName = nil
RewriteNamingData.NamingGiftId = nil
RewriteNamingData.NamingGiftCountKey = nil

function RewriteNamingData:RefreshData(data)
  if not data then
    return
  end
  self.Data = data
  self.OnePlayerData.rid = data.rid
  self.OnePlayerData.roleName = data.roleName
  self.OnePlayerData.regionName = data.regionName
  self.OnePlayerData.status = data.status
  self.OnePlayerData.tempName = data.tempName
  self.commerceId = data.commerceId
  self:RefreshRankListData()
  self:RefreshNamingMyData()
  self:GetNamingMyRewardData()
  EventManager.Dispatch(Event.NamingDataChange)
end

function RewriteNamingData:RefreshRankListData()
  local isActivity = true
  local conFg = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", 551)
  for i, v in pairs(conFg) do
    if ConditionManager.Check(v.condition) then
      isActivity = false
    end
  end
  if isActivity then
    if self.Data.lastRoleRankInfo then
      self.RankListData = self.Data.lastRoleRankInfo
      table.sort(self.RankListData, function(a, b)
        return a.rank < b.rank
      end)
    end
  elseif self.Data.roleRankInfo then
    self.RankListData = self.Data.roleRankInfo
    table.sort(self.RankListData, function(a, b)
      return a.rank < b.rank
    end)
  end
end

function RewriteNamingData:RefreshNamingMyData()
  local isActivity = true
  local conFg = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", 551)
  for i, v in pairs(conFg) do
    if ConditionManager.Check(v.condition) then
      isActivity = false
    end
  end
  if isActivity then
    for i, v in pairs(self.Data.lastRoleRankInfo) do
      if v.rid == ViewData.meData.id then
        self.NamingMyData = v
      end
    end
  else
    for i, v in pairs(self.Data.roleRankInfo) do
      if v.rid == ViewData.meData.id then
        self.NamingMyData = v
      end
    end
  end
  self.NamingMyData.isActivity = isActivity
  self.NamingMyData.isOn = false
  if self.NamingMyData and #self.NamingMyData <= 0 then
    self.NamingMyData.rechargeNum = self.Data.myRecharge
  end
  return self.NamingMyData
end

function RewriteNamingData:GetRankListData()
  if self.RankListData then
    return self.RankListData
  end
end

function RewriteNamingData:GetNamingMyData()
  if self.NamingMyData then
    return self.NamingMyData
  end
end

function RewriteNamingData:GetNamingOnePlayerData()
  if self.OnePlayerData then
    return self.OnePlayerData
  end
end

function RewriteNamingData:GetNamingRedPoint()
  if self.NamingGiftCountKey then
    local reward = RefreshData.GetLimitCount(self.NamingGiftCountKey)
    if reward and reward <= 0 then
      return false
    elseif self.NamingMyData.isOn and self.OnePlayerData.status == 0 then
      return true
    end
  end
  return false
end

function RewriteNamingData:GetNamingMyRewardData()
  if not self.commerceId then
    return
  end
  local conGiftData = {}
  self.itemMyRewardData = {}
  if not self.commerceId or self.commerceId == 0 then
    self.commerceId = 55101
  end
  local conGiftFg = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 55)
  for i, v in pairs(conGiftFg) do
    if v.subType == 552 then
      table.insert(conGiftData, v)
    end
  end
  for n, m in pairs(conGiftData) do
    if m.buyCondition then
      local str = TableParse:SplitStringToNamingList(m.buyCondition)
      if tonumber(str[1810]) == self.commerceId then
        local diamond = ConfigManager.FindConfigs("cfg_Box_box", "boxId", m.reward)
        for j, k in pairs(diamond) do
          self.itemMyRewardData[j] = {
            itemId = k.itemId,
            count = k.count
          }
        end
        self.NamingGiftId = m.id
        self.NamingGiftCountKey = m.countKey
        self.NamingMyData.rewardId = m.reward
        if self.NamingMyData and self.NamingMyData.rechargeNum >= tonumber(str[5501]) then
          self.NamingMyData.isOn = true
        end
        return
      end
    end
  end
end

function RewriteNamingData:GetItemMyRewardData()
  if self.itemMyRewardData then
    return self.itemMyRewardData
  end
end

function RewriteNamingData:GetOneRewardData()
  if not self.commerceId then
    return
  end
  local itemData = {}
  local conGiftData = {}
  if not self.commerceId or self.commerceId == 0 then
    self.commerceId = 55101
  end
  local conGiftFg
  conGiftFg = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 55)
  for i, v in pairs(conGiftFg) do
    if v.subType == 551 then
      table.insert(conGiftData, v)
    end
  end
  if not conGiftData then
    return
  end
  for n, m in pairs(conGiftData) do
    if m.buyCondition then
      local str = TableParse:SplitStringToNamingList(m.buyCondition)
      if tonumber(str[1810]) == self.commerceId then
        local diamond = ConfigManager.FindConfigs("cfg_Box_box", "boxId", m.reward)
        for i, v in pairs(diamond) do
          itemData[i] = {
            itemId = v.itemId,
            count = v.count
          }
        end
        return itemData
      end
    end
  end
  return itemData
end

return RewriteNamingData
