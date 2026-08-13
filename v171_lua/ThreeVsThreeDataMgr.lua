local ThreeVsThreeDataMgr = {}
setmetatable(ThreeVsThreeDataMgr, LuaClass.PlayActivity)
ThreeVsThreeDataMgr._campInfoDic = nil
ThreeVsThreeDataMgr._mainPlayerCampInfo = nil
ThreeVsThreeDataMgr._enemyCampInfoList = nil
ThreeVsThreeDataMgr._playerCampInfoList = nil
ThreeVsThreeDataMgr._endTime = nil
ThreeVsThreeDataMgr._isRegistEvent = nil
ThreeVsThreeDataMgr.client = {}
ThreeVsThreeDataMgr.index = 1
ThreeVsThreeDataMgr.offlineGamerList = nil
ThreeVsThreeDataMgr.playerCampPositionInfoList = nil

function ThreeVsThreeDataMgr:EnterThreeVSThreeGame()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  self:RegistEvents()
end

function ThreeVsThreeDataMgr:ExitThreeVSThreeGame(data)
  self:ResetActivityData()
end

function ThreeVsThreeDataMgr:ResetActivityData()
  self:UnRegistAllEvents()
  self._isRegistEvent = false
  self:ResetMatchData()
  ThreeVsThreeUtility.ThreeVSThreeIsClose()
  self:ClearData()
end

function ThreeVsThreeDataMgr:ClearData()
  self._campInfoDic = nil
  self._mainPlayerCampInfo = nil
  self._enemyCampInfoList = nil
  self._isRegistEvent = nil
  self.offlineGamerList = nil
  self._playerCampInfoList = nil
  self.playerCampPositionInfoList = nil
end

function ThreeVsThreeDataMgr:RefreshPlaneInfoDataByServerData(serverData)
  if serverData == nil then
    return
  end
  self.pvpCount = serverData.pvpCount or 0
  self.buyCount = serverData.buyCount or 0
  self.score = serverData.score or 0
  self.stage = serverData.stage or 0
  self.stageLevel = serverData.stageLevel or 0
  self.joinSum = serverData.joinSum or 0
  self.victorySum = serverData.victorySum or 0
  self.doublePVP = serverData.doublePVP
  self.punishTime = serverData.punishTime
  self.punishCount = serverData.punishCount
  self.cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(self.stage, self.stageLevel)
  EventManager.Dispatch(Event.RefreshThreeVThreePlaneInfo)
end

function ThreeVsThreeDataMgr:RefreshMatchTeamDataByServerData(serverData)
  if serverData == nil then
    return
  end
  self.captainId = serverData.captainId or 0
  self.member = serverData.member or {}
  self.teamId = serverData.teamId or 0
  self.pvpType = serverData.pvpType or 1
  EventManager.Dispatch(Event.RefreshThreeVThreeMatchTeamInfo)
  if table.isNullOrEmpty(self.member) then
    EventManager.Dispatch(Event.ThreeVThreeMatchTeamDissolve)
  end
end

function ThreeVsThreeDataMgr:RefreshResultScoreDataByServerData(serverData)
  if serverData == nil or serverData.campInfo == nil or next(serverData.campInfo) == nil then
    return
  end
  local resultScoreCampInfoDic = {}
  local myResultScoreCampInfo
  local enemyResultScoreCampInfoList = {}
  for k = 1, table.count(serverData.campInfo) do
    resultScoreCampInfoDic[k] = LuaClass.CampInfo:New()
    local campInfo = resultScoreCampInfoDic[k]
    campInfo:RefreshInfo(serverData.campInfo[k])
  end
  for k, v in pairs(resultScoreCampInfoDic) do
    if v:IsContainMainPlayer() then
      myResultScoreCampInfo = v
    else
      table.insert(enemyResultScoreCampInfoList, v)
    end
  end
  local data = {
    myResultScoreCampInfo = myResultScoreCampInfo,
    enemyResultScoreCampInfoList = enemyResultScoreCampInfoList,
    winGroupType = serverData.groupType,
    competition = serverData.competition
  }
  if UIManager.IsVisible(UIID.Activity_Sport3V3Score) then
    EventManager.Dispatch(Event.RefreshThreeVThreeScoreUIInfo, data)
  else
    UIManager.Show(UIID.Activity_Sport3V3Score, {resultData = data})
  end
  EventManager.Dispatch(Event.ThreeVSThree3V3BeginBgHide, true)
