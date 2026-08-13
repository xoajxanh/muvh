function networkRequest.ReqPutOnTheEquip(position, equipId)
  local reqTable = {}
  
  if position ~= nil then
    reqTable.position = position
  end
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqPutOnTheEquip, reqTable)
end

function networkRequest.ReqTakeOffTheEquip(position)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  NetManager.Send(EquipMessage.ReqTakeOffTheEquip, reqTable)
end

function networkRequest.ReqEquipIntensify(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipIntensify, reqTable)
end

function networkRequest.ReqEquipAdditional(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipAdditional, reqTable)
end

function networkRequest.ReqEquipGrowUp(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipGrowUp, reqTable)
end

function networkRequest.ReqEquipBreach(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipBreach, reqTable)
end

function networkRequest.ReqEquipInfo(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipInfo, reqTable)
end

function networkRequest.ReqEquipSuperpose(equipId, supEquipId, excellent, upRate, chooseId, excellentId, excellentInfo)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if supEquipId ~= nil then
    reqTable.supEquipId = supEquipId
  end
  if excellent ~= nil then
    reqTable.excellent = excellent
  else
    reqTable.excellent = {}
  end
  if upRate ~= nil then
    reqTable.upRate = upRate
  else
    reqTable.upRate = {}
  end
  if chooseId ~= nil then
    reqTable.chooseId = chooseId
  end
  if excellentId ~= nil then
    reqTable.excellentId = excellentId
  end
  if excellentInfo ~= nil then
    reqTable.excellentInfo = excellentInfo
  else
    reqTable.excellentInfo = {}
  end
  NetManager.Send(EquipMessage.ReqEquipSuperpose, reqTable)
end

function networkRequest.ReqEquipTransfer(equipId, traEquipId, type, maxIntensify, maxAdditional)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if traEquipId ~= nil then
    reqTable.traEquipId = traEquipId
  end
  if type ~= nil then
    reqTable.type = type
  else
    reqTable.type = {}
  end
  if maxIntensify ~= nil then
    reqTable.maxIntensify = maxIntensify
  end
  if maxAdditional ~= nil then
    reqTable.maxAdditional = maxAdditional
  end
  NetManager.Send(EquipMessage.ReqEquipTransfer, reqTable)
end

function networkRequest.ReqEquipDecompose(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  else
    reqTable.equipId = {}
  end
  NetManager.Send(EquipMessage.ReqEquipDecompose, reqTable)
end

function networkRequest.ReqEquipDefaultHorse(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipDefaultHorse, reqTable)
end

function networkRequest.ReqTakeOffTheHorse(equipId, position)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if position ~= nil then
    reqTable.position = position
  end
  NetManager.Send(EquipMessage.ReqTakeOffTheHorse, reqTable)
end

function networkRequest.ReqChangeTitleState(rid, position, wear)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if position ~= nil then
    reqTable.position = position
  end
  if wear ~= nil then
    reqTable.wear = wear
  end
  NetManager.Send(EquipMessage.ReqChangeTitleState, reqTable)
end

function networkRequest.ReqRedEquipUpRank(position, equipId, equipItemId)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if equipItemId ~= nil then
    reqTable.equipItemId = equipItemId
  end
  NetManager.Send(EquipMessage.ReqRedEquipUpRank, reqTable)
end

function networkRequest.ReqEquipExcellentClear(equipId, state)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if state ~= nil then
    reqTable.state = state
  end
  NetManager.Send(EquipMessage.ReqEquipExcellentClear, reqTable)
end

function networkRequest.ReqEquipReGenerate(equipId, attId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if attId ~= nil then
    reqTable.attId = attId
  end
  NetManager.Send(EquipMessage.ReqEquipReGenerate, reqTable)
end

function networkRequest.ReqEquipReEvolution(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqEquipReEvolution, reqTable)
end

function networkRequest.ReqreplaceEquipReGenerate(equipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  NetManager.Send(EquipMessage.ReqreplaceEquipReGenerate, reqTable)
end

function networkRequest.ReqTransferEquipCareer(equipId, itemId, consumEquipId)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if consumEquipId ~= nil then
    reqTable.consumEquipId = consumEquipId
  end
  NetManager.Send(EquipMessage.ReqTransferEquipCareer, reqTable)
end

function networkRequest.ReqInlayReplaceRune(itemId, indexId, point)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if indexId ~= nil then
    reqTable.indexId = indexId
  end
  if point ~= nil then
    reqTable.point = point
  end
  NetManager.Send(EquipMessage.ReqInlayReplaceRune, reqTable)
end

function networkRequest.ReqRuneFuse(runeId, runeFuseId, index, point)
  local reqTable = {}
  if runeId ~= nil then
    reqTable.runeId = runeId
  end
  if runeFuseId ~= nil then
    reqTable.runeFuseId = runeFuseId
  end
  if index ~= nil then
    reqTable.index = index
  end
  if point ~= nil then
    reqTable.point = point
  end
  NetManager.Send(EquipMessage.ReqRuneFuse, reqTable)
end

function networkRequest.ReqTakeOffRune(index, point)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  if point ~= nil then
    reqTable.point = point
  end
  NetManager.Send(EquipMessage.ReqTakeOffRune, reqTable)
end

function networkRequest.ReqOperationFashion(fashionType, position, type)
  local reqTable = {}
  if fashionType ~= nil then
    reqTable.fashionType = fashionType
  end
  if position ~= nil then
    reqTable.position = position
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(EquipMessage.ReqOperationFashion, reqTable)
end

function networkRequest.ReqRuneUp(index, type)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(EquipMessage.ReqRuneUp, reqTable)
end

function networkRequest.ReqImplantRune(index, itemId)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(EquipMessage.ReqImplantRune, reqTable)
end

function networkRequest.ReqEnchantUpgrade(index)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  NetManager.Send(EquipMessage.ReqEnchantUpgrade, reqTable)
end

function networkRequest.ReqEnchantReplace(index, uniqueId)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  if uniqueId ~= nil then
    reqTable.uniqueId = uniqueId
  end
  NetManager.Send(EquipMessage.ReqEnchantReplace, reqTable)
end

function networkRequest.ReqEquipSmelt(equipId, type)
  local reqTable = {}
  if equipId ~= nil then
    reqTable.equipId = equipId
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(EquipMessage.ReqEquipSmelt, reqTable)
end
