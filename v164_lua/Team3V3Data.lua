local Team3V3Data = {}

function Team3V3Data:Init()
  self:InitConfig()
  self.MatchTeamInfo = {}
  self.battleMenbersInfo = {}
  self.MenbersInfo = {}
  self.QueryHasTeam = {}
  self.CanInvite = false
  self.SetBattleMenberShow = true
  self.matchSuccessFul = false
  self.BattleInfo = {}
  self.AllTeamList = {}
  self.RefuseInviteId = {}
  self.TeamApplyInfo = {}
  self.KnockoutDrawData = {}
  self.RecordInfo = {}
  self.battleId = 0
  self.stairsRankData = {}
  self.eliminationRankData = {}
  self.thirdPlaceRankData = {}
  self.championRankData = {}
  self.thirdPlaceTeamInfo = {}
  self.championTeamInfo = {}
  self.EnemyTeamInfo = {}
  self.baoMinTime = {}
  self.JoinMatchState = {state = false, info = nil}
  self.curStage = -1
  self.JinJiTimeDetail = {}
  self.TaoTaiTimeDetail = {}
  self.drawPublishTime = 0
  self.chatCd = 0
end

function Team3V3Data:SetChatCd(cd)
  self.chatCd = cd
end

function Team3V3Data:GetChatCd()
  return self.chatCd
end

function Team3V3Data:SetJoinMatch(state, msg)
  self.JoinMatchState.state = state
  self.JoinMatchState.info = msg
end

function Team3V3Data:GetJoinMatch()
  return self.JoinMatchState
end

function Team3V3Data:InsertBattleInfo(id)
  if not self.BattleInfo[id] then
    self.BattleInfo[id] = id
    return true
  end
  return false
end

function Team3V3Data:RemoveBattleInfo(id)
  if self.BattleInfo[id] then
    self.BattleInfo[id] = nil
    return true
  end
  return false
end

function Team3V3Data:ClearBattleInfo()
  self.BattleInfo = {}
end

function Team3V3Data:RestoreBattleInfo()
  self.BattleInfo = {}
  if table.count(self.battleMenbersInfo) > 0 then
    for i, v in pairs(self.battleMenbersInfo) do
      self.BattleInfo[v] = v
    end
  end
end

function Team3V3Data:GetBattleInfo()
  return self.BattleInfo
end

function Team3V3Data:SetBattleMenberBtnShow(data)
  self.SetBattleMenberShow = data
end

function Team3V3Data:GetBattleMenberBtnShow()
  return self.SetBattleMenberShow
end

function Team3V3Data:SetInvite(data)
  self.CanInvite = data
end

function Team3V3Data:GetInvite()
  return self.CanInvite
end

function Team3V3Data:InsertRefuseInviteId(id)
  if not self.RefuseInviteId[id] then
    self.RefuseInviteId[id] = Time.GetServerTime()
  end
end

function Team3V3Data:CanInviteId(id)
  if self.RefuseInviteId[id] and Time.GetServerTime() - self.RefuseInviteId[id] < 300000 then
    return false
  end
  return true
end

function Team3V3Data:ClearMatchTeamInfo()
  self.MatchTeamInfo = {}
end

function Team3V3Data:Clear(type)
  if type == 2 and RoleManager.me.id == self.MatchTeamInfo.leadId then
    self.TeamApplyInfo = {}
  end
  self.MatchTeamInfo = {}
  self.battleMenbersInfo = {}
  self.MenbersInfo = {}
  self.QueryHasTeam = {}
  self.CanInvite = false
  self.SetBattleMenberShow = true
  self.BattleInfo = {}
  self.AllTeamList = {}
  self.RecordInfo = {}
  self.EnemyTeamInfo = {}
  self.matchSuccessFul = false
  self.battleId = 0
  self.JoinMatchState = {state = false, info = nil}
  EventManager.Dispatch(Event.RefreshTeam3V3Info)
end

function Team3V3Data:InitConfig()
  self.dailyReward = ClientTable.cfg_Team3v3_RewardManager:TryGetValue(2, "previewType")
  self.dailyReward.reward = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(self.dailyReward.rewardPreview, "boxId")
  self.rankRewards = ClientTable.cfg_Team3v3_RewardManager:GetSortTabListByType(5, "previewType")
  self.promotionRewards = ClientTable.cfg_Team3v3_RewardManager:GetSortTabListByType(3, "previewType")
  self.regisTimePeriod = string.split(ClientTable.cfg_Activity_globalManager:GetEffect(500567, "id"), "#")
  self:InitTeam3V3Reward()
  self:InitRewardShowInfo()
