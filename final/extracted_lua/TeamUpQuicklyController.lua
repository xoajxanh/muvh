TeamUpQuicklyController = {}
require("GameModel/TeamUpQuicklyData")
local this = TeamUpQuicklyController
local matchState

function TeamUpQuicklyController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function TeamUpQuicklyController.RegistMessages()
  this.messageContainer:Regist(InstanceMatchMessage.ResInstanceMatchTeamInfo, this.ResInstanceMatchTeamInfo)
  this.messageContainer:Regist(UserMessage.ResLogout, this.CleanTeamUpData)
end

local firstStart = false
local firstEnd = false
local SecondProcess = false
local haveSecend = true

local function FirstProcessWait(endTime)
  if not TeamUpQuicklyData.TeamInfor then
    return
  end
  if TeamUpQuicklyData.TeamInfor.endTime ~= endTime then
    return
  end
  if TeamUpQuicklyData.process == 2 then
    return
  end
  if not TeamUpQuicklyData.IsLeader() then
    local members = TeamUpQuicklyData.TeamInfor.members
    for i = 1, #members do
      if members[i].rid == ViewData.meData.id then
        if members[i].reason ~= 1 then
          NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
            teamId = TeamUpQuicklyData.TeamInfor.id,
            friend = false,
            agree = false
          })
        else
          NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
            teamId = TeamUpQuicklyData.TeamInfor.id,
            friend = false,
            agree = true
          })
        end
      end
    end
  end
  firstEnd = true
  firstStart = false
  if not haveSecend then
    UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
    TeamUpQuicklyData.TeamInfor = nil
    EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
    haveSecend = true
  end
end

local function SecondProcessWait(endTime)
  firstEnd = false
  TeamUpQuicklyData.TeamInfor = nil
  UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
  EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
  SecondProcess = false
end

function TeamUpQuicklyController.ResInstanceMatchTeamInfo(id, msg)
  TeamUpQuicklyData.matchResult = true
  for i = 1, #msg.members do
    local item = msg.members[i]
    if item.reason ~= 1 then
      TeamUpQuicklyData.matchResult = false
    end
  end
  if not TeamUpQuicklyData.TeamInfor then
    TeamUpQuicklyData.SetInstanceInfor(msg)
    TeamUpQuicklyData.TeamInfor = msg
    TeamUpQuicklyData.process = 1
    local id, uiName = TeamUpQuicklyData.GetInstanceInfor()
    if uiName then
      UIManager.Hide(uiName)
    end
    if msg.match and (msg.endTime - Time.GetServerTime()) * 0.001 < 10 then
      haveSecend = false
    end
    UIManager.Show(UIID.Team_TeamUpQuicklyUI)
    EventManager.Dispatch(Event.Team_MatchingTeamInforRefresh)
    firstStart = true
    local waitTime = (msg.endTime - Time.GetServerTime()) * 0.001
    Timer.Start(waitTime, FirstProcessWait, msg.endTime)
    return
  end
  if msg.endTime == 0 then
    TeamUpQuicklyData.TeamInfor = nil
    UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
    EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
    return
  elseif TeamUpQuicklyData.TeamInfor.endTime == msg.endTime then
    if #TeamData.membersList == 1 or not TeamData.isInTeam then
      if TeamData.isInTeam and TeamUpQuicklyData.IsLeader() then
        NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
      end
      UIManager.Hide(UIID.Team_TeamUpQuicklyUI)
      TeamUpQuicklyData.TeamInfor = nil
      EventManager.Dispatch(Event.Team_TeamUpQuicklyMinimize, false)
    end
    if not SecondProcess and haveSecend and (Time.GetServerTime() - msg.endTime > -400 or firstEnd) then
      msg.endTime = msg.endTime + 5000
      TeamUpQuicklyData.TeamInfor = msg
      UIManager.Show(UIID.Team_TeamUpQuicklyUI)
      local interface = UIManager.GetUiByName(UIID.Team_TeamUpQuicklyUI)
      interface:ReSetCountDown()
      SecondProcess = true
      local waitTime = (msg.endTime - Time.GetServerTime()) * 0.001
      Timer.Start(waitTime, SecondProcessWait)
      return
    end
  else
    TeamUpQuicklyData.TeamInfor = msg
    TeamUpQuicklyData.process = 2
    if not SecondProcess then
      UIManager.Show(UIID.Team_TeamUpQuicklyUI)
      SecondProcess = true
      local waitTime = (msg.endTime - Time.GetServerTime()) * 0.001
      Timer.Start(waitTime, SecondProcessWait)
      for i = 1, #msg.members do
        if msg.members[i].rid == RoleManager.me.data.id and msg.members[i].reason ~= 1 then
          NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
            teamId = TeamUpQuicklyData.TeamInfor.id,
            friend = false,
            agree = true
          })
        end
      end
    end
  end
  TeamUpQuicklyData.TeamInfor = msg
  EventManager.Dispatch(Event.Team_MatchingTeamInforRefresh)
