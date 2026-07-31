local TimeLimited_MiracleBattlePass = {}
setmetatable(TimeLimited_MiracleBattlePass, LuaClass.TimeLimitedActivity)
TimeLimited_MiracleBattlePass.level = 0
TimeLimited_MiracleBattlePass.curExp = 0
TimeLimited_MiracleBattlePass.nextExp = 0
TimeLimited_MiracleBattlePass.levelRewardInfoList = nil
TimeLimited_MiracleBattlePass.rareRewardList = nil
TimeLimited_MiracleBattlePass.cacheRareIndex = 0
TimeLimited_MiracleBattlePass.hasTypeDic = nil
TimeLimited_MiracleBattlePass.hasRewardIdDic = nil
TimeLimited_MiracleBattlePass.canGetRewardList = nil
TimeLimited_MiracleBattlePass.finishTaskInfoList = nil
TimeLimited_MiracleBattlePass.notFinishTaskInfoList = nil

function TimeLimited_MiracleBattlePass:RefreshDataByServerData(serverData)
  if serverData ~= nil then
    self:RefreshLevelData(serverData)
    self:RefreshRewardData(serverData)
    self:RefreshTaskData(serverData)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.TimeLimited_zhanlin
    })
    EventManager.Dispatch(Event.CombineWarOrderPassRefesh)
  end
end

function TimeLimited_MiracleBattlePass:RefreshLevelData(serverData)
  if serverData ~= nil and serverData.level ~= nil and serverData.exp ~= nil then
    self.level = serverData.level
    self.curExp = serverData.exp
    local nextExp = ClientTable.cfg_Commerce_zhanlinRewardManager:GetNextExpByLevel(self.level)
    if nextExp then
      self.nextExp = nextExp
    end
  end
end

function TimeLimited_MiracleBattlePass:RefreshRewardData(serverData)
  if serverData ~= nil and serverData.hasType and serverData.hasRewardId then
    for i, v in ipairs(serverData.hasRewardId) do
      if self.hasRewardIdDic == nil then
        self.hasRewardIdDic = {}
      end
      self.hasRewardIdDic[v] = true
    end
    for i, v in pairs(serverData.hasType) do
      if self.hasTypeDic == nil then
        self.hasTypeDic = {}
      end
      self.hasTypeDic[v] = true
    end
  end
end

function TimeLimited_MiracleBattlePass:RefreshTaskData(serverData)
  if serverData ~= nil and serverData.goalInfo then
    if self.notFinishTaskInfoList == nil then
      self:InitTaskInfoList()
    end
    for i, task in ipairs(serverData.goalInfo) do
      local isRefresh = self:TryRefreshTaskInfo(self.notFinishTaskInfoList, task)
      if not isRefresh then
        self:TryRefreshTaskInfo(self.finishTaskInfoList, task)
      end
    end
    for i = #self.notFinishTaskInfoList, 1, -1 do
      local taskInfo
      if self.notFinishTaskInfoList[i].finishTimes >= self.notFinishTaskInfoList[i].totalTimes then
        taskInfo = self.notFinishTaskInfoList[i]
        table.remove(self.notFinishTaskInfoList, i)
      end
      if taskInfo then
        table.insert(self.finishTaskInfoList, taskInfo)
      end
    end
    table.sort(self.finishTaskInfoList, function(a, b)
      return a.id < b.id
    end)
  end
end

function TimeLimited_MiracleBattlePass:TryRefreshTaskInfo(taskInfoList, goalInfo)
  for i, v in ipairs(taskInfoList) do
    if v.taskId == goalInfo.goalId then
      local tbl = ClientTable.cfg_Task_goalManager:TryGetValue(v.taskId)
      if tbl and tbl.type == 1602 then
        v.curCount = math.floor(goalInfo.current / 10)
        v.totalCount = math.floor(goalInfo.count / 10)
      else
        v.curCount = goalInfo.current
        v.totalCount = goalInfo.count
      end
      v.finishTimes = goalInfo.overTimes
      return true
    end
  end
  return false
end

function TimeLimited_MiracleBattlePass:Init()
end

function TimeLimited_MiracleBattlePass:InitTaskInfoList()
  if self.notFinishTaskInfoList == nil then
    self.notFinishTaskInfoList = {}
  end
  if self.finishTaskInfoList == nil then
    self.finishTaskInfoList = {}
  end
  local commerceId = self:GetCommerceId()
  local taskTbl = ClientTable.cfg_Commerce_zhanlintaskManager:GetDic()
  for i, v in pairs(taskTbl) do
    if commerceId == v.commerceId then
      local taskInfo = self:NewTaskInfo(v)
      table.insert(self.notFinishTaskInfoList, taskInfo)
    end
  end
  table.sort(self.notFinishTaskInfoList, function(a, b)
    return a.id < b.id
  end)
end