end

function Team3V3Data:RefreshTeamKillInfo(data)
  if data == nil then
    return
  end
  for i, v in pairs(data.infos) do
    local singleRecordData = {}
    singleRecordData.rid = v.rid
    singleRecordData.killCount = v.killCount
    singleRecordData.dieCount = v.dieCount
    singleRecordData.battleCount = v.battleCount
    singleRecordData.winCount = v.winCount
    singleRecordData.winRate = v.winRate .. "%"
    if self.RecordInfo[v.rid] then
      self.RecordInfo[v.rid] = {}
    end
    self.RecordInfo[v.rid] = singleRecordData
  end
  EventManager.Dispatch(Event.Team3v3CheckRecord)
end

function Team3V3Data:RefreshTeamListData(data)
  if data == nil then
    return
  end
  self.AllTeamList = {}
  for i, v in pairs(data.infos) do
    local teamData = {}
    teamData.teamId = v.teamId
    teamData.teamName = v.teamName
    teamData.leadName = v.leadName
    teamData.totalLevel = v.totalLevel
    teamData.needLevel = v.needLevel
    teamData.memberCount = v.memberCount
    teamData.apply = v.apply
    table.insert(self.AllTeamList, teamData)
  end
  EventManager.Dispatch(Event.RefreshTeam3v3List)
end

function Team3V3Data:RefreshMatchTeamInfo(data)
  if not table.isNullOrEmpty(data) then
    self.MatchTeamInfo = data
    self:SetMenbersInfo(data)
    EventManager.Dispatch(Event.RefreshTeam3V3Info)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.Team3V3
    })
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.Team3V3UI
    })
  end
end

function Team3V3Data:GetMatchTeamInfo()
  return self.MatchTeamInfo
end

function Team3V3Data:SetMenbersInfo(data)
  self.MenbersInfo = data.members
  self.battleMenbersInfo = data.battleIds
  self.BattleInfo = {}
  if table.count(data.battleIds) > 0 then
    for i, v in pairs(data.battleIds) do
      self.BattleInfo[v] = v
    end
  end
  table.sort(self.MenbersInfo, function(a, b)
    return a.joinTime < b.joinTime
  end)
end

function Team3V3Data:GetMenbersInfoByRid(rid)
  if not table.isNullOrEmpty(self.MenbersInfo) then
    for i, v in pairs(self.MenbersInfo) do
      if v.rid == rid then
        return v
      end
    end
  end
  return nil
end

function Team3V3Data:SetQueryHasTeam(data)
  self.QueryHasTeam = data
  EventManager.Dispatch(Event.RefreshTeam3v3InvitablePlayInfo)
end

function Team3V3Data:CheckMenberDontHasTeam(rid)
  return table.contains(self.QueryHasTeam, rid)
end

function Team3V3Data:GetMenbersInfo()
  return self.MenbersInfo
end

function Team3V3Data:CheckIsBattleMenber(rid)
  if not rid then
    return false
  end
  return table.contains(self.battleMenbersInfo, rid)
end

function Team3V3Data:CheckBattleMenberIsFull()
  return table.count(self.battleMenbersInfo) >= 3
end

function Team3V3Data:GetBattleMenberInfo()
  return self.battleMenbersInfo
end

function Team3V3Data:InitTeam3V3Reward()
  local info = ClientTable.cfg_Team3v3_RewardManager:TryGetValue(1, "type")
  local box = ClientTable.cfg_Box_boxManager:TryGetTabListByType(info.rewardPreview, "boxId")
  table.sort(box, function(a, b)
    return a.layer < b.layer
  end)
  self.Team3V3Reward = {}
  for i, v in pairs(box) do
    if v then
      table.insert(self.Team3V3Reward, {
        itemId = v.itemId,
        itemCount = v.count
      })
    end
  end
end

function Team3V3Data:InitRewardShowInfo()
  self.rewardData, self.rewardSuitDic = ClientTable.cfg_Team3v3_ShowManager:GetTabListByMeetsCondition()
end

