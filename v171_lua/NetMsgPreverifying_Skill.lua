netMsgPreprocessing[205002] = function(msgID, tblData)
end
netMsgPreprocessing[205003] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetSkillManager():GetSKillGroupAdditionManager():RefreshData(tblData)
end
