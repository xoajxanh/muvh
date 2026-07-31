HelpTask = class()

function HelpTask:ctor(data)
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
  self.taskName = "Nhi\225\187\135m V\225\187\165 H\225\187\151 Tr\225\187\163"
  self.taskType = 9
  self.isNavigationFlag = false
  self:SetProgress()
  self.posIndex = 1
  self.multiCoordinate = false
end

function HelpTask:GetTransferId()
  return self.transferId
end

function HelpTask:GetState()
  return self.state
end

function HelpTask:GetNavi()
  return self.isNavigationFlag
end

function HelpTask:GetHelp()
  return false
end

function HelpTask:GetId()
  return self.taskId
end

function HelpTask:GetTaskGola()
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

function HelpTask:SetPurposeful(isPurposeful)
  if isPurposeful then
    for k, v in pairs(self.goals) do
      if v:GetCurFinishCount() < v:GetCount() then
        v:SetPurposeful()
        break
      end
    end
  end
end

function HelpTask:GetAllGoals()
  local goalsList = {}
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      table.insert(goalsList, v)
    end
  end
  return goalsList
end

function HelpTask:GetPosition()
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      return v:GetPosition()
    end
  end
end

function HelpTask:IsAutoFight()
  return 0
end

function HelpTask:GetUnionTaskLevelDes()
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

function HelpTask:GetTaskType()
  return ""
end

function HelpTask:GetTaskTypeName()
  return "Other"
end

function HelpTask:GetTaskTypeID()
  return self.taskType
end

function HelpTask:GetRewards()
  return self.rewards
end

function HelpTask:GetDes()
  local str = self.taskName
  for i, v in pairs(self.goals) do
    str = str .. string.format([[

%s]], v.goalTbl.goalTips)
  end
  return str
end

function HelpTask:SetProgress()
  for i, v in pairs(self.goals) do
    if i == 2 then
      self.finishCountTwo = v.finishCount
    else
      self.finishCountOne = v.finishCount
    end
  end
end

function HelpTask:GetProgress()
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

function HelpTask:GetUnionTaskTitle()
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

function HelpTask:GetUnionTaskJuTiInfo()
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

function HelpTask:GetTaskGola()
  for k, v in pairs(self.goals) do
    if v:GetCurFinishCount() < v:GetCount() then
      return v
    end
  end
end

function HelpTask:UpdateState(state)
  if self.state ~= state then
    self.state = state
  end
end

function HelpTask:UpdateGoalInfo(data)
  for i, v in ipairs(self.goals) do
    if v.goalTbl.goalId == data.goalId then
      v:SetCurFinishCount(data.count)
      if v:GetCurFinishCount() >= v:GetCount() then
        EventManager.Dispatch(Event.Task_ProgressChange, v.goalTbl.goalParam)
      end
    end
  end
end

function HelpTask:GuideOrder()
  return self.taskTbl.guideOrder
end

function HelpTask:GetAcceptableEffect()
  return self.taskTbl.taskAccept
end

function HelpTask:GetAcceptEffect()
  return self.taskTbl.taskConduct
end

function HelpTask:GetCompletedEffect()
  return self.taskTbl.taskComplete
end

function HelpTask:GetSubmittedEffect()
  return self.taskTbl.taskSubmit
end

function HelpTask:GetTaskBgEffect()
  return self.taskTbl.taskBg
end