function TimeLimited_MiracleBattlePass:IsNotGetState(level, type)
  if not (self.hasTypeDic and self.hasTypeDic[type]) or level > self.level then
    return true
  end
  return false
end

function TimeLimited_MiracleBattlePass:IsGotState(id)
  if self.hasRewardIdDic then
    return self.hasRewardIdDic[id]
  end
  return false
end

function TimeLimited_MiracleBattlePass:IsHasType(type)
  if self.hasTypeDic and self.hasTypeDic[type] then
    return true
  end
  return false
end

function TimeLimited_MiracleBattlePass:AddCanGetReward(id)
  if self.canGetRewardList == nil then
    self.canGetRewardList = {}
  end
  for i, v in ipairs(self.canGetRewardList) do
    if v == id then
      return
    end
  end
  table.insert(self.canGetRewardList, id)
end

function TimeLimited_MiracleBattlePass:RefreshRareRewardListByIndex()
  if self.levelRewardInfoList == nil then
    return
  end
  self:ResetRareRewardList()
  for i, v in ipairs(self.levelRewardInfoList) do
    if v.isRare then
      local rareReward = {index = i, distance = 0}
      table.insert(self.rareRewardList, rareReward)
    end
  end
end

function TimeLimited_MiracleBattlePass:CalculateRareRewardListDistance(cellSizeX, spaceX, posX, targetPosX)
  if self.rareRewardList == nil then
    return
  end
  for i, v in ipairs(self.rareRewardList) do
    v.distance = (cellSizeX + spaceX) * (v.index - 1) + posX - targetPosX
  end
  self:RefreshShowRareRewardIndex()
end

function TimeLimited_MiracleBattlePass:RefreshShowRareRewardIndex()
  local minPositiveDistance = 999999
  local minIndex = 0
  for i, v in ipairs(self.rareRewardList) do
    if 0 <= v.distance and minPositiveDistance > v.distance then
      minPositiveDistance = v.distance
      minIndex = v.index
    end
  end
  if 0 < minIndex then
    if self.cacheRareIndex ~= minIndex then
      self.cacheRareIndex = minIndex
      EventManager.Dispatch(Event.CombineWarOrderPassRefeshRare)
    end
  else
    self.cacheRareIndex = 0
    EventManager.Dispatch(Event.CombineWarOrderPassRefeshRare)
  end
end

function TimeLimited_MiracleBattlePass:AnalyseRewardStr(str)
  local rewardsInfo = {}
  if not string.isNullOrEmpty(str) then
    local rewards = string.split(str, "&")
    for i, v in ipairs(rewards) do
      local rewardStr = string.split(v, "#")
      local rewardInfo = {
        itemId = tonumber(rewardStr[1]),
        count = tonumber(rewardStr[2])
      }
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  return rewardsInfo
end

function TimeLimited_MiracleBattlePass:AnalyseRewardState(tbl)
  local state = GuardRewardStateEnum.CanGet
  if self:IsNotGetState(tbl.level, tbl.type) then
    state = GuardRewardStateEnum.NotGet
  elseif self:IsGotState(tbl.id) then
    state = GuardRewardStateEnum.Got
  elseif not string.isNullOrEmpty(tbl.reward) then
    self:AddCanGetReward(tbl.id)
  end
  return state
end

function TimeLimited_MiracleBattlePass:GetLevelRewardInfoList()
  self:ResetLevelRewardInfoList()
  self:ResetCanGetRewardList()
  local rareLevelDic = {}
  local commerceId = self:GetCommerceId()
  local rewardDic = ClientTable.cfg_Commerce_zhanlinRewardManager:GetDic()
  local rewardInfoArray = {}
  for i, v in pairs(rewardDic) do
    if commerceId == v.commerceId and v.condition and ConditionManager.Check4D(v.condition) then
      local typeRewardInfo = self:NewTypeRewardInfo(v)
      if rewardInfoArray[v.level] == nil then
        rewardInfoArray[v.level] = {}
      end
      rewardInfoArray[v.level][v.type] = typeRewardInfo
      if v.mark == 1 then
        rareLevelDic[v.level] = true
      end
    end
  end
  for level, typeRewardInfoList in pairs(rewardInfoArray) do
    local levelRewardInfo = self:NewLevelRewardInfo(level, rareLevelDic[level], typeRewardInfoList)
    table.insert(self.levelRewardInfoList, levelRewardInfo)
  end
  table.sort(self.levelRewardInfoList, function(a, b)
    return a.level < b.level
  end)
  self:RefreshRareRewardListByIndex()
  return self.levelRewardInfoList
end

function TimeLimited_MiracleBattlePass:GetLevel()
  return self.level
end

function TimeLimited_MiracleBattlePass:GetCurExp()
  return self.curExp
end

function TimeLimited_MiracleBattlePass:GetNextExp()
  return self.nextExp
end

