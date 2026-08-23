require("GameModel/RefreshData")
RefreshController = {}
local this = RefreshController

function RefreshController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
end

function RefreshController.RegistEvent()
  this.messageContainer:Regist(CountMessage.ResCounts, this.OnResCounts)
  this.messageContainer:Regist(CountMessage.ResCount, this.OnResCount)
end

function RefreshController.CloseRefresh()
  this.messageContainer:UnRegistAll()
end

function RefreshController.OnResCounts(_, msg)
  RefreshData.ResetRefreshesTbl(msg.counts)
  this.GenerateSchedule()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.showExp,
    state = true
  })
  EventManager.Dispatch(Event.AllCountsRefresh, msg.counts)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
end

function RefreshController.OnResCount(_, msg)
  RefreshData.RefreshTbl(msg)
  if msg.updateTime ~= 0 then
    this.AddSchedule(msg)
    this.ExecuteSchedule()
  end
  this.ScheduleDispatch({
    msg.key
  })
  EventManager.Dispatch(Event.CountsRefresh, msg)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.showExp,
    state = true
  })
  RechargeController.RefreshTimeRecharge()
end

RefreshController.Init()

function RefreshController.ExecuteSchedule()
  local minTime
  local scheduleKeys = {}
  for _, schedule in pairs(RefreshData.ScheduleTbl) do
    if minTime then
      if minTime > schedule.residueTime then
        minTime = schedule.residueTime
        scheduleKeys = {}
        table.insert(scheduleKeys, schedule.key)
      elseif minTime == schedule.residueTime then
        table.insert(scheduleKeys, schedule.key)
      end
    else
      minTime = schedule.residueTime
      table.insert(scheduleKeys, schedule.key)
    end
  end
  if this.timer then
    Timer.Stop(this.timer)
  end
  if minTime then
    this.timer = Timer.Start(minTime, RefreshController.RefreshSchedule, scheduleKeys)
  end
end

function RefreshController.RefreshSchedule(scheduleKeys)
  for _, scheduleKey in pairs(scheduleKeys) do
    RefreshData.RemoveSchedule(scheduleKey)
    RefreshData.RemoveRefreshByKey(scheduleKey)
  end
  this.ScheduleDispatch(scheduleKeys)
  this.ExecuteSchedule()
end

function RefreshController.NeedScheduleJudge(keyTbl, refresh)
  local flag = false
  if not keyTbl then
    return flag
  end
  local tbl = keyTbl
  if tbl then
    local refreshed = true
    local refreshTbl
    if string.isNullOrEmpty(tbl.refreshRule) then
      refreshed = false
      refresh.residueTime = -1
    else
      refreshTbl = ParseUtility.AnalysisCondition(tbl.refreshRule)
      for type, content in pairs(refreshTbl) do
        local refreshState, residueTime = TimeUtility.AnalysisRefreshJudge(type, content, refresh.updateTime)
        if not refreshState then
          refreshed = false
          refresh.residueTime = residueTime
          break
        end
      end
    end
    flag = refreshed
  end
  return flag
end

function RefreshController.AddSchedule(refresh)
  local parseTbl = ClientTable.cfg_Count_countManager:TryGetValue(refresh.key, "key")
  if parseTbl == nil then
    logError("D\225\187\175 li\225\187\135u l\195\160m m\225\187\155i kh\195\180ng \196\145\225\187\147ng b\225\187\153 gi\225\187\175a client v\195\160 server", refresh.key)
    return
  end
  local refreshState = this.NeedScheduleJudge(parseTbl, refresh)
  if not refreshState and refresh.residueTime ~= 0 then
    if refresh.residueTime > 0 then
      RefreshData.IncreaseSchedule(refresh)
    end
  else
    RefreshData.RemoveRefreshByKey(refresh.key)
  end
end

function RefreshController.GenerateSchedule()
  for _, refresh in pairs(RefreshData.TotalRefreshTbl) do
    this.AddSchedule(refresh)
  end
  this.ExecuteSchedule()
end

function RefreshController.ScheduleDispatch(typeSchedules)
  for _, countKey in pairs(typeSchedules) do
    local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
    if countTbl == nil then
      logError("D\225\187\175 li\225\187\135u l\195\160m m\225\187\155i kh\195\180ng \196\145\225\187\147ng b\225\187\153 gi\225\187\175a client v\195\160 server", countKey)
    else
      local eventId = RefreshData.GetEventByKey(countTbl.subType)
      if eventId then
        EventManager.Dispatch(eventId, countKey)
      end
    end
  end
end
