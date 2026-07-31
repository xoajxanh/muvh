function networkRequest.ReqGetEquipRansomInfo()
  NetManager.Send(EquipRansomMessage.ReqGetEquipRansomInfo)
end

function networkRequest.ReqRansomEquip(itemId, type)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(EquipRansomMessage.ReqRansomEquip, reqTable)
end
