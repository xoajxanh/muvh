UnionTask = class()

function UnionTask:ctor(data)
  self.taskId = data.taskId
  self.state = data.state
  self.level = data.level
  self.canHelp = data.canHelp
  self.taskTbl = ClientTable.cfg_union_taskManager:TryGetValue(self.taskId)
  self.goals = {}
  self.transferId = {}
  for i, v in pairs(data.goals) do
    local taskGoal = TaskGoal(v.goalId)
    if taskGoal ~= nil then
      taskGoal:SetCurFinishCount(v.count)
      table.insert(self.goals, taskGoal)
      table.insert(self.transferId, taskGoal:GetTransferId())
    end
  end
  self.rewards = {}
  local rewardIds = string.split(self.taskTbl.reward, "&")
  for i, v in pairs(rewardIds) do
    local reward = string.split(v, "#")
    local rewardItemId = tonumber(reward[1])
    local num = tonumber(reward[2])
    self.rewards[rewardItemId] = num
  end
  self.navigation = nil
  self.navigationFunction = nil
  if self.taskTbl.navi ~= "" then
    self.navigation = NavigationUtility.GetNavTblForId(tonumber(self.taskTbl.navi))
    if self.navigation ~= nil then
      self.navigationFunction = ClientTable.cfg_Function_functionManager:TryGetValue(tonumber(self.navigation.functionId), "id")
    end
  end
  self.unionTaskName = "Nhi\225\187\135m v\225\187\165 Guild"
  self.unionTaskType = 8
  self.isNavigationFlag = false
  self:SetProgress()
  self.posIndex = 1
  self.multiCoordinate = false
end

function UnionTask:GetHelp()
  return self.canHelp
end

function UnionTask:GetNavi()
  return self.isNavigationFlag
end

function UnionTask:GetNavigation()
  return self.navigation
end

function UnionTask:GetNavigationFunction()
  return self.navigationFunction
end

function UnionTask:GetState()
  return self.state
end

function UnionTask:GetId()
  return self.taskId
end

function UnionTask:GetTaskGola()
  if self.state == TaskStateType.Acceptable then
    return self.goals[1]
  end
  if self.state == TaskStateType.Accept then
    for k, v in pairs(self.goals) do
      if v:GetCurFinishCount() < v:GetCount() then
        return v
      end
    end
  end
  if self.state == TaskStateType.Completed then
    return self.goals[1]
  end
  if self.state == TaskStateType.Submitted then
    return self.goals[1]
  end
end

function UnionTask:SetPurposeful(isPurposeful)
  if isPurposeful then
    for k, v in pairs(self.goals) do
      if v:GetCurFinishCount() < v:GetCount() then
        v:SetPurposeful()
        break
      end
    end
  end
end

function UnionTask:GetPosition()
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      return v:GetPosition()
    end
  end
end

function UnionTask:GetTaskTypePosition()
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      return v:GetFlagMul(), v:GetGoalSeekType()
    end
  end
end

function UnionTask:GetAllGoals()
  local goalsList = {}
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      table.insert(goalsList, v)
    end
  end
  return goalsList
end

function UnionTask:IsAutoFight()
  return self.taskTbl.autoFight == 0
end

function UnionTask:GetUnionTaskLevelDes()
  local levelDes = {
    [1] = "S",
    [2] = "A",
    [3] = "B",
    [4] = "C",
    [5] = "D",
    [6] = "E"
  }
  return self.level, levelDes[tonumber(self.level)]
end

function UnionTask:GetTaskType()
  return ""
end

function UnionTask:GetTaskTypeName()
  return "Other"
end

function UnionTask:GetTaskTypeID()
  return self.unionTaskType
end

function UnionTask:GetRewards()
  return self.rewards
end

function UnionTask:GetTransferId()
  return self.transferId
end

