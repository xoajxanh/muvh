ActivityListData = {}
local this = ActivityListData
this.allActivityList = {}

function ActivityListData.GetLimitTimeUnix(timeSlot, middleTimeSlot)
  local times = string.split(timeSlot, "-")
  local startStr = times[1]
  local endStr = times[2]
  local startLimitTimeUnix = 0
  local endLimitTimeUnix = 0
  local timeStrs = string.split(startStr, ":")
  startLimitTimeUnix = startLimitTimeUnix + tonumber(timeStrs[1]) * ETimeSec.hour
  startLimitTimeUnix = startLimitTimeUnix + tonumber(timeStrs[2]) * ETimeSec.min
  startLimitTimeUnix = startLimitTimeUnix + (tonumber(timeStrs[3]) and tonumber(timeStrs[3]) or 0)
  timeStrs = string.split(endStr, ":")
  endLimitTimeUnix = endLimitTimeUnix + tonumber(timeStrs[1]) * ETimeSec.hour
  endLimitTimeUnix = endLimitTimeUnix + tonumber(timeStrs[2]) * ETimeSec.min
  endLimitTimeUnix = endLimitTimeUnix + (tonumber(timeStrs[3]) and tonumber(timeStrs[3]) or 0)
  local middleLimitTimeUnix = this.GetMiddleLimitTimeUnix(middleTimeSlot)
  local limitUnix = {}
  limitUnix.startLimitTimeUnix = startLimitTimeUnix
  limitUnix.endLimitTimeUnix = endLimitTimeUnix
  limitUnix.middleLimitTimeUnix = middleLimitTimeUnix
  return limitUnix
end

function ActivityListData.GetMiddleLimitTimeUnix(middleTimeSlot)
  if not middleTimeSlot then
    return
  end
  local times = string.split(middleTimeSlot, "-")
  local startStr = times[1]
  local middleLimitTimeUnix = 0
  local timeStrs = string.split(startStr, ":")
  middleLimitTimeUnix = middleLimitTimeUnix + tonumber(timeStrs[1]) * ETimeSec.hour
  middleLimitTimeUnix = middleLimitTimeUnix + tonumber(timeStrs[2]) * ETimeSec.min
  middleLimitTimeUnix = middleLimitTimeUnix + (tonumber(timeStrs[3]) and tonumber(timeStrs[3]) or 0)
  return middleLimitTimeUnix
end

function ActivityListData.InitData()
  this.allActivityList = {}
  local activityIndexData = ClientTable.cfg_Activity_indexManager:GetDic()
  for i, v in pairs(activityIndexData) do
    local id = v.activityId
    local activityOverview = ClientTable.cfg_Activity_overviewManager:TryGetValue(id, "activityId")
    local openTime = this.GetOpenTime(activityOverview.condition, activityOverview.preTime, activityOverview.activityId)
    this.allActivityList[#this.allActivityList + 1] = {
      activityName = v.activityName,
      id = v.activityId,
      timeCondition = activityOverview.preTime ~= nil and activityOverview.preTime or activityOverview.condition,
      enterCondition = activityOverview.enterCondition,
      openCondition = activityOverview.condition,
      openTime = openTime
    }
  end
end

function ActivityListData.GetOpenTime(condition, preTime, activityId)
  local limitTime = {}
  if preTime ~= nil then
    local openConditionStr = preTime
    local middleConditionStr = condition
    for i = 1, #openConditionStr do
      local timeStr = openConditionStr[i]
      local middleStr = middleConditionStr[i]
      for k = 1, #timeStr do
        if timeStr[k][1] == 908 then
          local timeCondition = timeStr[k]
          local middleTimeCondition
          local index = 1
          while middleStr[index] and middleStr[index][1] ~= 908 do
            index = index + 1
          end
          if not middleStr[index] then
          else
            middleTimeCondition = middleStr[index]
            limitTime[#limitTime + 1] = this.GetLimitTimeUnix(timeCondition[2], middleTimeCondition and middleTimeCondition[2])
            limitTime[#limitTime].condition = openConditionStr[i]
          end
        end
      end
    end
  else
    local openConditionStr = condition
    for i = 1, #openConditionStr do
      local timeStr = openConditionStr[i]
      for k = 1, #timeStr do
        if timeStr[k][1] == 908 then
          local timeCondition = timeStr[k]
          limitTime[#limitTime + 1] = this.GetLimitTimeUnix(timeCondition[2])
          limitTime[#limitTime].condition = openConditionStr[i]
        end
      end
    end
  end
  return limitTime
end

function ActivityListData.GetCurOpenActivityData()
  local openData = {}
  for i = 1, #this.allActivityList do
    local timeCondition = this.allActivityList[i].timeCondition
    local enterCondition = this.allActivityList[i].enterCondition
    if ConditionManager.Check4D(timeCondition) and ConditionManager.Check4D(enterCondition) then
      openData[#openData + 1] = this.allActivityList[i]
    end
  end
  return openData
end

function ActivityListData.GetOpenActivityRootData(data)
  local needShieldActivityList = string.split(ClientTable.cfg_Activity_globalManager:TryGetValue(500242).effect, "#")
  for i, v in pairs(data) do
    if table.contains(needShieldActivityList, tostring(v.id)) then
      table.remove(data, i)
    end
    if v.id == PlayActivityIdType.SiFangZhengBa then
      local isOpen = QuickFind:GetSiFangZhengBaDataManager():GetIsOpenSiFangZhengBa()
      local isFinished = QuickFind:GetSiFangZhengBaDataManager():CheckActivityFinish()
      if isOpen == true and isFinished == true then
        table.remove(data, i)
      end
    end
  end
  return data
end
