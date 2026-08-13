PCActivityManager = {}
PCActivityManager.m_FirstLoginGiftData = nil
PCActivityManager.m_DailyRegistrationGiftData = nil
PCActivityManager.m_CumulativeRechargeGiftData = nil
PCActivityManager.m_DailyRegistrationType = nil
PCActivityManager.m_DailyRegistrationDays = 0
PCActivityManager.m_PCTotalRechargePoint = 0

function PCActivityManager:Init()
  self:InitFirstLoginGiftData()
  self:InitDailyRegistrationGiftData()
  self:InitCumulativeRechargeGiftData()
end

function PCActivityManager:InitFirstLoginGiftData()
  local giftConfig = ClientTable.cfg_Gift_giftManager:TryGetValue(561001)
  if giftConfig == nil or next(giftConfig) == nil then
    return
  end
  self.m_FirstLoginGiftData = giftConfig
end

function PCActivityManager:GetFirstLoginGiftData()
  return self.m_FirstLoginGiftData
end

function PCActivityManager:InitDailyRegistrationGiftData()
  self.m_DailyRegistrationType = DailyRegistrationTypeEnum.Month
  local giftConfigTable = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 33)
  if giftConfigTable == nil or next(giftConfigTable) == nil then
    return
  end
  table.sort(giftConfigTable, function(a, b)
    if a.sortId and b.sortId then
      return a.sortId < b.sortId
    end
  end)
  self.m_DailyRegistrationGiftData = giftConfigTable
end

function PCActivityManager:RefreshDailyRegistrationDays(tblData)
  local dayType = tblData[self.m_DailyRegistrationType]
  if dayType == nil or dayType.day == nil or next(dayType.day) == nil then
    return
  end
  local channelOne = dayType.day[1103]
  local channelTwo = dayType.day[1223]
  local day = channelOne ~= nil and channelOne or channelTwo
  self.m_DailyRegistrationDays = day
end

function PCActivityManager:GetDailyRegistrationGiftData()
  return self.m_DailyRegistrationGiftData
end

function PCActivityManager:GetDailyRegistrationDays()
  return self.m_DailyRegistrationDays
end

function PCActivityManager:InitCumulativeRechargeGiftData()
  local giftConfig = ClientTable.cfg_Gift_giftManager:TryGetValue(581001)
  if giftConfig == nil or next(giftConfig) == nil then
    return
  end
  self.m_CumulativeRechargeGiftData = giftConfig
end

function PCActivityManager:RefreshPCTotalRechargePoint(totalPoint)
  self.m_PCTotalRechargePoint = totalPoint / 10
end

function PCActivityManager:GetCumulativeRechargeGiftData()
  return self.m_CumulativeRechargeGiftData
end

function PCActivityManager:GetPCTotalRechargePoint()
  return self.m_PCTotalRechargePoint
end

function PCActivityManager:CheckFirstLoginRedPoint()
  if self.m_FirstLoginGiftData == nil then
    return false
  end
  return not self:CheckIsReceiveReward(self.m_FirstLoginGiftData.countKey)
end

function PCActivityManager:CheckDailyRegistrationRedPoint()
  if self.m_DailyRegistrationGiftData == nil or next(self.m_DailyRegistrationGiftData) == nil or self.m_DailyRegistrationDays == nil then
    return false
  end
  for _, data in ipairs(self.m_DailyRegistrationGiftData) do
    local day = data.sortId
    local isReceiveReward = PCActivityManager:CheckIsReceiveReward(data.countKey)
    if day <= self.m_DailyRegistrationDays and not isReceiveReward then
      return true
    end
  end
  return false
end

function PCActivityManager:CheckCumulativeRechargeRedPoint()
  local effect = GlobalConfig.GetGlobalConfig(63000008)
  if string.isNullOrEmpty(effect) or self.m_CumulativeRechargeGiftData == nil or self.m_PCTotalRechargePoint == nil then
    return false
  end
  local maxTotalNumber = tonumber(effect)
  if maxTotalNumber <= self.m_PCTotalRechargePoint then
    return not self:CheckIsReceiveReward(self.m_CumulativeRechargeGiftData.countKey)
  end
  return false
end

function PCActivityManager:CheckIsReceiveReward(countKey)
  if countKey == nil then
    return false
  end
  local isReceiveReward = true
  local refresh = RefreshData.GetRefreshByKey(countKey)
  if refresh ~= nil and refresh.total - refresh.count > 0 then
    isReceiveReward = false
  end
  return isReceiveReward
end
