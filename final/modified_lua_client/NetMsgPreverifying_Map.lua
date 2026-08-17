netMsgPreprocessing[100001] = function(msgID, tblData)
  gameMgr:GetAvatarManager():RefreshAvatarDic(tblData)
end
netMsgPreprocessing[100002] = function(msgID, tblData)
  gameMgr:GetAvatarManager():RemoveAvatar(tblData.exitId)
end
netMsgPreprocessing[100003] = function(msgID, tblData)
  if tblData ~= nil and tblData.info ~= nil then
    gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Player, tblData.info.roleId, tblData)
  end
end
netMsgPreprocessing[100004] = function(msgID, tblData)
  gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Monster, tblData.id, tblData)
  EventManager.Dispatch(Event.MonsterEnterView, tblData)
end
netMsgPreprocessing[100005] = function(msgID, tblData)
  gameMgr:GetAvatarManager():RefreshAvatarDic(tblData)
end
netMsgPreprocessing[100006] = function(msgID, tblData)
  gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Npc, tblData.id, tblData)
end
netMsgPreprocessing[100007] = function(msgID, tblData)
end
netMsgPreprocessing[100008] = function(msgID, tblData)
end
netMsgPreprocessing[100009] = function(msgID, tblData)
end
netMsgPreprocessing[100010] = function(msgID, tblData)
end
netMsgPreprocessing[100011] = function(msgID, tblData)
end
netMsgPreprocessing[100012] = function(msgID, tblData)
end
netMsgPreprocessing[100013] = function(msgID, tblData)
  gameMgr:GetSceneManager():GetSceneDataManager():GetSceneEffectDataManager():RefreshData(tblData)
end
netMsgPreprocessing[100100] = function(msgID, tblData)
  if tblData ~= nil and tblData.info ~= nil then
    gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Player, tblData.info.roleId, tblData)
  end
end
netMsgPreprocessing[100101] = function(msgID, tblData)
  gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Monster, tblData.id, tblData)
  EventManager.Dispatch(Event.MonsterEnterView, tblData)
end
netMsgPreprocessing[100102] = function(msgID, tblData)
  gameMgr:GetAvatarManager():AddAvatar(AvatarEnum.Npc, tblData.id, tblData)
end
netMsgPreprocessing[100103] = function(msgID, tblData)
end
netMsgPreprocessing[100104] = function(msgID, tblData)
end
netMsgPreprocessing[100105] = function(msgID, tblData)
end
netMsgPreprocessing[100106] = function(msgID, tblData)
end
netMsgPreprocessing[100107] = function(msgID, tblData)
end
netMsgPreprocessing[100109] = function(msgID, tblData)
end
netMsgPreprocessing[100110] = function(msgID, tblData)
end
netMsgPreprocessing[100111] = function(msgID, tblData)
end
netMsgPreprocessing[100112] = function(msgID, tblData)
end
netMsgPreprocessing[100113] = function(msgID, tblData)
end
netMsgPreprocessing[100201] = function(msgID, tblData)
end
netMsgPreprocessing[100202] = function(msgID, tblData)
end
netMsgPreprocessing[100204] = function(msgID, tblData)
end
netMsgPreprocessing[100302] = function(msgID, tblData)
end
netMsgPreprocessing[100304] = function(msgID, tblData)
end
netMsgPreprocessing[100305] = function(msgID, tblData)
end
netMsgPreprocessing[100307] = function(msgID, tblData)
  if tblData then
    local instanceTbl = ClientTable.cfg_Map_instanceManager:TryGetValue(tblData.mapId)
    if instanceTbl and instanceTbl.type == TranScriptData.TranScriptSubType.KalimarTemple then
      PathFinderManager.ResetData()
      PathFinderManager.CloseFlyShoeUI()
    end
  end