end

function ThreeVsThreeDataMgr:SetOpenActivity_Sport3V3RankData(serverData)
  self.openActivity_Sport3V3RankData = serverData
end

function ThreeVsThreeDataMgr:GetOpenActivity_Sport3V3RankData(serverData)
  if self.openActivity_Sport3V3RankData == nil then
  end
  return self.openActivity_Sport3V3RankData
end

function ThreeVsThreeDataMgr:RefreshResultTipDataByServerData(serverData)
  if serverData == nil then
    return
  end
  if UIManager.IsVisible(UIID.CrossServer_IntoUI) then
    local CrossServer_IntoUI = UIManager.GetUiByName(UIID.CrossServer_IntoUI)
    if CrossServer_IntoUI then
      CrossServer_IntoUI.isRefreshSportTeam3V3Template = self:GetMatchTeamType() == 2
      if CrossServer_IntoUI.curType ~= CrossServerTabType.ThreeVsThree then
        CrossServer_IntoUI.mainTogs[CrossServer_IntoUI.curType]:SetIsOn(true)
      else
        CrossServer_IntoUI:RefreshThreeVsThreeCrossPanel()
      end
    end
  else
    UIManager.Show(UIID.CrossServer_IntoUI, {
      openFirstTab = CrossServerTabType.ThreeVsThree,
      isRefreshSportTeam3V3Template = self:GetMatchTeamType() == 2
    })
  end
  if UIManager.IsVisible(UIID.Activity_Sport3V3Rank) then
    EventManager.Dispatch(Event.RefreshThreeVThreeRankUIInfo, serverData)
  else
    UIManager.Show(UIID.Activity_Sport3V3Rank, {data = serverData})
  end
end

function ThreeVsThreeDataMgr:RefreshBattleInfo(data)
  if data.endTime == nil or data.campInfo == nil or next(data.campInfo) == nil then
    return
  end
  self._campInfoDic = {}
  self._endTime = data.endTime
  local refreshIndex = 1
  local cacheCompInfoListCount = table.count(self._campInfoDic)
  while refreshIndex <= cacheCompInfoListCount do
    self._campInfoDic[refreshIndex]:Destroy()
    refreshIndex = refreshIndex + 1
  end
  local campInfoCount = table.count(data.campInfo)
  local cacheRefreshCount = refreshIndex - 1
  for k = 1, campInfoCount do
    local compInfo
    if k > cacheRefreshCount then
      self._campInfoDic[k] = LuaClass.CampInfo:New()
    end
    compInfo = self._campInfoDic[k]
    compInfo:RefreshInfo(data.campInfo[k])
  end
  self:RefreshMainPlayerCampInfo()
  ThreeVsThreeUtility.TryOpen3V3ExpandPanel()
  self:EnterThreeVSThreeGame()
end

function ThreeVsThreeDataMgr:RefreshMainPlayerCampInfo()
  self._mainPlayerCampInfo = nil
  self._enemyCampInfoList = {}
  self._playerCampInfoList = {}
  for k, v in pairs(self._campInfoDic) do
    if v:IsContainMainPlayer() then
      self._mainPlayerCampInfo = v
      table.insert(self._playerCampInfoList, v)
    else
      table.insert(self._enemyCampInfoList, v)
    end
  end
end

function ThreeVsThreeDataMgr:RefreshSingleCampInfo(data)
  local campInfo = self:GetCampInfo(data.groupType)
  if campInfo == nil then
    return
  end
  campInfo:RefreshInfo(data)
  EventManager.Dispatch(Event.ThreeVSThreeSingleCampInfoChange, campInfo)
end

function ThreeVsThreeDataMgr:RefreshPlayerInfo(data)
  local campInfo = self:GetCampInfo(data.groupType)
  if campInfo == nil then
    return
  end
  campInfo:RefreshPlayerInfo(data)
  EventManager.Dispatch(Event.ThreeVSThreeSinglePlayerInfoChange, campInfo:GetPlayerInfo(data.id))
