function networkRequest.ReqBossIcon()
  NetManager.Send(MapMessage.ReqBossIcon)
end

function networkRequest.ReqMove(x, y, action, time, blockIndex)
  local reqTable = {}
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  if action ~= nil then
    reqTable.action = action
  end
  if time ~= nil then
    reqTable.time = time
  end
  if blockIndex ~= nil then
    reqTable.blockIndex = blockIndex
  end
  NetManager.Send(MapMessage.ReqMove, reqTable)
end

function networkRequest.ReqChangeDir(dir)
  local reqTable = {}
  if dir ~= nil then
    reqTable.dir = dir
  end
  NetManager.Send(MapMessage.ReqChangeDir, reqTable)
end

function networkRequest.ReqLoginMap()
  NetManager.Send(MapMessage.ReqLoginMap)
end

function networkRequest.ReqTryEnterMap(mid, line)
  local reqTable = {}
  if mid ~= nil then
    reqTable.mid = mid
  end
  if line ~= nil then
    reqTable.line = line
  end
  NetManager.Send(MapMessage.ReqTryEnterMap, reqTable)
end

function networkRequest.ReqTransmit(mapId, line, x, y)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  NetManager.Send(MapMessage.ReqTransmit, reqTable)
end

function networkRequest.ReqTransferTransmit(transferId, line, changeLine)
  local reqTable = {}
  if transferId ~= nil then
    reqTable.transferId = transferId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if changeLine ~= nil then
    reqTable.changeLine = changeLine
  end
  NetManager.Send(MapMessage.ReqTransferTransmit, reqTable)
end

function networkRequest.ReqPetMove(x, y)
  local reqTable = {}
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  NetManager.Send(MapMessage.ReqPetMove, reqTable)
end

function networkRequest.ReqPickUpMapItem(objId)
  local reqTable = {}
  if objId ~= nil then
    reqTable.objId = objId
  end
  NetManager.Send(MapMessage.ReqPickUpMapItem, reqTable)
end

function networkRequest.ReqCallFlag(type, rid, mapId, line, x, y, hostId)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  if line ~= nil then
    reqTable.line = line
  end
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(MapMessage.ReqCallFlag, reqTable)
end

function networkRequest.ReqPickUpMapItems(objIds)
  local reqTable = {}
  if objIds ~= nil then
    reqTable.objIds = objIds
  else
    reqTable.objIds = {}
  end
  NetManager.Send(MapMessage.ReqPickUpMapItems, reqTable)
end

function networkRequest.ReqGetBossMapAndCount()
  NetManager.Send(MapMessage.ReqGetBossMapAndCount)
end

function networkRequest.ReqChangeInteractionState(interactionState, x, y)
  local reqTable = {}
  if interactionState ~= nil then
    reqTable.interactionState = interactionState
  end
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  NetManager.Send(MapMessage.ReqChangeInteractionState, reqTable)
end

