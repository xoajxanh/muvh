netMsgPreprocessing[203002] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():ResetGemCalculate()
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():BagItemChange()
  gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():RefreshData_NeedActiveInfo(tblData ~= nil and tblData.items or nil, nil, true)
end
netMsgPreprocessing[203004] = function(msgID, tblData)
end
netMsgPreprocessing[203006] = function(msgID, tblData)
end
netMsgPreprocessing[203009] = function(msgID, tblData)
end
netMsgPreprocessing[203010] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():ResetGemCalculate()
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():BagItemChange()
  gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():SetXiLianEquipByServerDataList(tblData.items)
  gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():RefreshData_NeedActiveInfo(tblData.items, tblData.removeItem)
end
netMsgPreprocessing[203014] = function(msgID, tblData)
end
netMsgPreprocessing[203018] = function(msgID, tblData)
end
netMsgPreprocessing[203022] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():SetLightStoneCellInfo(tblData)
end
netMsgPreprocessing[203024] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():EquipIndexGemListRefresh(tblData)
end
netMsgPreprocessing[203026] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():EquipIndexGemRefresh(tblData.lightStone, true)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():ResetGemCalculate()
end
netMsgPreprocessing[203027] = function(msgID, tblData)
  if tblData and tblData.reRuneInfoPackingInfo and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr() then
    MeRunneController:ServerUpdateRuneData(tblData.reRuneInfoPackingInfo)
  end
  if tblData and tblData.reRuneInfoPackingInfo then
    EventManager.Dispatch(Event.RuneFusionCallBack, tblData)
  end
end
netMsgPreprocessing[203028] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr() then
    MeRunneController:ServerDeleteRuneData(tblData)
  end
end
netMsgPreprocessing[203029] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResBagChange(tblData)
  end
end
netMsgPreprocessing[203030] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResBagInfo(tblData)
  end
end
netMsgPreprocessing[203032] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr() and tblData.storageType == 4 then
    gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():OnResBagInfo(tblData)
  end
  if tblData and tblData.storageType == StorageTypeEnum.CrystalNucleus then
    CrystalNucleusBagManager:OnResBagInfo(tblData)
  end
  if tblData and tblData.storageType == StorageTypeEnum.PandoraBag then
    BagInfoController.OnResPandoraInfo(tblData)
  end
end
