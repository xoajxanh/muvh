netMsgPreprocessing[11002] = function(msgID, tblData)
end
netMsgPreprocessing[11003] = function(msgID, tblData)
end
netMsgPreprocessing[11004] = function(msgID, tblData)
end
netMsgPreprocessing[11006] = function(msgID, tblData)
end
netMsgPreprocessing[11007] = function(msgID, tblData)
end
netMsgPreprocessing[11008] = function(msgID, tblData)
end
netMsgPreprocessing[11010] = function(msgID, tblData)
  EventManager.Dispatch(Event.KalunteRuinsTransRank, tblData)
end
netMsgPreprocessing[11012] = function(msgID, tblData)
  if QuickFind:GetKunShouBattleDataMgr() then
    QuickFind:GetKunShouBattleDataMgr():SetRankData(tblData)
  end
end
netMsgPreprocessing[11013] = function(msgID, tblData)
end
netMsgPreprocessing[11014] = function(msgID, tblData)
end
netMsgPreprocessing[11016] = function(msgID, tblData)
end
netMsgPreprocessing[11018] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  QuickFind:GetDuoQiZhengBaManager():SetTeamRanks(tblData.unionInfo)
end