function TimeLimited_MiracleBattlePass:GetTaskInfoList()
  local taskInfoList = {}
  if self.notFinishTaskInfoList == nil then
    self:InitTaskInfoList()
  end
  taskInfoList = table.DeepCopy(self.notFinishTaskInfoList)
  taskInfoList = table.combine(taskInfoList, self.finishTaskInfoList)
  return taskInfoList
end

function TimeLimited_MiracleBattlePass:GetCanGetRewardList()
  if self.canGetRewardList == nil then
    self.canGetRewardList = {}
  end
  return self.canGetRewardList
end

function TimeLimited_MiracleBattlePass:GetShowRareReward()
  return self.levelRewardInfoList[self.cacheRareIndex]
end

function TimeLimited_MiracleBattlePass:GetStartIndex()
  local index = 1
  if self.levelRewardInfoList and self.hasTypeDic then
    for i, v in ipairs(self.levelRewardInfoList) do
      for type, bool in pairs(self.hasTypeDic) do
        if v.levelReward[type].state == GuardRewardStateEnum.CanGet and table.count(v.levelReward[type].rewards) > 0 or v.levelReward[type].state == GuardRewardStateEnum.NotGet then
          index = i
          return index
        end
      end
    end
  end
  return index
end

function TimeLimited_MiracleBattlePass:GetCommerceId()
  local overviewTbl = ClientTable.cfg_Commerce_overviewManager:GetTabListByType(self:GetActivityId(), "group")
  local commerceType = self:GetCommerceType()
  for i, v in pairs(overviewTbl) do
    if ConditionManager.Check(v.condition) and commerceType == v.commerceType and v.commerceId then
      return v.commerceId
    end
  end
  return 0
end

function TimeLimited_MiracleBattlePass:CheckRedPointState()
  self:GetLevelRewardInfoList()
  if self.canGetRewardList and table.count(self.canGetRewardList) > 0 then
    return true
  end
  return false
end

function TimeLimited_MiracleBattlePass:NewTaskInfo(tbl)
  local taskInfo = {}
  if tbl then
    taskInfo.id = tbl.id
    taskInfo.taskId = tbl.mission
    taskInfo.getExp = tbl.reward[2]
    taskInfo.des = tbl.description
    taskInfo.curCount = 0
    taskInfo.totalCount = 0
    taskInfo.finishTimes = 0
    taskInfo.totalTimes = tonumber(tbl.frequency)
  end
  return taskInfo
end

function TimeLimited_MiracleBattlePass:NewTypeRewardInfo(tbl)
  local typeRewardInfo = {}
  if tbl then
    typeRewardInfo.id = tbl.id
    typeRewardInfo.rewards = self:AnalyseRewardStr(tbl.reward)
    typeRewardInfo.state = self:AnalyseRewardState(tbl)
  end
  return typeRewardInfo
end

function TimeLimited_MiracleBattlePass:NewLevelRewardInfo(level, isRare, levelReward)
  local levelRewardInfo = {}
  levelRewardInfo.level = level
  if isRare == nil then
    isRare = false
  end
  levelRewardInfo.isRare = isRare
  levelRewardInfo.levelReward = levelReward
  return levelRewardInfo
end

function TimeLimited_MiracleBattlePass:ResetActivityData()
  self.level = 0
  self.curExp = 0
  self.nextExp = 0
  self.cacheRareIndex = 0
  self.hasRewardIdDic = {}
  self.hasTypeDic = {}
  self:ResetRareRewardList()
  self:ResetLevelRewardInfoList()
  self:ResetCanGetRewardList()
  self:ResetTaskInfoList()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.TimeLimited_zhanlin
  })
end

function TimeLimited_MiracleBattlePass:ResetTaskInfoList()
  if self.notFinishTaskInfoList then
    for i = #self.notFinishTaskInfoList, 1, -1 do
      table.remove(self.notFinishTaskInfoList)
    end
  end
  if self.finishTaskInfoList then
    for i = #self.finishTaskInfoList, 1, -1 do
      table.remove(self.finishTaskInfoList)
    end
  end
  self.notFinishTaskInfoList = nil
  self.finishTaskInfoList = nil
end

function TimeLimited_MiracleBattlePass:ResetCanGetRewardList()
  if self.canGetRewardList then
    for i = #self.canGetRewardList, 1, -1 do
      table.remove(self.canGetRewardList)
    end
  else
    self.canGetRewardList = {}
  end
end

function TimeLimited_MiracleBattlePass:ResetLevelRewardInfoList()
  if self.levelRewardInfoList then
    for i = #self.levelRewardInfoList, 1, -1 do
      table.remove(self.levelRewardInfoList)
    end
  else
    self.levelRewardInfoList = {}
  end
end

function TimeLimited_MiracleBattlePass:ResetRareRewardList()
  if self.rareRewardList then
    for i = #self.rareRewardList, 1, -1 do
      table.remove(self.rareRewardList)
    end
  else
    self.rareRewardList = {}
  end
end

return TimeLimited_MiracleBattlePass
