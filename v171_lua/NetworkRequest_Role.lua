function networkRequest.ReqAttributeModify(modify, add)
  local reqTable = {}
  
  if modify ~= nil then
    reqTable.modify = modify
  else
    reqTable.modify = {}
  end
  if add ~= nil then
    reqTable.add = add
  end
  NetManager.Send(RoleMessage.ReqAttributeModify, reqTable)
end

function networkRequest.ReqOtherRoleInfo(direction, hostId, roleId, serverId)
  local reqTable = {}
  if direction ~= nil then
    reqTable.direction = direction
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  if serverId ~= nil then
    reqTable.serverId = serverId
  end
  NetManager.Send(RoleMessage.ReqOtherRoleInfo, reqTable)
end

function networkRequest.ReqSetPKMode(param, campId)
  local reqTable = {}
  if param ~= nil then
    reqTable.param = param
  end
  if campId ~= nil then
    reqTable.campId = campId
  end
  NetManager.Send(RoleMessage.ReqSetPKMode, reqTable)
end

function networkRequest.ReqTeamEquipsInfo(roleId, hostId, reqFlag)
  local reqTable = {}
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if reqFlag ~= nil then
    reqTable.reqFlag = reqFlag
  end
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, reqTable)
end

function networkRequest.ReqSaveAppear(appear)
  local reqTable = {}
  if appear ~= nil then
    reqTable.appear = appear
  end
  NetManager.Send(RoleMessage.ReqSaveAppear, reqTable)
end

function networkRequest.ReqChangeRoleName(roleId, changeName, itemId)
  local reqTable = {}
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  if changeName ~= nil then
    reqTable.changeName = changeName
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(RoleMessage.ReqChangeRoleName, reqTable)
end

function networkRequest.ReqWashAttrPoints()
  NetManager.Send(RoleMessage.ReqWashAttrPoints)
end

function networkRequest.ReqWashCounts()
  NetManager.Send(RoleMessage.ReqWashCounts)
end

function networkRequest.ReqActiveAndFind()
  NetManager.Send(RoleMessage.ReqActiveAndFind)
end

function networkRequest.ReqFind(fId, itemId, count)
  local reqTable = {}
  if fId ~= nil then
    reqTable.fId = fId
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(RoleMessage.ReqFind, reqTable)
end

function networkRequest.ReqAward(phase)
  local reqTable = {}
  if phase ~= nil then
    reqTable.phase = phase
  end
  NetManager.Send(RoleMessage.ReqAward, reqTable)
end

function networkRequest.ReqSaveClientData(dataInt, dataString)
  local reqTable = {}
  if dataInt ~= nil then
    reqTable.dataInt = dataInt
  else
    reqTable.dataInt = {}
  end
  if dataString ~= nil then
    reqTable.dataString = dataString
  else
    reqTable.dataString = {}
  end
  NetManager.Send(RoleMessage.ReqSaveClientData, reqTable)
end

function networkRequest.ReqRoleRedName()
  NetManager.Send(RoleMessage.ReqRoleRedName)
end

function networkRequest.ReqVipMemberInfo()
  NetManager.Send(RoleMessage.ReqVipMemberInfo)
end

function networkRequest.ReqVipMemberLevelReward(level)
  local reqTable = {}
  if level ~= nil then
    reqTable.level = level
  end
  NetManager.Send(RoleMessage.ReqVipMemberLevelReward, reqTable)
end

function networkRequest.ReqVipMemberDailyReward()
  NetManager.Send(RoleMessage.ReqVipMemberDailyReward)
end

function networkRequest.ReqVipMemberNowTask()
  NetManager.Send(RoleMessage.ReqVipMemberNowTask)
end

function networkRequest.ReqGuardInfo()
  NetManager.Send(RoleMessage.ReqGuardInfo)
end

function networkRequest.ReqActivationGuard(guardId, itemId)
  local reqTable = {}
  if guardId ~= nil then
    reqTable.guardId = guardId
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(RoleMessage.ReqActivationGuard, reqTable)
end

function networkRequest.ReqLevelStarGuard(guardId, itemId)
  local reqTable = {}
  if guardId ~= nil then
    reqTable.guardId = guardId
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(RoleMessage.ReqLevelStarGuard, reqTable)
end