end

function ThreeVsThreeDataMgr:RefreshScore(data)
  local campInfo = self:GetCampInfo(data.groupType)
  if campInfo == nil then
    return
  end
  campInfo.KillNum = data.killCount
  EventManager.Dispatch(Event.ThreeVSThreeScoreChange, campInfo)
end

function ThreeVsThreeDataMgr:RefreshOfflineGamer(tblData)
  if self.offlineGamerList == nil then
    self.offlineGamerList = {}
  end
  if self.offlineGamerList[tblData.otherId] then
    return
  end
  self.offlineGamerList[tblData.otherId] = tblData
end

function ThreeVsThreeDataMgr:PlayerCampPositionInfoChange(tblData)
  if tblData.campPosition then
    if self.playerCampPositionInfoList == nil then
      self.playerCampPositionInfoList = {}
    end
    self.playerCampPositionInfoList = tblData.campPosition
  end
end

function ThreeVsThreeDataMgr:JudgmentGamerWhetherOffline(gamerId)
  if self.offlineGamerList == nil then
    return false
  end
  for k, v in pairs(self.offlineGamerList) do
    if v.otherId == gamerId then
      return v.offline
    end
  end
  return false
end

function ThreeVsThreeDataMgr:SetMatchPeopleType(matchPeopleType)
  self.matchPeopleType = matchPeopleType
end

function ThreeVsThreeDataMgr:SetMatchState(matchState)
  self.matchState = matchState
end

function ThreeVsThreeDataMgr:SetJoinMatchTime(joinMatchTime)
  self.joinMatchTime = joinMatchTime
end

function ThreeVsThreeDataMgr:SetIsNeedAfterCancelMatchReqExitTeam(isNeedAfterCancelMatchReqExitTeam)
  self.isNeedAfterCancelMatchReqExitTeam = isNeedAfterCancelMatchReqExitTeam
end

function ThreeVsThreeDataMgr:GetIsNeedAfterCancelMatchReqExitTeam()
  if self.isNeedAfterCancelMatchReqExitTeam == nil then
  end
  return self.isNeedAfterCancelMatchReqExitTeam
end

function ThreeVsThreeDataMgr:GetMeReadyState()
  if not table.isNullOrEmpty(self.member) then
    for i, v in pairs(self.member) do
      if v.id == RoleManager.me.id then
        return v.prepare
      end
    end
  end
  return false
end

function ThreeVsThreeDataMgr:GetMatchPeopleType()
  return self.matchPeopleType or 0
end

function ThreeVsThreeDataMgr:GetPunishTime()
  return self.punishTime or 0
end

function ThreeVsThreeDataMgr:GetHangUpPunishState()
  return self:GetPunishTime() > Time.GetServerTime()
end

function ThreeVsThreeDataMgr:GetPunishCount()
  return self.punishCount or 1
end

function ThreeVsThreeDataMgr:GetMatchState()
  return self.matchState or 0
end

function ThreeVsThreeDataMgr:GetJoinMatchTime()
  return self.joinMatchTime or 0
end

function ThreeVsThreeDataMgr:GetMatchRoomPlayerNum()
  return table.isNullOrEmpty(self.member) and 0 or table.count(self.member)
end

function ThreeVsThreeDataMgr:GetPvpCount()
  return self.pvpCount or 0
end

function ThreeVsThreeDataMgr:GetBuyCount()
  return self.buyCount or 0
end

function ThreeVsThreeDataMgr:GetScore()
  return self.score or 0
end

function ThreeVsThreeDataMgr:GetStage()
  return self.stage or 0
end

function ThreeVsThreeDataMgr:GetStageLevel()
  return self.stageLevel or 0
end

function ThreeVsThreeDataMgr:GetJoinSum()
  return self.joinSum or 0
end

function ThreeVsThreeDataMgr:GetVictorySum()
  return self.victorySum or 0
end

