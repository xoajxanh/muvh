function networkRequest.ReqInstanceMatchCreateTeam(instanceId)
  local reqTable = {}
  
  if instanceId ~= nil then
    reqTable.instanceId = instanceId
  end
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCreateTeam, reqTable)
end

function networkRequest.ReqInstanceMatchInviteAll()
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteAll)
end

function networkRequest.ReqInstanceMatchInviteFriend(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteFriend, reqTable)
end

function networkRequest.ReqInstanceMatchInviteOperation(teamId, friend, agree)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if friend ~= nil then
    reqTable.friend = friend
  end
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchInviteOperation, reqTable)
end

function networkRequest.ReqInstanceMatchStartMatch()
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchStartMatch)
end

function networkRequest.ReqInstanceMatchConfirmReady()
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchConfirmReady)
end

function networkRequest.ReqInstanceMatchCancelMatch()
  NetManager.Send(InstanceMatchMessage.ReqInstanceMatchCancelMatch)
end