function networkRequest.ReqSetGuardAppearance(guardId, guardSwitch)
  local reqTable = {}
  if guardId ~= nil then
    reqTable.guardId = guardId
  end
  if guardSwitch ~= nil then
    reqTable.guardSwitch = guardSwitch
  end
  NetManager.Send(RoleMessage.ReqSetGuardAppearance, reqTable)
end

function networkRequest.ReqBiBleRedPoint()
  NetManager.Send(RoleMessage.ReqBiBleRedPoint)
end

function networkRequest.ReqRoleMpHpSetting(hpRatio, mpRatio)
  local reqTable = {}
  if hpRatio ~= nil then
    reqTable.hpRatio = hpRatio
  end
  if mpRatio ~= nil then
    reqTable.mpRatio = mpRatio
  end
  NetManager.Send(RoleMessage.ReqRoleMpHpSetting, reqTable)
end

function networkRequest.ReqUpgradeHolyRing(itemId, ringExp, ringLevel, count)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if ringExp ~= nil then
    reqTable.ringExp = ringExp
  end
  if ringLevel ~= nil then
    reqTable.ringLevel = ringLevel
  end
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(RoleMessage.ReqUpgradeHolyRing, reqTable)
end

function networkRequest.ReqPutOnReplaceHolyRing(itemId, point)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if point ~= nil then
    reqTable.point = point
  end
  NetManager.Send(RoleMessage.ReqPutOnReplaceHolyRing, reqTable)
end

function networkRequest.ReqTakeOffHolyRing(point)
  local reqTable = {}
  if point ~= nil then
    reqTable.point = point
  end
  NetManager.Send(RoleMessage.ReqTakeOffHolyRing, reqTable)
end

function networkRequest.ReqHolyRingExp()
  NetManager.Send(RoleMessage.ReqHolyRingExp)
end

function networkRequest.ReqRoleEquipNormalPos()
  NetManager.Send(RoleMessage.ReqRoleEquipNormalPos)
end

function networkRequest.ReqTowerLevel()
  NetManager.Send(RoleMessage.ReqTowerLevel)
end

function networkRequest.ReqRewardTower(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(RoleMessage.ReqRewardTower, reqTable)
end

function networkRequest.ReqSaveClientSetting(setting)
  local reqTable = {}
  if setting ~= nil then
    reqTable.setting = setting
  else
    reqTable.setting = {}
  end
  NetManager.Send(RoleMessage.ReqSaveClientSetting, reqTable)
end

function networkRequest.ReqPutOnNucleus(row, col, itemId)
  local reqTable = {}
  if row ~= nil then
    reqTable.row = row
  end
  if col ~= nil then
    reqTable.col = col
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(RoleMessage.ReqPutOnNucleus, reqTable)
end

function networkRequest.ReqTakeOffNucleus(itemIds, takeOffAll)
  local reqTable = {}
  if itemIds ~= nil then
    reqTable.itemIds = itemIds
  else
    reqTable.itemIds = {}
  end
  if takeOffAll ~= nil then
    reqTable.takeOffAll = takeOffAll
  end
  NetManager.Send(RoleMessage.ReqTakeOffNucleus, reqTable)
end

function networkRequest.ReqUnLockDisk()
  NetManager.Send(RoleMessage.ReqUnLockDisk)
end

function networkRequest.ReqNucleusDoLevelUp(itemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(RoleMessage.ReqNucleusDoLevelUp, reqTable)
end

function networkRequest.ReqCrystalNucleusTransfer(itemId, traItemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if traItemId ~= nil then
    reqTable.traItemId = traItemId
  end
  NetManager.Send(RoleMessage.ReqCrystalNucleusTransfer, reqTable)
end

function networkRequest.ReqCrystalNucleusDecompose(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  else
    reqTable.equipId = {}
  end
  NetManager.Send(RoleMessage.ReqCrystalNucleusDecompose, reqTable)
end

function networkRequest.ReqDeepSeaTreasureInfo(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(RoleMessage.ReqDeepSeaTreasureInfo, reqTable)
end

function networkRequest.ReqDeepSeaTreasureAward(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(RoleMessage.ReqDeepSeaTreasureAward, reqTable)
end

function networkRequest.ReqDeepSeaTreasureReset(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(RoleMessage.ReqDeepSeaTreasureReset, reqTable)
end

function networkRequest.ReqDeepSeaTreasureCanReward()
  NetManager.Send(RoleMessage.ReqDeepSeaTreasureCanReward)
end
