function networkRequest.ReqSwitchUnitBuffhUnitBuff(state, type)
  local reqTable = {}
  
  if state ~= nil then
    reqTable.state = state
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnitMessage.ReqSwitchUnitBuffhUnitBuff, reqTable)
end

function networkRequest.ReqUnitState(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnitMessage.ReqUnitState, reqTable)
end

function networkRequest.ReqEquipFunction(type, open)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if open ~= nil then
    reqTable.open = open
  end
  NetManager.Send(UnitMessage.ReqEquipFunction, reqTable)
end

function networkRequest.ReqHolySealLevelUp(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnitMessage.ReqHolySealLevelUp, reqTable)
end

function networkRequest.ReqGrandMasterInfo()
  NetManager.Send(UnitMessage.ReqGrandMasterInfo)
end

function networkRequest.ReqExchangeGrandMasterExp(countGear, equipId, count)
  local reqTable = {}
  if countGear ~= nil then
    reqTable.countGear = countGear
  end
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(UnitMessage.ReqExchangeGrandMasterExp, reqTable)
end

function networkRequest.ReqEnableGrandMasterTalent(masterTalent, enableType)
  local reqTable = {}
  if masterTalent ~= nil then
    reqTable.masterTalent = masterTalent
  end
  if enableType ~= nil then
    reqTable.enableType = enableType
  end
  NetManager.Send(UnitMessage.ReqEnableGrandMasterTalent, reqTable)
end

function networkRequest.ReqUpGrandMasterSkill(masterTalent, skillId)
  local reqTable = {}
  if masterTalent ~= nil then
    reqTable.masterTalent = masterTalent
  end
  if skillId ~= nil then
    reqTable.skillId = skillId
  end
  NetManager.Send(UnitMessage.ReqUpGrandMasterSkill, reqTable)
end

function networkRequest.ReqResetGrandMaster()
  NetManager.Send(UnitMessage.ReqResetGrandMaster)
end

function networkRequest.ReqHolySpiritLevelUp(type, configId)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(UnitMessage.ReqHolySpiritLevelUp, reqTable)
end

function networkRequest.ReqUnitHolySpirit()
  NetManager.Send(UnitMessage.ReqUnitHolySpirit)
end

function networkRequest.ReqPageChange(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnitMessage.ReqPageChange, reqTable)
end

function networkRequest.ReqHolySpiritWashPoint(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnitMessage.ReqHolySpiritWashPoint, reqTable)
end