function ThreeVsThreeDataMgr:GetVictoryRate()
  local victoryCount = self:GetVictorySum()
  local joinCount = self:GetJoinSum()
  local victoryRate = joinCount == 0 and 0 or Mathf.Ceil(victoryCount / joinCount * 100)
  return victoryRate
end

function ThreeVsThreeDataMgr:GetIsDoublePVP()
  return self.doublePVP
end

function ThreeVsThreeDataMgr:GetCfgData()
  return self.cfgData
end

function ThreeVsThreeDataMgr:GetIsHaveTeam()
  return not table.isNullOrEmpty(self.member)
end

function ThreeVsThreeDataMgr:GetMatchTeamType()
  local matchTeamType = 0
  if table.isNullOrEmpty(self.member) then
    return matchTeamType
  end
  matchTeamType = table.count(self.member) <= 1 and 1 or 2
  return matchTeamType
end

function ThreeVsThreeDataMgr:GetMeIsCaptain()
  return self:GetIsHaveTeam() and self.captainId == RoleManager.me.id
end

function ThreeVsThreeDataMgr:GetMatchTeamData()
  local allPlayerInfo = {}
  if not table.isNullOrEmpty(self.member) then
    for k, player in pairs(self.member) do
      local playerInfo = {
        id = player.id,
        name = player.name,
        prepare = player.prepare,
        career = player.career,
        level = player.level,
        stage = player.stage,
        stageLevel = player.stageLevel,
        isCaptain = player.id == self.captainId,
        captainIndex = player.id == self.captainId and 1 or 0,
        headIcon = tostring(RoleUtility.GetBasicCareer(player.career)),
        fight = player.fightPower,
        cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(player.stage, player.stageLevel or 1)
      }
      table.insert(allPlayerInfo, playerInfo)
    end
  end
  if table.count(allPlayerInfo) < 3 then
    for i = 1, 3 - table.count(allPlayerInfo) do
      local playerInfo = {
        id = 0,
        name = "",
        level = "",
        prepare = false,
        isCaptain = false,
        captainIndex = 0,
        headIcon = nil
      }
      table.insert(allPlayerInfo, playerInfo)
    end
  end
  table.sort(allPlayerInfo, function(a, b)
    if a and b then
      return a.captainIndex > b.captainIndex
    end
    return false
  end)
  return allPlayerInfo
end

function ThreeVsThreeDataMgr:GetInvitablePlayerData(friendType, isSelectOnLine)
  if friendType == nil or type(friendType) ~= "number" then
    return {}
  end
  local allInvitablePlayerInfo, friendData = {}, {}
  if friendType == 1 then
    for i, v in pairs(FriendData.FriendList[FriendTypeEnum.FRIEND]) do
      if v.info.online and v.info.offline == false and not self:JudgmentGamerWhetherOffline(v.info.roleId) then
        table.insert(friendData, v.info)
      end
    end
  elseif friendType == 2 then
    for i, v in pairs(WarAllianceData.MemberList) do
      if v.mapId ~= 0 and v.id ~= RoleManager.me.id and v.offline == false and not self:JudgmentGamerWhetherOffline(v.id) then
        table.insert(friendData, v)
      end
    end
  elseif friendType == 3 then
    local nearPlayers = gameMgr:GetAvatarManager():GetAvatarByType(AvatarEnum.Player)
    for lid, v in pairs(nearPlayers) do
      if lid ~= ViewData.meData.id then
        local info = v.playerInfo and v.playerInfo.OtherAttr and v.playerInfo.OtherAttr.roundPlayerInfo and v.playerInfo.OtherAttr.roundPlayerInfo.info
        if info and info.offline == false and not self:JudgmentGamerWhetherOffline(lid) then
          local isOnSever = info.serverId ~= nil and info.serverId == ViewData.meData.serverId or info.serverId == nil
          if info.online and isOnSever then
            table.insert(friendData, info)
          end
        end
      end
    end
  end
  for k, player in pairs(friendData) do
    local playerInfo = {
      id = player.roleId or player.id,
      serverId = player.serverId or 0,
      name = player.name,
      career = player.career,
      level = player.level,
      stage = player.pvpStage,
      stageLevel = player.pvpStageLevel,
      pvpCount = player.pvpCount,
      headIcon = tostring(RoleUtility.GetBasicCareer(player.career)),
      cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(player.pvpStage, player.pvpStageLevel or 1)
    }
    table.insert(allInvitablePlayerInfo, playerInfo)
  end
  table.sort(allInvitablePlayerInfo, function(a, b)
    if a and b then
      if a.stage == b.stage then
        return a.stageLevel < b.stageLevel
      else
        return a.stage < b.stage
      end
    end
    return false
  end)
  return allInvitablePlayerInfo
