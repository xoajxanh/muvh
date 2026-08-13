function networkRequest.ReqItemCombine(combineId, mainBuckets, bonusBuckets, combineCount)
  local reqTable = {}
  
  if combineId ~= nil then
    reqTable.combineId = combineId
  end
  if mainBuckets ~= nil then
    reqTable.mainBuckets = mainBuckets
  else
    reqTable.mainBuckets = {}
  end
  if bonusBuckets ~= nil then
    reqTable.bonusBuckets = bonusBuckets
  else
    reqTable.bonusBuckets = {}
  end
  if combineCount ~= nil then
    reqTable.combineCount = combineCount
  end
  NetManager.Send(ItemCombineMessage.ReqItemCombine, reqTable)
end

function networkRequest.ReqHolyRingCombine(combineId, combineCount)
  local reqTable = {}
  if combineId ~= nil then
    reqTable.combineId = combineId
  end
  if combineCount ~= nil then
    reqTable.combineCount = combineCount
  end
  NetManager.Send(ItemCombineMessage.ReqHolyRingCombine, reqTable)
end
