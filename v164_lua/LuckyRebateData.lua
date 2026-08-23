local LuckyRebateData = {}
setmetatable(LuckyRebateData, LuaClass.HolidayActivity)
LuckyRebateData.gradeInfoList = nil
LuckyRebateData.turntableCount = 0
LuckyRebateData.curRechargeValue = 0

function LuckyRebateData:Init()
  self.turntableCount = 4
end

function LuckyRebateData:InitData()
end

function LuckyRebateData:TryInitGradeInfoList()
  if not table.isNullOrEmpty(self.gradeInfoList) then
    return
  end
  self.gradeInfoList = {}
  self.gradeInfoList = {}
  local commerceOverviewTbl = self:GetFirstConditionCommerce_HolidayActivityConfig()
  if type(commerceOverviewTbl) ~= "table" then
    return
  end
  local tblDic = ClientTable.cfg_Commerce_RebateManager:GetDic()
  for i, tbl in pairs(tblDic) do
    if tbl.overviewId == commerceOverviewTbl.commerceId then
      local gradeInfo = self:NewGradeInfo(tbl)
      table.insert(self.gradeInfoList, gradeInfo)
    end
  end
  table.sort(self.gradeInfoList, function(a, b)
    return a.id < b.id
  end)
end

function LuckyRebateData:NewGradeInfo(tbl)
  local gradeInfo = {}
  gradeInfo.id = tbl.id or 0
  gradeInfo.taskId = tbl.goalId or 0
  gradeInfo.turntableCount = self.turntableCount
  gradeInfo.des = tbl.describe or ""
  gradeInfo.rewardId = tbl.giftId or 0
  gradeInfo.taskCurCount = 0
  gradeInfo.taskTotalCount = 0
  gradeInfo.rewardCount = 0
  gradeInfo.rewardCountArr = {}
  gradeInfo.state = GuardRewardStateEnum.NotGet
  return gradeInfo
end

function LuckyRebateData:RefreshDataByServerData(serverData)
  if type(serverData) ~= "table" or type(serverData.infos) ~= "table" then
    return
  end
  self:TryInitGradeInfoList()
  for i, info in ipairs(serverData.infos) do
    self:RefreshGradeInfoByServerInfo(info)
  end
  EventManager.Dispatch(Event.LuckyRebateRefresh)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_LuckyRebates
  })
end

function LuckyRebateData:RefreshGradeInfoByServerInfo(info)
  if table.isNullOrEmpty(info) then
    return
  end
  for i, gradeInfo in ipairs(self.gradeInfoList) do
    if gradeInfo.id == info.configId then
      gradeInfo.taskCurCount = info.count
      gradeInfo.taskTotalCount = info.goalCount
      gradeInfo.rewardCount = info.rewardCount
      self:UpdateGradeInfoState(gradeInfo)
      self:UpdateGradeInfoRewardCountArr(gradeInfo)
      self:UpdateCurRechargeValue(gradeInfo)
      break
    end
  end
end

function LuckyRebateData:NumberToArr(changeNum, showBit)
  local bit = type(showBit) == "number" and showBit or self.turntableCount
  local arr = {}
  if type(changeNum) ~= "number" or changeNum < 0 then
    for i = 1, bit do
      table.insert(arr, 0)
    end
    return arr
  end
  local num = math.modf(changeNum)
  while 0 < num do
    table.insert(arr, num % 10)
    num = math.modf(num / 10)
  end
  local addBit = bit - table.count(arr)
  for i = 1, addBit do
    table.insert(arr, 0)
  end
  return arr
end

function LuckyRebateData:UpdateGradeInfoState(gradeInfo)
  if gradeInfo.rewardCount > 0 then
    gradeInfo.state = GuardRewardStateEnum.Got
  elseif gradeInfo.taskCurCount >= gradeInfo.taskTotalCount then
    gradeInfo.state = GuardRewardStateEnum.CanGet
  else
    gradeInfo.state = GuardRewardStateEnum.NotGet
  end
end

function LuckyRebateData:UpdateGradeInfoRewardCountArr(gradeInfo)
  gradeInfo.rewardCountArr = self:NumberToArr(gradeInfo.rewardCount, gradeInfo.turntableCount)
end

function LuckyRebateData:UpdateCurRechargeValue(gradeInfo)
  local taskTbl = ClientTable.cfg_Task_goalManager:TryGetValue(gradeInfo.taskId)
  if type(taskTbl) ~= "table" or taskTbl.type ~= 1607 then
    return
  end
  local rechargeValue = gradeInfo.taskCurCount / 10
  if rechargeValue > self.curRechargeValue then
    self.curRechargeValue = rechargeValue
  end
end

function LuckyRebateData:GetGradeInfoList()
  if self.gradeInfoList == nil then
    self.gradeInfoList = {}
  end
  return self.gradeInfoList
end

function LuckyRebateData:GetShowGradeInfoList()
  local notGetGradeInfoList = {}
  local gotGradeInfoList = {}
  for i, gradeInfoList in ipairs(self:GetGradeInfoList()) do
    if gradeInfoList.state == GuardRewardStateEnum.Got then
      table.insert(gotGradeInfoList, gradeInfoList)
    else
      table.insert(notGetGradeInfoList, gradeInfoList)
    end
  end
  table.combine(notGetGradeInfoList, gotGradeInfoList)
  return notGetGradeInfoList
end

function LuckyRebateData:GetFirstIndexByNotGetOrCanGet()
  if table.isNullOrEmpty(self:GetGradeInfoList()) then
    return 0
  end
  for i, gradeInfo in ipairs(self:GetGradeInfoList()) do
    if gradeInfo.state == GuardRewardStateEnum.CanGet or gradeInfo.state == GuardRewardStateEnum.NotGet then
      return i
    end
  end
  return table.count(self:GetGradeInfoList())
end

function LuckyRebateData:GetGradeInfoById(id)
  for i, gradeInfo in ipairs(self.gradeInfoList) do
    if gradeInfo.id == id then
      return gradeInfo, i
    end
  end
  return nil, 0
end

function LuckyRebateData:GetCurRechargeValue()
  return MathUtility.FormatNum(self.curRechargeValue)
end

function LuckyRebateData:CheckRedPointState()
  for i, gradeInfo in ipairs(self:GetGradeInfoList()) do
    if gradeInfo.state == GuardRewardStateEnum.CanGet then
      return true
    end
  end
  return false
end

function LuckyRebateData:ResetActivityData()
  self.curRechargeValue = 0
  self:ResetList(self:GetGradeInfoList())
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_LuckyRebates
  })
end

function LuckyRebateData:ResetList(list)
  if table.isNullOrEmpty(list) then
    return
  end
  for i = #list, 1, -1 do
    table.remove(list)
  end
end

return LuckyRebateData