end

function ThreeVsThreeDataMgr:GetInvitablePlayerAndLvData(friendType, isSelectOnLine, GreaterLv, LvAndTeam)
  if friendType == nil or type(friendType) ~= "number" then
    return {}
  end
  local allInvitablePlayerInfo, friendData = {}, {}
  if friendType == 1 then
    for i, v in pairs(FriendData.FriendList[FriendTypeEnum.FRIEND]) do
      if v.info.online and v.info.offline == false and not self:JudgmentGamerWhetherOffline(v.info.roleId) then
        table.insert(friendData, v.info)
      end
    end
  elseif friendType == 2 then
    for i, v in pairs(WarAllianceData.MemberList) do
      if v.mapId ~= 0 and v.id ~= RoleManager.me.id and v.offline == false and not self:JudgmentGamerWhetherOffline(v.id) then
        table.insert(friendData, v)
      end
    end
  elseif friendType == 3 then
    local nearPlayers = gameMgr:GetAvatarManager():GetAvatarByType(AvatarEnum.Player)
    for lid, v in pairs(nearPlayers) do
      if lid ~= ViewData.meData.id then
        local info = v.playerInfo and v.playerInfo.OtherAttr and v.playerInfo.OtherAttr.roundPlayerInfo and v.playerInfo.OtherAttr.roundPlayerInfo.info
        if info and info.offline == false and not self:JudgmentGamerWhetherOffline(lid) then
          local isOnSever = info.serverId ~= nil and info.serverId == ViewData.meData.serverId or info.serverId == nil
          if info.online and isOnSever then
            table.insert(friendData, info)
          end
        end
      end
    end
  end
  for k, player in pairs(friendData) do
    if LvAndTeam and GreaterLv then
      if GreaterLv <= player.level and QuickFind:GetTeam3V3DataMgr():CheckMenberDontHasTeam(player.roleId or player.id) then
        local playerInfo = {
          id = player.roleId or player.id,
          serverId = player.serverId or 0,
          name = player.name,
          career = player.career,
          level = player.level,
          stage = player.pvpStage,
          stageLevel = player.pvpStageLevel,
          pvpCount = player.pvpCount,
          headIcon = tostring(RoleUtility.GetBasicCareer(player.career)),
          cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(player.pvpStage, player.pvpStageLevel or 1)
        }
        table.insert(allInvitablePlayerInfo, playerInfo)
      end
    else
      local playerInfo = {
        id = player.roleId or player.id,
        serverId = player.serverId or 0,
        name = player.name,
        career = player.career,
        level = player.level,
        stage = player.pvpStage,
        stageLevel = player.pvpStageLevel,
        pvpCount = player.pvpCount,
        headIcon = tostring(RoleUtility.GetBasicCareer(player.career)),
        cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(player.pvpStage, player.pvpStageLevel or 1)
      }
      table.insert(allInvitablePlayerInfo, playerInfo)
    end
  end
  table.sort(allInvitablePlayerInfo, function(a, b)
    if a and b then
      if a.stage == b.stage then
        return a.stageLevel < b.stageLevel
      else
        return a.stage < b.stage
      end
    end
    return false
  end)
  return allInvitablePlayerInfo
end

function ThreeVsThreeDataMgr:GetCampInfo(id)
  if self._campInfoDic ~= nil then
    for k, v in pairs(self._campInfoDic) do
      if v.GroupId == id then
        return v
      end
    end
  end
end

function ThreeVsThreeDataMgr:GetEndTime()
  return self._endTime
end

function ThreeVsThreeDataMgr:GetMainPlayerCampInfo()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  return self._mainPlayerCampInfo
end

