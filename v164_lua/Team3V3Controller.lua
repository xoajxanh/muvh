require("GameModel/Team3V3/Team3V3Constant")
Team3V3Controller = {}
local this = Team3V3Controller

function Team3V3Controller.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function Team3V3Controller.RegistEvent()
  this.messageContainer:Regist(MatchTeamMessage.ResStairsRank, this.ResStairsRankRefresh)
  this.messageContainer:Regist(MatchTeamMessage.ResMatchInviteInfo, this.ResMatchInviteInfoRefresh)
  this.messageContainer:Regist(MatchTeamMessage.ResAllTeam, this.ResAllTeam)
  this.messageContainer:Regist(MatchTeamMessage.ResTeamKillInfo, this.ResTeamKillInfo)
  this.messageContainer:Regist(PVPMatchMessage.ResKnockoutDrawTip, this.ResKnockoutDrawTipRefresh)
  this.messageContainer:Regist(PVPMatchMessage.ResCompetitionTips, this.ResCompetitionTips)
  this.messageContainer:Regist(PVPMatchMessage.ResJoinMatchSuccess, this.JoinMatchSuccess)
  this.messageContainer:Regist(PVPMatchMessage.ResCancelMatchSuccess, this.CancelMatchSuccess)
  this.messageContainer:Regist(MatchTeamMessage.ResTeamApplyInfo, this.ResTeamApplyInfoRefresh)
  this.messageContainer:Regist(MatchTeamMessage.ResTeamDuelTotal, this.ResTeamDuelTotal)
  this.messageContainer:Regist(MatchTeamMessage.ResEnemyTeamInfoToRole, this.ResEnemyTeamInfoToRole)
  this.messageContainer:Regist(MatchTeamMessage.ResTeamDuelDetailById, this.ResTeamDuelDetailById)
  this.messageContainer:Regist(PVPMatchMessage.ResCompetitionStage, this.ResCompetitionStage)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnLeaveGame)
end

function Team3V3Controller.ResCompetitionTips(_, msg)
  if msg then
    if msg.battleId ~= 0 then
      QuickFind:GetTeam3V3DataMgr().battleId = msg.battleId
    end
    this:TipShow(tostring(msg.type))
  end
end

function Team3V3Controller.ResTeamKillInfo(_, msg)
  if msg and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():RefreshTeamKillInfo(msg)
  end
end

function Team3V3Controller.ResAllTeam(_, msg)
  if msg and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():RefreshTeamListData(msg)
  end
end

function Team3V3Controller.ResStairsRankRefresh(_, msg)
  if msg and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():SetStairsRank(msg)
    UIManager.Show(UIID.Team3V3RankUI)
  end
end

function Team3V3Controller.OnLeaveGame()
  if QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():ResetStairsRank()
    QuickFind:GetTeam3V3DataMgr():Clear()
  end
end

function Team3V3Controller.ResMatchInviteInfoRefresh(_, msg)
  if msg and QuickFind:GetTeam3V3DataMgr():CanInviteId(msg.teamId) then
    UIManager.Show(UIID.Team3V3Invite, msg)
  end
end

function Team3V3Controller.ResTeamApplyInfoRefresh(_, msg)
  if msg then
    QuickFind:GetTeam3V3DataMgr():RefreshTeamApplyInfo(msg)
  end
end

function Team3V3Controller.ResKnockoutDrawTipRefresh(_, msg)
  if msg then
    QuickFind:GetTeam3V3DataMgr():SetKnockoutDrawData(msg)
    UIManager.Show(UIID.Team3V3DrawlotsUI)
  end
end

local function ReturnMainCity()
  local mapData = {mapId = 100101}
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  UIManager.Show(UIID.Team3V3UI)
end

Team3V3Controller.callbacks = {
  [1] = function()
    ReturnMainCity()
  end,
  [2] = function()
    ReturnMainCity()
    networkRequest.ReqUpBattleMember()
  end,
  [3] = function()
    local battleId = QuickFind:GetTeam3V3DataMgr().battleId
    if battleId == nil or battleId == 0 then
      return
    end
    networkRequest.ReqJoinCompetitionBattle(battleId)
  end,
  [4] = function()
    local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
    if teamInfo.teamId and teamInfo.teamId ~= 0 then
      networkRequest.ReqDissolveMatchTeam(teamInfo.teamId)
    end
  end,
  [5] = function()
    local teamInfo = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
    if RoleManager.me.id ~= teamInfo.leaderId then
      networkRequest.ReqExitMatchTeam(teamInfo.teamId)
    end
  end
}

