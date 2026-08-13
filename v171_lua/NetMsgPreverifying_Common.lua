netMsgPreprocessing[303008] = function(msgID, tblData)
end
netMsgPreprocessing[303009] = function(msgID, tblData)
end
netMsgPreprocessing[303011] = function(msgID, tblData)
end
netMsgPreprocessing[303012] = function(msgID, tblData)
end
netMsgPreprocessing[303013] = function(msgID, tblData)
  gameMgr:GetFunctionDisableManager():RefreshFunctionDisableList(tblData)
end
netMsgPreprocessing[303014] = function(msgID, tblData)
  if tblData then
    SceneData.openDayMax = tblData.openDayMax
  end
end
