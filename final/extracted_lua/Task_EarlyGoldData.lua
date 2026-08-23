local Task_EarlyGoldData = {}
GoldenDragonRewardEnum = {
  panel_goldDragon = enum(),
  panel_invite = enum(),
  panel_levelReward = enum()
}
Task_EarlyGoldData.GoldenDragonReward = nil
Task_EarlyGoldData.RewardingTickets = nil
Task_EarlyGoldData.giftData = nil
Task_EarlyGoldData.InvitationReward = nil
Task_EarlyGoldData.VerifyData = nil
Task_EarlyGoldData.FullNameLevelUpData = nil
Task_EarlyGoldData.LotteryData = nil

function Task_EarlyGoldData:Init()
  self.GoldenDragonReward = {}
  self.RewardingTickets = {}
  self.giftData = {}
  self.InvitationReward = {}
  self.VerifyData = {}
  self.FullNameLevelUpData = {}
  self.LotteryData = {}
  self:InitData()
end

function Task_EarlyGoldData:InitData()
  local str = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(68000001).effect, "#")
  for i, v in ipairs(str) do
    local tbl = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(v))
    table.insert(self.InvitationReward, tbl)
  end
  local rankData = ClientTable.cfg_Level_rankRewardManager:GetTabListByType(100, "place")
  local global1 = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(69000002).effect, "#")
  local global2 = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(69000003).effect, "#")
  table.sort(rankData, function(a, b)
    return a.id < b.id
  end)
  for i, v in pairs(rankData) do
    local gift1 = self:GetGift(v.reward1)
    local gift2 = self:GetGift(v.reward2, global1, global2)
    local tbl = {
      rankData = v,
      ordinary = gift1,
      advanced = gift2
    }
    table.insert(self.FullNameLevelUpData, tbl)
  end
end

function Task_EarlyGoldData:SetOnResTasks(data)
  if data == nil or data.tasks == nil then
    return
  end
  self.GoldenDragonReward = {}
  self.RewardingTickets = {}
  for i, v in pairs(data.tasks) do
    local count = v.goals[1].count
    if v.goals[1].count == nil then
      count = 0
    end
    local tbl = {
      taskId = v.taskId,
      state = v.state,
      count = count
    }
    local taskData = ClientTable.cfg_Task_taskManager:TryGetValue(v.taskId)
    if taskData and taskData.type == 14 then
      self.taskType = taskData.type
      tbl.tasks = taskData
      if taskData.subtype == 1 then
        table.insert(self.GoldenDragonReward, tbl)
      elseif taskData.subtype == 2 then
        table.insert(self.RewardingTickets, tbl)
      end
    end
  end
  local goldReward = {}
  local rewardTick = {}
  if self.taskType ~= nil then
    self.task = ClientTable.cfg_Task_taskManager:GetTabListByType(self.taskType, "type")
  else
    self.task = ClientTable.cfg_Task_taskManager:GetTabListByType(14, "type")
  end
  for _, v in pairs(self.task) do
    if v.subtype == 1 then
      table.insert(goldReward, v.taskId)
    elseif v.subtype == 2 then
      table.insert(rewardTick, v.taskId)
    end
  end
  if goldReward and rewardTick then
    self:complementTaskList(self.GoldenDragonReward, goldReward)
    self:complementTaskList(self.RewardingTickets, rewardTick)
  end
end

function Task_EarlyGoldData:complementTaskList(targetList, presetIds)
  local existIds = {}
  for _, task in ipairs(targetList) do
    existIds[task.taskId] = true
  end
  local defaultCountMap = {
    [80001] = 1,
    [80002] = 2,
    [80003] = 3
  }
  for _, presetId in ipairs(presetIds) do
    if 3 <= #targetList then
      break
    end
    if not existIds[presetId] then
      local taskConfig = ClientTable.cfg_Task_taskManager:TryGetValue(presetId)
      local count = defaultCountMap[tonumber(taskConfig.taskId)]
      local newTask = {
        taskId = presetId,
        state = 3,
        count = count,
        tasks = taskConfig
      }
      table.insert(targetList, newTask)
    end
  end
end

function Task_EarlyGoldData:SetOnResTask(data)
  if data == nil then
    return
  end
  local tbl = {
    taskId = data.taskId,
    state = data.state,
    count = data.goals[1].count
  }
  local taskData = ClientTable.cfg_Task_taskManager:TryGetValue(data.taskId)
  if taskData.type == 14 then
    if taskData.subtype == 1 then
      for i, v in pairs(self.GoldenDragonReward) do
        if data.taskId == v.taskId then
          v.task = tbl
        end
      end
    elseif taskData.subtype == 2 then
      for i, v in pairs(self.RewardingTickets) do
        if data.taskId == v.taskId then
          v.task = tbl
        end
      end
    end
  end
  EventManager.Dispatch(Event.GoldFarmingActivityRedDot)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.golden_hunt
  })
