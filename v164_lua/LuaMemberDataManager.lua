local LuaMemberDataManager = {}

function LuaMemberDataManager:AllMemberTaskDic()
  if self.allMemberTaskDic == nil then
    self.allMemberTaskDic = {}
  end
  return self.allMemberTaskDic
end

function LuaMemberDataManager:AllTaskIdListByLevelDic()
  if self.allTaskIdListByLevelDic == nil then
    self.allTaskIdListByLevelDic = {}
  end
  return self.allTaskIdListByLevelDic
end

function LuaMemberDataManager:GetCurDailyTaskList(isNeedSort)
  if self.curDailyTaskDic == nil then
    self.curDailyTaskDic = {}
  end
  if isNeedSort then
    local dataList = {}
    for i, v in pairs(self.curDailyTaskDic) do
      table.insert(dataList, v)
    end
    table.sort(dataList, function(a, b)
      if a.state == EMemberTaskState.finish then
        if a.state == b.state then
          return a.sort < b.sort
        else
          return false
        end
      end
      return a.sort < b.sort
    end)
    return dataList
  end
  return self.curDailyTaskDic
end

function LuaMemberDataManager:RedPointInfoDic()
  if self.mRedPointInfoDic == nil then
    self.mRedPointInfoDic = {}
  end
  return self.mRedPointInfoDic
end

function LuaMemberDataManager:PageInfoList()
  if self.mPageInfoList == nil then
    self.mPageInfoList = {}
  end
  return self.mPageInfoList
end

function LuaMemberDataManager:MemberBuyInfoDic()
  if self.memberBuyInfoDic == nil then
    self.memberBuyInfoDic = {}
  end
  return self.memberBuyInfoDic
end

function LuaMemberDataManager:MemberIdsByGroupDic()
  if self.mMemberIdsByGroupDic == nil then
    self.mMemberIdsByGroupDic = {}
  end
  return self.mMemberIdsByGroupDic
end

function LuaMemberDataManager:MemberMaxStarByGroupDic()
  if self.mMemberMaxStarByGroupDic == nil then
    self.mMemberMaxStarByGroupDic = {}
  end
  return self.mMemberMaxStarByGroupDic
end

function LuaMemberDataManager:MemberDataItemById()
  if self.mMemberItemDataById == nil then
    self.mMemberItemDataById = {}
  end
  return self.mMemberItemDataById
end

function LuaMemberDataManager:SrcStateByMemberGroupDic()
  if self.mSrcStateByMemberGroupDic == nil then
    self.mSrcStateByMemberGroupDic = {}
  end
  return self.mSrcStateByMemberGroupDic
end

function LuaMemberDataManager:GetMemberLevle()
  return self.level == nil and 0 or self.level
end

function LuaMemberDataManager:GetNextMemberLevel()
  return self.nextMemberLevel or 0
end

function LuaMemberDataManager:GetcurMemberTable()
  if self.curMemberTable == nil or self.curMemberTable.id ~= self:GetMemberLevle() then
    self.curMemberTable = ClientTable.cfg_MemberManager:TryGetValue(self:GetMemberLevle())
  end
  return self.curMemberTable
end

function LuaMemberDataManager:GetCurMemberGroup()
  return self.curGroup or 0
end

function LuaMemberDataManager:GetCurMemberStar()
  return self.curStar or 0
end

function LuaMemberDataManager:GetTemporaryMemberLevle()
  return self.temporaryLevel == nil and 0 or self.temporaryLevel
end

function LuaMemberDataManager:GetTemporaryMemberTotalTime()
  return self.temporaryLevelTotalTime == nil and 0 or self.temporaryLevelTotalTime
end

function LuaMemberDataManager:GetTemporaryMemberEndTime()
  return self.temporaryLevelTime == nil and 0 or self.temporaryLevelTime
end

function LuaMemberDataManager:GetMemberMaxGroup()
  return self.maxGroup or 0
end

function LuaMemberDataManager:GetCurExp()
  return self.curExp or 0
end

function LuaMemberDataManager:GetCurTotalExp()
  local nowData = self:MemberDataItemById()[self:GetMemberLevle()]
  if nowData then
    return nowData.needExp
  end
  return 0
end

function LuaMemberDataManager:GetBuyExpCountData()
  return self.buyExpCountData
end

function LuaMemberDataManager:Init()
  self:InitInfo()
end

