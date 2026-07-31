Activity_LuoLanSiegeData = {}
local this = Activity_LuoLanSiegeData
this.siegeData = {}
this.unionWinData = {}
this.rewardWinBoyData = {}
this.rewardFailBoyData = {}
this.rewardWinBossData = {}
this.rewardWinAuctionData = {}
this.rewardFailAuctionData = {}
this.rewardFirScoreData = {}
this.rewardSecScoreData = {}
this.rewardThirdScoreData = {}
this.rewardFourthRewardScoreData = {}
this.rewardFifthRewardScoreData = {}
this.rewardSixthRewardScoreData = {}
this.rewardSeventhRewardScoreData = {}
this.endLimitTimeUnix = 0
this.unionMap = {}
this.activityStatus = ActivityStatusEnum.INIT
this.holdUnionId = 0
this.preHoldUnionId = 0
this.curHaveUnionId = 0
this.preHaveUnionId = 0
this.unionScoreRank = {}
this.myUnionScoreRank = nil
this.personalScoreRank = {}
this.myPersonalScoreRank = nil
this.monsters = nil
this.tipsCellMap = {}
this.attackTargetData = {}
this.defendTargetData = {}

function Activity_LuoLanSiegeData.Init()
  this.InitShowTipCellPos()
  this.InitUnionRewardData()
  this.InitTargetData()
end

