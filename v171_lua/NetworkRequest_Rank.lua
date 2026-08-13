function networkRequest.ReqQueryRanks(rankType, career)
  local reqTable = {}
  
  if rankType ~= nil then
    reqTable.rankType = rankType
  end
  if career ~= nil then
    reqTable.career = career
  end
  NetManager.Send(RankMessage.ReqQueryRanks, reqTable)
end

function networkRequest.ReqColetRuinsRanks()
  NetManager.Send(RankMessage.ReqColetRuinsRanks)
end

function networkRequest.ReqPlayerTarppedRanks()
  NetManager.Send(RankMessage.ReqPlayerTarppedRanks)
end

function networkRequest.ReqRoleKillMonsterScore()
  NetManager.Send(RankMessage.ReqRoleKillMonsterScore)
end

function networkRequest.ReqUnionKuaFuRanks()
  NetManager.Send(RankMessage.ReqUnionKuaFuRanks)
end