function LuaMemberDataManager:InitInfo()
  self.maxId = 0
  self.maxGroup = 0
  local dic = ClientTable.cfg_MemberManager:GetDic()
  if dic == nil then
    return
  end
  for k, v in pairs(dic) do
    self:InitPageData(v)
    self:InitGroupInfo(v)
    self:InitOtherInfo(v)
  end
  self:InitializedFunction()
end

function LuaMemberDataManager:InitTaskInfo(tbl)
  if tbl == nil or tbl.task == "" or tbl.task == nil then
    return
  end
  self:AllTaskIdListByLevelDic()[tbl.id] = TableParse:SplitStringToIntList(tbl.task, "#")
end

function LuaMemberDataManager:InitPageData(tbl)
  if tbl.starnum ~= 1 then
    return
  end
  local temp = {
    id = tbl.id,
    order = tbl.id,
    group = tbl.vipLevel,
    str = string.format("img_member_btn_%s_", tbl.vipLevel),
    name = "Tog_Btn" .. tbl.redPoint,
    condition = tbl.ishide
  }
  table.insert(self:PageInfoList(), temp)
end

function LuaMemberDataManager:InitGroupInfo(tbl)
  if self:MemberIdsByGroupDic()[tbl.vipLevel] == nil then
    self:MemberIdsByGroupDic()[tbl.vipLevel] = {}
  end
  if tbl.starnum > 0 then
    table.insert(self:MemberIdsByGroupDic()[tbl.vipLevel], {
      id = tbl.id,
      order = tbl.starnum
    })
  end
  if self:MemberMaxStarByGroupDic()[tbl.vipLevel] == nil then
    self:MemberMaxStarByGroupDic()[tbl.vipLevel] = tbl.starnum
  elseif self:MemberMaxStarByGroupDic()[tbl.vipLevel] < tbl.starnum then
    self:MemberMaxStarByGroupDic()[tbl.vipLevel] = tbl.starnum
  end
  if self:MemberDataItemById()[tbl.id] == nil then
    self:MemberDataItemById()[tbl.id] = self:NewMemberDataItem(tbl)
  end
end

function LuaMemberDataManager:InitOtherInfo(tbl)
  if tbl.starnum == 1 then
    self:RedPointInfoDic()[tbl.redPoint] = tbl.vipLevel
  end
  if self.maxId < tbl.id then
    self.maxId = tbl.id
  end
  if self.maxGroup < tbl.vipLevel then
    self.maxGroup = tbl.vipLevel
  end
end

function LuaMemberDataManager:InitializedFunction()
  local function sortFunc(a, b)
    return a and b and a.order and b.order and a.order < b.order
  end
  
  for i, v in pairs(self:MemberIdsByGroupDic()) do
    if v and next(v) then
      table.sort(v, sortFunc)
    end
  end
  table.sort(self:PageInfoList(), sortFunc)
end

function LuaMemberDataManager:RefreshData(memberData)
  if memberData == nil then
    return
  end
  self:RefreshBasicData(memberData)
  self:RefreshTemporaryData(memberData)
  self:ProcessTaskData(memberData.taskList, false)
  self:ProcessDailyTaskData(memberData.dailyTaskList)
  self:ProcessDailyRewardData(memberData.dailyReceived)
  self:ProcessSrcRewardData(memberData.receivedLevelReward)
  self:RefreshAddExpValue()
end

function LuaMemberDataManager:RefreshBasicData(memberData)
  local lastExp = self.curExp
  self.curExp = memberData.vipExp
  if self.level ~= memberData.level then
    self.level = memberData.level
    local curGroup = self:GetMemberGroupById(self:GetMemberLevle())
    self.curStar = self:GetMemberStarById(self:GetMemberLevle())
    if self.curGroup ~= curGroup then
      self.curGroup = curGroup
      EventManager.Dispatch(Event.MemberGroupChanged)
    end
    self.nextMemberLevel = self:CalculateMemberNextLevel()
    EventManager.Dispatch(Event.MemberLevelChanged)
  elseif lastExp ~= memberData.vipExp then
    EventManager.Dispatch(Event.MemberExpChanged)
  end
end