function Team3V3Data:GetRoleModelShowInfo(rewardData, parent)
  local equip = {}
  for i, v in ipairs(rewardData) do
    local reward = ItemUtility.GenerateItemData(v)
    reward.bagGridIndex = RoleEquipUtility.GetWearEquipPosition(reward)
    table.insert(equip, reward)
  end
  local career = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(RoleManager.me.career)
  if career == 11 or career == 14 then
    local secondWeapon = ItemUtility.GenerateItemData(rewardData[1])
    secondWeapon.bagGridIndex = tonumber(string.split(secondWeapon.tblEquip.equipPosition, "#")[2])
    table.insert(equip, secondWeapon)
  end
  local viewRoleData = {}
  viewRoleData.equipsData = RoleEquipData(equip)
  viewRoleData.career = ViewData.meData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = 1003
  viewRoleData.id = 1003
  viewRoleData.roleName = ViewData.meData.name
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.parent = parent
  viewRoleData.animationName = "idle"
  viewRoleData.modelScale = 1
  return viewRoleData
end

function Team3V3Data:GetCreateTeam3V3Reward()
  return self.Team3V3Reward
end

function Team3V3Data:GetRemainingRegisTimePeriodDes()
  if not self.regisTimePeriod or #self.regisTimePeriod < 2 then
    return ""
  end
  local startStamp = tonumber(self.regisTimePeriod[1])
  local endStamp = tonumber(self.regisTimePeriod[2])
  local now = Time.GetServerSecondTime()
  if endStamp > now then
    return TimeUtility.ShowTime(endStamp - now)
  end
  return ""
end

function Team3V3Data:SetStairsRank(data)
  self.stairsRankData = data
end

function Team3V3Data:GetStairsRank()
  return self.stairsRankData.rankDetail
end

function Team3V3Data:GetMyTeamStairsRank()
  local myRankData = self.stairsRankData.myRank
  if myRankData then
    return myRankData
  end
  local myTeamInfo = self:GetMatchTeamInfo()
  local myTeamLeaderInfo = self:GetMenbersInfoByRid(myTeamInfo.leaderId)
  local myRankTbl = {
    rank = 0,
    teamName = myTeamInfo.teamName or "-",
    serverId = myTeamInfo.serverId or "-",
    winCount = 0,
    leaderName = myTeamLeaderInfo and myTeamLeaderInfo.name or "-",
    score = 0
  }
  return myRankTbl
end

