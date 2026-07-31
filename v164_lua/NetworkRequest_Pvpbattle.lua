function networkRequest.ReqCapitulate(agree)
  local reqTable = {}
  
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(PVPBattleMessage.ReqCapitulate, reqTable)
end

function networkRequest.ReqPVPAnnounce(id, params)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if params ~= nil then
    reqTable.params = params
  end
  NetManager.Send(PVPBattleMessage.ReqPVPAnnounce, reqTable)
end