function networkRequest.ReqBossStateByType(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(MapMessage.ReqBossStateByType, reqTable)
end

function networkRequest.ReqExitInstance()
  local reqTable = {}
  NetManager.Send(MapMessage.ReqExitInstance, reqTable)
end

function networkRequest.ReqInstanceReward()
  local reqTable = {}
  NetManager.Send(MapMessage.ReqInstanceReward, reqTable)
end

function networkRequest.ReqSubmitInstanceTask(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(MapMessage.ReqSubmitInstanceTask, reqTable)
end

function networkRequest.ReqInviteJoinInstance()
  NetManager.Send(MapMessage.ReqInviteJoinInstance)
end

function networkRequest.ReqSkipWait()
  NetManager.Send(MapMessage.ReqSkipWait)
end

function networkRequest.ReqInstanceCoolDown(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(MapMessage.ReqInstanceCoolDown, reqTable)
end

function networkRequest.ReqBlackRoomInfo()
  NetManager.Send(MapMessage.ReqBlackRoomInfo)
end

function networkRequest.ReqBlackRoomByFine()
  NetManager.Send(MapMessage.ReqBlackRoomByFine)
end

function networkRequest.ReqFlagActivityCollectBox(boxId, status)
  local reqTable = {}
  if boxId ~= nil then
    reqTable.boxId = boxId
  end
  if status ~= nil then
    reqTable.status = status
  end
  NetManager.Send(MapMessage.ReqFlagActivityCollectBox, reqTable)
end

function networkRequest.ReqGetFlagActivityReward(configId, rewardType)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  if rewardType ~= nil then
    reqTable.rewardType = rewardType
  end
  NetManager.Send(MapMessage.ReqGetFlagActivityReward, reqTable)
end

function networkRequest.ReqUnionKuaFuSystemInstanceInfo()
  local reqTable = {}
  NetManager.Send(MapMessage.ReqUnionKuaFuSystemInstanceInfo, reqTable)
end

function networkRequest.ReqUnionSiFangZhengBaInfo()
  NetManager.Send(MapMessage.ReqUnionSiFangZhengBaInfo)
end

function networkRequest.ReqUnionSiFangZhengBaBaoMing(campId)
  local reqTable = {}
  if campId ~= nil then
    reqTable.campId = campId
  end
  NetManager.Send(MapMessage.ReqUnionSiFangZhengBaBaoMing, reqTable)
end

function networkRequest.ReqShowMapLinePlayer()
  NetManager.Send(MapMessage.ReqShowMapLinePlayer)
end

function networkRequest.ReqCanJoinRemoteMap()
  local reqTable = {}
  NetManager.Send(MapMessage.ReqCanJoinRemoteMap, reqTable)
end

function networkRequest.ReqFixView(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MapMessage.ReqFixView, reqTable)
end

function networkRequest.ReqTeamMatePosition()
  NetManager.Send(MapMessage.ReqTeamMatePosition)
end

function networkRequest.ReqCreateTemporaryTransmit(transferId)
  local reqTable = {}
  if transferId ~= nil then
    reqTable.transferId = transferId
  end
  NetManager.Send(MapMessage.ReqCreateTemporaryTransmit, reqTable)
end

function networkRequest.ReqMonsterInfoByTypeAndInstanceType(instanceType, monsterType)
  local reqTable = {}
  if instanceType ~= nil then
    reqTable.instanceType = instanceType
  end
  if monsterType ~= nil then
    reqTable.monsterType = monsterType
  else
    reqTable.monsterType = {}
  end
  NetManager.Send(MapMessage.ReqMonsterInfoByTypeAndInstanceType, reqTable)
end

function networkRequest.ReqCountDown(mapId)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  NetManager.Send(MapMessage.ReqCountDown, reqTable)
end

function networkRequest.ReqMonsterDropRate(monsterConfigId)
  local reqTable = {}
  if monsterConfigId ~= nil then
    reqTable.monsterConfigId = monsterConfigId
  else
    reqTable.monsterConfigId = {}
  end
  NetManager.Send(MapMessage.ReqMonsterDropRate, reqTable)
end

function networkRequest.ReqSpecialOjbectPosition(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(MapMessage.ReqSpecialOjbectPosition, reqTable)
end

function networkRequest.ReqPickUpMapItemsByType(objIds, storageType)
  local reqTable = {}
  if objIds ~= nil then
    reqTable.objIds = objIds
  else
    reqTable.objIds = {}
  end
  if storageType ~= nil then
    reqTable.storageType = storageType
  end
  NetManager.Send(MapMessage.ReqPickUpMapItemsByType, reqTable)
end

function networkRequest.ReqCallBoss(id, mid, state)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if mid ~= nil then
    reqTable.mid = mid
  end
  if state ~= nil then
    reqTable.state = state
  end
  NetManager.Send(MapMessage.ReqCallBoss, reqTable)
end

function networkRequest.ReqAncientBossInfo(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(MapMessage.ReqAncientBossInfo, reqTable)
end

function networkRequest.ReqJoinToTower()
  NetManager.Send(MapMessage.ReqJoinToTower)
end

function networkRequest.ReqStartNextTower()
  NetManager.Send(MapMessage.ReqStartNextTower)
end

function networkRequest.ReqReChallengeTower()
  NetManager.Send(MapMessage.ReqReChallengeTower)
end

function networkRequest.ReqJoinGoldCaves(type, count)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(MapMessage.ReqJoinGoldCaves, reqTable)
end

function networkRequest.ReqGetRingBossCount(transfer, line)
  local reqTable = {}
  if transfer ~= nil then
    reqTable.transfer = transfer
  end
  if line ~= nil then
    reqTable.line = line
  end
  NetManager.Send(MapMessage.ReqGetRingBossCount, reqTable)
end

function networkRequest.ReqGetAllLine(mapId)
  local reqTable = {}
  if mapId ~= nil then
    reqTable.mapId = mapId
  end
  NetManager.Send(MapMessage.ReqGetAllLine, reqTable)
end

function networkRequest.ReqAscendSecretRealmMonster(itemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(MapMessage.ReqAscendSecretRealmMonster, reqTable)
end
