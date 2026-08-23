netMsgPreprocessing[33001] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():RefreshMatchTeamInfo(tblData)
  end
end
netMsgPreprocessing[33004] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():Clear(1)
  end
end
netMsgPreprocessing[33011] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():Clear(2)
  end
end
netMsgPreprocessing[33012] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():Clear(3)
  end
end
netMsgPreprocessing[33034] = function(msgID, tblData)
end
netMsgPreprocessing[33045] = function(msgID, tblData)
end
netMsgPreprocessing[33049] = function(msgID, tblData)
end
netMsgPreprocessing[33056] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() and tblData.msgType == ReqTeamInfoType.Default then
    QuickFind:GetTeam3V3DataMgr():SetEnemyTeamInfo(tblData)
  end
end
netMsgPreprocessing[33062] = function(msgID, tblData)
  if tblData and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():SetQueryHasTeam(tblData.rids)
  end
end
netMsgPreprocessing[33068] = function(msgID, tblData)
end
netMsgPreprocessing[33080] = function(msgID, tblData)
end
netMsgPreprocessing[33084] = function(msgID, tblData)
end
