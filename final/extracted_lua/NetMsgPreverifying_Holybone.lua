netMsgPreprocessing[26002] = function(msgID, tblData)
  if tblData == nil or tblData.holyBoneGap == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():ChangeRefreshData(tblData)
    gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():OnResSacredBoneItemChange(tblData)
  end
end
netMsgPreprocessing[26003] = function(msgID, tblData)
  if tblData == nil or tblData.holyBoneInfo == nil then
    return
  end
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():InitRefreshData(tblData)
    gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():OnResSacredBoneEquipInfo(tblData)
  end
end
