function networkRequest.ReqRegisterServer(ip, port, hostId, serverType, openTime)
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
  if openTime ~= nil then
    reqTable.openTime = openTime
  end
  NetManager.Send(PVPMatchMessage.ReqRegisterServer, reqTable)
end

function networkRequest.ReqStartMultipleMoBaMatch(matchType, unit, hostId, totalFightPower, stairsId)
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
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
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

function networkRequest.ResJoinMultipleMoBaMatchSuccess(matchType, unit, comPetitionMatchType)
  local reqTable = {}
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if unit ~= nil then
    reqTable.unit = unit
  end
  if comPetitionMatchType ~= nil then
    reqTable.comPetitionMatchType = comPetitionMatchType
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

function networkRequest.ReqCancelMultipleMoBaMatch(matchType, unit, hostId, offline, cancelRid, stairsId)
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
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
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

function networkRequest.ResCancelMultipleMoBaMatch(matchType, unit, hostId, offline, cancelRid, stairsId)
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
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
  end
  NetManager.Send(PVPMatchMessage.ResCancelMultipleMoBaMatch, reqTable)
end

function networkRequest.ReqCreateBattle(battleId, matchType, matchGroup, battleIp, battlePort, battleMapId, battleLine, hostId, competitionType, zoneId, TipsType)
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
  if competitionType ~= nil then
    reqTable.competitionType = competitionType
  end
  if zoneId ~= nil then
    reqTable.zoneId = zoneId
  end
  if TipsType ~= nil then
    reqTable.TipsType = TipsType
  end
  NetManager.Send(PVPMatchMessage.ReqCreateBattle, reqTable)
end

function networkRequest.ResCreateBattle(battleId, matchType, matchGroup, battleIp, battlePort, battleMapId, battleLine, hostId, competitionType, zoneId, TipsType)
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
  if competitionType ~= nil then
    reqTable.competitionType = competitionType
  end
  if zoneId ~= nil then
    reqTable.zoneId = zoneId
  end
  if TipsType ~= nil then
    reqTable.TipsType = TipsType
  end
  NetManager.Send(PVPMatchMessage.ResCreateBattle, reqTable)
end

function networkRequest.ReqBattleResult(battleId, matchType, winGroupId, battleClose, onHookPlayer, mvpPlayer, bubbleCount, competitionScore, killInfos, competitionType)
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
  if bubbleCount ~= nil then
    reqTable.bubbleCount = bubbleCount
  end
  if competitionScore ~= nil then
    reqTable.competitionScore = competitionScore
  end
  if killInfos ~= nil then
    reqTable.killInfos = killInfos
  else
    reqTable.killInfos = {}
  end
  if competitionType ~= nil then
    reqTable.competitionType = competitionType
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

function networkRequest.ReqChangeRule(fullCount, teamCount, nowTime)
  local reqTable = {}
  if fullCount ~= nil then
    reqTable.fullCount = fullCount
  end
  if teamCount ~= nil then
    reqTable.teamCount = teamCount
  end
  if nowTime ~= nil then
    reqTable.nowTime = nowTime
  end
  NetManager.Send(PVPMatchMessage.ReqChangeRule, reqTable)
end

function networkRequest.ReqMatchStairs(stairsId, rid, hostId, offlineRids)
  local reqTable = {}
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if offlineRids ~= nil then
    reqTable.offlineRids = offlineRids
  else
    reqTable.offlineRids = {}
  end
  NetManager.Send(PVPMatchMessage.ReqMatchStairs, reqTable)
end

function networkRequest.ResMatchStairsToServer(members, leaderId, stairsId)
  local reqTable = {}
  if members ~= nil then
    reqTable.members = members
  else
    reqTable.members = {}
  end
  if leaderId ~= nil then
    reqTable.leaderId = leaderId
  end
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
  end
  NetManager.Send(PVPMatchMessage.ResMatchStairsToServer, reqTable)
end

