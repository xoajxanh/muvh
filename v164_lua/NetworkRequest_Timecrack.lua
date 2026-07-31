function networkRequest.ResGameServerConnect()
  NetManager.Send(TimeCrackMessage.ResGameServerConnect)
end

function networkRequest.ResGameServerJoin(hostId)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(TimeCrackMessage.ResGameServerJoin, reqTable)
end

function networkRequest.ResUnionChange(changeType, hostId, union)
  local reqTable = {}
  if changeType ~= nil then
    reqTable.changeType = changeType
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if union ~= nil then
    reqTable.union = union
  end
  NetManager.Send(TimeCrackMessage.ResUnionChange, reqTable)
end

function networkRequest.ReqJoinTimeCrack(count)
  local reqTable = {}
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(TimeCrackMessage.ReqJoinTimeCrack, reqTable)
end

function networkRequest.ReqTimeCrackPanel()
  NetManager.Send(TimeCrackMessage.ReqTimeCrackPanel)
end

function networkRequest.ReqCenterCrackPanel(hostId, unionId, rid, time, name)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if time ~= nil then
    reqTable.time = time
  end
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(TimeCrackMessage.ReqCenterCrackPanel, reqTable)
end

function networkRequest.ResServerCrackPanel(info, rid)
  local reqTable = {}
  if info ~= nil then
    reqTable.info = info
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(TimeCrackMessage.ResServerCrackPanel, reqTable)
end

function networkRequest.ResSendTip(roleId, tipId, params)
  local reqTable = {}
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  if tipId ~= nil then
    reqTable.tipId = tipId
  end
  if params ~= nil then
    reqTable.params = params
  else
    reqTable.params = {}
  end
  NetManager.Send(TimeCrackMessage.ResSendTip, reqTable)
end

function networkRequest.ResCreateTimeCrackMap(mapId, serverGroup, unionGroup, unionIds, infos)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if serverGroup ~= nil then
    reqTable.serverGroup = serverGroup
  end
  if unionGroup ~= nil then
    reqTable.unionGroup = unionGroup
  end
  if unionIds ~= nil then
    reqTable.unionIds = unionIds
  else
    reqTable.unionIds = {}
  end
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  NetManager.Send(TimeCrackMessage.ResCreateTimeCrackMap, reqTable)
end

function networkRequest.ResCreateTimeCrackMapRet(mapId, line, serverGroup, unionGroup, hostId, time, unionId, rid, name)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if serverGroup ~= nil then
    reqTable.serverGroup = serverGroup
  end
  if unionGroup ~= nil then
    reqTable.unionGroup = unionGroup
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if time ~= nil then
    reqTable.time = time
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(TimeCrackMessage.ResCreateTimeCrackMapRet, reqTable)
end

function networkRequest.ReqEnterTimeCrack()
  NetManager.Send(TimeCrackMessage.ReqEnterTimeCrack)
end

function networkRequest.ReqCenterEnterTimeCrack(hostId, unionId, rid, time, name)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if time ~= nil then
    reqTable.time = time
  end
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(TimeCrackMessage.ReqCenterEnterTimeCrack, reqTable)
end

function networkRequest.ResEnterBattleToLogic(hostId, mapId, line, rid, ip, port)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if ip ~= nil then
    reqTable.ip = ip
  end
  if port ~= nil then
    reqTable.port = port
  end
  NetManager.Send(TimeCrackMessage.ResEnterBattleToLogic, reqTable)
end

function networkRequest.ResBattleServerInfo(ip, port, hostId)
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
  NetManager.Send(TimeCrackMessage.ResBattleServerInfo, reqTable)
end

function networkRequest.ReqSpaceCrackUnionRank()
  NetManager.Send(TimeCrackMessage.ReqSpaceCrackUnionRank)
end

function networkRequest.ResSpaceCrackPersonRankToCenter(ranks, rid, hostId, unionId)
  local reqTable = {}
  if ranks ~= nil then
    reqTable.ranks = ranks
  else
    reqTable.ranks = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(TimeCrackMessage.ResSpaceCrackPersonRankToCenter, reqTable)
end

function networkRequest.ResSpaceCrackUnionRankToCenter(ranks, rid, hostId, unionId)
  local reqTable = {}
  if ranks ~= nil then
    reqTable.ranks = ranks
  else
    reqTable.ranks = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(TimeCrackMessage.ResSpaceCrackUnionRankToCenter, reqTable)
end

function networkRequest.ResSpaceCrackPersonRankToLogic(ranks, rid, hostId, unionId)
  local reqTable = {}
  if ranks ~= nil then
    reqTable.ranks = ranks
  else
    reqTable.ranks = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(TimeCrackMessage.ResSpaceCrackPersonRankToLogic, reqTable)
end

function networkRequest.ResSpaceCrackUnionRankToLogic(ranks, rid, hostId, unionId)
  local reqTable = {}
  if ranks ~= nil then
    reqTable.ranks = ranks
  else
    reqTable.ranks = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(TimeCrackMessage.ResSpaceCrackUnionRankToLogic, reqTable)
end

function networkRequest.ReqSpaceCrackPersonRank()
  NetManager.Send(TimeCrackMessage.ReqSpaceCrackPersonRank)
end

function networkRequest.ResSpaceCrackSettleRank(info, serverGroup, unionGroup)
  local reqTable = {}
  if info ~= nil then
    reqTable.info = info
  end
  if serverGroup ~= nil then
    reqTable.serverGroup = serverGroup
  end
  if unionGroup ~= nil then
    reqTable.unionGroup = unionGroup
  end
  NetManager.Send(TimeCrackMessage.ResSpaceCrackSettleRank, reqTable)
end

function networkRequest.ReqCenterEnterTime(hostId, unionId, rid, time, name)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if time ~= nil then
    reqTable.time = time
  end
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(TimeCrackMessage.ReqCenterEnterTime, reqTable)
end

function networkRequest.ResEnterTimeToBattle(mapId, line, serverGroup, unionGroup, hostId, time, unionId, rid, name)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if serverGroup ~= nil then
    reqTable.serverGroup = serverGroup
  end
  if unionGroup ~= nil then
    reqTable.unionGroup = unionGroup
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if time ~= nil then
    reqTable.time = time
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(TimeCrackMessage.ResEnterTimeToBattle, reqTable)
end
