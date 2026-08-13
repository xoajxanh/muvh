local ActivityDataManager = {}

function ActivityDataManager:Init()
  self.guardInvestData = {
    GuardInvestList = nil,
    CurGuardType = GuardTypeEnum.DamageIncreased
  }
end

function ActivityDataManager:SetCommercialActivityInfo(_data)
  if _data == nil then
    return
  end
  if CommercializeActivityTab.Opening_service == _data.icon then
    if _data.GuardInvestList and table.count(_data.GuardInvestList) > 0 then
      self.guardInvestData.GuardInvestList = _data.GuardInvestList
      EventManager.Dispatch(Event.CallRefreshRedPoint, {
        id = ERedPointId.open_guard_invest
      })
    end
    EventManager.Dispatch(Event.Commer_Openingserinfo_Mu2, _data.groupId)
  elseif CommercializeActivityTab.Holiday == _data.icon then
  elseif CommercializeActivityTab.Combining_service == _data.icon then
  end
end

function ActivityDataManager:CurGuardType(_IndexEnum, _value)
  if _IndexEnum == IndexerEnum.get then
    return self.guardInvestData.CurGuardType
  elseif _IndexEnum == IndexerEnum.set then
    self.guardInvestData.CurGuardType = _value
  end
end

function ActivityDataManager:SortByRewardId(_rewardList)
  if _rewardList == nil then
    return
  end
  table.sort(_rewardList, function(a, b)
    if a.rewardId and b.rewardId then
      return a.rewardId < b.rewardId
    else
      return false
    end
  end)
  for key, value in pairs(_rewardList) do
    if key == 1 then
      value.sortId = 1
    elseif value.rewardState == GuardRewardStateEnum.CanGet then
      value.sortId = 1
    elseif value.rewardState == GuardRewardStateEnum.NotGet then
      value.sortId = 2
    elseif value.rewardState == GuardRewardStateEnum.Got then
      value.sortId = 3
    end
  end
  return _rewardList
end

function ActivityDataManager:GetGuardInvestDataByType(_type)
  if self.guardInvestData.GuardInvestList == nil then
    return
  end
  local guradData = {}
  for index, value in pairs(self.guardInvestData.GuardInvestList) do
    if _type == value.guardInvestType then
      guradData = value
      break
    end
  end
  self:SortByRewardId(guradData.rewardList)
  return guradData
end

function ActivityDataManager:GetCurTypeGuardInvestData()
  local curGuardType = self:CurGuardType(IndexerEnum.get)
  local guradData = self:GetGuardInvestDataByType(curGuardType)
  local tabList = ClientTable.cfg_Guard_investManager:GetTabByType(curGuardType)
  for key, value in pairs(tabList) do
    value.sortId = guradData.rewardList[key].sortId
    value.rewardState = guradData.rewardList[key].rewardState
  end
  table.sort(tabList, function(a, b)
    if a.sortId and b.sortId then
      if a.sortId < b.sortId then
        return true
      elseif a.sortId > b.sortId then
        return false
      else
        return a.id < b.id
      end
    else
      return false
    end
  end)
  return tabList
end

function ActivityDataManager:IsShowGuardRedPoint()
  local isShow, _ = self:GetTypeAndReward()
  return isShow
end

function ActivityDataManager:GetTypeAndReward()
  local isCanGetReward = false
  local defalutGuardType = 2
  if self.guardInvestData == nil or self.guardInvestData.GuardInvestList == nil then
    return isCanGetReward, defalutGuardType
  end
  for key1, value1 in pairs(self.guardInvestData.GuardInvestList) do
    for key2, value2 in pairs(value1.rewardList) do
      isCanGetReward = isCanGetReward or value2.rewardState == GuardRewardStateEnum.CanGet
    end
    if isCanGetReward then
      defalutGuardType = value1.guardInvestType
      break
    end
  end
  return isCanGetReward, defalutGuardType
end

function ActivityDataManager:GetKLTRuinsManager()
  if self.mKLTRuinsManager == nil then
    self.mKLTRuinsManager = LuaClass.KLTRuinsManager:New()
  end
  return self.mKLTRuinsManager
end

function ActivityDataManager:GetTurntableUIDataMgr()
  if self.Active_TurntableUIDataMgr == nil then
    self.Active_TurntableUIDataMgr = LuaClass.Active_TurntableUIDataMgr:New()
  end
  return self.Active_TurntableUIDataMgr
end

function ActivityDataManager:ActivityExit(activityType)
  if activityType == ServerActivityEnum.KLTRuins then
    self:GetKLTRuinsManager():Exit()
    EventManager.Dispatch(Event.KalunteRuinsExit)
  end
  EventManager.Dispatch(Event.ClearkillNotice)
end

function ActivityDataManager:GetHolidayLuckyTurntableManager()
  if self.mHolidayLuckyTurntableManager == nil then
    self.mHolidayLuckyTurntableManager = LuaClass.HolidayLuckyTurntableManager:New()
  end
  return self.mHolidayLuckyTurntableManager
end

function ActivityDataManager:GetWarAllianceRedEnvelopeManager()
  if self.mWarAllianceRedEnvelopeManager == nil then
    self.mWarAllianceRedEnvelopeManager = LuaClass.WarAllianceRedEnvelopeData:New()
  end
  return self.mWarAllianceRedEnvelopeManager
end

function ActivityDataManager:GetRechargeSurpriseManager()
  if self.mRechargeSurpriseManager == nil then
    self.mRechargeSurpriseManager = LuaClass.RechargeSurpriseData:New()
  end
  return self.mRechargeSurpriseManager
end

return ActivityDataManager