function Activity_LuoLanSiegeData.InitTargetData()
  this.attackTargetData = {}
  this.defendTargetData = {}
  local siegeTargetData = ClientTable.cfg_Activity_siegeManager:GetDic()
  for i, v in pairs(siegeTargetData) do
    if v.id < 2000 then
      this.attackTargetData[#this.attackTargetData + 1] = {isComplete = false}
      this.attackTargetData[#this.attackTargetData].targetList = this.GetTargetList(v, "attack")
    end
    if v.id >= 2000 then
      this.defendTargetData[#this.defendTargetData + 1] = {isComplete = true}
      this.defendTargetData[#this.defendTargetData].targetList = this.GetTargetList(v, "defend")
    end
  end
  table.sort(this.attackTargetData, function(a, b)
    return a.targetList[1].warChapter < b.targetList[1].warChapter
  end)
end

function Activity_LuoLanSiegeData.GetTargetList(targetData, fightType)
  local targetList = {}
  local targetStr = targetData.target
  if targetStr ~= "" then
    targetStr = string.split(targetStr, "#")
    for i = 1, #targetStr do
      targetList[i] = {
        targetId = targetStr[i] and tonumber(targetStr[i]) or 0,
        transferId = type(targetData.walkto) == "table" and targetData.walkto[i] or targetData.walkto,
        desc = targetData.desc,
        fightType = fightType,
        warChapter = targetData.warChapter
      }
    end
  else
    targetList[1] = {
      targetId = targetStr[1] and tonumber(targetStr[1]) or 0,
      transferId = type(targetData.walkto) == "table" and targetData.walkto[1] or targetData.walkto,
      desc = targetData.desc,
      fightType = fightType,
      warChapter = targetData.warChapter
    }
  end
  return targetList
end

function Activity_LuoLanSiegeData.UpdateTargetState()
  if this.holdUnionId ~= 0 and RoleManager.me.unionId == this.holdUnionId then
    this.UpdateDefendTarget()
  else
    this.UpdateAttackTarget()
  end
end

function Activity_LuoLanSiegeData.UpdateAttackTarget()
  for i = 1, #this.attackTargetData do
    local targetList = this.attackTargetData[i].targetList
    for k = 1, #targetList do
      local targetId = targetList[k].targetId
      if targetId ~= 0 then
        local siegeTargetStr = ClientTable.cfg_Activity_globalManager:TryGetValue(targetId).effect
        local siegeTargetData = string.split(siegeTargetStr, "#")
        local res = this.IsAliveOnCellMonster(tonumber(siegeTargetData[1]), tonumber(siegeTargetData[2]), tonumber(siegeTargetData[3]))
        this.attackTargetData[i].isComplete = not res
        if not res then
          break
        end
      end
    end
  end
end

function Activity_LuoLanSiegeData.UpdateDefendTarget()
  for i = 1, #this.defendTargetData do
    local targetList = this.defendTargetData[i].targetList
    for k = 1, #targetList do
      local targetId = targetList[k].targetId
      if targetId ~= 0 then
        local siegeTargetStr = ClientTable.cfg_Activity_globalManager:TryGetValue(targetId).effect
        local siegeTargetData = string.split(siegeTargetStr, "#")
        local res = this.IsAliveOnCellMonster(tonumber(siegeTargetData[1]), tonumber(siegeTargetData[2]), tonumber(siegeTargetData[3]))
        this.defendTargetData[i].isComplete = res
        if not res then
          break
        end
      end
    end
  end
end

function Activity_LuoLanSiegeData.GetUnCompleteAttackTarget()
  for i = 1, #this.attackTargetData do
    if not this.attackTargetData[i].isComplete then
      local list = {
        this.attackTargetData[i].targetList[1]
      }
      return list
    end
  end
end

function Activity_LuoLanSiegeData.GetUnCompleteDefendTarget()
  for i = 1, #this.defendTargetData do
    if this.defendTargetData[i].isComplete then
      local list = {
        this.defendTargetData[i].targetList[1]
      }
      return list
    end
  end
end

function Activity_LuoLanSiegeData.InitData(msg)
  this.siegeData = msg.gongCheng
  this.activityStatus = this.siegeData.state
  this.preHoldUnionId = this.holdUnionId
  this.preHaveUnionId = this.curHaveUnionId
  this.holdUnionId = this.siegeData.holdUnionId
  this.curHaveUnionId = this.siegeData.curHaveUnionId
  this.monsters = this.siegeData.monsters
  if this.holdUnionId and this.holdUnionId ~= 0 and this.preHoldUnionId ~= this.holdUnionId then
    this.SetCurOccupationUnionLogo()
  end
  if this.curHaveUnionId and this.curHaveUnionId ~= 0 and this.curHaveUnionId ~= this.holdUnionId then
    if this.curHaveUnionId ~= this.preHaveUnionId then
      if UIManager.IsVisible(UIID.Activity_SiegeProgressUI) then
        EventManager.Dispatch(Event.RefreshSiegeProcess)
      else
        UIManager.Show(UIID.Activity_SiegeProgressUI)
      end
    end
  else
    UIManager.Hide(UIID.Activity_SiegeProgressUI)
  end
  if this.IsActivityOpen() then
    Activity_SiegeManager.UpdateHalo(this.holdUnionId, this.curHaveUnionId, RoleManager.me.unionId)
    if not UIManager.IsVisible(UIID.Activity_SiegefortTaskUI) then
      EventManager.Dispatch(Event.EnterSiege)
      RoleManager.RefreshHeadColor()
      BlockBuildManager.RefreshUnionBlockBuilding()
    end
    Activity_SiegeManager.SiegePrefabLoad()
  else
    EventManager.Dispatch(Event.QuitSiege)
  end
  this.UpdateTargetState()
  EventManager.Dispatch(Event.RefreshSiegeTask)
  if this.preHoldUnionId ~= this.holdUnionId then
    RoleManager.RefreshHeadColor()
    BlockBuildManager.RefreshUnionBlockBuilding()
  end
end

function Activity_LuoLanSiegeData.InitShowTipCellPos()
  local tipPos = ClientTable.cfg_Activity_globalManager:TryGetValue(100362, "id").effect
  tipPos = string.split(tipPos, "#")
  this.tipsCellMap = {}
  for i = 1, #tipPos do
    this.tipsCellMap[tipPos[i]] = true
  end
end

function Activity_LuoLanSiegeData.IsShowTipsPos(cellPos)
  if this.tipsCellMap[cellPos] and not this.IsDefeatAllDefendStatues() and RoleManager.me.unionId ~= this.holdUnionId then
    return true
  else
    return false
  end
end

function Activity_LuoLanSiegeData.IsDefeatAllDefendStatues()
  if this.monsters then
    for i, v in pairs(this.monsters) do
      if v.configId == 103100002 and v.hp > 0 then
        return false
      end
    end
  end
  return true
end

function Activity_LuoLanSiegeData.GetMonsterByCell(monsterId, x, y)
  if not this.monsters then
    return
  end
  for i, v in pairs(this.monsters) do
    if v.configId == monsterId and v.x == x and v.y == y then
      return v
    end
  end
end

function Activity_LuoLanSiegeData.IsAliveOnCellMonster(monsterId, x, y)
  if this.monsters then
    for i, v in pairs(this.monsters) do
      if v.configId == monsterId and v.x == x and v.y == y and v.hp > 0 then
        return true
      end
    end
  end
  return false
end

function Activity_LuoLanSiegeData.InitUnionWinData(msg)
  for i, v in ipairs(msg.members) do
    if v.roleSummaryInfo.name == ViewData.meData.name and v.roleSummaryInfo.id == ViewData.meData.id then
      v.roleSummaryInfo.equips = ViewData.meData.equipsData.Data
      v.roleSummaryInfo.appear = ForgeData.appearData[RoleManager.me.id]
    end
  end
  this.unionWinData = msg
  UIManager.Show(UIID.Activity_SiegeUI)
end

function Activity_LuoLanSiegeData.GetUnionWinMember()
  return Activity_LuoLanSiegeData.unionWinData and Activity_LuoLanSiegeData.unionWinData.members
end

function Activity_LuoLanSiegeData.ProcessRewardItem(rewardStr, itemTable)
  local function ProcessItemData(itemStr)
    local items = string.split(itemStr, "#")
    
    local item = ItemUtility.GenerateItemData(tonumber(items[1]))
    item.count = tonumber(items[2])
    return item
  end
  
  local reward = string.split(rewardStr, "&")
  for i, v in ipairs(reward) do
    itemTable[#itemTable + 1] = ProcessItemData(v)
  end
end

function Activity_LuoLanSiegeData.InitUnionRewardData()
  this.unionWinData = {}
  this.rewardWinBoyData = {}
  this.rewardFailBoyData = {}
  this.rewardWinBossData = {}
  this.rewardWinAuctionData = {}
  this.rewardFailAuctionData = {}
  this.rewardFirScoreData = {}
  this.rewardSecScoreData = {}
  this.rewardThirdScoreData = {}
  this.rewardFourthRewardScoreData = {}
  this.rewardFifthRewardScoreData = {}
  this.rewardSixthRewardScoreData = {}
  this.rewardSeventhRewardScoreData = {}
  local rewardWinBoy = ClientTable.cfg_Activity_globalManager:TryGetValue(100343, "id").effect
  local rewardBoss = ClientTable.cfg_Activity_globalManager:TryGetValue(100344, "id").effect
  local rewardWinAuction = ClientTable.cfg_Activity_globalManager:TryGetValue(100346, "id").effect
  local rewardLostBoy = ClientTable.cfg_Activity_globalManager:TryGetValue(100345, "id").effect
  local rewardLostAuction = ClientTable.cfg_Activity_globalManager:TryGetValue(100363, "id").effect
  this.ProcessRewardItem(rewardWinBoy, this.rewardWinBoyData)
  this.ProcessRewardItem(rewardBoss, this.rewardWinBossData)
  this.ProcessRewardItem(rewardWinAuction, this.rewardWinAuctionData)
  this.ProcessRewardItem(rewardLostBoy, this.rewardFailBoyData)
  this.ProcessRewardItem(rewardLostAuction, this.rewardFailAuctionData)
  local firReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100301, "id").showReward
  local secReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100302, "id").showReward
  local thirdReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100303, "id").showReward
  local fourthReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100304, "id").showReward
  local fifthReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100305, "id").showReward
  local sixthReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100306, "id").showReward
  local seventhReward = ClientTable.cfg_Activity_rankRewardManager:TryGetValue(100307, "id").showReward
  this.ProcessRewardItem(firReward, this.rewardFirScoreData)
  this.ProcessRewardItem(secReward, this.rewardSecScoreData)
  this.ProcessRewardItem(thirdReward, this.rewardThirdScoreData)
  this.ProcessRewardItem(fourthReward, this.rewardFourthRewardScoreData)
  this.ProcessRewardItem(fifthReward, this.rewardFifthRewardScoreData)
  this.ProcessRewardItem(sixthReward, this.rewardSixthRewardScoreData)
  this.ProcessRewardItem(seventhReward, this.rewardSeventhRewardScoreData)
