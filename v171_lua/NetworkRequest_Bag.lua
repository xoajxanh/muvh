function networkRequest.ReqBagInfo()
  NetManager.Send(BagMessage.ReqBagInfo)
end

function networkRequest.ReqUseItem(count, itemId, clientParams)
  local reqTable = {}
  if count ~= nil then
    reqTable.count = count
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if clientParams ~= nil then
    reqTable.clientParams = clientParams
  else
    reqTable.clientParams = {}
  end
  NetManager.Send(BagMessage.ReqUseItem, reqTable)
end

function networkRequest.ReqStorageInfo()
  NetManager.Send(BagMessage.ReqStorageInfo)
end

function networkRequest.ReqPutIntoStorage(id, bagGridIndex)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if bagGridIndex ~= nil then
    reqTable.bagGridIndex = bagGridIndex
  end
  NetManager.Send(BagMessage.ReqPutIntoStorage, reqTable)
end

function networkRequest.ReqTakeOutFromStorage(id, bagGridIndex)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if bagGridIndex ~= nil then
    reqTable.bagGridIndex = bagGridIndex
  end
  NetManager.Send(BagMessage.ReqTakeOutFromStorage, reqTable)
end

function networkRequest.ReqBagSort()
  NetManager.Send(BagMessage.ReqBagSort)
end

function networkRequest.ReqAddCell(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(BagMessage.ReqAddCell, reqTable)
end

function networkRequest.ReqStorageSort()
  NetManager.Send(BagMessage.ReqStorageSort)
end

function networkRequest.ReqMoveItem(itemId, bagGridIndex, type)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if bagGridIndex ~= nil then
    reqTable.bagGridIndex = bagGridIndex
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(BagMessage.ReqMoveItem, reqTable)
end

function networkRequest.ResItemInfoUpdate(items, type)
  local reqTable = {}
  if items ~= nil then
    reqTable.items = items
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(BagMessage.ResItemInfoUpdate, reqTable)
end

function networkRequest.ReqThrowItem(itemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(BagMessage.ReqThrowItem, reqTable)
end

function networkRequest.ReqDestroyItem(itemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(BagMessage.ReqDestroyItem, reqTable)
end

function networkRequest.ReqUseCDKey(cdKey)
  local reqTable = {}
  if cdKey ~= nil then
    reqTable.cdKey = cdKey
  end
  NetManager.Send(BagMessage.ReqUseCDKey, reqTable)
end

function networkRequest.ReqLightStoneCellState()
  NetManager.Send(BagMessage.ReqLightStoneCellState)
end

function networkRequest.ReqUnlockLightStone(index)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  NetManager.Send(BagMessage.ReqUnlockLightStone, reqTable)
end

function networkRequest.ReqLightStoneLevelUp(index)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  NetManager.Send(BagMessage.ReqLightStoneLevelUp, reqTable)
end

function networkRequest.ReqHolyRingBag()
  NetManager.Send(BagMessage.ReqHolyRingBag)
end

function networkRequest.ReqBagInfoByType(storageType)
  local reqTable = {}
  if storageType ~= nil then
    reqTable.storageType = storageType
  end
  NetManager.Send(BagMessage.ReqBagInfoByType, reqTable)
end

function networkRequest.ReqBagSortByType(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(BagMessage.ReqBagSortByType, reqTable)
end

function networkRequest.ReqTakeOutFromPandoraBag(ids)
  local reqTable = {}
  if ids ~= nil then
    reqTable.ids = ids
  else
    reqTable.ids = {}
  end
  NetManager.Send(BagMessage.ReqTakeOutFromPandoraBag, reqTable)
end

function networkRequest.ReqDestroyFromPandoraBag(itemIds)
  local reqTable = {}
  if itemIds ~= nil then
    reqTable.itemIds = itemIds
  else
    reqTable.itemIds = {}
  end
  NetManager.Send(BagMessage.ReqDestroyFromPandoraBag, reqTable)
end
