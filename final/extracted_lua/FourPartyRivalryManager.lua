FourPartyRivalryManager = {}
FourPartyRivalryManager.m_FourPartyRivalryActivityInfo = nil
FourPartyRivalryManager.m_FourPartyRivalryRankData = nil
FourPartyRivalryManager.m_Stage = nil
FourPartyRivalryManager.m_CityGateState = {}
FourPartyRivalryManager.m_ReviveBuffId = 0
FourPartyRivalryManager.m_LastMapId = 0

function FourPartyRivalryManager:Init()
  local activityConfig = ClientTable.cfg_Activity_globalManager:TryGetValue(500547)
  if activityConfig == nil or string.isNullOrEmpty(activityConfig.effect) then
    return
  end
  self.m_ReviveBuffId = tonumber(activityConfig.effect)
end

function FourPartyRivalryManager:OnEnterGame()
  self.m_FourPartyRivalryActivityInfo = nil
  self.m_FourPartyRivalryRankData = nil
  self.m_Stage = nil
  self.m_CityGateState = {}
end

function FourPartyRivalryManager:ResFourPartyRivalryActivityInfo(_tblData)
  if _tblData == nil then
    return
  end
  self.m_FourPartyRivalryActivityInfo = _tblData
  self:RefreshThronedBlockPoint(_tblData.stage)
  self:RefreshCityGateBlockPoint(_tblData.doorList)
  EventManager.Dispatch(Event.ResFourPartyRivalryActivityInfo)
end

function FourPartyRivalryManager:RefreshThronedBlockPoint(_stage, _isInit)
  if _stage == nil then
    return
  end
  if self.m_Stage == nil or self.m_Stage and self.m_Stage ~= _stage or _isInit then
    if _stage == FourPartyRivalryConstant.ThronedStage then
      self:RemoveBlockPoint(FourPartyRivalryConstant.ThronedBlockId)
    else
      self:AddBlockPoint(FourPartyRivalryConstant.ThronedBlockId)
    end
    self.m_Stage = _stage
    Scene.GenerateGuidePoints()
  end
end

function FourPartyRivalryManager:RefreshCityGateBlockPoint(_doorList, _isInit)
  if table.count(_doorList) == 0 then
    return
  end
  for i, v in pairs(_doorList) do
    if FourPartyRivalryCityGateBlockEnum[v.configId] and (self.m_CityGateState[v.configId] == nil or self.m_CityGateState[v.configId] and self.m_CityGateState[v.configId] ~= v.status or _isInit) then
      if v.status == 0 then
        self:AddBlockPoint(FourPartyRivalryCityGateBlockEnum[v.configId])
      else
        self:RemoveBlockPoint(FourPartyRivalryCityGateBlockEnum[v.configId])
      end
      self.m_CityGateState[v.configId] = v.status
      Scene.GenerateGuidePoints()
    end
  end
end

function FourPartyRivalryManager:ResFourPartyRivalrySiFangGetScore(_tblData)
  if _tblData == nil then
    return
  end
  FourPartyRivalryScoreTipUtility:ResSiFangGetScoreMessage(_tblData)
end

function FourPartyRivalryManager:ResFourPartyRivalryScoreRank(_tblData)
  if _tblData == nil then
    return
  end
  self.m_FourPartyRivalryRankData = _tblData
  if self.m_FourPartyRivalryRankData.close == true then
    EventManager.Dispatch(Event.OpenSettlementRankPanel)
  else
    EventManager.Dispatch(Event.ResKuaFuGongChengScoreRank)
  end
end

function FourPartyRivalryManager:ResAnnounce(_msg)
  if _msg == nil or _msg.id == nil then
    return
  end
  local chatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(_msg.id)
  if chatConfig == nil or chatConfig.type == nil then
    return
  end
  local typeTab = TableParse:SplitStringToIntList(chatConfig.type, "&")
  if not table.contains(typeTab, FourPartyRivalryConstant.AnnounceType) then
    return
  end
  EventManager.Dispatch(Event.RefreshFourPartyRivalryAnnounce, {chatConfig = chatConfig, msg = _msg})
end

function FourPartyRivalryManager:ResPlayerUseSkill(_tblData)
  if not self:IsEnterFourPartyRivalryMap() then
    return
  end
  if _tblData == nil or _tblData.monsterConfigId == 0 or _tblData.attackerId == nil or _tblData.attackerId ~= RoleManager.me.id then
    return
  end
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(_tblData.monsterConfigId)
  if monsterConfig == nil or monsterConfig.type ~= FourPartyRivalryConstant.CityGateType then
    return
  end
  local buffStruct = BuffData.GetFirstBuffByType(RoleManager.me.id, FourPartyRivalryConstant.FlagBuffType)
  if buffStruct then
    return
  end
  FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("attackerCityGateTip"))