end

function Activity_LuoLanSiegeData.InitScoreData(msg)
  this.unionScoreRank = msg and msg.rankList or {}
  this.myUnionScoreRank = msg and msg.myRank or nil
  this.personalScoreRank = msg and msg.playerRankList or {}
  this.myPersonalScoreRank = msg and msg.mypRank or nil
  EventManager.Dispatch(Event.RefreshSiegeRank)
end

function Activity_LuoLanSiegeData.InitUnionData(msg)
  if not msg then
    return
  end
  this.unionMap = {}
  for i, v in ipairs(msg.activityUnion) do
    this.unionMap[v.unionId] = v
  end
end

function Activity_LuoLanSiegeData.GetUnionByUnionId(unionId)
  return this.unionMap[unionId]
end

function Activity_LuoLanSiegeData.IsActivityOpen()
  return this.activityStatus == ActivityStatusEnum.RUNNING
end

function Activity_LuoLanSiegeData.IsWinUnionAreMeUnion()
  return this.holdUnionId ~= 0 and this.holdUnionId == RoleManager.me.unionId
end

function Activity_LuoLanSiegeData.GetCurOccupationUnion()
  return this.unionMap[this.siegeData.curHaveUnionId]
end

function Activity_LuoLanSiegeData.SetCurOccupationUnionLogo()
  local texture = Texture2D(10, 18)
  local holdUnionLogo = WarAllianceData.GetUnionLogoById(this.holdUnionId)
  if table.count(holdUnionLogo) <= 0 then
    texture:Apply()
    CS.Framework.FlagMaterialChangeEvent.SetWarAllianceTexture(texture)
    CS.Framework.FlagMaterialChangeEvent.UpdateAllFlagMaterial()
    return
  end
  local armbandColorData = {}
  local num = WarAllianceData.ArmbandsDesignGridNum
  for i = 1, num do
    table.insert(armbandColorData, i, holdUnionLogo[i])
  end
  local index = 0
  for j = 18, 1, -1 do
    for i = 1, 10 do
      if 5 < j and j < 14 and 1 < i and i < 10 then
        index = index + 1
        local logoNum = ColorUtility.IntToColor(armbandColorData[index])
        texture:SetPixel(i - 1, j - 1, logoNum)
      else
        texture:SetPixel(i - 1, j - 1, Color(1, 1, 1, 1))
      end
    end
  end
  texture:Apply()
  CS.Framework.FlagMaterialChangeEvent.SetWarAllianceTexture(texture)
  CS.Framework.FlagMaterialChangeEvent.UpdateAllFlagMaterial()
