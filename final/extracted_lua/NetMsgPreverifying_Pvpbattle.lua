netMsgPreprocessing[17001] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshBattleInfo(tblData)
  end
end
netMsgPreprocessing[17002] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshSingleCampInfo(tblData)
  end
end
netMsgPreprocessing[17003] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshPlayerInfo(tblData)
  end
end
netMsgPreprocessing[17005] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():GetSurrenderData():Refresh(tblData)
  end
end
netMsgPreprocessing[17006] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshScore(tblData)
  end
end
netMsgPreprocessing[17007] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():ExitThreeVSThreeGame(tblData)
  end
end
netMsgPreprocessing[17009] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():ShowPVPAnnounce(tblData)
  end
end
netMsgPreprocessing[17010] = function(msgID, tblData)
  if tblData ~= nil and tblData.task ~= nil then
    ClientTable.cfg_Map_instance_missionManager:TriggerMissionEvents(tblData.task)
  end
end
netMsgPreprocessing[17011] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshResultScoreDataByServerData(tblData)
    if UIManager.IsVisible(UIID.Activity_Sport3V3Task) then
      UIManager.Show(UIID.LeftTopPanelUI)
      UIManager.Hide(UIID.Activity_Sport3V3Task)
    end
  end
end
