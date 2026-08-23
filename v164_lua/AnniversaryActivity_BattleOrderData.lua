AnniversaryActivity_BattleOrderData = {}
AnniversaryActivity_BattleOrderData.commerceId = 0
AnniversaryActivity_BattleOrderData.battleOrderData = {}
AnniversaryActivity_BattleOrderData.battleOrderLevel = 1
AnniversaryActivity_BattleOrderData.battleOrderExp = 0
AnniversaryActivity_BattleOrderData.battleOrderNextExp = 0
AnniversaryActivity_BattleOrderData.allRewardTbl = {}
AnniversaryActivity_BattleOrderData.isUnLockHighReward = false
AnniversaryActivity_BattleOrderData.battleOrderDailyTask = {}
AnniversaryActivity_BattleOrderData.battleOrderActivityTask = {}
AnniversaryActivity_BattleOrderData.hasRewardId = {}

function AnniversaryActivity_BattleOrderData.SetBattleOrderData(data)
  if data and data.newZhanLingInfo then
    local zhanLingInfo = data.newZhanLingInfo
    AnniversaryActivity_BattleOrderData.commerceId = ClientTable.cfg_Commerce_overviewManager:TryGetValue(data.groupId, "group").commerceId or nil
    AnniversaryActivity_BattleOrderData.battleOrderData = zhanLingInfo
    AnniversaryActivity_BattleOrderData.battleOrderExp = zhanLingInfo.exp or nil
    AnniversaryActivity_BattleOrderData.battleOrderLevel = zhanLingInfo.level or nil
    AnniversaryActivity_BattleOrderData.RefreshNextLevelInfo(data)
    AnniversaryActivity_BattleOrderData.hasRewardId = zhanLingInfo.hasRewardId or nil
    local hasType = false
    if table.contains(zhanLingInfo.hasType, 2) then
      hasType = true
    end
    AnniversaryActivity_BattleOrderData.isUnLockHighReward = hasType
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_zhanlin
  })
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderData()
  return AnniversaryActivity_BattleOrderData.battleOrderData
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderLevel()
  return AnniversaryActivity_BattleOrderData.battleOrderLevel
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderRewardData()
  if next(AnniversaryActivity_BattleOrderData.allRewardTbl) == nil then
    local allRewardTbl = ConfigManager.FindConfigs("cfg_Commerce_newzhanlinReward", "commerceId", AnniversaryActivity_BattleOrderData.commerceId)
    for i, v in ipairs(allRewardTbl) do
      if v.condition and ConditionManager.Check4D(v.condition) then
        if AnniversaryActivity_BattleOrderData.allRewardTbl[v.level] == nil then
          AnniversaryActivity_BattleOrderData.allRewardTbl[v.level] = {}
        end
        AnniversaryActivity_BattleOrderData.allRewardTbl[v.level][v.type] = v
      end
    end
  end
  return AnniversaryActivity_BattleOrderData.allRewardTbl
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderAllTaskData()
  if next(AnniversaryActivity_BattleOrderData.battleOrderData) == nil then
    return
  end
  if next(AnniversaryActivity_BattleOrderData.battleOrderData.goalInfo) == nil then
    return
  end
  local goalInfo = AnniversaryActivity_BattleOrderData.battleOrderData.goalInfo
  AnniversaryActivity_BattleOrderData.battleOrderDailyTask = {}
  AnniversaryActivity_BattleOrderData.battleOrderActivityTask = {}
  for i, v in ipairs(goalInfo) do
    local taskData = ClientTable.cfg_Commerce_newzhanlintaskManager:TryGetValue(v.goalId, "mission")
    taskData.goalInfo = v
    if taskData then
      if taskData.type == 1 then
        table.insert(AnniversaryActivity_BattleOrderData.battleOrderDailyTask, taskData)
      elseif taskData.type == 5 then
        table.insert(AnniversaryActivity_BattleOrderData.battleOrderActivityTask, taskData)
      end
    end
  end
  table.sort(AnniversaryActivity_BattleOrderData.battleOrderDailyTask, function(a, b)
    return a.id < b.id
  end)
  table.sort(AnniversaryActivity_BattleOrderData.battleOrderActivityTask, function(a, b)
    return a.id < b.id
  end)
  return AnniversaryActivity_BattleOrderData.battleOrderDailyTask, AnniversaryActivity_BattleOrderData.battleOrderActivityTask
end

function AnniversaryActivity_BattleOrderData.RefreshNextLevelInfo(data)
  if data ~= nil and data.newZhanLingInfo.level ~= nil and data.newZhanLingInfo.exp ~= nil then
    local nextExp = 0
    local isMax = true
    if next(AnniversaryActivity_BattleOrderData.GetBattleOrderRewardData()) then
      for i, v in pairs(AnniversaryActivity_BattleOrderData.GetBattleOrderRewardData()) do
        if v[1].level == v[2].level and v[1].level == AnniversaryActivity_BattleOrderData.battleOrderLevel + 1 then
          nextExp = v[1].count
          isMax = false
          break
        end
      end
      if isMax then
        nextExp = "MAX"
      end
    end
    AnniversaryActivity_BattleOrderData.battleOrderNextExp = nextExp
  end
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderExp()
  return AnniversaryActivity_BattleOrderData.battleOrderExp
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderNextExp()
  return AnniversaryActivity_BattleOrderData.battleOrderNextExp
end

function AnniversaryActivity_BattleOrderData.GetIsUnLockHighReward()
  return AnniversaryActivity_BattleOrderData.isUnLockHighReward
end

function AnniversaryActivity_BattleOrderData.GetBattleOrderTaskInfo(taskId)
  return ClientTable.cfg_Task_goalManager:TryGetValue(taskId)
end

function AnniversaryActivity_BattleOrderData.GetShowModelData()
  local showData = ClientTable.cfg_Commerce_globalManager:TryGetValue(127001).effect
  if not showData then
    return
  end
  local showDataTbl = string.split(showData, "#")
  return showDataTbl
end

function AnniversaryActivity_BattleOrderData.CheckRedPoint()
  if next(AnniversaryActivity_BattleOrderData.battleOrderData) == nil then
    return false
  end
  local rewardTbl = AnniversaryActivity_BattleOrderData.GetBattleOrderRewardData()
  for i, v in ipairs(rewardTbl) do
    for j, k in ipairs(v) do
      if k.level and k.level <= AnniversaryActivity_BattleOrderData.battleOrderLevel and not table.contains(AnniversaryActivity_BattleOrderData.hasRewardId, k.id) then
        if k.type and k.type == 1 then
          return true
        elseif k.type and k.type == 2 and AnniversaryActivity_BattleOrderData.isUnLockHighReward == true then
          return true
        end
      end
    end
  end
  return false
end
