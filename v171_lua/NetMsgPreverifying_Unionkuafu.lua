netMsgPreprocessing[24001] = function(msgID, tblData)
  gameMgr:GetCoalitionManager():RefreshSingleCoalitionInfo(tblData)
end
netMsgPreprocessing[24006] = function(msgID, tblData)
  gameMgr:GetCoalitionManager():RefreshAllCoalitionInfo(tblData)
end
netMsgPreprocessing[24007] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():SetCoalitionId(tblData.camp)
    EventManager.Dispatch(Event.MainPlayerCoalitionChange)
  end
end
netMsgPreprocessing[24011] = function(msgID, tblData)
  gameMgr:GetCoalitionManager():RefreshOnLineNum(tblData)
end
