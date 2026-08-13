function networkRequest.ReqGetTableConfig(key, enum)
  local reqTable = {}
  
  if key ~= nil then
    reqTable.key = key
  end
  if enum ~= nil then
    reqTable.enum = enum
  end
  NetManager.Send(TableConfigMessage.ReqGetTableConfig, reqTable)
end