function UnionTask:GetDes()
  local allCount = TaskData.GetCanUnionTaskCount()
  local residueDegree = allCount - TaskData.canAcceptCount
  local str = self.unionTaskName .. string.format("[%d/%d]", residueDegree, allCount)
  for i, v in pairs(self.goals) do
    str = str .. string.format([[

%s]], v.goalTbl.goalTips)
  end
  return str
end

function UnionTask:SetProgress()
  for i, v in pairs(self.goals) do
    if i == 2 then
      self.finishCountTwo = v:GetCurFinishCount()
    else
      self.finishCountOne = v:GetCurFinishCount()
    end
  end
end

function UnionTask:GetProgress()
  local str1 = ""
  local str2 = ""
  local refushOne = false
  local refushTwo = false
  for i, v in pairs(self.goals) do
    if i == 2 then
      if v:GetCurFinishCount() == v:GetCount() then
        str2 = str2 .. string.format([[
<color=#00FF0A>
%d/%d</color>]], v:GetCurFinishCount(), v:GetCount())
      else
        str2 = str2 .. string.format([[

%d/%d]], v:GetCurFinishCount(), v:GetCount())
        if v:GetCurFinishCount() ~= 0 and self.finishCountTwo ~= nil and self.finishCountTwo ~= v:GetCurFinishCount() then
          refushTwo = true
          self.finishCountTwo = v:GetCurFinishCount()
        end
      end
    elseif v:GetCurFinishCount() == v:GetCount() then
      str1 = str1 .. string.format([[
<color=#00FF0A>
%d/%d</color>]], v:GetCurFinishCount(), v:GetCount())
    else
      str1 = str1 .. string.format([[

%d/%d]], v:GetCurFinishCount(), v:GetCount())
      if v:GetCurFinishCount() ~= 0 and self.finishCountOne ~= nil and self.finishCountOne ~= v:GetCurFinishCount() then
        refushOne = true
        self.finishCountOne = v:GetCurFinishCount()
      end
    end
  end
  return str1, str2, refushOne, refushTwo
end

function UnionTask:GetUnionTaskTitle()
  local titleStr = ""
  for i, v in pairs(self.goals) do
    if i == 2 then
      titleStr = titleStr .. string.format([[

%s]], v.goalTbl.goalTips)
    else
      titleStr = titleStr .. string.format("%s", v.goalTbl.goalTips)
    end
  end
  return titleStr
end

function UnionTask:GetUnionTaskJuTiInfo()
  local infoStr = ""
  for i, v in pairs(self.goals) do
    if i == 2 then
      infoStr = infoStr .. string.format([[

(%d/%d)]], v:GetCurFinishCount(), v:GetCount())
    else
      infoStr = infoStr .. string.format("(%d/%d)", v:GetCurFinishCount(), v:GetCount())
    end
  end
  return infoStr
end

function UnionTask:GetTaskGola()
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      return v
    end
  end
end

function UnionTask:UpdateState(state)
  if self.state ~= state then
    self.state = state
  end
end

function UnionTask:UpdateGoalInfo(data)
  for i, v in ipairs(self.goals) do
    if v.goalTbl.goalId == data.goalId then
      v:SetCurFinishCount(data.count)
      if v:GetCurFinishCount() >= v:GetCount() then
        EventManager.Dispatch(Event.Task_ProgressChange, v.goalTbl.goalParam)
      end
    end
  end
end

function UnionTask:GuideOrder()
  return self.taskTbl.guideOrder
end

function UnionTask:GetAcceptableEffect()
  return self.taskTbl.taskAccept
end

function UnionTask:GetAcceptEffect()
  return self.taskTbl.taskConduct
end

function UnionTask:GetCompletedEffect()
  return self.taskTbl.taskComplete
end

function UnionTask:GetSubmittedEffect()
  return self.taskTbl.taskSubmit
end

function UnionTask:GetTaskBgEffect()
  return self.taskTbl.taskBg
end

function UnionTask:GetNaviNpc()
  return nil
end

function UnionTask:GetUnionExp()
  return tonumber(self.taskTbl.unionExp)
end
