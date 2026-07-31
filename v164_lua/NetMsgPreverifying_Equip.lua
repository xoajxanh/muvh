netMsgPreprocessing[206003] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():RefreshData(tblData)
    gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():ResetGemCalculate()
    gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetRegenerateEquipByServerDataList(tblData.items)
  end
end
netMsgPreprocessing[206005] = function(msgID, tblData)
end
netMsgPreprocessing[206007] = function(msgID, tblData)
end
netMsgPreprocessing[206008] = function(msgID, tblData)
end
netMsgPreprocessing[206012] = function(msgID, tblData)
end
netMsgPreprocessing[206014] = function(msgID, tblData)
end
netMsgPreprocessing[206016] = function(msgID, tblData)
end
netMsgPreprocessing[206018] = function(msgID, tblData)
end
netMsgPreprocessing[206019] = function(msgID, tblData)
end
netMsgPreprocessing[206023] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():RefreshData(tblData)
end
netMsgPreprocessing[206025] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetRedEquipLevelDataMgr():RefreshUpRankCallBack(tblData)
  end
end
netMsgPreprocessing[206026] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetRedEquipLevelDataMgr():RefreshAllRedEquipData(tblData)
  end
end
netMsgPreprocessing[206027] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():SetXiLianNewExcellenceList(tblData.equipExcellentClear)
  end
end
netMsgPreprocessing[206031] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetRegenerateNewExcellenceList(tblData.reGenerateItem.regenerateClearAttrs)
  end
end
netMsgPreprocessing[206032] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetRegenerateNewExcellenceEvoList(tblData.success)
  end
end
netMsgPreprocessing[206039] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():RefreshData_ServerInfo(tblData)
  end
end
netMsgPreprocessing[206040] = function(msgID, tblData)
  EventManager.Dispatch(Event.Appear_FashionSuccess)
  MeEquipController.ReqSaveAppear(ForgeData.appearData[RoleManager.me.id])
end
netMsgPreprocessing[206041] = function(msgID, tblData)
  if tblData and tblData.runeList and QuickFind:GetNewRuneDataManager() then
    QuickFind:GetNewRuneDataManager():RefreshAllRuneServerData(tblData.runeList)
  end
end
netMsgPreprocessing[206042] = function(msgID, tblData)
  if tblData and QuickFind:GetNewRuneDataManager() then
    QuickFind:GetNewRuneDataManager():RefreshOneRuneServerData(tblData)
  end
end
netMsgPreprocessing[206047] = function(msgID, tblData)
end
netMsgPreprocessing[206048] = function(msgID, tblData)
end