end
netMsgPreprocessing[100310] = function(msgID, tblData)
end
netMsgPreprocessing[100312] = function(msgID, tblData)
end
netMsgPreprocessing[100315] = function(msgID, tblData)
end
netMsgPreprocessing[100317] = function(msgID, tblData)
end
netMsgPreprocessing[100320] = function(msgID, tblData)
end
netMsgPreprocessing[100400] = function(msgID, tblData)
end
netMsgPreprocessing[100403] = function(msgID, tblData)
end
netMsgPreprocessing[100404] = function(msgID, tblData)
end
netMsgPreprocessing[100407] = function(msgID, tblData)
end
netMsgPreprocessing[100408] = function(msgID, tblData)
end
netMsgPreprocessing[100409] = function(msgID, tblData)
end
netMsgPreprocessing[100410] = function(msgID, tblData)
end
netMsgPreprocessing[100411] = function(msgID, tblData)
end
netMsgPreprocessing[100412] = function(msgID, tblData)
end
netMsgPreprocessing[100414] = function(msgID, tblData)
end
netMsgPreprocessing[100415] = function(msgID, tblData)
end
netMsgPreprocessing[100417] = function(msgID, tblData)
end
netMsgPreprocessing[100418] = function(msgID, tblData)
end
netMsgPreprocessing[100419] = function(msgID, tblData)
end
netMsgPreprocessing[100500] = function(msgID, tblData)
end
netMsgPreprocessing[100501] = function(msgID, tblData)
end
netMsgPreprocessing[100502] = function(msgID, tblData)
end
netMsgPreprocessing[100503] = function(msgID, tblData)
end
netMsgPreprocessing[100504] = function(msgID, tblData)
end
netMsgPreprocessing[100505] = function(msgID, tblData)
end
netMsgPreprocessing[100508] = function(msgID, tblData)
end
netMsgPreprocessing[100509] = function(msgID, tblData)
end
netMsgPreprocessing[100510] = function(msgID, tblData)
end
netMsgPreprocessing[100511] = function(msgID, tblData)
end
netMsgPreprocessing[100512] = function(msgID, tblData)
end
netMsgPreprocessing[100513] = function(msgID, tblData)
  if tblData ~= nil and QuickFind:GetDuoQiCrossDataManager() ~= nil then
    QuickFind:GetDuoQiCrossDataManager():SetServerData(tblData)
  end
end
netMsgPreprocessing[100514] = function(msgID, tblData)
  EventManager.Dispatch(Event.UnionFinalScore, tblData)
end
netMsgPreprocessing[100516] = function(msgID, tblData)
  EventManager.Dispatch(Event.ScoreBubbleChange, tblData)
end
netMsgPreprocessing[100518] = function(msgID, tblData)
  EventManager.Dispatch(Event.UnionProcess, tblData)
end
netMsgPreprocessing[100519] = function(msgID, tblData)
  EventManager.Dispatch(Event.RefreshBoxMapInfoOfUnion, tblData)
end
netMsgPreprocessing[100521] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  QuickFind:GetDuoQiZhengBaManager():SetNominatedGroupList(tblData.ruWeiInfo)
  QuickFind:GetDuoQiZhengBaManager():SetNotPassServerIds(tblData.serverIds)
end
netMsgPreprocessing[100522] = function(msgID, tblData)
end
netMsgPreprocessing[100525] = function(msgID, tblData)
end
netMsgPreprocessing[100526] = function(msgID, tblData)
end
netMsgPreprocessing[100527] = function(msgID, tblData)
end
netMsgPreprocessing[100600] = function(msgID, tblData)
end
netMsgPreprocessing[100601] = function(msgID, tblData)
end
netMsgPreprocessing[100900] = function(msgID, tblData)
end
netMsgPreprocessing[100901] = function(msgID, tblData)
end
netMsgPreprocessing[100903] = function(msgID, tblData)
end
netMsgPreprocessing[100905] = function(msgID, tblData)
end
netMsgPreprocessing[100907] = function(msgID, tblData)
end
netMsgPreprocessing[100908] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr():RefreshData(tblData)
  end
end
netMsgPreprocessing[100910] = function(msgID, tblData)
  if gameMgr:GetSceneManager() and gameMgr:GetSceneManager():GetSceneDataManager() then
    gameMgr:GetSceneManager():GetSceneDataManager():GetScenePointDataManager():RefreshTeamMemberData(tblData)
  end
end
netMsgPreprocessing[100912] = function(msgID, tblData)
  if tblData then
    PathFinderManager.MoveToPos(tblData.mapId, Vector2(tblData.x, tblData.y), tblData.transferId, SceneData.line)
  end
end
netMsgPreprocessing[100914] = function(msgID, tblData)
end
netMsgPreprocessing[100916] = function(msgID, tblData)
end
netMsgPreprocessing[100918] = function(msgID, tblData)
  if tblData ~= nil then
    BossData:RefreshDropNumber(tblData)
    EventManager.Dispatch(Event.RefreshBossDrop)
  end
end
netMsgPreprocessing[100919] = function(msgID, tblData)
  if tblData ~= nil and tblData.basic ~= nil then
    ClientTable.cfg_Map_instance_missionManager:TriggerMissionEvents(tblData.basic.task)
  end
end
netMsgPreprocessing[100920] = function(msgID, tblData)
  if tblData ~= nil then
    ClientTable.cfg_Effects_mainManager:SetEffectTipActive(tblData.code, tblData.switch)
  end
end
netMsgPreprocessing[100921] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  if tblData.type == EMapLimitOperationType.BLACKHOUSE then
    UIManager.Show(UIID.Warning_TipsUI)
    return
  end
end
netMsgPreprocessing[100923] = function(msgID, tblData)
  if gameMgr:GetSceneManager() and gameMgr:GetSceneManager():GetSceneDataManager() then
    gameMgr:GetSceneManager():GetSceneDataManager():GetScenePointDataManager():RefreshUniversalData(tblData)
  end
