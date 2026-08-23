local WorldCupGuessData = {}
setmetatable(WorldCupGuessData, LuaClass.HolidayActivity)
WorldCupGuessData.singleRaceInfoList = nil
WorldCupGuessData.curId = 0

function WorldCupGuessData:Init()
  self:InitRaceData()
  self:InitHasClick()
end

function WorldCupGuessData:InitRaceData()
  if self.singleRaceInfoList == nil then
    self.singleRaceInfoList = {}
  end
  local tblDic = ClientTable.cfg_Commerce_worldcupManager:GetDic()
  for i, v in pairs(tblDic) do
    local singleRaceInfo = self:NewSingleRaceInfo(v)
    table.insert(self.singleRaceInfoList, singleRaceInfo)
  end
  table.sort(self.singleRaceInfoList, function(a, b)
    return a.id < b.id
  end)
end

function WorldCupGuessData:InitHasClick()
  local roleId = tostring(ViewData.meData.id)
  local hasClickStr = PlayerPrefs.GetString("WorldCupHasClickGift" .. roleId, "")
  if string.isNullOrEmpty(hasClickStr) then
    return
  end
  local hasClickIdList = string.split(hasClickStr, "#")
  for i, v in ipairs(hasClickIdList) do
    local id = tonumber(v)
    self:SetIsClickById(id)
  end
end

function WorldCupGuessData:NewTeamInfo(country, flag)
  local teamInfo = {}
  teamInfo.countryName = country
  teamInfo.flagSpriteName = flag
  teamInfo.score = 0
  teamInfo.result = WorldCupGuessResultType.Draw
  return teamInfo
end

function WorldCupGuessData:NewGiftInfo(reward, cost)
  local giftInfo = {}
  local rewardInfo = ParseUtility.ParseSingleCost(reward)
  giftInfo.rewardItemId = rewardInfo.itemId
  giftInfo.rewardCount = rewardInfo.count
  local costInfo = ParseUtility.ParseSingleCost(cost)
  giftInfo.costItemId = costInfo.itemId
  giftInfo.costCount = costInfo.count
  giftInfo.state = GuardRewardStateEnum.NotGet
  giftInfo.isClick = false
  return giftInfo
end

function WorldCupGuessData:NewSingleRaceInfo(tbl)
  local singleRaceInfo = {}
  singleRaceInfo.id = tbl.id
  singleRaceInfo.raceTime = tbl.time
  singleRaceInfo.guessEndTime = TimeUtility.SwitchMonthDayStamp(tbl.cutoffTime)
  singleRaceInfo.teamsInfo = {}
  local teamInfo = self:NewTeamInfo(tbl.redCountry, tbl.redCountryFlag)
  table.insert(singleRaceInfo.teamsInfo, teamInfo)
  teamInfo = self:NewTeamInfo(tbl.blueCountry, tbl.blueCountryFlag)
  table.insert(singleRaceInfo.teamsInfo, teamInfo)
  singleRaceInfo.raceResult = WorldCupGuessResultType.None
  singleRaceInfo.guessResult = WorldCupGuessResultType.None
  singleRaceInfo.giftInfo = self:NewGiftInfo(tbl.winReward, tbl.loseRewardPrice)
  singleRaceInfo.timeState = WorldCupGuessTimeState.None
  return singleRaceInfo
end

function WorldCupGuessData:RefreshDataByServerData(serverData)
  if serverData and serverData.worldCupGroupInfo then
    for i, v in ipairs(serverData.worldCupGroupInfo) do
      self:RefreshSingleRaceInfo(v)
    end
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.holidayActivity_WorldCup
    })
    EventManager.Dispatch(Event.WorldCupGuessRefresh)
  end
end