function ThreeVsThreeDataMgr:GetSingleEnemyCampInfo()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  return self._enemyCampInfoList[next(self._enemyCampInfoList)]
end

function ThreeVsThreeDataMgr:GetEnemyCampInfoList()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  return self._enemyCampInfoList
end

function ThreeVsThreeDataMgr:GetPlayerCampInfoList()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  return self._playerCampInfoList
end

function ThreeVsThreeDataMgr:GetExceptMePlayerCampInfoList()
  if ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() == false then
    return
  end
  local playerList = {}
  if self._campInfoDic then
    for i, v in pairs(self._campInfoDic) do
      for x, y in pairs(v:GetPlayerInfoList()) do
        table.insert(playerList, y)
      end
    end
  end
  return playerList
end

function ThreeVsThreeDataMgr:GetEnemyPlayerData(lid)
  local campInfo = self:GetSingleEnemyCampInfo()
  if campInfo == nil then
    return
  end
  return campInfo:GetPlayerInfo(lid)
end

function ThreeVsThreeDataMgr:GetTeammatePlayerInfo(lid)
  local campInfo = self:GetMainPlayerCampInfo()
  if campInfo == nil then
    return
  end
  return campInfo:GetPlayerInfo(lid)
end

function ThreeVsThreeDataMgr:GetCampPositionInfoList(id)
  if table.count(self.playerCampPositionInfoList) > 0 then
    for i, v in pairs(self.playerCampPositionInfoList) do
      if v.lid == id then
        return v
      end
    end
  end
end

function ThreeVsThreeDataMgr:IsEnemyPlayer(lid)
  return self:GetEnemyPlayerData(lid) ~= nil
end

function ThreeVsThreeDataMgr:IsTeammate(lid)
  return self:GetTeammatePlayerInfo(lid) ~= nil
end

function ThreeVsThreeDataMgr:IsInActivity()
  return self:GetActivityState() == ActivityStatusEnum.RUNNING and self._campInfoDic ~= nil
end

function ThreeVsThreeDataMgr:CheckIsShowRedPoint()
  return false
end

function ThreeVsThreeDataMgr:RegistEvents()
  if self._isRegistEvent == true then
    return
  end
  self._isRegistEvent = true
  self:RegistEvent(Event.Role_OnRoleEnterView, self.OnRole_OnRoleEnterViewChange, self)
  self:RegistEvent(Event.GameObject_OnGameObjectLeaveView, self.OnGameObject_OnGameObjectLeaveViewChange, self)
  self:RegistEvent(Event.OtherPlayerEnterCloaking, self.OnGameObject_OnGameObjectLeaveViewChange, self)
  self:RegistEvent(Event.OtherPlayerExitCloaking, self.OnRole_OnRoleEnterViewChange, self)
end

function ThreeVsThreeDataMgr:OnRole_OnRoleEnterViewChange(_, msg)
  if msg == nil or msg.roleType ~= ERoleType.Player then
    return
  end
  local enemyInfo = self:GetEnemyPlayerData(msg.id)
  if enemyInfo ~= nil then
    enemyInfo:EnterView()
  end
  local playerInfo = self:GetTeammatePlayerInfo(msg.id)
  if playerInfo ~= nil then
    playerInfo:EnterView()
  end
  if enemyInfo ~= nil or playerInfo ~= nil then
    local playerData = enemyInfo ~= nil and enemyInfo or playerInfo
    EventManager.Dispatch(Event.ThreeVSThreeEnemyEnterView, playerData)
  end
end

function ThreeVsThreeDataMgr:OnGameObject_OnGameObjectLeaveViewChange(_, msg)
  if msg == nil or msg.roleType ~= ERoleType.Player then
    return
  end
  local enemyInfo = self:GetEnemyPlayerData(msg.id)
  if enemyInfo ~= nil then
    enemyInfo:ExitView()
  end
  local playerInfo = self:GetTeammatePlayerInfo(msg.id)
  if playerInfo ~= nil then
    playerInfo:ExitView()
  end
  if enemyInfo ~= nil or playerInfo ~= nil then
    local playerData = enemyInfo ~= nil and enemyInfo or playerInfo
    EventManager.Dispatch(Event.ThreeVSThreeEnemyExitView, playerData)
  end