function networkRequest.ResCompetitionRewardToServer(detail)
  local reqTable = {}
  if detail ~= nil then
    reqTable.detail = detail
  else
    reqTable.detail = {}
  end
  NetManager.Send(PVPMatchMessage.ResCompetitionRewardToServer, reqTable)
end

function networkRequest.ReqMatchGroup(stairsId, rid, hostId, offlineRids)
  local reqTable = {}
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if offlineRids ~= nil then
    reqTable.offlineRids = offlineRids
  else
    reqTable.offlineRids = {}
  end
  NetManager.Send(PVPMatchMessage.ReqMatchGroup, reqTable)
end

function networkRequest.ReqMatchGroupToCenter(stairsId, rid, hostId, offlineRids)
  local reqTable = {}
  if stairsId ~= nil then
    reqTable.stairsId = stairsId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if offlineRids ~= nil then
    reqTable.offlineRids = offlineRids
  else
    reqTable.offlineRids = {}
  end
  NetManager.Send(PVPMatchMessage.ReqMatchGroupToCenter, reqTable)
end

function networkRequest.ResCompetitionStart(battleId, matchType, matchGroup, battleIp, battlePort, battleMapId, battleLine, hostId, competitionType, zoneId, TipsType)
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
  if competitionType ~= nil then
    reqTable.competitionType = competitionType
  end
  if zoneId ~= nil then
    reqTable.zoneId = zoneId
  end
  if TipsType ~= nil then
    reqTable.TipsType = TipsType
  end
  NetManager.Send(PVPMatchMessage.ResCompetitionStart, reqTable)
end

function networkRequest.ResCompetitionTipsToServer(tipData)
  local reqTable = {}
  if tipData ~= nil then
    reqTable.tipData = tipData
  else
    reqTable.tipData = {}
  end
  NetManager.Send(PVPMatchMessage.ResCompetitionTipsToServer, reqTable)
end

function networkRequest.ReqJoinCompetitionBattle(battleId)
  local reqTable = {}
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  NetManager.Send(PVPMatchMessage.ReqJoinCompetitionBattle, reqTable)
end

function networkRequest.ReqJoinCompetitionBattleToCenter(battleId, rid, hostId)
  local reqTable = {}
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(PVPMatchMessage.ReqJoinCompetitionBattleToCenter, reqTable)
end

function networkRequest.ReqJoinCompetitionBattleToServer(rid, battleId, mapId, line, battleHostId, matchType, battleIp, battlePort)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if battleId ~= nil then
    reqTable.battleId = battleId
  end
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if battleHostId ~= nil then
    reqTable.battleHostId = battleHostId
  end
  if matchType ~= nil then
    reqTable.matchType = matchType
  end
  if battleIp ~= nil then
    reqTable.battleIp = battleIp
  end
  if battlePort ~= nil then
    reqTable.battlePort = battlePort
  end
  NetManager.Send(PVPMatchMessage.ReqJoinCompetitionBattleToServer, reqTable)
end

function networkRequest.ResKnockoutDrawTipToServer(position, rid, type, releaseTime)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if type ~= nil then
    reqTable.type = type
  end
  if releaseTime ~= nil then
    reqTable.releaseTime = releaseTime
  end
  NetManager.Send(PVPMatchMessage.ResKnockoutDrawTipToServer, reqTable)
end

function networkRequest.ReqCompetitionStage()
  NetManager.Send(PVPMatchMessage.ReqCompetitionStage)
end

function networkRequest.ReqCompetitionStageToCenter(hostId, rid)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(PVPMatchMessage.ReqCompetitionStageToCenter, reqTable)
end

function networkRequest.ResCompetitionStageToServer(rid, info, promoteTimeDetail, stage)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if info ~= nil then
    reqTable.info = info
  else
    reqTable.info = {}
  end
  if promoteTimeDetail ~= nil then
    reqTable.promoteTimeDetail = promoteTimeDetail
  else
    reqTable.promoteTimeDetail = {}
  end
  if stage ~= nil then
    reqTable.stage = stage
  end
  NetManager.Send(PVPMatchMessage.ResCompetitionStageToServer, reqTable)
end
