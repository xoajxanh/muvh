netMsgPreprocessing[16008] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshPlaneInfoDataByServerData(tblData)
  end
end
netMsgPreprocessing[16010] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshMatchTeamDataByServerData(tblData)
  end
end
netMsgPreprocessing[16013] = function(msgID, tblData)
  if tblData then
    if tblData.type == 2 and tblData.result == 0 then
      return
    end
    if tblData.result == 2 then
      EventManager.Dispatch(Event.ThreeVSThreeInviteUIAndBubbleHide)
      return
    end
    local recordTime = PlayerPrefs.GetString(string.format("%s_Sport3V3InviteRemindTogTime", tostring(ViewData.meData.id)))
    if not string.isNullOrEmpty(recordTime) and Time.GetServerTime() - recordTime <= 300000 then
      EventManager.Dispatch(Event.ThreeVSThreeInviteUIMinimize, tblData)
      return
    end
    if UIManager.IsVisible(UIID.Activity_Sport3V3Invite) then
      EventManager.Dispatch(Event.RefreshThreeVThreeInviteUIInfo, tblData)
    else
      UIManager.Show(UIID.Activity_Sport3V3Invite, {data = tblData})
    end
  end
end
netMsgPreprocessing[16018] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshMatchTeamDataByServerData(tblData)
  end
end
netMsgPreprocessing[16022] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() and tblData.comPetitionMatchType == 0 then
    local matchResult = tblData.unit and tblData.unit.matchResult
    if matchResult == 0 then
      QuickFind:GetThreeVsThreeDataMgr():SetMatchState(1)
      QuickFind:GetThreeVsThreeDataMgr():SetJoinMatchTime(Time.GetServerTime())
      EventManager.Dispatch(Event.ThreeVThreeMatching)
    elseif matchResult == 2 then
      QuickFind:GetThreeVsThreeDataMgr():SetMatchState(0)
      QuickFind:GetThreeVsThreeDataMgr():SetJoinMatchTime(0)
      EventManager.Dispatch(Event.ThreeVThreeMatchTimeOut)
    elseif matchResult == 3 then
      QuickFind:GetThreeVsThreeDataMgr():SetMatchState(0)
      QuickFind:GetThreeVsThreeDataMgr():SetJoinMatchTime(0)
    end
  end
end
netMsgPreprocessing[16023] = function(msgID, tblData)
  if tblData and tblData.comPetitionMatchType == 0 and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():SetMatchState(0)
    QuickFind:GetThreeVsThreeDataMgr():SetJoinMatchTime(0)
    EventManager.Dispatch(Event.ThreeVThreeCancleMatchSuccess)
    if QuickFind:GetThreeVsThreeDataMgr():GetIsNeedAfterCancelMatchReqExitTeam() == true then
      if QuickFind:GetThreeVsThreeDataMgr():GetIsHaveTeam() then
        networkRequest.ReqExitThreeVThreeTeam(1)
      end
      QuickFind:GetThreeVsThreeDataMgr():SetIsNeedAfterCancelMatchReqExitTeam(false)
    end
  end
end
netMsgPreprocessing[16028] = function(msgID, tblData)
end
netMsgPreprocessing[16029] = function(msgID, tblData)
end
netMsgPreprocessing[16030] = function(msgID, tblData)
  if tblData and tblData.competitionType ~= 1 and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():SetMatchState(0)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
    EventManager.Dispatch(Event.ThreeVThreeMatchSuccessTransferToMap, tblData)
    EventManager.Dispatch(Event.HideQuickUseWindow)
  elseif tblData and tblData.competitionType == 1 and QuickFind:GetTeam3V3DataMgr() then
    QuickFind:GetTeam3V3DataMgr():SetJoinMatch(false, {})
    QuickFind:GetTeam3V3DataMgr():SetMatchSuccessFul(true)
    UIManager.Hide(UIID.Team3V3UI)
    EventManager.Dispatch(Event.ThreeVThreeMatchSuccessTransferToMap, tblData)
    EventManager.Dispatch(Event.HideQuickUseWindow)
  end
end
netMsgPreprocessing[16033] = function(msgID, tblData)
  if UIManager.IsVisible(UIID.Activity_Sport3V3Score) then
    QuickFind:GetThreeVsThreeDataMgr():SetOpenActivity_Sport3V3RankData(tblData)
  elseif tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshResultTipDataByServerData(tblData)
  end
  networkRequest.ReqThreeVThreePlaneInfo(1)
end
netMsgPreprocessing[16035] = function(msgID, tblData)
end
netMsgPreprocessing[16036] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshOfflineGamer(tblData)
  end
end
netMsgPreprocessing[16047] = function(msgID, tblData)
end
netMsgPreprocessing[16049] = function(msgID, tblData)
end
netMsgPreprocessing[16053] = function(msgID, tblData)
end
