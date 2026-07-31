netMsgPreprocessing[4001] = function(msgID, tblData)
  if tblData then
    QuickFind:GetTask_EarlyGoldManager():SetOnResTasks(tblData)
  end
end
netMsgPreprocessing[4002] = function(msgID, tblData)
  if tblData then
    QuickFind:GetTask_EarlyGoldManager():SetOnResTask(tblData)
  end
end
netMsgPreprocessing[4003] = function(msgID, tblData)
end
netMsgPreprocessing[4009] = function(msgID, tblData)
end
netMsgPreprocessing[4010] = function(msgID, tblData)
end
netMsgPreprocessing[4015] = function(msgID, tblData)
end
netMsgPreprocessing[4017] = function(msgID, tblData)
end
netMsgPreprocessing[4018] = function(msgID, tblData)
end
netMsgPreprocessing[4020] = function(msgID, tblData)
  TaskData.SetNewBossBountyReward(tblData)
end
netMsgPreprocessing[4022] = function(msgID, tblData)
end