end
netMsgPreprocessing[100924] = function(msgID, tblData)
end
netMsgPreprocessing[100925] = function(msgID, tblData)
  if gameMgr:GetAvatarManager():GetMainPlayer() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():ChangeVirusCircle(tblData)
  end
end
netMsgPreprocessing[100927] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():ActivityExit(tblData.instanceType)
end
netMsgPreprocessing[100928] = function(msgID, tblData)
  if gameMgr:GetAvatarManager():GetMainPlayer() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetKLTSettleManager():ChangeSettleInfoByServer(tblData)
  end
end
netMsgPreprocessing[100929] = function(msgID, tblData)
end
netMsgPreprocessing[100930] = function(msgID, tblData)
  gameMgr:GetMapManager():GetMapServerMonsterPoint():RefreshData(tblData)
end
netMsgPreprocessing[100931] = function(msgID, tblData)
  gameMgr:GetMapManager():GetMapServerMonsterPoint():RefreshSingleData(tblData)
end
netMsgPreprocessing[100932] = function(msgID, tblData)
  if tblData and tblData.mapId and tblData.countDownTime then
    TranScriptData.ServerRoleCountDownTimeData = tblData
    EventManager.Dispatch(Event.GetServerRoleCountDownTime, tblData)
  end
end
netMsgPreprocessing[100934] = function(msgID, tblData)
  if QuickFind:GetKunShouBattleDataMgr() then
    QuickFind:GetKunShouBattleDataMgr():RefreshRankData(tblData)
  end
end
netMsgPreprocessing[100935] = function(msgID, tblData)
  if QuickFind:GetKunShouBattleDataMgr() then
    QuickFind:GetKunShouBattleDataMgr():RefreshKillData(tblData)
  end
end
netMsgPreprocessing[100936] = function(msgID, tblData)
  if QuickFind:GetKunShouBattleDataMgr() then
    QuickFind:GetKunShouBattleDataMgr():ProcessKillNotice(tblData)
  end
  QuickFind:GetKunShouBattleDataMgr():ThreeVsThreeProcessKillNotice(tblData)
end
netMsgPreprocessing[100937] = function(msgID, tblData)
  if QuickFind:GetKunShouBattleDataMgr() then
    QuickFind:GetKunShouBattleDataMgr():RefreshCampTeamDataByServerData(tblData)
  end
end
netMsgPreprocessing[100938] = function(msgID, tblData)
  if tblData.basic.mapId == 1077 then
    if QuickFind:GetKunShouBattleDataMgr() then
      QuickFind:GetKunShouBattleDataMgr():RefreshTrappedInstanceData(tblData)
    end
    if tblData and tblData.task then
      ClientTable.cfg_Map_instance_missionManager:TriggerMissionEvents(tblData.task)
    end
  elseif tblData.basic.mapId == 1095 and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():GetThreeTaskData(tblData)
  end
end
netMsgPreprocessing[100939] = function(msgID, tblData)
end
netMsgPreprocessing[100940] = function(msgID, tblData)
  if tblData and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():PlayerCampPositionInfoChange(tblData)
  end
end
netMsgPreprocessing[100941] = function(msgID, tblData)
  if tblData then
    EventManager.Dispatch(Event.RefreshDimensionalCracks, tblData)
  end
end
netMsgPreprocessing[100943] = function(msgID, tblData)
  if tblData and tblData.state then
    if tblData.state == 0 then
      local word = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("dimensionDefeated")
      FloatingTipUtility.QuickMsg(word)
    end
    EventManager.Dispatch(Event.RefreshCallMonsterDimension, true)
  end
end
netMsgPreprocessing[100944] = function(msgID, tblData)
end
netMsgPreprocessing[100946] = function(msgID, tblData)
  if tblData then
    SceneData:RefreshAncientBossData(tblData)
  end
end
netMsgPreprocessing[100947] = function(msgID, tblData)
  if tblData then
    SceneData.AncientStateData[tblData.type] = tblData.light
  end
end
netMsgPreprocessing[100948] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and tblData then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetClimBTowerData():RefreshRoweinfo(tblData)
  end
end
netMsgPreprocessing[100952] = function(msgID, tblData)
  TranScriptData.isFinishedGoldCaves = tblData and tblData.finish or false
end
netMsgPreprocessing[100955] = function(msgID, tblData)
  SceneData:RefreshGetRingBossCountData(tblData)
end
netMsgPreprocessing[100956] = function(msgID, tblData)
end
netMsgPreprocessing[100958] = function(msgID, tblData)
end
netMsgPreprocessing[100959] = function(msgID, tblData)
end
netMsgPreprocessing[100960] = function(msgID, tblData)
end
netMsgPreprocessing[100962] = function(msgID, tblData)
end
netMsgPreprocessing[100963] = function(msgID, tblData)
end
