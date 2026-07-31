netMsgPreprocessing[14002] = function(msgID, tblData)
end
netMsgPreprocessing[14004] = function(msgID, tblData)
end
netMsgPreprocessing[14006] = function(msgID, tblData)
end
netMsgPreprocessing[14008] = function(msgID, tblData)
end
netMsgPreprocessing[14010] = function(msgID, tblData)
end
netMsgPreprocessing[14017] = function(msgID, tblData)
end
netMsgPreprocessing[14018] = function(msgID, tblData)
end
netMsgPreprocessing[14021] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr():RefreshAllData(tblData)
  end
end
netMsgPreprocessing[14023] = function(msgID, tblData)
end
netMsgPreprocessing[14026] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr():RefreshArmbandData(tblData)
  end
end
netMsgPreprocessing[14031] = function(msgID, tblData)
end
netMsgPreprocessing[14034] = function(msgID, tblData)
end
netMsgPreprocessing[14038] = function(msgID, tblData)
end
netMsgPreprocessing[14051] = function(msgID, tblData)
end
netMsgPreprocessing[14061] = function(msgID, tblData)
end
netMsgPreprocessing[14063] = function(msgID, tblData)
end
netMsgPreprocessing[14067] = function(msgID, tblData)
end
netMsgPreprocessing[14068] = function(msgID, tblData)
end
netMsgPreprocessing[14070] = function(msgID, tblData)
end
netMsgPreprocessing[14073] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetWarAllianceRedEnvelopeManager():RefreshRedEnvelopeData(tblData)
  end
end