function LuaMemberDataManager:RefreshTemporaryData(memberData)
  if self.temporaryLevel ~= memberData.temporaryLevel or self.temporaryLevelTime ~= memberData.temporaryLevelTime then
    self.temporaryLevel = memberData.temporaryLevel
    self.temporaryLevelTime = memberData.temporaryLevelTime
    self.temporaryLevelTotalTime = memberData.temporaryLevelAllTime
    EventManager.Dispatch(Event.TemporaryMemberLevelChanged)
  end
end

function LuaMemberDataManager:RefreshTaskData(taskData)
  if taskData == nil or taskData.taskList == nil then
    return
  end
  self:ProcessTaskData(taskData.taskList, true)
  self:ProcessDailyTaskData(taskData.dailyTaskList)
  local targetId = self:GetMemberLevle() == 0 and 1 or self:GetMemberLevle() == self.maxId and self.maxId or self:GetMemberLevle() + 1
  EventManager.Dispatch(Event.MemberMissionChanged, {id = targetId})
end

function LuaMemberDataManager:RefreshAddExpValue()
  local curLevel = self:GetMemberLevle()
  local curAddExpNum = 0
  local tbl = ClientTable.cfg_MemberManager:TryGetValue(curLevel)
  if tbl then
    curAddExpNum = tbl.experienceRate / 10000
  end
  if self.addExpNum ~= curAddExpNum then
    self.addExpNum = curAddExpNum
    EventManager.Dispatch(Event.MemberAddExpChange, {value = curAddExpNum})
  end
end

function LuaMemberDataManager:RefreshExpCountData(data)
  self.buyExpCountData = data
  EventManager.Dispatch(Event.MemberBuyExpCountChanged)
end

function LuaMemberDataManager:ProcessDailyRewardData(tbl)
  self.dailiyRewardIdList = tbl
end

function LuaMemberDataManager:ProcessSrcRewardData(idList)
  local curState
  local isRefreshReward = false
  self.RewardList = idList
  if idList then
    table.sort(self.RewardList, function(l, f)
      if l and f then
        return f < l
      end
      return false
    end)
  end
  for i, v in pairs(self:MemberMaxStarByGroupDic()) do
    if self:SrcStateByMemberGroupDic()[i] == nil then
      self:SrcStateByMemberGroupDic()[i] = self:GetVipRewardStateByGroup(i)
    else
      curState = self:GetVipRewardStateByGroup(i)
      if curState ~= self:SrcStateByMemberGroupDic()[i] then
        isRefreshReward = true
        self:SrcStateByMemberGroupDic()[i] = curState
      end
    end
  end
  if isRefreshReward then
    EventManager.Dispatch(Event.MemberRewardChanged)
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.member
  })
end

function LuaMemberDataManager:ProcessTaskData(taskInfo, isRefresh)
  local task
  if not isRefresh then
    if self.lastTaskList ~= nil then
      for i, v in pairs(self.lastTaskList) do
        task = self:GetTaskItemBytaskId(v.taskId)
        task.state = EMemberTaskState.finish
      end
    end
    self.lastTaskList = taskInfo
  end
  for i, v in pairs(taskInfo) do
    task = self:GetTaskItemBytaskId(v.taskId)
    task.curNum = v.process
    task.state = v.state
  end
end

function LuaMemberDataManager:ProcessDailyTaskData(taskInfo, isRefresh)
  if self.curDailyTaskDic == nil then
    self.curDailyTaskDic = {}
  end
  local keyList = self:GetcurDailyTaskDicKeyList()
  for i, v in pairs(taskInfo) do
    keyList[v.taskId] = nil
    if self.curDailyTaskDic[v.taskId] == nil then
      self.curDailyTaskDic[v.taskId] = self:NewDailyMemberTaskDataItem(v)
    end
    self.curDailyTaskDic[v.taskId].curNum = v.finishNum
  end
  for i, v in pairs(keyList) do
    self.curDailyTaskDic[i] = nil
  end
end

function LuaMemberDataManager:GetcurDailyTaskDicKeyList()
  if self.curDailyTaskDic == nil then
    return {}
  end
  local keyList = {}
  for i, v in pairs(self.curDailyTaskDic) do
    keyList[i] = true
  end
  return keyList
end

