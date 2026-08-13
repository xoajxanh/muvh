local ActivityDataBase = {}
ActivityDataBase.activityTbl = nil
ActivityDataBase.nearOpenTimeIsDirty = nil
ActivityDataBase.openTimeStamp = nil
ActivityDataBase.nearNoticeTimeIsDirty = nil
ActivityDataBase.noticeTimeStamp = nil
ActivityDataBase.cacheActivityState = nil

function ActivityDataBase:Refresh(activityTbl)
  self.activityTbl = activityTbl
  self:ResetTimeCache()
end

function ActivityDataBase:RefreshActivityState()
  local activityState = self:GetActivityState()
  local isChange = false
  if activityState == ActivityStatusEnum.RUNNING and self.cacheActivityState ~= ActivityStatusEnum.RUNNING or activityState ~= ActivityStatusEnum.RUNNING and self.cacheActivityState == ActivityStatusEnum.RUNNING then
    isChange = true
  end
  self.cacheActivityState = activityState
  return isChange
end

function ActivityDataBase:ReqJoinActivity()
  SceneController.OnReqTransferTransmitMap(nil, {
    mapId = self:GetTransferId()
  })
end

function ActivityDataBase:GetOpenTimeStamp()
  local timeList = self:GetNearOpenTimeList()
  if timeList == nil or #timeList < 2 then
    return -1
  end
  return timeList[1]
end

function ActivityDataBase:GetEndTimeStamp()
  local timeList = self:GetNearOpenTimeList()
  if timeList == nil or #timeList < 2 then
    return -1
  end
  return timeList[2]
end

function ActivityDataBase:GetNearOpenTimeList()
  if self.openTimeStamp == nil or self.nearOpenTimeIsDirty and #self.openTimeStamp > 1 and Time.GetServerTime() > self.openTimeStamp[2] then
    self.nearOpenTimeIsDirty = true
  end
  if self.nearOpenTimeIsDirty then
    self.nearOpenTimeIsDirty = false
    if self:GetOpenTimeConfig() then
      self.openTimeStamp = self:AnalysisTimeStamp(self:GetOpenTimeConfig())
    elseif self:GetSingleOpenTimeConfig() then
      self.openTimeStamp = self:AnalysisSingleTimeStamp(self:GetSingleOpenTimeConfig())
    end
  end
  return self.openTimeStamp
end

function ActivityDataBase:GetNoticeOpenTimeStamp()
  local timeList = self:GetNearNoticeTimeList()
  if timeList == nil or #timeList < 2 then
    return -1
  end
  return timeList[1]
end

function ActivityDataBase:GetNoticeEndTimeStamp()
  local timeList = self:GetNearNoticeTimeList()
  if timeList == nil or #timeList < 2 then
    return -1
  end
  return timeList[2]
end

function ActivityDataBase:GetNearNoticeTimeList()
  if self.noticeTimeStamp == nil or self.nearNoticeTimeIsDirty and #self.noticeTimeStamp > 1 and Time.GetServerTime() > self.noticeTimeStamp[2] then
    self.nearNoticeTimeIsDirty = true
  end
  if self.nearNoticeTimeIsDirty then
    self.nearNoticeTimeIsDirty = false
    if self:GetNoticeTimeConfig() then
      self.noticeTimeStamp = self:AnalysisTimeStamp(self:GetNoticeTimeConfig())
    elseif self:GetSingleNoticeTimeConfig() then
      self.noticeTimeStamp = self:AnalysisSingleTimeStamp(self:GetSingleNoticeTimeConfig())
    end
  end
  return self.noticeTimeStamp
end

function ActivityDataBase:AnalysisTimeStamp(timeConfig)
  if timeConfig == nil then
    return
  end
  local startStamp, endStamp, serverTime, differentTime = TimeUtility.MaxTime, TimeUtility.MaxTime, Time.GetServerTime(), TimeUtility.MaxTime
  for k, v in pairs(timeConfig) do
    local sStamp, eStamp = TimeUtility.CalcTimeStamp(v)
    if eStamp ~= nil and 0 < sStamp and serverTime < eStamp and (startStamp == TimeUtility.MaxTime or differentTime > sStamp - serverTime) then
      differentTime = sStamp - serverTime
      startStamp = sStamp
      endStamp = eStamp
    end
  end
  if startStamp ~= TimeUtility.MaxTime then
    local stampList = {}
    table.insert(stampList, startStamp)
    table.insert(stampList, endStamp)
    return stampList
  end
end

