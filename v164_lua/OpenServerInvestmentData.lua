local OpenServerInvestmentData = {}
setmetatable(OpenServerInvestmentData, LuaClass.TimeLimitedActivity)
OpenServerInvestmentData.investmentInfoDic = nil
OpenServerInvestmentData.gotIdList = nil
OpenServerInvestmentData.curServerDay = 0
OpenServerInvestmentData.isNeedReset = false

function OpenServerInvestmentData:Init()
  self:RegistEvents()
  self:InitData()
end

function OpenServerInvestmentData:InitData()
  if self.investmentInfoDic == nil then
    self.investmentInfoDic = {}
  end
  for i, rechargeId in pairs(KFTZGradeType) do
    local tblList = ClientTable.cfg_Commerce_touziManager:GetTabListByType(rechargeId, "RechargeId")
    local state = self:GetGradeStateByRechargeId(rechargeId)
    self.investmentInfoDic[rechargeId] = self:NewInvestmentInfo(rechargeId, tblList, state)
  end
  self.curServerDay = LoginData.GetOpenServerDay()
end

function OpenServerInvestmentData:NewDayGiftInfo(tbl, gradeState)
  local dayGiftInfo = {}
  dayGiftInfo.id = tbl.id
  dayGiftInfo.openDay = tonumber(tbl.des)
  dayGiftInfo.rewardId = tbl.itemId
  dayGiftInfo.rewardCount = tbl.num
  dayGiftInfo.state = self:GetDayGiftInfoState(tbl.id, gradeState)
  return dayGiftInfo
end

function OpenServerInvestmentData:NewInvestmentInfo(rechargeId, tblList, gradeState)
  local investmentInfo = {}
  investmentInfo.id = rechargeId
  investmentInfo.state = gradeState
  investmentInfo.notGotDayGiftInfoList = {}
  investmentInfo.gotDayGiftInfoList = {}
  for k, tbl in pairs(tblList) do
    table.insert(investmentInfo.notGotDayGiftInfoList, self:NewDayGiftInfo(tbl, gradeState))
  end
  table.sort(investmentInfo.notGotDayGiftInfoList, function(a, b)
    return a.openDay < b.openDay
  end)
  return investmentInfo
end

function OpenServerInvestmentData:RefreshDataByServerData(serverData)
  if serverData and serverData.getRewards then
    self.gotIdList = serverData.getRewards
    if self.isNeedReset == true then
      self:ResetData()
      self.isNeedReset = false
    end
    self:RefreshGiftInfoByGotId(serverData.getRewards)
  end
end

function OpenServerInvestmentData:TryUpdateCurDay()
  local setDay = LoginData.GetOpenServerDay()
  if setDay > self.curServerDay then
    self.curServerDay = setDay
    self:RefreshInvestmentInfoByTime()
  end
end

function OpenServerInvestmentData:RefreshGiftInfoByGotId(gotIdList)
  if self.investmentInfoDic == nil or type(gotIdList) ~= "table" then
    return
  end
  for rechargeId, investmentInfo in pairs(self.investmentInfoDic) do
    local index = 1
    while index <= #investmentInfo.notGotDayGiftInfoList do
      if table.contains(gotIdList, investmentInfo.notGotDayGiftInfoList[index].id) then
        investmentInfo.notGotDayGiftInfoList[index].state = KFTZRewardState.Got
        table.insert(investmentInfo.gotDayGiftInfoList, investmentInfo.notGotDayGiftInfoList[index])
        table.remove(investmentInfo.notGotDayGiftInfoList, index)
      else
        index = index + 1
      end
    end
    table.sort(investmentInfo.gotDayGiftInfoList, function(a, b)
      return a.openDay < b.openDay
    end)
    investmentInfo.state = self:GetGradeStateByRechargeId(rechargeId)
  end
  EventManager.Dispatch(Event.OpenServerInvestmentRefresh)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.TimeLimited_Investment
  })
end

function OpenServerInvestmentData:RefreshInvestmentInfoByCountKey()
  if self.investmentInfoDic == nil then
    return
  end
  local isChange = false
  for rechargeId, investmentInfo in pairs(self.investmentInfoDic) do
    local investmentState = self:GetGradeStateByRechargeId(rechargeId)
    if investmentInfo.state ~= investmentState then
      investmentInfo.state = investmentState
      for i, dayGiftInfo in ipairs(investmentInfo.notGotDayGiftInfoList) do
        dayGiftInfo.state = self:GetDayGiftInfoState(dayGiftInfo.id, investmentInfo.state)
      end
      isChange = true
    end
  end
  if isChange then
    EventManager.Dispatch(Event.OpenServerInvestmentRefresh)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.TimeLimited_Investment
    })
  end
end

function OpenServerInvestmentData:RefreshInvestmentInfoByTime()
  for rechargeId, investmentInfo in pairs(self.investmentInfoDic) do
    investmentInfo.state = self:GetGradeStateByRechargeId(rechargeId)
    for i, dayGiftInfo in ipairs(investmentInfo.notGotDayGiftInfoList) do
      dayGiftInfo.state = self:GetDayGiftInfoState(dayGiftInfo.id, investmentInfo.state)
    end
  end
  EventManager.Dispatch(Event.OpenServerInvestmentRefresh)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.TimeLimited_Investment
  })