end

function FourPartyRivalryManager:AddBlockPoint(_globalId)
  if _globalId == nil then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(_globalId)
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  local pointList = TableParse:SplitStringToIntListList(activityGlobalTbl.effect, "&", "#")
  if table.count(pointList) == 0 then
    return
  end
  for k, v in pairs(pointList) do
    if table.count(v) > 0 then
      Scene.AddTileType(Vector2(v[1], v[2]), SceneTileType.Block)
    end
  end
end

function FourPartyRivalryManager:RemoveBlockPoint(_globalId)
  if _globalId == nil then
    return
  end
  local activityGlobalTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(_globalId)
  if activityGlobalTbl == nil or string.isNullOrEmpty(activityGlobalTbl.effect) then
    return
  end
  local pointList = TableParse:SplitStringToIntListList(activityGlobalTbl.effect, "&", "#")
  if table.count(pointList) == 0 then
    return
  end
  for k, v in pairs(pointList) do
    if table.count(v) > 0 then
      Scene.RemoveTileType(Vector2(v[1], v[2]), SceneTileType.Block)
    end
  end
end

function FourPartyRivalryManager:IsEnterFourPartyRivalryMap()
  return self:CheckInFourPartyRivalryMap(SceneData.mapId)
end

function FourPartyRivalryManager:CheckInFourPartyRivalryMap(_mapId)
  if _mapId == nil then
    return false
  end
  if _mapId == FourPartyRivalryConstant.MapId then
    return true
  end
  return false
end

function FourPartyRivalryManager:GetMyCampRankData()
  local myCampId = QuickFind:GetSiFangZhengBaDataManager():GetMyUnionId()
  if myCampId == 0 or self.m_FourPartyRivalryRankData == nil or table.count(self.m_FourPartyRivalryRankData.campList) == 0 then
    return
  end
  for i, v in pairs(self.m_FourPartyRivalryRankData.campList) do
    if v.campId == myCampId then
      return v
    end
  end
  return nil
end

function FourPartyRivalryManager:GetMyPersonRankData()
  if self.m_FourPartyRivalryRankData == nil or table.count(self.m_FourPartyRivalryRankData.playerList) == 0 then
    return
  end
  for i, v in pairs(self.m_FourPartyRivalryRankData.playerList) do
    if v.pId == RoleManager.me.id then
      return v
    end
  end
end

function FourPartyRivalryManager:GetNowTaskStageData()
  if self.m_FourPartyRivalryActivityInfo == nil or self.m_FourPartyRivalryActivityInfo.stage == nil then
    return
  end
  local stage = self.m_FourPartyRivalryActivityInfo.stage
  local taskCfg = ClientTable.cfg_Activity_taskSifangManager:TryGetValue(stage, "warChapter")
  if taskCfg == nil then
    return
  end
  return taskCfg
end

function FourPartyRivalryManager:GetTaskTargetData()
  if self.targetData ~= nil then
    return self.targetData
  end
  self.targetData = {}
  local siegeTargetData = ClientTable.cfg_Activity_taskSifangManager:GetDic()
  for i, v in pairs(siegeTargetData) do
    self.targetData[#self.targetData + 1] = {}
    self.targetData[#self.targetData].targetList = self:GetTargetList(v)
  end
  table.sort(self.targetData, function(a, b)
    return a.targetList[1].warChapter < b.targetList[1].warChapter
  end)
  return self.targetData
end

function FourPartyRivalryManager:GetTargetList(targetData)
  local targetList = {}
  local targetStr = targetData.target
  if targetStr ~= "" then
    targetStr = string.split(targetStr, "#")
    for i = 1, #targetStr do
      targetList[i] = {
        targetId = targetStr[i] and tonumber(targetStr[i]) or 0,
        transferId = type(targetData.walkto) == "table" and targetData.walkto[i] or targetData.walkto,
        desc = targetData.desc,
        warChapter = targetData.warChapter
      }
    end
  else
    targetList[1] = {
      targetId = targetStr[1] and tonumber(targetStr[1]) or 0,
      transferId = type(targetData.walkto) == "table" and targetData.walkto[1] or targetData.walkto,
      desc = targetData.desc,
      warChapter = targetData.warChapter
    }
  end
  return targetList
end

function FourPartyRivalryManager:GetMyCampPlayerRank()
  if self.m_FourPartyRivalryRankData == nil or self.m_FourPartyRivalryRankData.playerList == nil then
    return
  end
  local playerList = self.m_FourPartyRivalryRankData.playerList
  local myCampId = QuickFind:GetSiFangZhengBaDataManager():GetMyUnionId()
  local myCampPlayerList = {}
  for i, v in pairs(playerList) do
    if v.campId == myCampId then
      table.insert(myCampPlayerList, v)
    end
  end
  return myCampPlayerList
end
