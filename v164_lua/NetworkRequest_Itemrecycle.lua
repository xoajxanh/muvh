function networkRequest.ReqItemRecycle(recycleItems, recycleType)
  local reqTable = {}
  
  if recycleItems ~= nil then
    reqTable.recycleItems = recycleItems
  else
    reqTable.recycleItems = {}
  end
  if recycleType ~= nil then
    reqTable.recycleType = recycleType
  end
  NetManager.Send(ItemRecycleMessage.ReqItemRecycle, reqTable)
end
