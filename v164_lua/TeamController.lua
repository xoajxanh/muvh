TeamController = {}
require("GameModel/TeamData")
local this = TeamController

function TeamController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function TeamController.RegistMessages()
  this.messageContainer:Regist(TeamMessage.ResTeamInfo, this.OnResTeamInfo)
  this.messageContainer:Regist(TeamMessage.ResDissolveTeam, this.OnResDissolveTeam)
  this.messageContainer:Regist(TeamMessage.ResDissolveTeamToInvitor, this.OnResDissolveTeamToInvitor)
  this.messageContainer:Regist(TeamMessage.ResRoundTeams, this.OnResRoundTeams)
  this.messageContainer:Regist(TeamMessage.ResPlayerTeamIdUpdate, this.OnResTeamIdChange)
  this.messageContainer:Regist(TeamMessage.ResDisAgreeInvite, this.OnResDisAgreeInvite)
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnGamePlayLeave)
  this.messageContainer:Regist(TeamMessage.ResActivityLevel, this.OnRetLimitType)
end

function TeamController.OnRetLimitType(id, msg)
  TeamData.OnRetLimitType(msg)
end

function TeamController.OnGamePlayLeave()
  TeamData.Reset()
end

function TeamController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function TeamController.OnResTeamInfo(id, msg)
  if not msg then
    return
  end
  TeamData.SetData(msg)
end

function TeamController.OnResDissolveTeam(id, msg)
end

function TeamController.OnResDissolveTeamToInvitor(id, msg)
  if msg and msg.teamId ~= nil then
    TeamData.RemoveInviteMeData(msg.teamId)
  end
end

function TeamController.OnResRoundTeams(id, msg)
  TeamData.SetNearbyTeamsData(msg)
  EventManager.Dispatch(Event.Team_RefushTeamsPanel, nil)
  local openType = {
    openType = ShowTeamType.NearTeamType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function TeamController.OnResTeamIdChange(id, msg)
  if msg and msg.teamId == 0 and msg.playerId == ViewData.meData.id then
    TeamData.ClearTeamData()
    this.QuicklyTeam()
  end
end

function TeamController.QuicklyTeam()
  if TeamUpQuicklyData.TeamInfor then
    UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
    EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
    TeamUpQuicklyData.TeamInfor = nil
  end
end

function TeamController.OnResDisAgreeInvite(id, msg)
  if msg and msg.teamId ~= nil then
    TeamData.DisAgreeInviteData(msg.teamId)
  end
end

function TeamController.OnResDisagreeInvite(id, msg)
  if msg then
    TeamData.RemoveInviteMeData(msg.teamId)
  end
end

function TeamController.GetTeamInfo(id)
  local msg = {}
  NetManager.Send(TeamMessage.ReqGetTeamInfo, msg)
end

function TeamController.ChangeLeader(id, leaderId)
  if not leaderId then
    return
  end
  local msg = {newLeaderId = leaderId}
  NetManager.Send(TeamMessage.ReqChangeLeader, msg)
end

function TeamController.DissolveTeam(id)
  local msg = {}
  NetManager.Send(TeamMessage.ReqDissolveTeam, msg)
end

function TeamController.ChangeLimit(id, newLevel)
  if not newLevel then
    return
  end
  local msg = {needLevel = newLevel}
  NetManager.Send(TeamMessage.ReqSetLimit, msg)
end

function TeamController.CreateTeam(id)
  if this.IsBlock() then
    return
  end
  local msg = {}
  NetManager.Send(TeamMessage.ReqCreateTeam, msg)
end

function TeamController.AskEnterOtherTeam(id, teamId)
  if this.IsBlock() then
    return
  end
  if not teamId then
    return
  end
  if not TeamData.GetAskTeamCondition() then
    local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamError_2")
    local level = tonumber(GlobalConfig.GetGlobalConfig(2450011))
    local text = string.format(titleStr, level)
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = text
    })
    return
  end
  if TeamData.IsInTeamState() then
    if teamId == TeamData.GetTeamId() then
      local curTitle = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_2", "id")
      if curTitle then
        UIManager.Show(UIID.PromptTipUI, {
          title = "Nh\225\186\175c nh\225\187\159",
          textContent = curTitle
        })
      end
    else
      local curTitle = ClientTable.cfg_Ui_wordManager:TryGetValue("AddTeamFail_1", "id")
      if curTitle then
        UIManager.Show(UIID.PromptTipUI, {
          title = "Nh\225\186\175c nh\225\187\159",
          textContent = tostring(curTitle.content)
        })
      end
    end
    return
  end
  local msg = {teamId = teamId}
  NetManager.Send(TeamMessage.ReqAskEnterTeam, msg)
