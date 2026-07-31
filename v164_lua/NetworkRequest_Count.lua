function networkRequest.ReqCountByType(type)
  local reqTable = {}
  
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CountMessage.ReqCountByType, reqTable)
end

function networkRequest.ReqCountByKey(key)
  local reqTable = {}
  if key ~= nil then
    reqTable.key = key
  end
  NetManager.Send(CountMessage.ReqCountByKey, reqTable)
end