function Team3V3Data:GetMyTeamStairsRankIndex()
  local rankList = self:GetStairsRank()
  local myRank = self:GetMyTeamStairsRank()
  if myRank.rank <= 1 then
    return 1
  elseif myRank.rank >= 2 and myRank.rank <= #rankList - 3 then
    return myRank.rank - 1
  elseif myRank.rank >= #rankList - 2 then
    return math.max(#rankList - 4, 1)
  else
    return 1
  end
end

function Team3V3Data:SetEnemyTeamInfo(data)
  self.EnemyTeamInfo = data
  EventManager.Dispatch(Event.RefreshEnemyTeamInfoInfo)
end

function Team3V3Data:GetEnemyTeamInfo()
  return self.EnemyTeamInfo
end

function Team3V3Data:SetTeamDuelTotal(data)
  if data.releaseTime > 0 then
    self.drawPublishTime = data.releaseTime
  end
  if data.teamDuelStage then
    if not data.teamDuelStage then
      return
    end
    for i, v in ipairs(data.teamDuelStage) do
      if v.stage == TeamProcessStage.KnockoutRound then
        self:SetEliminationRank(v.info)
      elseif v.stage == TeamProcessStage.ThirdplaceMatch then
        self:SetThirdPlaceRank(v.info)
      elseif v.stage == TeamProcessStage.Championship then
        self:SetChampionRank(v.info)
      end
    end
  end
end

function Team3V3Data:GetAllRaceRankInfo()
  local allRaceRankInfo = {}
  if not table.isNullOrEmpty(self.eliminationRankData) then
    for i, v in ipairs(self.eliminationRankData) do
      table.insert(allRaceRankInfo, v)
    end
  end
  if not table.isNullOrEmpty(self.championRankData) then
    for i, v in ipairs(self.championRankData) do
      table.insert(allRaceRankInfo, v)
    end
  end
  return allRaceRankInfo
end

function Team3V3Data:SetEliminationRank(data)
  self.eliminationRankData = data
end

function Team3V3Data:GetEliminationRank()
  return self.eliminationRankData
end

function Team3V3Data:SetThirdPlaceRank(data)
  self.thirdPlaceRankData = data
end

function Team3V3Data:GetThirdPlaceRank()
  return self.thirdPlaceRankData
end

function Team3V3Data:SetChampionRank(data)
  self.championRankData = data
end

function Team3V3Data:GetChampionRank()
  return self.championRankData
end

function Team3V3Data:SetThirdPlaceTeamInfo(data)
  self.thirdPlaceTeamInfo = data
end

function Team3V3Data:GetThirdPlaceTeamInfo()
  return self.thirdPlaceTeamInfo
end

function Team3V3Data:SetChampionTeamInfo(data)
  self.championTeamInfo = data
end

function Team3V3Data:GetChampionTeamInfo()
  return self.championTeamInfo
end

function Team3V3Data:CheckScheduleType()
  local type
  if self.curStage <= TeamProcessStage.PromotionMatch then
    type = ScheduleTeam3V3UIEnum.JINJI
  elseif self.curStage == TeamProcessStage.KnockoutRound then
    type = ScheduleTeam3V3UIEnum.TAOTAI
  elseif self.curStage == TeamProcessStage.ThirdplaceMatch then
    type = ScheduleTeam3V3UIEnum.JIJUN
  elseif self.curStage == TeamProcessStage.Championship then
    type = ScheduleTeam3V3UIEnum.GUANJUN
  end
  return type
end

function Team3V3Data:SetKnockoutDrawData(data)
  self.KnockoutDrawData = data
end

function Team3V3Data:GetKnockoutDrawData()
  return self.KnockoutDrawData
end

function Team3V3Data:GetKnockoutDrawGroupName(groupId)
  local cfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500586).effect
  if not string.isNullOrEmpty(cfg) then
    local cfgTbl = string.split(cfg, "&")
    for i, v in pairs(cfgTbl) do
      local groupInfo = string.split(v, "#")
      if table.count(groupInfo) == 2 and tonumber(groupInfo[1]) == groupId then
        return groupInfo[2]
      end
    end
  end
  return ""
end

function Team3V3Data:RefreshTeamApplyInfo(data)
  if data and RoleManager.me.id == self.MatchTeamInfo.leaderId then
    self.TeamApplyInfo = data.applyInfos
    EventManager.Dispatch(Event.Team3v3ApplyInfoChange)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.Team3V3UI
    })
  end
end

