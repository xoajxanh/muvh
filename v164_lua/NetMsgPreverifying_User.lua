netMsgPreprocessing[1002] = function(msgID, tblData)
  print("\230\142\165\230\148\182\229\136\176\231\148\168\230\136\183\231\153\187\229\189\149\230\182\136\230\129\175  \230\156\141\229\138\161\229\153\168\229\189\147\229\137\141\230\151\182\233\151\180:" .. tblData.serverCurTime)
end
netMsgPreprocessing[1004] = function(msgID, tblData)
end
netMsgPreprocessing[1006] = function(msgID, tblData)
end
netMsgPreprocessing[1009] = function(msgID, tblData)
end
netMsgPreprocessing[1010] = function(msgID, tblData)
end
netMsgPreprocessing[1012] = function(msgID, tblData)
end
netMsgPreprocessing[1014] = function(msgID, tblData)
  gameMgr:Logout()
end
netMsgPreprocessing[1016] = function(msgID, tblData)
end
netMsgPreprocessing[1020] = function(msgID, tblData)
end
netMsgPreprocessing[1022] = function(msgID, tblData)
end
netMsgPreprocessing[1024] = function(msgID, tblData)
end
netMsgPreprocessing[1025] = function(msgID, tblData)
end
netMsgPreprocessing[1029] = function(msgID, tblData)
  if tblData then
    QuickFind:GetTask_EarlyGoldManager():SetVerificationCode(tblData)
  end
end
