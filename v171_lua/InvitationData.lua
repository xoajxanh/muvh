InvitationData = {}
local this = InvitationData

function InvitationData.Init(data)
  this.Reset()
end

function InvitationData.Reset()
  this.type = {}
  this.invitedToTeamData = {}
  this.inviteToAllianceData = {}
end

function InvitationData.SetData(msg)
  if msg.type == InvitationType.InvitedToTeam then
    this.OnResTeamInvite(msg.teamInfo)
  end
  if msg.type == InvitationType.InviteToAlliance then
    this.OnResAllianceInvite(msg.unionInfo)
  end
  if msg.type == InvitationType.All then
    this.OnResTeamInvite(msg.teamInfo)
    this.OnResAllianceInvite(msg.unionInfo)
  end
end

function InvitationData.CleanInvitationData()
  this.Reset()
end

function InvitationData.CrossCleanInvitationData()
  if SceneData.serverType == serverType.span and not this.crossRealm then
    this.crossRealm = true
    this.Reset()
    EventManager.Dispatch(Event.Team_InviteListUpdate, table.count(InvitationData.GetInvitedToTeamData()))
  end
  if SceneData.serverType == serverType.self and this.crossRealm then
    this.crossRealm = false
    this.Reset()
    EventManager.Dispatch(Event.Team_InviteListUpdate, table.count(InvitationData.GetInvitedToTeamData()))
  end
end

function InvitationData.OnResTeamInvite(msg)
  if msg == nil or string.isNullOrEmpty(msg) or table.count(msg) < 1 then
    this.invitedToTeamData = {}
    TeamData.SetInviteMeData(msg)
    return
  end
  this.invitedToTeamData = {}
  for k, v in pairs(msg) do
    local data = {
      type = InvitationType.InvitedToTeam,
      inviterId = v.inviterId,
      teamId = v.teamId,
      inviterName = v.inviterName,
      level = v.level,
      career = v.career
    }
    table.insert(this.invitedToTeamData, data)
    TeamData.SetInviteMeData(data)
  end
end

function InvitationData.OnResAllianceInvite(msg)
  this.inviteToAllianceData = {}
  for k, v in pairs(msg) do
    local data = {
      type = InvitationType.InviteToAlliance,
      inviterId = v.inviterId,
      unionId = v.unionId,
      inviterName = v.inviterName,
      unionName = v.unionName
    }
    table.insert(this.inviteToAllianceData, data)
  end
  EventManager.Dispatch(Event.UpdateAllianceInvite, table.count(InvitationData.GetInvitedToAllianceData()))
end

function InvitationData.GetInvitedToTeamData()
  return this.invitedToTeamData
end

function InvitationData.GetInvitedToAllianceData()
  return this.inviteToAllianceData
end
