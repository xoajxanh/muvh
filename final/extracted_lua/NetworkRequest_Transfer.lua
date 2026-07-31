function networkRequest.ReqTransferRole(itemId, career)
  local reqTable = {}
  
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if career ~= nil then
    reqTable.career = career
  end
  NetManager.Send(TransferMessage.ReqTransferRole, reqTable)
end

function networkRequest.ReqTransferItem(fromItemId, toConfigId)
  local reqTable = {}
  if fromItemId ~= nil then
    reqTable.fromItemId = fromItemId
  end
  if toConfigId ~= nil then
    reqTable.toConfigId = toConfigId
  end
  NetManager.Send(TransferMessage.ReqTransferItem, reqTable)
end