function Team3V3Data:CheckRedPoint(num)
  if table.isNullOrEmpty(self.MatchTeamInfo) then
    return false
  end
  local NowTime = math.floor(Time.GetServerTime() * 0.001)
  if num == 2 and self.MatchTeamInfo.teamStage < TeamProcessStage.PromotionMatch and self.MatchTeamInfo.leaderId == RoleManager.me.id then
    local FirstClick = string.format("%s_Team3V3btn_manageRedPoint", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(FirstClick, 0)
    return 0 < table.count(self.TeamApplyInfo) or lastRecordTime == 0
  elseif num == 1 and self.MatchTeamInfo.teamStage == TeamProcessStage.PromotionMatch then
    local count = self.MatchTeamInfo.promoteInfo and self.MatchTeamInfo.promoteInfo.validBattleCount or 0
    local isTime = NowTime >= self.MatchTeamInfo.matchStartTime and NowTime <= self.MatchTeamInfo.matchEndTime
    return not self.MatchTeamInfo.isOut and 0 < count and isTime
  elseif num == 1 and self.MatchTeamInfo.teamStage > TeamProcessStage.PromotionMatch then
    local isTime = NowTime >= self.MatchTeamInfo.matchStartTime and NowTime <= self.MatchTeamInfo.matchEndTime
    return not self.MatchTeamInfo.isOut and isTime
  end
  return false
end

function Team3V3Data:GetTeamApplyInfo()
  return self.TeamApplyInfo
end

function Team3V3Data:CheckIsDecisionMaker(rid)
  local isLeader = self.MatchTeamInfo.leaderId == rid
  local isSecondLeader = self.MatchTeamInfo.secondLeader == rid
  if isLeader or isSecondLeader then
    if isLeader then
      return true
    end
    local roleInfo = self:GetMenbersInfoByRid(self.MatchTeamInfo.leaderId)
    if isSecondLeader and roleInfo then
      return not roleInfo.online
    end
  end
  return false
end

function Team3V3Data:GetBaoMinTime()
  if table.isNullOrEmpty(self.baoMinTime) then
    self.baoMinTime = {
      endStamp = 0,
      startStr = "",
      endStr = ""
    }
    if not self.regisTimePeriod or #self.regisTimePeriod < 2 then
      return "", "", 0
    end
    local startFormatted = string.gsub(self.regisTimePeriod[1], "[_:]", "-")
    local endFormatted = string.gsub(self.regisTimePeriod[2], "[_:]", "-")
    local endStamp = TimeUtility.GetServerTimeByDate(endFormatted)
    local startStr = string.gsub(startFormatted, "(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+).*", "%4:%5:%6 %3/%2/%1")
    local endStr = string.gsub(endFormatted, "(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+).*", "%4:%5:%6 %3/%2/%1")
    self.baoMinTime = {
      endStamp = endStamp,
      startStr = startStr,
      endStr = endStr
    }
    return self.baoMinTime
  else
    return self.baoMinTime
  end
end

function Team3V3Data:SetMatchSuccessFul(data)
  self.matchSuccessFul = data
end

function Team3V3Data:GetMatchSuccessFul()
  return self.matchSuccessFul
end

function Team3V3Data:SetSelectionOpenTime(data)
  if data then
    if data.stage then
      self.curStage = data.stage
    end
    if data.info then
      self.TaoTaiTimeDetail = data.info
    end
    if data.promoteTimeDetail then
      self.JinJiTimeDetail = data.promoteTimeDetail
    end
  end
end

function Team3V3Data:GetSelectionOpenTimeOfJinJi()
  return self.JinJiTimeDetail
end

function Team3V3Data:GetSelectionOpenTimeOfTaoTai()
  return self.TaoTaiTimeDetail
end

function Team3V3Data:ResetStairsRank()
  self.eliminationRankData = {}
  self.thirdPlaceRankData = {}
  self.championRankData = {}
  self.thirdPlaceTeamInfo = {}
  self.championTeamInfo = {}
  self.curStage = -1
  self.JinJiTimeDetail = {}
  self.TaoTaiTimeDetail = {}
  self.drawPublishTime = 0
end

function Team3V3Data:ResetStairsRankData()
  self.stairsRankData = {}
end

function Team3V3Data:FormatTimeRange(startStamp, endStamp)
  local tzOffset = TimeUtility.TIMEZONES_SECONDS
  local startTbl = os.date("!*t", startStamp + tzOffset)
  local endTbl = os.date("!*t", endStamp + tzOffset)
  return string.format("%02d:%02d-%02d:%02d %d/%d/%d", startTbl.hour, startTbl.min, endTbl.hour, endTbl.min, endTbl.day, endTbl.month, endTbl.year)
end

function Team3V3Data:FormatTime(stamp)
  local tzOffset = TimeUtility.TIMEZONES_SECONDS
  local tbl = os.date("!*t", stamp + tzOffset)
  return string.format("%02d:%02d", tbl.hour, tbl.min)
end

function Team3V3Data:IsTimePassed()
  if self.drawPublishTime and self.drawPublishTime > 0 then
    return Time.GetServerSecondTime() > self.drawPublishTime
  end
  return false
end

function Team3V3Data:SetDelayTipsInfo(data)
  self.DelayTipsInfo = data
end

function Team3V3Data:GetDelayTipsInfo()
  return self.DelayTipsInfo
end

function Team3V3Data:ConvertSpecialIdToStr(num)
  if string.isNullOrEmpty(num) then
    return "-"
  end
  local str = tostring(num)
  if string.find(str, "^1000") then
    return "Top " .. tostring(tonumber(string.sub(str, -3)))
  elseif string.find(str, "^2000") then
    return "Top " .. tostring(tonumber(string.sub(str, -3))) .. "%"
  end
  return "-"
end

function Team3V3Data:CheckCanLiu()
  local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
  if not table.isNullOrEmpty(teamInfo) and not QuickFind:GetTeam3V3DataMgr():GetMenbersInfoByRid(RoleManager.me.id) then
    QuickFind:GetTeam3V3DataMgr():ClearMatchTeamInfo()
  end
end

return Team3V3Data
