local SiFangZhengBaData = {}
setmetatable(SiFangZhengBaData, LuaClass.PlayActivity)
SiFangZhengBaData.unionListData = nil
SiFangZhengBaRewardType = {
  PersonReward = enum(1),
  UnionReward = enum(2),
  AllUnionReward = enum(3)
}
SiFangZhengBaData.rewardDataList = {}

function SiFangZhengBaData:SetUnionListData(tblData)
  if not tblData then
    return
  end
  self.unionListData = tblData
end

function SiFangZhengBaData:GetUnionListData()
  return self.unionListData
end

function SiFangZhengBaData:GetIsOpenSiFangZhengBa()
  local cfgTbl = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.SiFangZhengBa)
  if cfgTbl and cfgTbl.condition then
    return ConditionManager.Check4D(cfgTbl.condition)
  end
  return false
end

function SiFangZhengBaData:GetIsAlreadyRuWei()
  if self.unionListData then
    for i, v in ipairs(self.unionListData.info) do
      if v.ruWeiInfo then
        for j, k in ipairs(v.ruWeiInfo) do
          if RoleManager.me.unionId ~= 0 and k.unionId ~= 0 and k.unionId == RoleManager.me.unionId then
            return true
          end
        end
      end
    end
  end
  return false
end

function SiFangZhengBaData:GetNeedLevel()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.SiFangZhengBa, "activityId")
  if temp == nil or temp.enterCondition == nil or temp.enterCondition[1] == nil or temp.enterCondition[1][2] == nil or temp.enterCondition[1][2][2] == nil then
    return
  end
  return temp.enterCondition[1][2][2]
end

function SiFangZhengBaData:GetAllSignUpUnionId()
  local allUnionId
  if self.unionListData and self.unionListData.info and #self.unionListData.info > 0 then
    allUnionId = {}
    for i, v in ipairs(self.unionListData.info) do
      if v.ruWeiInfo and 0 < #v.ruWeiInfo then
        table.insert(allUnionId, v.ruWeiInfo[1].unionId)
      end
    end
  end
  return allUnionId
end

function SiFangZhengBaData:GetRewardData(configId)
  local cfgTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(configId)
  local rewardData = {}
  if cfgTbl then
    local rewardTbl = string.split(cfgTbl.effect, "&")
    for i, v in ipairs(rewardTbl) do
      local reward = string.split(v, "#")
      table.insert(rewardData, {
        id = tonumber(reward[1]),
        count = tonumber(reward[2])
      })
    end
  end
  return rewardData
end

function SiFangZhengBaData:GetRankRewardData(index)
  if self.rewardDataList[index] then
    return self.rewardDataList[index]
  end
  self.rewardDataList[index] = {}
  local cfgTbl = ConfigManager.FindConfigs("cfg_Activity_rankReward", "activityId", PlayActivityIdType.SiFangZhengBa)
  local rewardData = {}
  local cfgIndex
  if index == SiFangZhengBaRewardType.AllUnionReward then
    cfgIndex = 2
  else
    cfgIndex = index
  end
  if cfgTbl and cfgIndex then
    for i, v in ipairs(cfgTbl) do
      if v.activityType == cfgIndex then
        table.insert(rewardData, v)
      end
    end
  end
  if index == SiFangZhengBaRewardType.UnionReward then
    table.remove(rewardData, 1)
  end
  self.rewardDataList[index] = rewardData
  return rewardData
end

function SiFangZhengBaData:GetActivityMapId()
  local cfgTbl = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.SiFangZhengBa)
  if cfgTbl and cfgTbl.mapId then
    return cfgTbl.mapId
  end
  return 0
end

function SiFangZhengBaData:GetTransferMapId()
  local cfgTbl = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.SiFangZhengBa)
  if cfgTbl and cfgTbl.mapId then
    local mapCfgTbl = ClientTable.cfg_Map_mapManager:TryGetValue(cfgTbl.mapId)
    if mapCfgTbl and mapCfgTbl.transferPosition then
      return tonumber(mapCfgTbl.transferPosition)
    end
  end
  return 0
end

function SiFangZhengBaData:GetIsPreparationStage()
  local cfgTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(500524)
  if cfgTbl and cfgTbl.effect then
    local conditionStr = cfgTbl.effect
    local conditionTbl = {}
    local condition = string.split(conditionStr, "/")
    for i, v in ipairs(condition) do
      local temp = TableParse:SplitStringToStrListList(v, "&", "#")
      for j, k in ipairs(temp) do
        k[1] = tonumber(k[1])
        if k[1] == 901 then
          k[2] = tonumber(k[2])
        end
      end
      table.insert(conditionTbl, temp)
    end
    local isPreparationStage = ConditionManager.Check4D(conditionTbl)
    return not isPreparationStage
  end
  return false
end

function SiFangZhengBaData:GetUnionNumber()
  if self.unionListData == nil then
    return 0
  end
  return #self.unionListData.info >= 2
end

function SiFangZhengBaData:GetWinUnionId()
  if self.unionListData == nil then
    return 0
  end
  return self.unionListData.finalWinCamp or 0
end

function SiFangZhengBaData:CheckActivityFinish()
  return self:GetWinUnionId() ~= 0
end

function SiFangZhengBaData:GetMyUnionId()
  if self.unionListData then
    for i, v in ipairs(self.unionListData.info) do
      if v.ruWeiInfo then
        for j, k in ipairs(v.ruWeiInfo) do
          if RoleManager.me.unionId ~= 0 and k.unionId ~= 0 and k.unionId == RoleManager.me.unionId then
            return v.campId
          end
        end
      end
    end
  end
  return 0
end

function SiFangZhengBaData:GetSiFangActivityTimeData()
  if self.cfgTbl == nil then
    local mapId = self:GetActivityMapId()
    self.cfgTbl = ClientTable.cfg_Map_instanceManager:TryGetValue(mapId)
  end
  return self.cfgTbl
end

function SiFangZhengBaData:AnalysisTimeStamp()
  local cfgTbl = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.SiFangZhengBa)
  local timeConfig = cfgTbl.condition
  if timeConfig == nil then
    return
  end
  local startStamp, endStamp, serverTime, differentTime = TimeUtility.MaxTime, TimeUtility.MaxTime, Time.GetServerTime(), TimeUtility.MaxTime
  for k, v in pairs(timeConfig) do
    local sStamp, eStamp = TimeUtility.CalcTimeStamp(v)
    if eStamp ~= nil and 0 < sStamp and serverTime < eStamp and (startStamp == TimeUtility.MaxTime or differentTime > sStamp - serverTime) then
      differentTime = sStamp - serverTime
      startStamp = sStamp
      endStamp = eStamp
    end
  end
  if startStamp ~= TimeUtility.MaxTime then
    local stampList = {}
    table.insert(stampList, startStamp)
    table.insert(stampList, endStamp)
    return stampList
  end
end

function SiFangZhengBaData:ResetData()
  self.unionListData = nil
end

function SiFangZhengBaData:GetCampIdByAppointUnionId(_unionId)
  if _unionId == nil or _unionId == 0 or table.count(self.unionListData) == 0 then
    return nil
  end
  for i, v in ipairs(self.unionListData.info) do
    if v.ruWeiInfo then
      for j, k in ipairs(v.ruWeiInfo) do
        if k.unionId ~= 0 and k.unionId == _unionId then
          return v.campId
        end
      end
    end
  end
  return nil
end

return SiFangZhengBaData
