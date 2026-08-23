local SpaceCrackActivityData = {}
setmetatable(SpaceCrackActivityData, LuaClass.PlayActivity)
SpaceCrackActivityData.m_ResTimeCrackPanelInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackTaskInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackPvpInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackMiniMapBoxInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackEndTime = nil
SpaceCrackActivityData.m_UnionRankRewardInfoData = nil
SpaceCrackActivityData.m_PersonRankRewardInfoData = nil
SpaceCrackActivityData.m_RushLevelRewardInfoData = nil
SpaceCrackActivityData.m_BoxRewardInfoData = nil
SpaceCrackActivityData.m_OpenDistance = 2
SpaceCrackActivityData.m_SpaceCrackActivityPersonRankInfoData = nil
SpaceCrackActivityData.m_SpaceCrackActivityUnionRankInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackSettlementPersonRankInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackSettlementUnionRankInfoData = nil
SpaceCrackActivityData.m_RefreshConditionOne = nil
SpaceCrackActivityData.m_RefreshConditionTwo = nil
SpaceCrackActivityData.m_ResServerCrackUnionBuffInfoData = nil
SpaceCrackActivityData.m_ResServerCrackBossInfoData = nil
SpaceCrackActivityData.m_ResSpaceCrackOpenBoxState = nil

function SpaceCrackActivityData:Refresh(_activityTbl)
  self:RunBaseFunction("Refresh", _activityTbl)
  self:InitRankRewardData()
  self:InitOtherRewardData()
  self:InitRefreshCondition()
end

function SpaceCrackActivityData:OnEnterGame()
  self.m_ResTimeCrackPanelInfoData = nil
  self.m_SpaceCrackActivityPersonRankInfoData = nil
  self.m_SpaceCrackActivityUnionRankInfoData = nil
end

function SpaceCrackActivityData:ResTimeCrackPanel(_tblData)
  if _tblData == nil then
    return
  end
  self.m_ResTimeCrackPanelInfoData = _tblData
  EventManager.Dispatch(Event.ResSpaceCrackActivity)
end

function SpaceCrackActivityData:ResSpaceCrackPersonRank(_tblData)
  if _tblData == nil or _tblData.ranks == nil or next(_tblData.ranks) == nil then
    return
  end
  self.m_SpaceCrackActivityPersonRankInfoData = _tblData
  EventManager.Dispatch(Event.RefreshSpaceCrackActivityRank)
end

function SpaceCrackActivityData:ResSpaceCrackUnionRank(_tblData)
  if _tblData == nil or _tblData.ranks == nil or next(_tblData.ranks) == nil then
    return
  end
  self.m_SpaceCrackActivityUnionRankInfoData = _tblData
  EventManager.Dispatch(Event.RefreshSpaceCrackActivityRank)
end

function SpaceCrackActivityData:ResSpaceCrackTask(_tblData)
  if _tblData == nil then
    return
  end
  TranScriptData.SetInTranscript(true)
  self.m_ResSpaceCrackEndTime = _tblData.endTime
  self.m_ResSpaceCrackPvpInfoData = nil
  self.m_ResSpaceCrackTaskInfoData = _tblData
  EventManager.Dispatch(Event.ResSpaceCrackTranscript)
end

function SpaceCrackActivityData:ResSpaceCrackPvp(_tblData)
  if _tblData == nil then
    return
  end
  TranScriptData.SetInTranscript(true)
  self.m_ResSpaceCrackEndTime = _tblData.endTime
  self.m_ResSpaceCrackTaskInfoData = nil
  self.m_ResSpaceCrackPvpInfoData = _tblData
  EventManager.Dispatch(Event.ResSpaceCrackTranscript)
  if self.m_ResSpaceCrackSettlementUnionRankInfoData == nil then
    self.m_ResSpaceCrackSettlementUnionRankInfoData = {
      ranks = {}
    }
  end
  if self.m_ResSpaceCrackSettlementPersonRankInfoData == nil then
    self.m_ResSpaceCrackSettlementPersonRankInfoData = {
      ranks = {}
    }
  end
  self.m_ResSpaceCrackSettlementUnionRankInfoData.ranks = _tblData.unionInfo
  self.m_ResSpaceCrackSettlementPersonRankInfoData.ranks = _tblData.personInfo
end

function SpaceCrackActivityData:ResSpaceCrackBox(_tblData)
  if _tblData == nil or _tblData.boxs == nil then
    return
  end
  self.m_ResSpaceCrackMiniMapBoxInfoData = _tblData.boxs
  EventManager.Dispatch(Event.ResSpaceCrackMiniMapBox)
end

function SpaceCrackActivityData:ResServerCrackUnionBuff(_tblData)
  if _tblData == nil or _tblData.unionBuffs == nil or next(_tblData.unionBuffs) == nil then
    return
  end
  self.m_ResServerCrackUnionBuffInfoData = _tblData.unionBuffs
  EventManager.Dispatch(Event.ResSpaceCrackTranscript)
end

function SpaceCrackActivityData:ResServerCrackBoss(_tblData)
  if _tblData == nil then
    return
  end
  self.m_ResServerCrackBossInfoData = _tblData
  EventManager.Dispatch(Event.ResSpaceCrackTranscript)