end

function Activity_LuoLanSiegeData.AddTrap(trapMsg)
  local trapData = TrapData(trapMsg)
  trapData:Init(trapMsg)
  EventManager.Dispatch(Event.Trap_OnTrapEnterView, trapData)
  return trapData
end

function Activity_LuoLanSiegeData.UpdateGongChengSafe(msg)
  EventManager.Dispatch(Event.UpdateSiegeSafeArea, msg)
end

function Activity_LuoLanSiegeData.GetOpenServerDay(compareTime)
  if compareTime <= LoginData.openServerTime then
    return 1
  end
  local openServerDay = TimeUtility.DayApartFromTwoTime(compareTime, LoginData.openServerTime) + 1
  return openServerDay
end

function Activity_LuoLanSiegeData.ArriveADayInWeek(wday, stamp)
  local curTime = stamp or Time.GetServerSecondTime()
  local date = TimeUtility.GetServerDateByTime("%A", curTime)
  local weekDay = EWeekEnum[date]
  local curWeekday = weekDay - 1
  if curWeekday <= 0 then
    curWeekday = 7
  end
  local flag = curWeekday == tonumber(wday)
  return flag
end

this.comparatorMap = {
  [900] = function(content, curTime)
    return this.GetOpenServerDay(curTime * 1000) > tonumber(content)
  end,
  [902] = function(content, curTime)
    return this.GetOpenServerDay(curTime * 1000) == tonumber(content)
  end,
  [908] = function(content, curTime)
    return TimeUtility.InTweenTimeSlot(content, curTime)
  end,
  [910] = function(content, curTime)
    local curRefreshState = this.ArriveADayInWeek(content, curTime)
    return curRefreshState
  end
}

