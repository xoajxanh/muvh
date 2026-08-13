AnniversaryActivity_NPCActivityData = {}
AnniversaryActivity_NPCActivityData.commerceId = 0
AnniversaryActivity_NPCActivityData.commerceInfo = {}
AnniversaryActivity_NPCActivityData.npcActivityData = {}
AnniversaryActivity_NPCActivityData.npcIntimacy = 0
AnniversaryActivity_NPCActivityData.npcIntimacyLevel = 0
AnniversaryActivity_NPCActivityData.npcDailyTaskData = {}
AnniversaryActivity_NPCActivityData.npcActivityTaskData = {}
AnniversaryActivity_NPCActivityData.RewardDataTbl = {}
AnniversaryActivity_NPCActivityData.hasRewardId = {}
AnniversaryActivity_NPCActivityData.isCanOpenPanel = false
AnniversaryActivity_NPCActivityData.npcSpecialTask = {}

function AnniversaryActivity_NPCActivityData.SetNpcActivityData(data)
  if data and data.npcInfo then
    local npcInfo = data.npcInfo
    AnniversaryActivity_NPCActivityData.commerceInfo = ClientTable.cfg_Commerce_overviewManager:TryGetValue(data.groupId, "group")
    AnniversaryActivity_NPCActivityData.commerceId = ClientTable.cfg_Commerce_overviewManager:TryGetValue(data.groupId, "group").commerceId or nil
    AnniversaryActivity_NPCActivityData.npcActivityData = npcInfo
    AnniversaryActivity_NPCActivityData.npcIntimacy = npcInfo.exp or nil
    AnniversaryActivity_NPCActivityData.npcIntimacyLevel = npcInfo.level or nil
    AnniversaryActivity_NPCActivityData.hasRewardId = npcInfo.hasRewardId or nil
    if npcInfo and npcInfo.goalInfo and next(AnniversaryActivity_NPCActivityData.npcSpecialTask) == nil then
      for i, v in ipairs(npcInfo.goalInfo) do
        local cfg = ClientTable.cfg_Task_goalManager:TryGetValue(v.goalId)
        if cfg and cfg.type == 201 then
          AnniversaryActivity_NPCActivityData.npcSpecialTask.id = cfg.goalParam
          AnniversaryActivity_NPCActivityData.npcSpecialTask.type = cfg.type
        end
      end
    end
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_NPC
  })
end

function AnniversaryActivity_NPCActivityData.GetNpcActivityCommerceInfo()
  return AnniversaryActivity_NPCActivityData.commerceInfo
end

function AnniversaryActivity_NPCActivityData.GetNpcActivityData()
  return AnniversaryActivity_NPCActivityData.npcActivityData
end

function AnniversaryActivity_NPCActivityData.GetNpcIntimacy()
  return AnniversaryActivity_NPCActivityData.npcIntimacy
end

function AnniversaryActivity_NPCActivityData.GetNpcIntimacyLevel()
  return AnniversaryActivity_NPCActivityData.npcIntimacyLevel
end

function AnniversaryActivity_NPCActivityData.GetNextNpcIntimacyLevel()
  if next(AnniversaryActivity_NPCActivityData.RewardDataTbl) == nil then
    AnniversaryActivity_NPCActivityData.GetNpcActivityRewardData()
  end
  for i, v in ipairs(AnniversaryActivity_NPCActivityData.RewardDataTbl) do
    if v.level == AnniversaryActivity_NPCActivityData.npcIntimacyLevel + 1 then
      return v.count or 0
    end
  end
  if next(AnniversaryActivity_NPCActivityData.RewardDataTbl) == nil then
    return 0
  end
  return AnniversaryActivity_NPCActivityData.RewardDataTbl[#AnniversaryActivity_NPCActivityData.RewardDataTbl].count or 0, "MAX"
end

function AnniversaryActivity_NPCActivityData.GetNpcActivityRewardData()
  if next(AnniversaryActivity_NPCActivityData.RewardDataTbl) ~= nil then
    return AnniversaryActivity_NPCActivityData.RewardDataTbl
  end
  local rewardTbl = ConfigManager.FindConfigs("cfg_Commerce_newzhanlinReward", "commerceId", AnniversaryActivity_NPCActivityData.commerceId)
  if not rewardTbl then
    return
  end
  for i, v in pairs(rewardTbl) do
    if v.condition and ConditionManager.Check4D(v.condition) then
      table.insert(AnniversaryActivity_NPCActivityData.RewardDataTbl, v)
    end
  end
  table.sort(AnniversaryActivity_NPCActivityData.RewardDataTbl, function(a, b)
    return a.level < b.level
  end)
  return AnniversaryActivity_NPCActivityData.RewardDataTbl
end

function AnniversaryActivity_NPCActivityData.GetNpcActivityAllTaskData()
  if next(AnniversaryActivity_NPCActivityData.npcActivityData) == nil then
    return
  end
  if next(AnniversaryActivity_NPCActivityData.npcActivityData.goalInfo) == nil then
    return
  end
  local goalInfo = AnniversaryActivity_NPCActivityData.npcActivityData.goalInfo
  AnniversaryActivity_NPCActivityData.npcDailyTaskData = {}
  AnniversaryActivity_NPCActivityData.npcActivityTaskData = {}
  for i, v in ipairs(goalInfo) do
    local taskData = ClientTable.cfg_Commerce_newzhanlintaskManager:TryGetValue(v.goalId, "mission")
    taskData.goalInfo = v
    if taskData then
      if taskData.type == 1 then
        table.insert(AnniversaryActivity_NPCActivityData.npcDailyTaskData, taskData)
      elseif taskData.type == 4 then
        table.insert(AnniversaryActivity_NPCActivityData.npcActivityTaskData, taskData)
      end
    end
  end
  table.sort(AnniversaryActivity_NPCActivityData.npcDailyTaskData, function(a, b)
    return a.id < b.id
  end)
  table.sort(AnniversaryActivity_NPCActivityData.npcActivityTaskData, function(a, b)
    return a.id < b.id
  end)
  return AnniversaryActivity_NPCActivityData.npcDailyTaskData, AnniversaryActivity_NPCActivityData.npcActivityTaskData
end

function AnniversaryActivity_NPCActivityData.GetNpcActivityTaskGoalData(taskId)
  return ClientTable.cfg_Task_goalManager:TryGetValue(taskId)
end

function AnniversaryActivity_NPCActivityData.CheckRedPoint()
  if next(AnniversaryActivity_NPCActivityData.npcActivityData) == nil then
    return false
  end
  local rewardTbl = AnniversaryActivity_NPCActivityData.GetNpcActivityRewardData()
  for i, v in ipairs(rewardTbl) do
    if v.level and v.level <= AnniversaryActivity_NPCActivityData.npcIntimacyLevel and not table.contains(AnniversaryActivity_NPCActivityData.hasRewardId, v.id) then
      return true
    end
  end
  return false
end
