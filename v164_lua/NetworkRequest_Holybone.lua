function networkRequest.ReqIntensifyHolyBone(type)
  local reqTable = {}
  
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(HolyBoneMessage.ReqIntensifyHolyBone, reqTable)
end

function networkRequest.ReqAllHolyBoneInfo()
  NetManager.Send(HolyBoneMessage.ReqAllHolyBoneInfo)
end

function networkRequest.ReqHolyBoneInlay(type, index, uniqueId)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if index ~= nil then
    reqTable.index = index
  end
  if uniqueId ~= nil then
    reqTable.uniqueId = uniqueId
  end
  NetManager.Send(HolyBoneMessage.ReqHolyBoneInlay, reqTable)
end

function networkRequest.ReqBoneMix(combineId, itemIds)
  local reqTable = {}
  if combineId ~= nil then
    reqTable.combineId = combineId
  end
  if itemIds ~= nil then
    reqTable.itemIds = itemIds
  else
    reqTable.itemIds = {}
  end
  NetManager.Send(HolyBoneMessage.ReqBoneMix, reqTable)
end
