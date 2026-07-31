netMsgPreprocessing[20002] = function(msgID, tblData)
end
netMsgPreprocessing[20004] = function(msgID, tblData)
end
netMsgPreprocessing[20006] = function(msgID, tblData)
end
netMsgPreprocessing[20008] = function(msgID, tblData)
end
netMsgPreprocessing[20011] = function(msgID, tblData)
end
netMsgPreprocessing[20013] = function(msgID, tblData)
end
netMsgPreprocessing[20015] = function(msgID, tblData)
end
netMsgPreprocessing[20016] = function(msgID, tblData)
end
netMsgPreprocessing[20017] = function(msgID, tblData)
  if tblData.totalRechargeRMB ~= nil then
    RechargeData.TotalRechargeNum = tblData.totalRechargeRMB
  end
end
netMsgPreprocessing[20019] = function(msgID, tblData)
  if tblData and tblData.lastStarList then
    RechargeData.LuckyStarData:SetRewardData(tblData)
  end
end
netMsgPreprocessing[20020] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():InitRechargeSurpriseDataList(tblData)
  end
end
netMsgPreprocessing[20021] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():PurchaseRechargeSurprise(tblData)
  end
end
netMsgPreprocessing[20025] = function(msgID, tblData)
end
netMsgPreprocessing[20026] = function(msgID, tblData)
  RechargeData.GoldDiamondRechargeData.RefreshRechargePoint(tblData)
end
netMsgPreprocessing[20028] = function(msgID, tblData)
end
netMsgPreprocessing[20029] = function(msgID, tblData)
end