end

function ThreeVsThreeDataMgr:ResetMatchData()
  if self:GetMatchState() == 1 then
  end
  self:SetMatchPeopleType(0)
  self:SetMatchState(0)
  self.captainId = 0
  self.member = {}
  self.teamId = 0
  self.pvpType = 1
  self.isNeedAfterCancelMatchReqExitTeam = false
end

function ThreeVsThreeDataMgr:GetSurrenderData()
  if self._surrenderData == nil then
    self._surrenderData = LuaClass.SurrenderData:New()
  end
  return self._surrenderData
end

function ThreeVsThreeDataMgr:GetThreeTaskData(Data)
  self.index = 1
  local data = Data.task
  table.sort(data, function(a, b)
    return a.id < b.id
  end)
  for k, v in pairs(data) do
    self:TriggerMissionEvent(v.id, v.state)
  end
end

function ThreeVsThreeDataMgr:TriggerMissionEvent(id, state)
  if type(id) ~= "number" or type(state) ~= "number" then
    return
  end
  TranScriptData.InTranscriptType = nil
  local tbl = ClientTable.cfg_Map_instance_missionManager:TryGetValue(id, "id")
  if tbl == nil then
    return
  end
  if self._mainPlayerCampInfo == nil or self._mainPlayerCampInfo.GroupId ~= tbl.campId then
    return
  end
  self.client[self.index] = {}
  self.client[self.index].description = tbl.description
  if state == ActivityStateInfo.Receive then
    self.client[self.index].tblCount = string.GetColorText("0/" .. tbl.count, ItemQuality2ColorDic[7])
  elseif state == ActivityStateInfo.Complete then
    self.client[self.index].tblCount = string.GetColorText(tbl.count .. "/" .. tbl.count, ItemQuality2ColorDic[5])
  end
  self.index = self.index + 1
  if not UIManager.IsVisible(UIID.Activity_Sport3V3Task) then
    UIManager.Show(UIID.Activity_Sport3V3Task)
    if UIManager.IsVisible(UIID.LeftTopPanelUI) then
      UIManager.Hide(UIID.LeftTopPanelUI)
    end
  else
    EventManager.Dispatch(Event.ThreeVSThreeTaskDataChange)
  end
end

function ThreeVsThreeDataMgr:GetThreeTask()
  if self.client then
    return self.client
  end
end

ThreeVsThreeDataMgr.announceTimer = nil
ThreeVsThreeDataMgr.announceQueue = {}
ThreeVsThreeDataMgr.announcedelyTime = nil

function ThreeVsThreeDataMgr:ShowPVPAnnounce(tblData)
  if self.announcedelyTime == nil then
    self.announcedelyTime = tonumber(ClientTable.cfg_Activity_globalManager:GetEffect(500010)) / 1000
  end
  table.insert(self.announceQueue, tblData)
  
  local function SecondProcessWait()
    if table.count(self.announceQueue) > 0 then
      local data = table.remove(self.announceQueue, 1)
      UIManager.Show(UIID.Activity_Sport3V3Info, data)
    else
      UIManager.Hide(UIID.Activity_Sport3V3Info)
      Timer.Stop(self.announceTimer)
      self.announceTimer = nil
    end
  end
  
  if self.announceTimer == nil then
    SecondProcessWait()
    self.announceTimer = Timer.StartLoopForever(self.announcedelyTime, SecondProcessWait)
  end
end

function ThreeVsThreeDataMgr:GetPlayerTeam(tblData)
  local team = self:GetMatchTeamData()
  for i, v in pairs(team) do
    if v.id == tblData.id then
      return true
    end
  end
  return false
end

function ThreeVsThreeDataMgr:GetPlayerCampPositionInfo(lid)
  if self.playerCampPositionInfoList then
    for i, v in pairs(self.playerCampPositionInfoList) do
      if v.lid == lid then
        return true
      end
    end
  end
  return false
end

return ThreeVsThreeDataMgr