end

function OpenServerInvestmentData:TimeAcrossDay()
  self:ResetTimeCache()
  self:RefreshInvestmentInfoByTime()
end

function OpenServerInvestmentData:IsAllGotToSingleGradeByRechargeId(rechargeId)
  if type(rechargeId) ~= "number" or type(self.investmentInfoDic[rechargeId]) ~= "table" then
    return false
  end
  if type(self.investmentInfoDic[rechargeId].notGotDayGiftInfoList) == "table" and table.count(self.investmentInfoDic[rechargeId].notGotDayGiftInfoList) <= 0 then
    return true
  end
  return false
end

function OpenServerInvestmentData:IsAllGotToRechargedGrade()
  for rechargeId, investmentInfo in pairs(self.investmentInfoDic) do
    if investmentInfo.state == KFTZGradeState.Recharged then
      return false
    end
  end
  return true
end

function OpenServerInvestmentData:IsShowActivity()
  for rechargeId, investmentInfo in pairs(self.investmentInfoDic) do
    investmentInfo.state = self:GetGradeStateByRechargeId(rechargeId)
    if investmentInfo.state == KFTZGradeState.Recharged or investmentInfo.state == KFTZGradeState.GoRecharge then
      return true
    end
  end
  return false
end

function OpenServerInvestmentData:GetDayGiftInfoListByRechargeId(rechargeId)
  if type(rechargeId) ~= "number" or type(self.investmentInfoDic[rechargeId]) ~= "table" then
    return
  end
  local dayGiftInfoList = {}
  if #self.investmentInfoDic[rechargeId].notGotDayGiftInfoList >= 1 then
    dayGiftInfoList = table.DeepCopy(self.investmentInfoDic[rechargeId].notGotDayGiftInfoList)
  end
  table.combine(dayGiftInfoList, self.investmentInfoDic[rechargeId].gotDayGiftInfoList)
  return dayGiftInfoList
end

function OpenServerInvestmentData:GetInvestmentInfoDicByRechargeId(rechargeId)
  if type(rechargeId) ~= "number" or type(self.investmentInfoDic) ~= "table" or type(self.investmentInfoDic[rechargeId]) ~= "table" then
    return
  end
  self.investmentInfoDic[rechargeId].state = self:GetGradeStateByRechargeId(rechargeId)
  return self.investmentInfoDic[rechargeId]
end

function OpenServerInvestmentData:GetGradeStateByRechargeId(rechargeId)
  local state = KFTZGradeState.NotRecharge
  if type(rechargeId) ~= "number" then
    return state
  end
  local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(rechargeId)
  if rechargeCfg and type(rechargeCfg.countKey) == "number" and RefreshData.GetLimitCount(rechargeCfg.countKey) < 1 then
    if self:IsAllGotToSingleGradeByRechargeId(rechargeId) then
      state = KFTZGradeState.AllGot
    else
      state = KFTZGradeState.Recharged
    end
  elseif rechargeCfg.showCondition and ConditionManager.Check4D(rechargeCfg.showCondition) then
    state = KFTZGradeState.GoRecharge
  else
    state = KFTZGradeState.NotRecharge
  end
  return state
end

function OpenServerInvestmentData:GetDayGiftInfoState(id, gradeState)
  local tbl = ClientTable.cfg_Commerce_touziManager:TryGetValue(id)
  local state = KFTZRewardState.NeedRecharge
  if type(self.gotIdList) == "table" and table.contains(self.gotIdList, id) then
    state = KFTZRewardState.Got
  elseif gradeState == KFTZGradeState.Recharged then
    if tbl.condition and ConditionManager.Check4D(tbl.condition) then
      state = KFTZRewardState.CanGet
    else
      state = KFTZRewardState.NotGet
    end
  else
    state = KFTZRewardState.NeedRecharge
  end
  return state
end

function OpenServerInvestmentData:CheckRedPointState()
  for k, investmentInfo in pairs(self.investmentInfoDic) do
    for i, dayGiftInfo in ipairs(investmentInfo.notGotDayGiftInfoList) do
      if dayGiftInfo.state == KFTZRewardState.CanGet then
        return true
      end
    end
  end
  return false
end

function OpenServerInvestmentData:RegistEvents()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.OpenServerInvestmentCount, self.RefreshInvestmentInfoByCountKey, self)
end

function OpenServerInvestmentData:UnRegistEvents()
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
end

function OpenServerInvestmentData:ResetActivityData()
  self.isNeedReset = true
  self.curServerDay = 0
  self.gotIdList = {}
  self.investmentInfoDic = {}
  self:UnRegistEvents()
end

function OpenServerInvestmentData:ResetData()
  self:InitData()
  self:RegistEvents()
end

function OpenServerInvestmentData:ResetList(list)
  if list == nil then
    list = {}
    return
  end
  for i = #list, 1, -1 do
    table.remove(list)
  end
end

return OpenServerInvestmentData