end

function TeamController.AgreeEnterMyTeam(id, data)
  if not data then
    return
  end
  if TeamData.HasMemberByIndex(5) then
    local curTitle = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("AddTeamFail_2", "id")
    if curTitle then
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = tostring(curTitle.content)
      })
    end
    return
  end
  local msg = {asks = data}
  NetManager.Send(TeamMessage.ReqAgreeEnterTeam, msg)
end

function TeamController.RefuseEnterMyTeam(id, data)
  if not data then
    return
  end
  local msg = {asks = data}
  NetManager.Send(TeamMessage.ReqDisAgreeEnterTeam, msg)
end

function TeamController.InviteEnterMyTeam(id, invite)
  if not invite then
    return
  end
  if TeamData.HasMemberByIndex(5) then
    local curTitle = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("AddTeamFail_4", "id")
    if curTitle then
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = curTitle
      })
    end
    return
  end
  local msg = {invites = invite}
  NetManager.Send(TeamMessage.ReqInviteEnter, msg)
end

function TeamController.AgreeInviteToOther(id, teamId)
  if this.IsBlock() then
    return
  end
  local msg = {teamId = teamId}
  NetManager.Send(TeamMessage.ReqAgreeInvite, msg)
end

function TeamController.RefuseInviteToOther(id, teamId)
  local msg = {teamId = teamId}
  NetManager.Send(TeamMessage.ReqDisAgreeInvite, msg)
end

function TeamController.KickTeam(id, memberId)
  if not memberId then
    return
  end
  local msg = {kickId = memberId}
  NetManager.Send(TeamMessage.ReqKickTeam, msg)
end

function TeamController.ExitTeam(id)
  NetManager.Send(TeamMessage.ReqExitTeam, nil)
end

function TeamController.ReqRoundTeam(id)
  NetManager.Send(TeamMessage.ReqRoundTeams, nil)
end

function TeamController.AutoJoinValueChange(id, isAutoJoin)
  TeamData.SetAutoInTeam(isAutoJoin)
end

function TeamController.AllAgreeInTeam(id)
  if this.IsBlock() then
    return
  end
  local askList = TeamData.GetAskInList()
  if askList then
    local askIds = {}
    for i, v in pairs(askList) do
      table.insert(askIds, v.rid)
    end
    local msg = {asks = askIds}
    NetManager.Send(TeamMessage.ReqAgreeEnterTeam, msg)
  end
end

function TeamController.AllRefuseInTeam(id, data)
  if this.IsBlock() then
    return
  end
  local msg = {asks = data}
  NetManager.Send(TeamMessage.ReqDisAgreeEnterTeam, msg)
end

function TeamController.RegistEvent()
  this.eventContainer:Regist(Event.Team_CreateTeam, this.CreateTeam)
  this.eventContainer:Regist(Event.Team_OpenTeamsPanel, this.ReqRoundTeam)
  this.eventContainer:Regist(Event.Team_ReqTeamsInfo, this.GetTeamInfo)
  this.eventContainer:Regist(Event.Team_AgreeInMyTeam, this.AgreeEnterMyTeam)
  this.eventContainer:Regist(Event.Team_RefuseInMyTeam, this.RefuseEnterMyTeam)
  this.eventContainer:Regist(Event.Team_KickOutRole, this.KickTeam)
  this.eventContainer:Regist(Event.Team_InviteInTeam, this.InviteEnterMyTeam)
  this.eventContainer:Regist(Event.Team_TransferLeader, this.ChangeLeader)
  this.eventContainer:Regist(Event.Team_QuitTeam, this.ExitTeam)
  this.eventContainer:Regist(Event.Team_AskEnterTeam, this.AskEnterOtherTeam)
  this.eventContainer:Regist(Event.Team_AgreeInOtherTeam, this.AgreeInviteToOther)
  this.eventContainer:Regist(Event.Team_RefuseInOtherTeam, this.RefuseInviteToOther)
  this.eventContainer:Regist(Event.Team_AutoJoinTeamSet, this.AutoJoinValueChange)
  this.eventContainer:Regist(Event.Team_AllAgreeInTeam, this.AllAgreeInTeam)
  this.eventContainer:Regist(Event.Team_AllRefuseInTeam, this.AllRefuseInTeam)
  this.eventContainer:Regist(Event.RedFortEntered, this.ShutDown)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnGamePlayLeave)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnGamePlayLeave)
end

function TeamController.PrivateTalk(id, rid)
end

function TeamController.ShutDown(id, data)
  if TeamData.IsInTeamState() then
    this.ExitTeam()
  end
end

function TeamController.IsBlock()
  return RedFortData.InRedFortActivity
end

TeamController.Init()