function WorldCupGuessData:RefreshSingleRaceInfo(worldCupGroupInfo)
  if worldCupGroupInfo == nil then
    return
  end
  for i, singleRaceInfo in ipairs(self:GetSingleRaceInfoList()) do
    if worldCupGroupInfo.id == singleRaceInfo.id then
      singleRaceInfo.teamsInfo[1].score = worldCupGroupInfo.red
      singleRaceInfo.teamsInfo[2].score = worldCupGroupInfo.blue
      singleRaceInfo.guessResult = worldCupGroupInfo.choice
      singleRaceInfo.raceResult = worldCupGroupInfo.result
      if singleRaceInfo.raceResult == WorldCupGuessResultType.Win then
        singleRaceInfo.teamsInfo[1].result = WorldCupGuessResultType.Win
        singleRaceInfo.teamsInfo[2].result = WorldCupGuessResultType.Lose
      elseif singleRaceInfo.raceResult == WorldCupGuessResultType.Lose then
        singleRaceInfo.teamsInfo[1].result = WorldCupGuessResultType.Lose
        singleRaceInfo.teamsInfo[2].result = WorldCupGuessResultType.Win
      else
        singleRaceInfo.teamsInfo[1].result = WorldCupGuessResultType.Draw
        singleRaceInfo.teamsInfo[2].result = WorldCupGuessResultType.Draw
      end
      if singleRaceInfo.raceResult ~= WorldCupGuessResultType.None then
        singleRaceInfo.timeState = WorldCupGuessTimeState.Announce
      elseif worldCupGroupInfo.guessingEnd then
        singleRaceInfo.timeState = WorldCupGuessTimeState.Wait
      else
        singleRaceInfo.timeState = WorldCupGuessTimeState.Guess
      end
      if worldCupGroupInfo.receiveAward then
        singleRaceInfo.giftInfo.state = GuardRewardStateEnum.Got
        break
      end
      if singleRaceInfo.timeState == WorldCupGuessTimeState.Announce and singleRaceInfo.guessResult ~= WorldCupGuessResultType.None then
        singleRaceInfo.giftInfo.state = GuardRewardStateEnum.CanGet
      end
      break
    end
  end
end

function WorldCupGuessData:IsGuessSuccess(singleRaceInfo)
  if singleRaceInfo and singleRaceInfo.raceResult ~= nil and singleRaceInfo.raceResult == singleRaceInfo.guessResult then
    return true
  end
  return false
end

function WorldCupGuessData:SetCurId(id)
  self.curId = id
end

function WorldCupGuessData:SetIsClickById(id)
  for i, singleRaceInfo in ipairs(self:GetSingleRaceInfoList()) do
    if singleRaceInfo.id == id then
      singleRaceInfo.giftInfo.isClick = true
      self:SaveClick()
      EventManager.Dispatch(Event.CallRefreshRedPoint, {
        id = ERedPointId.holidayActivity_WorldCup
      })
      EventManager.Dispatch(Event.WorldCupGuessRefresh)
      break
    end
  end
end

function WorldCupGuessData:SaveClick()
  local hasClickIdStr = ""
  for i, singleRaceInfo in ipairs(self:GetSingleRaceInfoList()) do
    if singleRaceInfo.giftInfo.isClick then
      if string.isNullOrEmpty(hasClickIdStr) then
        hasClickIdStr = tostring(singleRaceInfo.id)
      else
        hasClickIdStr = hasClickIdStr .. "#" .. tostring(singleRaceInfo.id)
      end
    end
  end
  if not string.isNullOrEmpty(hasClickIdStr) then
    local roleId = tostring(ViewData.meData.id)
    local roleIdStr = PlayerPrefs.GetString("WorldCupRoleId", "")
    if string.isNullOrEmpty(roleIdStr) then
      roleIdStr = roleId
    elseif string.isNullOrEmpty(PlayerPrefs.GetString("WorldCupHasClickGift" .. roleId, "")) then
      roleIdStr = roleIdStr .. "#" .. roleId
    end
    PlayerPrefs.SetString("WorldCupRoleId", roleIdStr)
    PlayerPrefs.SetString("WorldCupHasClickGift" .. roleId, hasClickIdStr)
  end
end

function WorldCupGuessData:GetSingleRaceInfoList()
  if self.singleRaceInfoList == nil then
    self.singleRaceInfoList = {}
  end
  return self.singleRaceInfoList
end

function WorldCupGuessData:GetCurId()
  return self.curId
end

function WorldCupGuessData:CheckRedPointState()
  for i, singleRaceInfo in ipairs(self:GetSingleRaceInfoList()) do
    if singleRaceInfo.giftInfo.state == GuardRewardStateEnum.CanGet and singleRaceInfo.giftInfo.isClick == false then
      return true
    end
  end
  return false
end

function WorldCupGuessData:ResetActivityData()
  self.curId = 0
  self.singleRaceInfoList = {}
  self:InitRaceData()
  self:InitHasClick()
  self:ClearClickSave()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_WorldCup
  })
end

function WorldCupGuessData:ClearClickSave()
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    if PlayerPrefs.HasKey("WorldCupRoleId") then
      PlayerPrefs.DeleteKey("WorldCupRoleId")
    end
    if PlayerPrefs.HasKey("WorldCupHasClickGift") then
      PlayerPrefs.DeleteKey("WorldCupHasClickGift")
    end
  end
end

return WorldCupGuessData