function Activity_LuoLanSiegeData.GetNextOpenActivityTime()
  local openCondition = ClientTable.cfg_Activity_overviewManager:TryGetValue(1003, "activityId").condition
  local curTime = Time.GetServerSecondTime()
  local timeTbl = TimeUtility.GetServerDateByTime("*t", curTime)
  local curToday = TimeUtility.GetServerTimeByDateTab({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = 0,
    min = 0
  })
  this.endLimitTimeUnix = TimeUtility.GetServerTimeByDateTab({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = 0,
    min = 0
  })
  for i = 1, 7 do
    for j = 1, #openCondition do
      local condition = openCondition[j]
      local res = true
      local timeSlot
      for k = 1, #condition do
        if k ~= #condition then
          res = this.comparatorMap[condition[k][1]](condition[k][2], curToday)
          if not res then
            break
          end
        else
          timeSlot = condition[k][2]
        end
      end
      if res and i == 1 then
        local startTime, endTime = TimeUtility.GetTweenTimeSlot(timeSlot)
        local times = string.split(timeSlot, "-")
        if curTime > startTime and curTime < endTime then
          local endStr = times[2]
          local timeStrs = string.split(endStr, ":")
          this.endLimitTimeUnix = curToday
          this.endLimitTimeUnix = TimeUtility.AddHour(this.endLimitTimeUnix * 1000, tonumber(timeStrs[1]))
          this.endLimitTimeUnix = TimeUtility.AddMin(this.endLimitTimeUnix * 1000, tonumber(timeStrs[2]))
        end
        if curTime > startTime and curTime < endTime then
          local startStr = times[1]
          local timeStrs = string.split(startStr, ":")
          curToday = TimeUtility.AddHour(curToday * 1000, tonumber(timeStrs[1]))
          curToday = TimeUtility.AddMin(curToday * 1000, tonumber(timeStrs[2]))
          return curToday
        end
      elseif res then
        local times = string.split(timeSlot, "-")
        local startStr = times[1]
        local timeStrs = string.split(startStr, ":")
        curToday = TimeUtility.AddHour(curToday * 1000, tonumber(timeStrs[1]))
        curToday = TimeUtility.AddMin(curToday * 1000, tonumber(timeStrs[2]))
        return curToday
      end
    end
    curToday = TimeUtility.AddDay(curToday * 1000, 1)
  end
end

function Activity_LuoLanSiegeData.GetNextOpenActivityTimeNew()
  local openCondition = ClientTable.cfg_Activity_overviewManager:TryGetValue(1003, "activityId").condition
  local curTime = Time.GetServerSecondTime()
  local tempTime = curTime
  for i = 1, 7 do
    for j = 1, #openCondition do
      local condition = openCondition[j]
      local isMeet, timeSlot = false
      for k = 1, #condition do
        if k ~= #condition then
          isMeet = this.comparatorMap[condition[k][1]](condition[k][2], tempTime)
          if not isMeet then
            break
          end
        else
          timeSlot = condition[k][2]
        end
      end
      if isMeet and i == 1 then
        local startTime, endTime = TimeUtility.GetTweenTimeSlot(timeSlot)
        if curTime < endTime then
          return tempTime
        end
      elseif isMeet then
        return tempTime
      end
    end
    tempTime = TimeUtility.AddDay(tempTime * 1000, 1)
  end
end

this.Init()
