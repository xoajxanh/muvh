function networkRequest.ReqRegisterServer(ip, port, hostId, serverType)
  local reqTable = {}
  
  if ip ~= nil then
    reqTable.ip = ip
  end
  if port ~= nil then
    reqTable.port = port
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if serverType ~= nil then
    reqTable.serverType = serverType
  end
  NetManager.Send(PVPMatchMessage.ReqRegisterServer, reqTable)
end

function networkRequest.ReqStartMultipleMoBaMatch(matchType, unit, hostId, totalFightPower)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unit ~= nil then
    reqTable.unit = unit
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if totalFightPower ~= nil then
    reqTable.totalFightPower = totalFightPower
  end
  NetManager.Send(PVPMatchMessage.ReqStartMultipleMoBaMatch, reqTable)
end

function networkRequest.ReqMatchServerHeart(serverType, serverKey)
  local reqTable = {}
  if serverType ~= nil then
    reqTable.serverType = serverType
  end
  if serverKey ~= nil then
    reqTable.serverKey = serverKey
  end
  NetManager.Send(PVPMatchMessage.ReqMatchServerHeart, reqTable)
end

function networkRequest.ResGameMatchServerHeart()
  NetManager.Send(PVPMatchMessage.ResGameMatchServerHeart)
end

function networkRequest.ResBattleMatchServerHeart()
  NetManager.Send(PVPMatchMessage.ResBattleMatchServerHeart)
end

function networkRequest.ResJoinMultipleMoBaMatchSuccess(matchType, unit)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unit ~= nil then
    reqTable.unit = unit
  end
  NetManager.Send(PVPMatchMessage.ResJoinMultipleMoBaMatchSuccess, reqTable)
end

function networkRequest.ReqThreeVThreePlaneInfo(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqThreeVThreePlaneInfo, reqTable)
end

function networkRequest.ReqCreateMatchTeam(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqCreateMatchTeam, reqTable)
end

function networkRequest.ReqThreeVThreeInvitePlayer(playerId, serverId, pvpType)
  local reqTable = {}
  if playerId ~= nil then
    reqTable.playerId = playerId
  end
  if serverId ~= nil then
    reqTable.serverId = serverId
  end
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqThreeVThreeInvitePlayer, reqTable)
end

function networkRequest.ReqThreeVThreeInviteAck(teamId, status, pvpType)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if status ~= nil then
    reqTable.status = status
  end
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqThreeVThreeInviteAck, reqTable)
end

function networkRequest.ReqStartMatchThreeVThree(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqStartMatchThreeVThree, reqTable)
end

function networkRequest.ReqCancelMatchThreeVThree(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqCancelMatchThreeVThree, reqTable)
end

function networkRequest.ReqExitThreeVThreeTeam(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqExitThreeVThreeTeam, reqTable)
end

function networkRequest.ReqKickOutTeam(playerId, pvpType)
  local reqTable = {}
  if playerId ~= nil then
    reqTable.playerId = playerId
  end
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqKickOutTeam, reqTable)
end

function networkRequest.ReqOpenDoublePVP(open, pvpType, multiple)
  local reqTable = {}
  if open ~= nil then
    reqTable.open = open
  end
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  if multiple ~= nil then
    reqTable.multiple = multiple
  end
  NetManager.Send(PVPMatchMessage.ReqOpenDoublePVP, reqTable)
end

function networkRequest.ReqCancelMultipleMoBaMatch(matchType, unit, hostId, offline, cancelRid)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unit ~= nil then
    reqTable.unit = unit
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if offline ~= nil then
    reqTable.offline = offline
  end
  if cancelRid ~= nil then
    reqTable.cancelRid = cancelRid
  end
  NetManager.Send(PVPMatchMessage.ReqCancelMultipleMoBaMatch, reqTable)
end

function networkRequest.ResJoinMultipleMoBaMatchError(matchType, unitId, errorType)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unitId ~= nil then
    reqTable.unitId = unitId
  end
  if errorType ~= nil then
    reqTable.errorType = errorType
  end
  NetManager.Send(PVPMatchMessage.ResJoinMultipleMoBaMatchError, reqTable)
end

function networkRequest.ResCancelMultipleMoBaMatch(matchType, unit, hostId, offline, cancelRid)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unit ~= nil then
    reqTable.unit = unit
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if offline ~= nil then
    reqTable.offline = offline
  end
  if cancelRid ~= nil then
    reqTable.cancelRid = cancelRid
  end
  NetManager.Send(PVPMatchMessage.ResCancelMultipleMoBaMatch, reqTable)
end

function networkRequest.ReqCreateBattle(battleId, matchType, matchGroup, battleIp, battlePort, battleMapId, battleLine, hostId)
  local reqTable = {}
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if matchGroup ~= nil then
    reqTable.matchGroup = matchGroup
  else
    reqTable.matchGroup = {}
  end
  if battleIp ~= nil then
    reqTable.battleIp = battleIp
  end
  if battlePort ~= nil then
    reqTable.battlePort = battlePort
  end
  if battleMapId ~= nil then
    reqTable.battleMapId = battleMapId
  end
  if battleLine ~= nil then
    reqTable.battleLine = battleLine
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(PVPMatchMessage.ReqCreateBattle, reqTable)
end

function networkRequest.ResCreateBattle(battleId, matchType, matchGroup, battleIp, battlePort, battleMapId, battleLine, hostId)
  local reqTable = {}
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if matchGroup ~= nil then
    reqTable.matchGroup = matchGroup
  else
    reqTable.matchGroup = {}
  end
  if battleIp ~= nil then
    reqTable.battleIp = battleIp
  end
  if battlePort ~= nil then
    reqTable.battlePort = battlePort
  end
  if battleMapId ~= nil then
    reqTable.battleMapId = battleMapId
  end
  if battleLine ~= nil then
    reqTable.battleLine = battleLine
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(PVPMatchMessage.ResCreateBattle, reqTable)
end

function networkRequest.ReqBattleResult(battleId, matchType, winGroupId, battleClose, onHookPlayer, mvpPlayer)
  local reqTable = {}
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if winGroupId ~= nil then
    reqTable.winGroupId = winGroupId
  end
  if battleClose ~= nil then
    reqTable.battleClose = battleClose
  end
  if onHookPlayer ~= nil then
    reqTable.onHookPlayer = onHookPlayer
  else
    reqTable.onHookPlayer = {}
  end
  if mvpPlayer ~= nil then
    reqTable.mvpPlayer = mvpPlayer
  else
    reqTable.mvpPlayer = {}
  end
  NetManager.Send(PVPMatchMessage.ReqBattleResult, reqTable)
end

function networkRequest.ReqClosePunish(pvpType)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  NetManager.Send(PVPMatchMessage.ReqClosePunish, reqTable)
end

function networkRequest.ReqPrepare(pvpType, prepare)
  local reqTable = {}
  if pvpType ~= nil then
    reqTable.pvpType = pvpType
  end
  if prepare ~= nil then
    reqTable.prepare = prepare
  end
  NetManager.Send(PVPMatchMessage.ReqPrepare, reqTable)
end