function LuaMemberDataManager:NewMemberTaskDataItem(memberTaskId)
  local taskTbl = {
    taskId = 0,
    taskStr = "",
    targetNum = 0,
    curNum = 0,
    state = EMemberTaskState.finish,
    allWay = {}
  }
  local tbl = ClientTable.cfg_Member_taskManager:TryGetValue(memberTaskId)
  if tbl then
    taskTbl.taskId = tbl.id
    taskTbl.taskStr = tbl.taskdes
    if tbl.openWay then
      local way = {}
      way.type = tbl.openWay
      if not string.isNullOrEmpty(tbl.param1) then
        way.main = tonumber(tbl.param1)
      end
      if not string.isNullOrEmpty(tbl.param2) then
        way.param = TableParse:SplitStringToStrList(tbl.param2, "#")
      end
      table.insert(taskTbl.allWay, way)
    end
  end
  return taskTbl
end

function LuaMemberDataManager:NewDailyMemberTaskDataItem(VipMemberDailyTask)
  local taskTbl = {
    taskId = 0,
    taskStr = "",
    targetNum = 0,
    curNum = 0,
    vipExp = 0,
    allWay = {},
    sort = 99999999,
    tbl = nil
  }
  local tbl = ClientTable.cfg_Member_taskManager:TryGetValue(VipMemberDailyTask.taskId)
  if tbl == nil then
    logError("D\225\187\175 li\225\187\135u taskId trong RolePackage.VipMemberDailyTask t\225\187\171 m\195\161y ch\225\187\167:" .. VipMemberDailyTask.taskId .. "Kh\195\180ng t\195\172m th\225\186\165y trong b\225\186\163ng cfg_Member_task")
  end
  if tbl then
    local vipExp = 1
    if tbl.vipExp ~= nil then
      local strs = string.split(tbl.vipExp, "#")
      if strs ~= nil and #strs == 2 then
        vipExp = tonumber(strs[2])
      end
    end
    taskTbl.taskId = tbl.id
    taskTbl.taskStr = tbl.taskdes
    taskTbl.vipExp = vipExp
    taskTbl.curNum = VipMemberDailyTask.finishNum
    local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(tbl.count)
    if countTbl ~= nil then
      taskTbl.targetNum = countTbl.refreshCountLimit
    end
    taskTbl.tbl = tbl
    taskTbl.sort = tbl.sort
    if tbl.openWay then
      local way = {}
      way.type = tbl.openWay
      if not string.isNullOrEmpty(tbl.param1) then
        way.main = tonumber(tbl.param1)
      end
      if not string.isNullOrEmpty(tbl.param2) then
        way.param = TableParse:SplitStringToStrList(tbl.param2, "#")
      end
      table.insert(taskTbl.allWay, way)
    end
  end
  return taskTbl
end

function LuaMemberDataManager:NewMemberBuyInfo(memberTaskId)
  local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(memberTaskId)
  if memberTbl == nil then
    return nil
  end
  local temp = {}
  temp.id = memberTbl.id
  temp.type = memberTbl.buyMethod
  temp.shopId = memberTbl.shopId
  temp.name = memberTbl.name
  return temp
end

function LuaMemberDataManager:NewMemberDataItem(tbl)
  local temp = {}
  temp.id = tbl.id
  temp.nextId = tbl.nextLevel
  temp.group = tbl.vipLevel
  temp.star = tbl.starnum
  temp.needExp = tbl.vipExp
  return temp
end

function LuaMemberDataManager:GetMeetPageInfoList()
  local pageTbl = {}
  self.ShowMaxGroup = 0
  self.viewMaxId = 0
  local ids
  for k, v in pairs(self:PageInfoList()) do
    if string.isNullOrEmpty(v.condition) or ConditionManager.Check4D(v.condition) then
      table.insert(pageTbl, v)
      if self.ShowMaxGroup < v.group then
        self.ShowMaxGroup = v.group
        ids = self:MemberIdsByGroupDic()[v.group]
        if ids and next(ids) then
          self.viewMaxId = ids[table.count(ids)].id
        end
      end
    end
  end
  return pageTbl
end

function LuaMemberDataManager:GetFirstPageGroup()
  for k, v in pairs(self:MemberIdsByGroupDic()) do
    if self:GetVipRewardStateByGroup(k) == EMemberRewardState.Get then
      return k
    end
  end
  if self:GetCurMemberGroup() >= self.ShowMaxGroup then
    return self.ShowMaxGroup
  end
  if self:GetCurMemberStar() ~= self:GetMaxMemberStarByGroup(self:GetCurMemberGroup()) then
    return self:GetCurMemberGroup()
  end
  return self:GetCurMemberGroup() + 1
end

