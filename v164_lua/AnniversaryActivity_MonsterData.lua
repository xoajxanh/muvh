AnniversaryActivity_MonsterData = {}
AnniversaryActivity_MonsterData.taskInfoTbl = nil

function AnniversaryActivity_MonsterData.SetMonsterData(data)
  if data and data.taskInfo then
    for i, v in ipairs(data.taskInfo) do
      local showTaskData = {}
      local taskData = ClientTable.cfg_Commerce_1Manager:TryGetValue(v.taskId)
      local goalInfo = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(taskData.goals))
      local giftData = ClientTable.cfg_Gift_giftManager:TryGetValue(v.giftInfo[1].giftId)
      local boxData = ClientTable.cfg_Box_boxManager:TryGetValue(giftData.reward, "boxId")
      table.insert(showTaskData, {
        taskData = taskData,
        goalInfo = goalInfo,
        giftData = giftData,
        boxData = boxData
      })
      v.showTaskData = showTaskData
    end
    table.sort(data.taskInfo, function(a, b)
      return a.taskId < b.taskId
    end)
    AnniversaryActivity_MonsterData.taskInfoTbl = data.taskInfo
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_monster
  })
end

function AnniversaryActivity_MonsterData.GetShowOrGetRewardData()
  if not AnniversaryActivity_MonsterData.taskInfoTbl then
    return
  end
  local stateTbl = {}
  for i, v in ipairs(AnniversaryActivity_MonsterData.taskInfoTbl) do
    if RechargeData.GetCount(v.showTaskData[1].giftData.countKey) == 0 then
      table.insert(stateTbl, v)
    end
  end
  if next(stateTbl) == nil then
    return AnniversaryActivity_MonsterData.taskInfoTbl[#AnniversaryActivity_MonsterData.taskInfoTbl]
  end
  for i, v in ipairs(AnniversaryActivity_MonsterData.taskInfoTbl) do
    if not v.giftInfo or not v.giftInfo[1] then
      return
    end
    if v.giftInfo[1].canGet == true and RechargeData.GetCount(v.showTaskData[1].giftData.countKey) == 0 then
      return v
    end
    if RechargeData.GetCount(v.showTaskData[1].giftData.countKey) == 0 then
      return v
    end
  end
  return AnniversaryActivity_MonsterData.taskInfoTbl[1]
end

function AnniversaryActivity_MonsterData.GetDropItemData()
  local showData = ClientTable.cfg_Commerce_globalManager:TryGetValue(127002).effect
  if not showData then
    return
  end
  return string.split(showData, "#")
end

function AnniversaryActivity_MonsterData.CheckRedPoint()
  if not AnniversaryActivity_MonsterData.taskInfoTbl then
    return false
  end
  for i, v in ipairs(AnniversaryActivity_MonsterData.taskInfoTbl) do
    if not v.giftInfo or not v.giftInfo[1] then
      return
    end
    if v.giftInfo[1].canGet == true and RechargeData.GetCount(v.showTaskData[1].giftData.countKey) == 0 then
      return true
    end
  end
  return false
end
