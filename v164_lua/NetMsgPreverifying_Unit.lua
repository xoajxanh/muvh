netMsgPreprocessing[22001] = function(msgID, tblData)
end
netMsgPreprocessing[22002] = function(msgID, tblData)
end
netMsgPreprocessing[22004] = function(msgID, tblData)
  if gameMgr:GetAvatarManager():GetMainPlayer() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetPrivilegeMgr():RefreshPrivilegeList(tblData)
  end
end
netMsgPreprocessing[22005] = function(msgID, tblData)
  if gameMgr:GetAvatarManager():GetMainPlayer() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetPrivilegeMgr():RefreshPrivilegeList(tblData)
  end
end
netMsgPreprocessing[22006] = function(msgID, tblData)
end
netMsgPreprocessing[22009] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr():HolySealInfoMessageCallBack(tblData)
  end
end
netMsgPreprocessing[22011] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr():HolySealChangeMessageCallBack(tblData)
  end
end
netMsgPreprocessing[22013] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshMasterDataCallBack(tblData)
  end
end
netMsgPreprocessing[22015] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshExchangeDataCallBack(tblData)
  end
end
netMsgPreprocessing[22017] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshEnableDataCallBack(tblData)
  end
end
netMsgPreprocessing[22019] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshSkillUpCallBack(tblData)
  end
end
netMsgPreprocessing[22021] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshResetPointDataCallBack(tblData)
  end
end
netMsgPreprocessing[22022] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  gameMgr:GetAvatarManager():GetMainPlayer():GetMasterDataMgr():RefreshFreeData(tblData)
end
netMsgPreprocessing[22023] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if QuickFind.MasterDataMgr() then
    QuickFind.MasterDataMgr():RefreshExChangeInfo(tblData.surplusExchangeNum, tblData.allExchangeNum)
  end
end
netMsgPreprocessing[22026] = function(msgID, tblData)
  if tblData == nil or tblData.recommmendId == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():ResHolySpiritData(tblData)
  end
end