function Team3V3Controller:TipShow(dialogId, params, customCallback)
  local config = ClientTable.cfg_Team3v3_promptwordManager:TryGetValue(dialogId, "type")
  config = config or ClientTable.cfg_Ui_promptwordManager:TryGetValue(dialogId)
  if config and config.target and config.target ~= "0" then
    local state = QuickFind:GetTeam3V3DataMgr():CheckIsBattleMenber(RoleManager.me.id) and "1" or "2"
    if state ~= config.target then
      return
    end
  end
  local content = config.content
  if params then
    if type(params) == "table" then
      local ok, result = pcall(string.format, content, table.unpack(params))
      content = ok and result or content
      if not ok then
        logError("\230\143\144\231\164\186\230\152\190\231\164\186\230\160\188\229\188\143\230\156\137\232\175\175\239\188\140\232\175\183\228\188\160table table\233\149\191\229\186\166\229\164\167\228\186\142\229\141\160\228\189\141\231\172\166\230\149\176\233\135\143 dialogId\239\188\154", dialogId, " content:", content, " params:", table.unpack(params))
        return
      end
    else
      local ok, result = pcall(string.format, content, params)
      content = ok and result or content
      if not ok then
        return
      end
    end
  end
  local hasLeftBtn = config.leftButton ~= nil and config.leftButton ~= ""
  local btnCount = hasLeftBtn and 2 or 1
  local btn1Text = config.rightButton
  local btn2Text = hasLeftBtn and config.leftButton or ""
  local leftCallBackId = 2 <= table.count(string.split(config.leftButtonEvent1, "#")) and string.split(config.leftButtonEvent1, "#")[2] or tonumber(config.leftButtonEvent1)
  local rightCallBackid = 2 <= table.count(string.split(config.rightButtonEvent1, "#")) and string.split(config.rightButtonEvent1, "#")[2] or tonumber(config.rightButtonEvent1)
  local tipArgs = {
    uiWordId = dialogId,
    title = config.title,
    content = content,
    btn1Text = btn1Text,
    btn2Text = btn2Text,
    btnCount = btnCount,
    params = params,
    confirmCallback = function()
      self:OnConfirm(rightCallBackid, params, customCallback)
    end,
    cancelCallback = function()
      self:OnCancel(leftCallBackId, params)
    end,
    type = rightCallBackid,
    delay = nil
  }
  QuickFind:GetTeam3V3DataMgr():SetDelayTipsInfo({})
  if config.delay and config.delay == 1 then
    tipArgs.delay = true
    QuickFind:GetTeam3V3DataMgr():SetDelayTipsInfo(tipArgs)
    return
  end
  UIManager.Show(UIID.Team3V3Tip, tipArgs)
end

function Team3V3Controller:OnConfirm(rightCallBackid, params, customCallback)
  if customCallback then
    customCallback(params)
    UIManager.Hide(UIID.Team3V3Tip)
    return
  end
  local callback = self.callbacks[rightCallBackid]
  if callback then
    callback(params)
  end
  UIManager.Hide(UIID.Team3V3Tip)
end

function Team3V3Controller:OnCancel(leftCallBackId, params)
  UIManager.Hide(UIID.Team3V3Tip)
end

function Team3V3Controller:RegisterCallback(dialogId, callback)
  self.callbacks[dialogId] = callback
end

function Team3V3Controller.JoinMatchSuccess(_, msg)
  if msg and msg.comPetitionMatchType == 1 then
    QuickFind:GetTeam3V3DataMgr():SetJoinMatch(true, msg)
    EventManager.Dispatch(Event.Team3v3MatchStatusChange)
  end
end

function Team3V3Controller.CancelMatchSuccess(_, msg)
  if msg and msg.comPetitionMatchType == 1 then
    QuickFind:GetTeam3V3DataMgr():SetJoinMatch(false, msg)
    EventManager.Dispatch(Event.Team3v3MatchStatusChange)
  end
end

function Team3V3Controller.ResTeamDuelTotal(msgID, msg)
  if msg then
    QuickFind:GetTeam3V3DataMgr():SetTeamDuelTotal(msg)
    EventManager.Dispatch(Event.Team3v3MainToggleChange, Team3V3UIEnum.SCHEDULE)
    local type = QuickFind:GetTeam3V3DataMgr():CheckScheduleType()
    EventManager.Dispatch(Event.Team3v3RaceScheduleToggleChange, type)
  end
end

function Team3V3Controller.ResEnemyTeamInfoToRole(msgID, msg)
  if msg and msg.msgType == ReqTeamInfoType.Tips then
    UIManager.Show(UIID.Team3V3CheckMemberUI, {teamMemberData = msg})
  end
end

function Team3V3Controller.ResTeamDuelDetailById(msgID, msg)
  if msg then
    if msg.stage == TeamProcessStage.ThirdplaceMatch then
      QuickFind:GetTeam3V3DataMgr():SetThirdPlaceTeamInfo(msg)
      EventManager.Dispatch(Event.Team3v3RefreshRaceInfo, ScheduleTeam3V3UIEnum.JIJUN)
    elseif msg.stage == TeamProcessStage.Championship then
      QuickFind:GetTeam3V3DataMgr():SetChampionTeamInfo(msg)
      EventManager.Dispatch(Event.Team3v3RefreshRaceInfo, ScheduleTeam3V3UIEnum.GUANJUN)
    end
  end
end

function Team3V3Controller.ResCompetitionStage(msgID, msg)
  if msg then
    QuickFind:GetTeam3V3DataMgr():SetSelectionOpenTime(msg)
  end
end
