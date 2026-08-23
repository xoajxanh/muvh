function networkRequest.ResSpecialShieldInfo(roleId, buffId, curValue, maxValue)
  local reqTable = {}
  
  if roleId ~= nil then
    reqTable.roleId = roleId
  end
  if buffId ~= nil then
    reqTable.buffId = buffId
  end
  if curValue ~= nil then
    reqTable.curValue = curValue
  end
  if maxValue ~= nil then
    reqTable.maxValue = maxValue
  end
  NetManager.Send(BufferMessage.ResSpecialShieldInfo, reqTable)
end
