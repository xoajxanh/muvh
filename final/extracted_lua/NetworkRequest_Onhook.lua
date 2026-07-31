function networkRequest.ReqGetOnHookInfo()
  NetManager.Send(OnHookMessage.ReqGetOnHookInfo)
end

function networkRequest.ReqGetOnHookReward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, reqTable)
end