function ActivityDataBase:AnalysisSingleTimeStamp(timeConfig)
  if timeConfig == nil then
    return
  end
  local sStamp, eStamp = TimeUtility.CalcTimeStamp(timeConfig)
  local stampList = {}
  table.insert(stampList, sStamp)
  table.insert(stampList, eStamp)
  return stampList
end

function ActivityDataBase:GetActivityState()
  local openTimeList = self:GetNearOpenTimeList()
  if type(openTimeList) ~= "table" or #openTimeList < 2 then
    return ActivityStatusEnum.END
  end
  local serverTime = Time.GetServerDayTime()
  if serverTime < openTimeList[1] then
    return ActivityStatusEnum.WAITSTART
  elseif serverTime >= openTimeList[1] and serverTime <= openTimeList[2] then
    return ActivityStatusEnum.RUNNING
  else
    return ActivityStatusEnum.CLOSING
  end
end

function ActivityDataBase:GetActivityTimeDes()
  local activityState = self:GetActivityState()
  if activityState == ActivityStatusEnum.END or activityState == ActivityStatusEnum.CLOSING then
    return
  end
  local activityName = self:GetActivityName()
  if string.isNullOrEmpty(activityName) then
    return
  end
  if activityState == ActivityStatusEnum.RUNNING then
    return activityName .. "\196\144ang ti\225\186\191n h\195\160nh"
  elseif activityState == ActivityStatusEnum.WAITSTART then
    local IsTodayActivity = self:IsTodayActivity()
    if IsTodayActivity then
      local openTimeDesFormat = self:GetOpenTimeDesFormat()
      if string.isNullOrEmpty(openTimeDesFormat) == false and self:GetOpenTimeStamp() > 0 then
        return activityName .. os.date(openTimeDesFormat, math.floor(self:GetOpenTimeStamp() * 0.001))
      end
    else
      local noticeTimeDesFormat = self:GetNoticeTimeDesFormat()
      if string.isNullOrEmpty(noticeTimeDesFormat) == false and 0 < self:GetRemainDay() then
        return activityName .. string.format(noticeTimeDesFormat, self:GetRemainDay())
      end
    end
  end
end

function ActivityDataBase:GetopenAvtivityTime(id)
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(id, "activityId").condition
  if openActivityCond == nil then
    logError("ActivityDataBase: SKcfg_Activity_overviewManagerSKid n\225\187\153i dung tr\225\187\145ng!")
    return
  end
  local isOpen = ConditionManager.Check4D(openActivityCond)
  local openTimeDesFormat = self:GetActivityTimeDesFormat()
  if string.isNullOrEmpty(openTimeDesFormat) == false and self:GetOpenTimeStamp() > 0 then
    if isOpen then
      gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.CoalitionSiege).RedimgTempModel = true
      return string.GetColorText(os.date(openTimeDesFormat, math.floor(self:GetOpenTimeStamp() * 0.001)), ItemQuality2ColorDic[5])
    else
      gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.CoalitionSiege).RedimgTempModel = false
      return string.GetColorText(os.date(openTimeDesFormat, math.floor(self:GetOpenTimeStamp() * 0.001)), ItemQuality2ColorDic[7])
    end
  end
end

function ActivityDataBase:GetRemainTimeDes()
  return ""
end

function ActivityDataBase:GetRemainDay()
  return TimeUtility.GetRemainDay(self:GetOpenTimeStamp())
end

function ActivityDataBase:IsTodayActivity()
  return TimeUtility.CheckIsServerSameDay(math.floor(self:GetOpenTimeStamp() * 0.001))
end

function ActivityDataBase:ResetTimeCache()
  self.nearOpenTimeIsDirty = true
  self.nearNoticeTimeIsDirty = true
  self.cacheActivityState = ActivityStatusEnum.INIT
end

function ActivityDataBase:TimeAcrossDay()
  self:ResetTimeCache()
end

function ActivityDataBase:GetActivityId()
end

function ActivityDataBase:GetTransferId()
end

function ActivityDataBase:GetOpenTimeConfig()
end

function ActivityDataBase:GetSingleOpenTimeConfig()
end

function ActivityDataBase:GetNoticeTimeConfig()
end

function ActivityDataBase:GetSingleNoticeTimeConfig()
end

function ActivityDataBase:GetOpenTimeDesFormat()
end

function ActivityDataBase:GetNoticeTimeDesFormat()
end

function ActivityDataBase:GetActivityName()
end

function ActivityDataBase:ResetActivityData()
end

return ActivityDataBase
