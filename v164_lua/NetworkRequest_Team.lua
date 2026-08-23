function networkRequest.ReqCreateTeam()
  local reqTable = {}
  
  NetManager.Send(TeamMessage.ReqCreateTeam, reqTable)
end

function networkRequest.ReqAskEnterTeam(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(TeamMessage.ReqAskEnterTeam, reqTable)
end

function networkRequest.ReqAgreeEnterTeam(asks)
  local reqTable = {}
  if asks ~= nil then
    reqTable.asks = asks
  else
    reqTable.asks = {}
  end
  NetManager.Send(TeamMessage.ReqAgreeEnterTeam, reqTable)
end

function networkRequest.ReqInviteEnter(invites)
  local reqTable = {}
  if invites ~= nil then
    reqTable.invites = invites
  else
    reqTable.invites = {}
  end
  NetManager.Send(TeamMessage.ReqInviteEnter, reqTable)
end

function networkRequest.ReqAgreeInvite(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(TeamMessage.ReqAgreeInvite, reqTable)
end

function networkRequest.ReqKickTeam(kickId)
  local reqTable = {}
  if kickId ~= nil then
    reqTable.kickId = kickId
  end
  NetManager.Send(TeamMessage.ReqKickTeam, reqTable)
end

function networkRequest.ReqExitTeam()
  local reqTable = {}
  NetManager.Send(TeamMessage.ReqExitTeam, reqTable)
end

function networkRequest.ReqDissolveTeam()
  local reqTable = {}
  NetManager.Send(TeamMessage.ReqDissolveTeam, reqTable)
end

function networkRequest.ReqChangeLeader(newLeaderId)
  local reqTable = {}
  if newLeaderId ~= nil then
    reqTable.newLeaderId = newLeaderId
  end
  NetManager.Send(TeamMessage.ReqChangeLeader, reqTable)
end

function networkRequest.ReqSetModeMode(enterMode)
  local reqTable = {}
  if enterMode ~= nil then
    reqTable.enterMode = enterMode
  end
  NetManager.Send(TeamMessage.ReqSetModeMode, reqTable)
end

function networkRequest.ReqSetLimit(minLevel, maxLevel)
  local reqTable = {}
  if minLevel ~= nil then
    reqTable.minLevel = minLevel
  end
  if maxLevel ~= nil then
    reqTable.maxLevel = maxLevel
  end
  NetManager.Send(TeamMessage.ReqSetLimit, reqTable)
end

function networkRequest.ReqGetTeamInfo()
  local reqTable = {}
  NetManager.Send(TeamMessage.ReqGetTeamInfo, reqTable)
end

function networkRequest.ReqDisAgreeEnterTeam(asks)
  local reqTable = {}
  if asks ~= nil then
    reqTable.asks = asks
  else
    reqTable.asks = {}
  end
  NetManager.Send(TeamMessage.ReqDisAgreeEnterTeam, reqTable)
end

function networkRequest.ReqRoundTeams()
  local reqTable = {}
  NetManager.Send(TeamMessage.ReqRoundTeams, reqTable)
end

function networkRequest.ReqDisAgreeInvite(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(TeamMessage.ReqDisAgreeInvite, reqTable)
end

function networkRequest.ReqSetActivity(activityMode)
  local reqTable = {}
  if activityMode ~= nil then
    reqTable.activityMode = activityMode
  end
  NetManager.Send(TeamMessage.ReqSetActivity, reqTable)
end