end

function Task_EarlyGoldData:SetVerificationCode(data)
  if data == nil then
    return
  end
  self.VerifyData = {}
  local tbl = {
    code = data.code,
    num = data.num,
    isCode = data.isCode
  }
  self.VerifyData = tbl
  EventManager.Dispatch(Event.RefreshFriendCode, {
    VerifyData = self.VerifyData
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.golden_hunt
  })
end

function Task_EarlyGoldData:SetTheLotteryResults(data)
  if data == nil then
    return
  end
  self.LotteryData = data
end

function Task_EarlyGoldData:GetGoldenDragonReward()
  return self.GoldenDragonReward
end

function Task_EarlyGoldData:GetRewardingTickets()
  return self.RewardingTickets
end

function Task_EarlyGoldData:GetInvitationReward()
  return self.InvitationReward
end

function Task_EarlyGoldData:GetVerifyData()
  return self.VerifyData
end

function Task_EarlyGoldData:GetFullNameLevelUpData()
  return self.FullNameLevelUpData
end

function Task_EarlyGoldData:GetLotteryData()
  return self.LotteryData
end

function Task_EarlyGoldData:GetBoxItemTbl(GrowTbl)
  if table.isNullOrEmpty(GrowTbl) then
    return
  end
  self.giftData = {}
  self.boxTbl = {}
  for i, v in ipairs(GrowTbl) do
    if tonumber(v.type) == 14 then
      self.boxTbl = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(tonumber(v.rewards))
    else
      self.boxTbl = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(tonumber(v.reward))
    end
    if table.isNullOrEmpty(self.boxTbl) == false then
      for _, box in ipairs(self.boxTbl) do
        local data = {
          count = box.count,
          itemId = box.itemId
        }
        table.insert(self.giftData, data)
      end
    end
    return self.giftData
  end
end

function Task_EarlyGoldData:GetTaskGoal(goals)
  local task = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(goals), "goalId")
  return task
end

function Task_EarlyGoldData:GetMonster(id)
  local task = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(id))
  return task
end

function Task_EarlyGoldData:GetGift(id, global1, global2)
  if string.isNullOrEmpty(id) then
    return
  end
  local gift = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(id))
  if global1 and global2 then
    if tonumber(id) == tonumber(global1[3]) then
      gift.global = global1
    elseif tonumber(id) == tonumber(global2[3]) then
      gift.global = global2
    end
  end
  return gift
end

function Task_EarlyGoldData:GetRefreshCountFun(data)
  local RefreshData = RefreshData.GetRefreshByKey(tonumber(data.countKey))
  if RefreshData then
    if RefreshData.total == RefreshData.count then
      return true
    elseif RefreshData.total > RefreshData.count then
      return false
    end
  end
  return false
end

function Task_EarlyGoldData:GetRedPoint()
  local isOn = false
  if self.GoldenDragonReward then
    for i, v in pairs(self.GoldenDragonReward) do
      local a = false
      if tonumber(v.state) == 2 then
        a = true
      end
      if v.task ~= nil then
        if tonumber(v.task.state) == 2 then
          a = true
        else
          a = false
        end
      end
      isOn = isOn or a
    end
  end
  if self.RewardingTickets then
    for i, v in pairs(self.RewardingTickets) do
      local a = false
      if tonumber(v.state) == 2 then
        a = true
      end
      if v.task ~= nil then
        if tonumber(v.task.state) == 2 then
          a = true
        else
          a = false
        end
      end
      isOn = isOn or a
    end
  end
  if self.VerifyData and self.VerifyData.num ~= 0 then
    local a = false
    if tonumber(self.VerifyData.num) == 1 or tonumber(self.VerifyData.num) == 3 or tonumber(self.VerifyData.num) == 5 then
      a = true
    end
    isOn = isOn or a
  end
  if self.FullNameLevelUpData then
    for i, v in pairs(self.FullNameLevelUpData) do
      local a = false
      if v.ordinary and v.ordinary.buyCondition and ConditionManager.Check4D(v.ordinary.buyCondition) then
        local ordinaryState = self:GetRefreshCountFun(v.ordinary)
        if ordinaryState then
          a = false
        else
          a = true
        end
      end
      if v.advanced and v.advanced.buyCondition and ConditionManager.Check4D(v.advanced.buyCondition) then
        local advancedCount = self:GetRefreshCountFun(v.advanced)
        local advancedServerCount = RefreshData.GetRefreshByKey(v.advanced.severCountKey)
        if advancedServerCount and advancedServerCount.total >= advancedServerCount.count then
          if advancedCount then
            a = false
          else
            a = true
          end
        else
          a = false
        end
      end
      isOn = isOn or a
    end
  end
  return isOn
end

return Task_EarlyGoldData