function LuaMemberDataManager:GetMemberSrcStateByGroup(group)
  if self:GetCurMemberStar() == 0 then
    return group == self:GetCurMemberGroup() and EMemberSrcState.UnLock or EMemberSrcState.Lock
  elseif self:GetCurMemberStar() == self:GetMaxMemberStarByGroup(self:GetCurMemberGroup()) then
    return group - self:GetCurMemberGroup() <= 1 and EMemberSrcState.UnLock or EMemberSrcState.Lock
  end
  return group - self:GetCurMemberGroup() < 1 and EMemberSrcState.UnLock or EMemberSrcState.Lock
end

function LuaMemberDataManager:GetSrcBuyStateByGroup(group)
  return group > self:GetCurMemberGroup() and EMemberBuyState.CanBuy or EMemberBuyState.Bought
end

function LuaMemberDataManager:GetMemberGroupById(id)
  if id and self:MemberDataItemById()[id] then
    return self:MemberDataItemById()[id].group
  end
  return 0
end

function LuaMemberDataManager:GetNextLevelMemberGroup()
  return self:GetMemberGroupById(self:GetNextMemberLevel())
end

function LuaMemberDataManager:GetFirstLevelByGroup(Group)
  local ids = self:GetIdListByGroup(Group)
  if ids and next(ids) then
    return ids[1].id
  end
  return 0
end

function LuaMemberDataManager:GetLastLevelByGroup(Group)
  local ids = self:GetIdListByGroup(Group)
  if ids and next(ids) then
    return ids[table.count(ids)].id
  end
  return 0
end

function LuaMemberDataManager:GetCurIdListByGroup()
  return self:MemberIdsByGroupDic()[self:GetCurMemberGroup()]
end

function LuaMemberDataManager:GetCurGroupDetailedInfo()
  local groupInfo = {}
  local CurIdListByGroup = self:GetCurIdListByGroup()
  if CurIdListByGroup ~= nil then
    for i, v in pairs(CurIdListByGroup) do
      local groupItem = LuaMemberDataManager:GetGroupItemDetailedInfo(v.id)
      if groupItem ~= nil and groupItem.starnum ~= 0 then
        table.insert(groupInfo, groupItem)
      end
    end
  end
  return groupInfo
end

function LuaMemberDataManager:GetCurGroupDetailedTipsDes(starnum)
  local dataList = self:GetCurGroupDetailedInfo()
  local str = ""
  for i, v in pairs(dataList) do
    if v.starnum == starnum then
      str = str .. v.nowTable.tips2 .. "\r\n"
    end
  end
  return str
end

function LuaMemberDataManager:GetGroupItemDetailedInfo(id)
  local nowmem = ClientTable.cfg_MemberManager:TryGetValue(id)
  if nowmem ~= nil then
    local groupItem = {
      name = nowmem.name,
      starnum = nowmem.starnum,
      vipLevel = nowmem.vipLevel,
      nowTable = nowmem
    }
    return groupItem
  end
  return nil
end

function LuaMemberDataManager:GetIdListByGroup(group)
  return self:MemberIdsByGroupDic()[group]
end

function LuaMemberDataManager:GetMemberStarById(id)
  if id and self:MemberDataItemById()[id] then
    return self:MemberDataItemById()[id].star
  end
  return 0
end

function LuaMemberDataManager:GetNextMemberStar()
  return self:GetMemberStarById(self:GetNextMemberLevel())
end

function LuaMemberDataManager:GetMaxMemberStarByGroup(group)
  return self:MemberMaxStarByGroupDic()[group]
end

function LuaMemberDataManager:GetDailyRewardStateByGroup(group)
  if self.dailiyRewardIdList ~= nil then
    for i, v in pairs(self.dailiyRewardIdList) do
      if v == group then
        return EMemberRewardState.Geted
      end
    end
  end
  if group > self:GetCurMemberGroup() or self:GetCurMemberGroup() == 0 then
    return EMemberRewardState.NotGet
  end
  return EMemberRewardState.Get
end

function LuaMemberDataManager:GetVipRewardStateByGroup(group)
  if self:GetCurMemberStar() == 0 then
    return EMemberRewardState.NotGet
  end
  if self.RewardList ~= nil then
    for i, v in pairs(self.RewardList) do
      if v == group then
        return EMemberRewardState.Geted
      end
    end
  end
  if group == self:GetCurMemberGroup() and self:GetCurMemberStar() ~= self:GetMaxMemberStarByGroup(self:GetCurMemberGroup()) then
    return EMemberRewardState.NotGet
  elseif group > self:GetCurMemberGroup() then
    return EMemberRewardState.NotGet
  end
  return EMemberRewardState.Get