end

function TeamUpQuicklyController.ResInstanceMatchInviteFriend(id, msg)
  TranScriptData.tranScriptInviteData.instanceId = msg.instanceId
  local titleText = LocalizationUtility.GetContentByKey("tishi")
  local agree = LocalizationUtility.GetContentByKey("tongyi")
  local disagree = LocalizationUtility.GetContentByKey("jujue")
  local inviteType = LocalizationUtility.GetContentByKey("inviteYou")
  local resetPanelInfor = {
    title = titleText,
    invitationType = inviteType,
    labEnter = agree,
    labCancel = disagree,
    inviterName = msg.name,
    enterOnClick = function()
      TeamUpQuicklyData.SetInstanceInfor(msg)
      UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
        teamId = msg.teamId,
        friend = true,
        agree = true
      })
    end,
    cancelOnClick = function()
      UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
        teamId = msg.teamId,
        friend = true,
        agree = false
      })
    end
  }
  UIManager.Show(UIID.Instance_BloodCastleSecondUI, resetPanelInfor)
end

function TeamUpQuicklyController.ResInstanceMatchMatchInfo(id, msg)
  if matchState ~= msg.state then
    if msg.state == 1 then
      EventManager.Dispatch(Event.Team_StartMatching, msg.cd)
    else
      EventManager.Dispatch(Event.Team_MatchingSuccessful, msg.cd)
    end
    matchState = msg.state
  end
  TeamUpQuicklyData.TeamInfor.members = msg.members
  EventManager.Dispatch(Event.Team_MatchingTeamInforRefresh)
  TeamUpQuicklyData.State = msg.state
end

function TeamUpQuicklyController.ResInstanceMatchMatchFail(id)
  matchState = nil
  EventManager.Dispatch(Event.Team_MatchingFail)
end

function TeamUpQuicklyController.ResMatchingSuccessful(id, msg)
  EventManager.Dispatch(Event.Team_MatchingSuccessful)
end

function TeamUpQuicklyController.RegistEvent()
  this.eventContainer:Regist(Event.Role_OnMeCreated, this.GetMeData)
  this.eventContainer:Regist(Event.matchingInviteNotice, this.MatchingInviteNoticeInfor)
end

function TeamUpQuicklyController.CleanTeamUpData()
  TeamUpQuicklyData.TeamInfor = nil
end

function TeamUpQuicklyController.InterfaceEventRegist(event, func)
  this.eventContainer:Regist(event, func)
end

function TeamUpQuicklyController.GetMeData(id, me)
  TeamUpQuicklyData.meData = me.data
end

function TeamUpQuicklyController.MatchingInviteNoticeInfor(id, msg)
  TranScriptData.tranScriptInviteData.instanceId = msg[2]
  local titleText = LocalizationUtility.GetContentByKey("tishi")
  local agree = LocalizationUtility.GetContentByKey("queding")
  local disagree = LocalizationUtility.GetContentByKey("quxiao")
  local inviteType = LocalizationUtility.GetContentByKey("yesNo")
  local resetPanelInfor = {
    title = titleText,
    invitationType = inviteType,
    labEnter = agree,
    labCancel = disagree,
    inviterName = msg[1],
    enterOnClick = function(mapid)
      TeamUpQuicklyData.SetInstanceInfor({
        instanceId = msg[2]
      })
      UIManager.Hide(UIID.Instance_BloodCastleSecondUI)
      NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, {
        teamId = msg[3],
        friend = false,
        agree = true
      })
    end
  }
  UIManager.Show(UIID.Instance_BloodCastleSecondUI, resetPanelInfor)
end

TeamUpQuicklyController.Init()