end

function SpaceCrackActivityData:ResSpaceCrackSettle(_tblData)
  if _tblData == nil or _tblData.union == nil or next(_tblData.union) == nil or _tblData.person == nil or next(_tblData.person) == nil then
    return
  end
  self.m_ResSpaceCrackSettlementUnionRankInfoData = _tblData.union
  self.m_ResSpaceCrackSettlementPersonRankInfoData = _tblData.person
  EventManager.Dispatch(Event.ResSpaceCrackSettle)
end

function SpaceCrackActivityData:ResServerCrackOpenBox(_tblData)
  if _tblData == nil or _tblData.state == nil then
    return
  end
  self.m_ResSpaceCrackOpenBoxState = _tblData.state
end

function SpaceCrackActivityData:OnProcessCollectionAndRob(_npcList)
  if _npcList == nil then
    return
  end
  local openBoxNpcId
  for i, v in pairs(_npcList) do
    local distance = Vector2.DistancePow(v.cellPos, RoleManager.me.cellPos)
    if distance <= self.m_OpenDistance and v.data ~= nil and v.data.config_Npc ~= nil and v.data.config_Npc.specialNPC == SpaceCrackMapData.SpecialNPC then
      openBoxNpcId = v.id
      break
    end
  end
  EventManager.Dispatch(Event.RefreshSpaceCrackTranscriptOpenBoxButton, openBoxNpcId)
end

function SpaceCrackActivityData:GetAppointRankRewardData(_rankRewardInfoData, _rank)
  if _rankRewardInfoData == nil or next(_rankRewardInfoData) == nil or _rank == nil then
    return
  end
  local rewardData
  for i, v in pairs(_rankRewardInfoData) do
    if _rank >= v.minRank and _rank <= v.maxRank then
      rewardData = v.reward
      break
    end
  end
  return rewardData
end

function SpaceCrackActivityData:InitRankRewardData()
  local rewardConfigList = ClientTable.cfg_Activity_rankRewardManager:GetTabListByType(self:GetActivityId(), "activityId")
  local unionRewardConfigList, personRewardConfigList = {}, {}
  for i, v in pairs(rewardConfigList) do
    if v.activityType == SpaceCrackRankRewardType.Union then
      table.insert(unionRewardConfigList, v)
    elseif v.activityType == SpaceCrackRankRewardType.Person then
      table.insert(personRewardConfigList, v)
    end
  end
  self.m_UnionRankRewardInfoData = SpaceCrackUtility:StructureRankRewardData(unionRewardConfigList)
  self.m_PersonRankRewardInfoData = SpaceCrackUtility:StructureRankRewardData(personRewardConfigList)
end

function SpaceCrackActivityData:InitOtherRewardData()
  self.m_RushLevelRewardInfoData = SpaceCrackUtility:StructureOtherRewardData(500307)
  self.m_BoxRewardInfoData = SpaceCrackUtility:StructureOtherRewardData(500308)
end

function SpaceCrackActivityData:InitRefreshCondition()
  local activityGlobalConfigOne = ClientTable.cfg_Activity_globalManager:TryGetValue(500333)
  local activityGlobalConfigTwo = ClientTable.cfg_Activity_globalManager:TryGetValue(500334)
  if activityGlobalConfigOne == nil or activityGlobalConfigTwo == nil then
    return
  end
  self.m_RefreshConditionOne = activityGlobalConfigOne.effect
  self.m_RefreshConditionTwo = activityGlobalConfigTwo.effect
end

function SpaceCrackActivityData:SetMiniMapBox(obj, boxId)
  if obj == nil or boxId == nil then
    return
  end
  local isBoxNpc, subType = self:IsBoxNpcByConfigId(boxId)
  if isBoxNpc == true then
    self:SetMiniBoxIconBySubType(obj, subType)
  end
end

function SpaceCrackActivityData:SetMiniBoxIconBySubType(obj, type)
  if type == 1 then
    if obj.transform:Find("img_box1").gameObject.activeSelf then
    else
      obj.transform:Find("img_box1").gameObject:SetActive(type == 1)
    end
  elseif obj.transform:Find("img_box1").gameObject.activeSelf then
    obj.transform:Find("img_box1").gameObject:SetActive(false)
  end
  if type == 2 then
    if obj.transform:Find("img_box2").gameObject.activeSelf then
    else
      obj.transform:Find("img_box2").gameObject:SetActive(type == 2)
    end
  elseif obj.transform:Find("img_box2").gameObject.activeSelf then
    obj.transform:Find("img_box2").gameObject:SetActive(false)
  end
  if type == 3 then
    if obj.transform:Find("img_box3").gameObject.activeSelf then
    else
      obj.transform:Find("img_box3").gameObject:SetActive(type == 3)
    end
  elseif obj.transform:Find("img_box3").gameObject.activeSelf then
    obj.transform:Find("img_box3").gameObject:SetActive(false)
  end
end

function SpaceCrackActivityData:IsBoxNpcByConfigId(configId)
  if configId == 10391101 then
    return true, 1
  elseif configId == 10391102 then
    return true, 2
  elseif configId == 10391103 then
    return true, 3
  end
  return false
end

return SpaceCrackActivityData