end

function LuaMemberDataManager:TryGetRewardByMemberId(memberId)
  if self.mRewardDic == nil then
    self.mRewardDic = {}
  end
  if self.mRewardDic[memberId] == nil then
    self.mRewardDic[memberId] = self:GetRewardByMemberId(memberId)
  end
  return self.mRewardDic[memberId]
end

function LuaMemberDataManager:TryGetDailyRewardByMemberId(memberId)
  if self.mDailyRewardDic == nil then
    self.mDailyRewardDic = {}
  end
  if self.mDailyRewardDic[memberId] == nil then
    self.mDailyRewardDic[memberId] = self:GetRewardByMemberId(memberId, EMemberRewarType.DailyReward)
  end
  return self.mDailyRewardDic[memberId]
end

function LuaMemberDataManager:GetRewardByMemberId(id, rewarType)
  local result = {}
  local tbl = ClientTable.cfg_MemberManager:TryGetValue(id)
  if tbl ~= nil then
    local boxTbl = ClientTable.cfg_Box_boxManager:GetDic()
    for k, v in pairs(boxTbl) do
      local reward = tbl.reward
      if rewarType == EMemberRewarType.DailyReward then
        reward = tonumber(tbl.dailyReward)
      end
      if v.boxId == reward then
        table.insert(result, {
          itemId = v.itemId,
          count = v.count,
          param = v.layer
        })
      end
    end
  end
  table.sort(result, function(a, b)
    if a and b then
      return a.param < b.param
    end
    return false
  end)
  return result
end

function LuaMemberDataManager:GetTaskItemByLevel(level)
  local tbl = {}
  if level ~= nil then
    local IdTbl = self:AllTaskIdListByLevelDic()[level]
    if IdTbl ~= nil then
      for i, v in pairs(IdTbl) do
        local temp = self:GetTaskItemBytaskId(v)
        table.insert(tbl, temp)
      end
    end
  end
  return tbl
end

function LuaMemberDataManager:GetMemberTaskGoalTempByTaskId(taskGoalId)
  if taskGoalId == nil then
    return nil
  end
  if self.AllMemberTaskGoal == nil then
    self.AllMemberTaskGoal = {}
  end
  if self.AllMemberTaskGoal[taskGoalId] == nil then
    self.AllMemberTaskGoal[taskGoalId] = TaskGoal(taskGoalId)
  end
  return self.AllMemberTaskGoal[taskGoalId]
end

function LuaMemberDataManager:GetTaskItemBytaskId(taskId)
  local tbl = self:AllMemberTaskDic()[taskId]
  if tbl == nil then
    tbl = self:NewMemberTaskDataItem(taskId)
    self:AllMemberTaskDic()[taskId] = tbl
  end
  return tbl
end

function LuaMemberDataManager:CardInfo(_indexer, _info)
  if self.mCardInfo == nil then
    self.mCardInfo = {}
  end
  if _indexer == IndexerEnum.get then
    return self.mCardInfo
  elseif _indexer == IndexerEnum.set then
    if _info.privilegeCardData then
      self.mCardInfo.privilegeCardData = _info.privilegeCardData
    end
    if _info.memberCardData then
      self.mCardInfo.memberCardData = _info.memberCardData
    end
  end
end

function LuaMemberDataManager:CardType(_indexer, _cardType)
  if _indexer == IndexerEnum.get then
    return self.mCardType
  elseif _indexer == IndexerEnum.set then
    self.mCardType = _cardType
  end
end

function LuaMemberDataManager:CheckMax()
  return self:GetMemberLevle() >= self.maxId or self.viewMaxId ~= nil and self:GetMemberLevle() >= self.viewMaxId
end

function LuaMemberDataManager:GetAddExp()
  return self.addExpNum or 0
end

function LuaMemberDataManager:GetCurCfgSetting()
  local mCardInfo = self:CardInfo(IndexerEnum.get)
  local mCardType = self:CardType(IndexerEnum.get)
  local cfg_memberSetting
  if mCardType == ExpiredTypeEnum.MemberCard and mCardInfo and mCardInfo.memberCardData and table.count(mCardInfo.memberCardData) > 0 then
    cfg_memberSetting = mCardInfo.memberCardData
  end
  if mCardType == ExpiredTypeEnum.PrivilegeCard and mCardInfo and mCardInfo.privilegeCardData and 0 < table.count(mCardInfo.privilegeCardData) then
    cfg_memberSetting = mCardInfo.privilegeCardData
  end
  return cfg_memberSetting
end

function LuaMemberDataManager:GetMemberCurBuyInfo()
  local id = self:GetNextMemberLevel()
  if self:MemberBuyInfoDic()[id] == nil then
    self:MemberBuyInfoDic()[id] = self:NewMemberBuyInfo(id)
  end
  return self:MemberBuyInfoDic()[id]
end

function LuaMemberDataManager:GetTimeEndTipsData()
  if self.TimeEndTipsData == nil then
    self.TimeEndTipsData = {}
    local memberSetTbl = ClientTable.cfg_Member_settingManager:TryGetValue(1)
    if memberSetTbl then
      self.TimeEndTipsData.itemId = tonumber(memberSetTbl.param1)
    end
    memberSetTbl = ClientTable.cfg_Member_settingManager:TryGetValue(2)
    if memberSetTbl then
      self.TimeEndTipsData.spriteName = memberSetTbl.param1
    end
  end
  return self.TimeEndTipsData
end

function LuaMemberDataManager:GetWarAllianceDes()
  if self.WarAllianceDes == nil then
    self.WarAllianceDes = {}
    self.WarAllianceDes.title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_1")
    self.WarAllianceDes.content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("warAllianceJoin_text")
    self.WarAllianceDes.okText = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("warAllianceJoin_btn")
  end
  return self.WarAllianceDes
end

function LuaMemberDataManager:IsHideDownTips()
  if self:GetMemberLevle() ~= 0 and self:GetMemberLevle() == self:GetTemporaryMemberLevle() then
    return true
  end
  return 0 < self:GetTemporaryMemberLevle()
end

function LuaMemberDataManager:GetMemberStrByGroup(group)
  if self.mMemberStrByGroup == nil then
    self.mMemberStrByGroup = {}
  end
  if self.mMemberStrByGroup[group] == nil then
    self.mMemberStrByGroup[group] = Localization.GetUIWord("Newmember_name_" .. group)
  end
  return self.mMemberStrByGroup[group]
end

function LuaMemberDataManager:GetMemberStrByGroupTxt(group)
  if self.mMemberStrByGroupTex == nil then
    self.mMemberStrByGroupTex = {}
  end
  if self.mMemberStrByGroupTex[group] == nil then
    self.mMemberStrByGroupTex[group] = Localization.GetUIWord("Newmember_name_txt_" .. group)
  end
  return self.mMemberStrByGroupTex[group]
end

function LuaMemberDataManager:CalculateMemberNextLevel()
  if self:GetMemberLevle() == 0 then
    local nextIds = self:MemberIdsByGroupDic()[1]
    if nextIds and next(nextIds) then
      return nextIds[1].id
    end
    return 0
  end
  if self:CheckMax() then
    return 0
  end
  if self:MemberDataItemById()[self:GetMemberLevle()] then
    return self:MemberDataItemById()[self:GetMemberLevle()].nextId
  end
  return 0
end

function LuaMemberDataManager:JumpMemberUIById(id)
  if id == nil then
    return
  end
  local group = self:GetMemberGroupById(id)
  self:JumpMemberUIByGroup(group)
end

function LuaMemberDataManager:JumpMemberUIByGroup(group)
  if group then
    UIManager.Show(UIID.Vip_NewMemberMainUI, {
      openFirstTab = EMemberViewType.Member,
      openSecondTab = group
    })
  end
end

function LuaMemberDataManager:IsShowRedPoint(redPointId)
  local memberGroup = self:RedPointInfoDic()[redPointId]
  return self:IsShowRedPoint_Group(memberGroup)
end

function LuaMemberDataManager:IsShowRedPoint_Group(memberGroup)
  if memberGroup then
    return self:GetMemberSrcStateByGroup(memberGroup) == EMemberSrcState.UnLock and self:SrcStateByMemberGroupDic()[memberGroup] and self:SrcStateByMemberGroupDic()[memberGroup] == EMemberRewardState.Get
  end
  return false
end

function LuaMemberDataManager:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return LuaMemberDataManager
