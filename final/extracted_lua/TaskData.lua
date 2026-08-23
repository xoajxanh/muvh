require("GamePlay/Task/Task")
require("GamePlay/Task/TaskGoal")
require("GamePlay/Task/UnionTask")
require("GamePlay/Task/HelpTask")
TaskData = {}
local this = TaskData
this.AllTasks = {}
this.mainTasks = {}
this.branchTasks = {}
this.rewardsTasks = {}
this.activeTasks = {}
this.monsterTasks = {}
this.starTasks = {}
this.counterpartTask = {}
this.skillBooksTasks = {}
this.periodicalTasks = {}
this.transferTask = {}
this.StarTaskCount = nil
this.allMonsterLevel = {}
this.instituteMiracleTasks = {}
this.hideFlag = false
this.TaskSchool = false
this.Preview = false

function TaskData.UpdatePlayerTasks(data)
  if next(this.AllTasks) ~= nil then
    return
  end
  this.InitTasks(data)
end

function TaskData.InitTasks(data)
  for i = 1, table.count(data) do
    local taskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(data[i].taskId, "taskId")
    if taskTbl == nil then
      logError("Nhi\225\187\135m v\225\187\165 \196\145\198\176\225\187\163c g\225\187\173i t\225\187\171 m\195\161y ch\225\187\167 hi\225\187\135n kh\195\180ng t\225\187\147n t\225\186\161i, c\195\179 th\225\187\131 do b\225\186\163ng ph\195\173a client v\195\160 server kh\195\180ng \196\145\225\187\147ng b\225\187\153", data[i].taskId)
      break
    end
    if this.AllTasks[data[i].taskId] then
      this.AllTasks[data[i].taskId]:SetFlagBit(true)
      this.UpdateTask(data[i])
    else
      local task = this.ConvertToTask(data[i])
      if task then
        this.AllTasks[data[i].taskId] = task
      end
    end
  end
  for k, v in pairs(this.AllTasks) do
    if not v:GetFlagBit() then
      this.AllTasks[k] = nil
    end
    v:SetFlagBit(false)
  end
  this.OnResetOtherTask()
  for k, v in pairs(this.AllTasks) do
    this.AddTask(v)
  end
  EventManager.Dispatch(Event.Task_Update, nil)
end

function TaskData.AddMainTask(task)
  if task:GetTaskTypeID() == RoleTaskType.MainTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.mainTasks, task)
    this.MainTaskOrder()
  end
end

function TaskData.RemoveMainTask(task)
  if task:GetTaskTypeID() == RoleTaskType.MainTask then
    for k, v in pairs(this.mainTasks) do
      if v.taskId == task.taskId then
        table.remove(this.mainTasks, k)
      end
    end
    this.MainTaskOrder()
  end
end

function TaskData.MainTaskOrder()
  table.sort(this.mainTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetAllMainTask()
  return this.mainTasks
end

function TaskData.AddBranchTask(task)
  if task:GetTaskTypeID() == RoleTaskType.BranchTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.branchTasks, task)
    this.BranchTaskOrder()
  end
end

function TaskData.RemoveBranchTask(task)
  if task:GetTaskTypeID() == RoleTaskType.BranchTask then
    for k, v in pairs(this.branchTasks) do
      if v.taskId == task.taskId then
        table.remove(this.branchTasks, k)
      end
    end
    this.BranchTaskOrder()
  end
end

function TaskData.BranchTaskOrder()
  table.sort(this.branchTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetBranchTask()
  return this.branchTasks
end

function TaskData.AddRewardsTask(task)
  if task:GetTaskTypeID() == RoleTaskType.RewardsTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.rewardsTasks, task)
    this.RewardsTaskOrder()
  end
end

function TaskData.RemoveRewardsTask(task)
  if task:GetTaskTypeID() == RoleTaskType.RewardsTask then
    for k, v in pairs(this.rewardsTasks) do
      if v.taskId == task.taskId then
        table.remove(this.rewardsTasks, k)
      end
    end
    this.RewardsTaskOrder()
  end
end

function TaskData.RewardsTaskOrder()
  table.sort(this.rewardsTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetRewardsTask()
  return this.rewardsTasks
end

function TaskData:RewardsTaskGoal(_indexer, _info)
  if self.taskGoalDic == nil then
    self.taskGoalDic = {}
  end
  if _indexer == IndexerEnum.get then
    return self.taskGoalDic
  elseif _indexer == IndexerEnum.set then
    self.taskGoalDic[_info.taskId] = _info.goalTbl
  end
end

function TaskData:OpenRewardsTask(_indexer, _info)
  if _indexer == IndexerEnum.get then
    return self.taskData
  elseif _indexer == IndexerEnum.set then
    self.taskData = _info
  end
end

function TaskData:GetRewardTask()
  return self.rewardsTasks and self.rewardsTasks[1] or nil
end

function TaskData.RemoveActiveTask(task)
  for k, v in pairs(this.activeTasks) do
    if v.taskId == task.taskId then
      this.activeTasks[k] = nil
    end
  end
end

function TaskData.AddCounterpartTask(task)
  if task:GetTaskTypeID() == RoleTaskType.TranscriptTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.counterpartTask, task)
  end
end

function TaskData.RemoveCounterpartTask(task)
  if task:GetTaskTypeID() == RoleTaskType.TranscriptTask then
    for k, v in pairs(this.counterpartTask) do
      if v.taskId == task.taskId then
        table.remove(this.counterpartTask, k)
      end
    end
  end
end

function TaskData.CounterpartTaskOrder()
  table.sort(this.counterpartTask, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetCounterpartTask()
  return this.counterpartTask
end

function TaskData.AddTransferTask(task)
  if task:GetTaskTypeID() == RoleTaskType.TransferTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.transferTask, task)
    this.TransferTaskOrder()
  end
end

function TaskData.RemoveTransferTask(task)
  if task:GetTaskTypeID() == RoleTaskType.TransferTask then
    for k, v in pairs(this.transferTask) do
      if v.taskId == task.taskId then
        table.remove(this.transferTask, k)
      end
    end
    this.TransferTaskOrder()
  end
end

function TaskData.TransferTaskOrder()
  table.sort(this.transferTask, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetTransferTask()
  return this.transferTask
end

function TaskData.AddStarTask(task)
  if task:GetTaskTypeID() == RoleTaskType.StarTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.starTasks, task)
    this.StarTaskOrder()
    this.UpdateStarTask(task)
  end
end

function TaskData.RemoveStarTask(task)
  if task:GetTaskTypeID() == RoleTaskType.StarTask then
    for k, v in pairs(this.starTasks) do
      if v.taskId == task.taskId then
        table.remove(this.starTasks, k)
        this.StarTaskOrder()
        this.UpdateStarTask(task)
      end
    end
  end
end

function TaskData.StarTaskOrder()
  table.sort(this.starTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.UpdateStarTask(msg)
  EventManager.Dispatch(Event.StarTask_Update, msg.taskId)
end

function TaskData.SetStarTaskCount(count)
  this.StarTaskCount = count
end

function TaskData.GetStarTaskCount()
  this.StarTaskCount = this.StarTaskCount ~= nil and this.StarTaskCount or 0
  return this.StarTaskCount
end

function TaskData.GetStarTask()
  return this.starTasks
end

function TaskData.IsStarTaskProgress()
  local isInProgress = false
  for i, v in pairs(this.starTasks) do
    if v.state == TaskStateType.Accept or v.state == TaskStateType.Completed then
      isInProgress = true
    end
  end
  return isInProgress
end

function TaskData.AddSkillBooksTasks(task)
  if task:GetTaskTypeID() == RoleTaskType.SkillTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.skillBooksTasks, task)
  end
  table.sort(this.skillBooksTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetSubType() > b:GetSubType()
    end
  end)
end

function TaskData.RemoveSkillBooksTasks(task)
  if task:GetTaskTypeID() == RoleTaskType.SkillTask then
    for k, v in pairs(this.skillBooksTasks) do
      if v.taskId == task.taskId then
        table.remove(this.skillBooksTasks, k)
      end
    end
    table.sort(this.skillBooksTasks, function(a, b)
      if a ~= nil and b ~= nil then
        return a:GetSubType() > b:GetSubType()
      end
    end)
  end
end

function TaskData.SkillBooksTasksOrder()
  table.sort(this.skillBooksTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetOrder() < b:GetOrder()
    end
  end)
end

function TaskData.GetSkillBooksTasks()
  return this.skillBooksTasks[1]
end

function TaskData.AddMonsterOfferedTasks(task)
  if task:GetTaskTypeID() == RoleTaskType.UnionTask then
    if this.monsterTasks[task:GetSubType()] ~= nil and #this.monsterTasks[task:GetSubType()] > 0 then
      table.insert(this.monsterTasks[task:GetSubType()], task)
    else
      this.monsterTasks[task:GetSubType()] = {}
      table.insert(this.monsterTasks[task:GetSubType()], task)
    end
  end
end

function TaskData.GetMonsterLevelTasks(level)
  if level ~= nil then
    if this.monsterTasks[level] ~= nil and #this.monsterTasks[level] > 0 then
      local sortTable = {}
      table.sort(this.monsterTasks[level], function(a, b)
        return a.taskId < b.taskId
      end)
      for k, v in pairs(this.monsterTasks[level]) do
        if type(v) == "table" and v.state == TaskStateType.Completed then
          table.insert(sortTable, v)
        end
      end
      for k, v in pairs(this.monsterTasks[level]) do
        if type(v) == "table" and v.state == TaskStateType.Accept then
          table.insert(sortTable, v)
        end
      end
      for k, v in pairs(this.monsterTasks[level]) do
        if type(v) == "table" and v.state == TaskStateType.Submitted then
          table.insert(sortTable, v)
        end
      end
      this.monsterTasks[level] = sortTable
      return this.monsterTasks[level]
    else
      return nil
    end
  end
end

function TaskData.GetAllMonsterLevelTasks()
  return this.monsterTasks
end

function TaskData.GetMonsterLevelCompletedTasks(level)
  if level ~= nil and this.monsterTasks[level] ~= nil and #this.monsterTasks[level] > 0 then
    for k, v in pairs(this.monsterTasks[level]) do
      if type(v) == "table" and v.state == TaskStateType.Completed then
        return true
      end
    end
  end
  return false
end

function TaskData.Get_Receive_Chapter_Reward_RedPoint(level)
  local periodicalTask = this.GetPeriodicalTaskByLevel(level)
  if periodicalTask ~= nil then
    return periodicalTask.state == TaskStateType.Completed and not this.GetCurMonsterLevelFinish(level)
  else
    return false
  end
end

function TaskData.UpdateMonsterTask(task)
  if task:GetTaskTypeID() == RoleTaskType.UnionTask then
    if this.monsterTasks[task:GetSubType()] ~= nil and #this.monsterTasks[task:GetSubType()] > 0 then
      table.insert(this.monsterTasks[task:GetSubType()], task)
    else
      this.monsterTasks[task:GetSubType()] = {}
      table.insert(this.monsterTasks[task:GetSubType()], task)
    end
  end
end

function TaskData.GetCurMonsterLevelFinish(level)
  local isNotFinish = false
  local curLevelMonsterTasks = this.GetMonsterLevelTasks(level)
  if curLevelMonsterTasks ~= nil and 0 < #curLevelMonsterTasks then
    for i, v in pairs(curLevelMonsterTasks) do
      if this.GetCurTaskStateSubmitted(v) then
        isNotFinish = true
      end
    end
  else
    isNotFinish = false
  end
  return isNotFinish
end

function TaskData.GetCurTaskStateSubmitted(task)
  local needToFinish = true
  if task ~= nil then
    if task:GetState() == TaskStateType.Acceptable or task:GetState() == TaskStateType.Accept or task:GetState() == TaskStateType.Completed then
      needToFinish = true
    else
      needToFinish = false
    end
  end
  return needToFinish
end

function TaskData.SetClickLevelBossTask(taskId)
  this.levelBossTaskId = taskId
  PlayerPrefs.SetString("taskReward" .. tostring(LoginData.roleId), taskId)
  EventManager.Dispatch(Event.Task_Update, nil)
end

function TaskData.GetClickLevelBossTask()
  if this.levelBossTaskId and this.AllTasks[this.levelBossTaskId] then
    if this.AllTasks[this.levelBossTaskId].state == TaskStateType.Submitted then
      return false
    end
    this.AllTasks[this.levelBossTaskId]:SetLevelBossFlag(true)
    return this.AllTasks[this.levelBossTaskId]
  else
    local levelBossData = PlayerPrefs.GetString("taskReward" .. tostring(LoginData.roleId), "0")
    local task = this.AllTasks[tonumber(levelBossData)]
    if tonumber(levelBossData) ~= 0 and task and task.state ~= TaskStateType.Submitted then
      task:SetLevelBossFlag(true)
      return task
    else
      return false
    end
  end
end

function TaskData.GetLastLevelBossTasks()
  local level, task
  for k, v in pairs(this.allMonsterLevel) do
    local monsterTask = this.monsterTasks[v]
    if monsterTask ~= nil then
      for m, n in pairs(this.monsterTasks[v]) do
        if n.state == TaskStateType.Completed then
          level = v
          task = n
          return level, task
        end
      end
    end
  end
  if task ~= nil and task then
    task:SetLevelBossFlag(false)
  end
  return level, task
end

function TaskData.UpdateMonsterOfferedTasks(msg)
  EventManager.Dispatch(Event.UnionTask_Update, msg.taskId)
end

function TaskData.AddMonsterPeriodicalTask(task)
  if task:GetTaskTypeID() == RoleTaskType.StageTask then
    table.insert(this.periodicalTasks, task)
  end
  table.sort(this.periodicalTasks, function(a, b)
    if a ~= nil and b ~= nil then
      return a:GetSubType() < b:GetSubType()
    end
  end)
end

function TaskData.GetMonsterPeriodicalTask()
  if this.periodicalTasks ~= nil and #this.periodicalTasks > 0 then
    return this.periodicalTasks
  else
    return nil
  end
end

function TaskData.GetPeriodicalTaskByLevel(level)
  if this.periodicalTasks ~= nil and #this.periodicalTasks > 0 then
    for k, v in pairs(this.periodicalTasks) do
      if level == v:GetSubType() then
        return v
      end
    end
  else
    return nil
  end
end

function TaskData.GetPeriodicalTaskComplete()
  for k, v in pairs(this.periodicalTasks) do
    if v.state == TaskStateType.Completed then
      return true
    end
  end
  return false
end

function TaskData.UpdateMonsterPeriodicalTask(msg)
  EventManager.Dispatch(Event.UnionTask_Update, msg.taskId)
end

function TaskData.AddInstituteMiracleTasks(task)
  if task:GetTaskTypeID() == RoleTaskType.MiracleTask and task:GetState() ~= TaskStateType.Submitted then
    table.insert(this.instituteMiracleTasks, task)
    this.UpdateInstituteMiracleTasks(task)
  end
end

function TaskData.RemoveInstituteMiracleTasks(task)
  if task:GetTaskTypeID() == RoleTaskType.MiracleTask then
    for k, v in pairs(this.instituteMiracleTasks) do
      if v.taskId == task.taskId then
        table.remove(this.instituteMiracleTasks, k)
        this.UpdateInstituteMiracleTasks(v)
      end
    end
  end
end

function TaskData.UpdateInstituteMiracleTasks(msg)
  EventManager.Dispatch(Event.MiracleTask_Update, msg.taskId)
  if RoleManager.me then
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.school,
      state = true
    })
  end
end

function TaskData.GetInstituteMiracleTasks()
  return this.instituteMiracleTasks
end

function TaskData.IsInstituteMiracleTasks(task)
  return task:GetTaskTypeID() == RoleTaskType.MiracleTask and task:GetState() ~= TaskStateType.Completed
end

function TaskData.OnResetOtherTask()
  this.mainTasks = {}
  this.branchTasks = {}
  this.activeTasks = {}
  this.monsterTasks = {}
  this.starTasks = {}
  this.periodicalTasks = {}
  this.transferTask = {}
  this.instituteMiracleTasks = {}
  this.skillBooksTasks = {}
  this.counterpartTask = {}
  this.rewardsTasks = {}
end

function TaskData.Reset()
  this.AllTasks = {}
  this.OnResetOtherTask()
end

function TaskData.SwitchRole()
  this.Reset()
  this.OnSetUnionTask()
  this.completedTasksCount = {}
  this.levelBossTaskId = nil
end

function TaskData.GetTaskById(taskId)
  return this.AllTasks[taskId] or this.allUnionTasks[taskId] or nil
end

function TaskData.UpdateTaskInfo(msg)
  local taskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(msg.taskId, "taskId")
  if taskTbl == nil then
    logError("Nhi\225\187\135m v\225\187\165 \196\145\198\176\225\187\163c g\225\187\173i t\225\187\171 m\195\161y ch\225\187\167 hi\225\187\135n kh\195\180ng t\225\187\147n t\225\186\161i, c\195\179 th\225\187\131 do b\225\186\163ng ph\195\173a client v\195\160 server kh\195\180ng \196\145\225\187\147ng b\225\187\153", msg.taskId)
    return
  end
  if msg and this.GetTaskById(msg.taskId) then
    local task = this.ConvertToTask(msg)
    if task:GetTaskTypeID() == RoleTaskType.MainTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveMainTask(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.BranchTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveBranchTask(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.UnionTask then
      this.UpdateTask(msg)
      this.UpdateMonsterOfferedTasks(msg)
    end
    if task:GetTaskTypeID() == RoleTaskType.StarTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveStarTask(task)
      else
        this.UpdateTask(msg)
        this.UpdateStarTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.StageTask then
      this.UpdateTask(msg)
      this.UpdateMonsterPeriodicalTask(msg)
    end
    if task:GetTaskTypeID() == RoleTaskType.MiracleTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveInstituteMiracleTasks(task)
      else
        this.UpdateTask(msg)
        this.UpdateInstituteMiracleTasks(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.SkillTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveSkillBooksTasks(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.TranscriptTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveCounterpartTask(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.TransferTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveTransferTask(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.RewardsTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveRewardsTask(task)
      else
        this.UpdateTask(msg)
      end
    end
    if task:GetTaskTypeID() == RoleTaskType.LevelUpTask then
      if task:GetState() == TaskStateType.Submitted then
        this.AllTasks[task.taskId] = nil
        this.RemoveActiveTask(task)
        this.RemoveRewardsTask(task)
      else
        this.UpdateTask(msg)
      end
    end
  else
    local task = this.ConvertToTask(msg)
    this.AddTask(task)
  end
  EventManager.Dispatch(Event.Task_Update, msg.taskId)
end

function TaskData.ConvertToTask(msg)
  local task = Task(msg)
  return task or nil
end

function TaskData.UpdateTask(msg)
  local task = this.GetTaskById(msg.taskId)
  task:UpdateState(msg.state)
  if msg.taskAcceptState ~= nil then
    task:UpdateTaskAcceptState(msg.taskAcceptState)
  end
  for i, v in pairs(msg.goals) do
    if v then
      task:UpdateGoalInfo(v)
    end
  end
end

function TaskData.AddTask(task)
  this.AllTasks[task.taskId] = task
  this.AddMainTask(task)
  this.AddBranchTask(task)
  this.AddRewardsTask(task)
  this.AddMonsterOfferedTasks(task)
  this.AddMonsterPeriodicalTask(task)
  this.AddStarTask(task)
  this.AddInstituteMiracleTasks(task)
  this.AddSkillBooksTasks(task)
  this.AddCounterpartTask(task)
  this.AddTransferTask(task)
  if this.IsTaskActive(task) then
    this.activeTasks[task.taskId] = task
  end
  task:SetFlagBit(false)
  this.SetTaskPickLimit(task.taskId)
end

function TaskData.OnResRemoveTask(taskId)
  if this.AllTasks[taskId] then
    this.RemoveActiveTask(this.AllTasks[taskId])
    this.RemoveMainTask(this.AllTasks[taskId])
    this.RemoveBranchTask(this.AllTasks[taskId])
    this.RemoveStarTask(this.AllTasks[taskId])
    this.RemoveInstituteMiracleTasks(this.AllTasks[taskId])
    this.RemoveSkillBooksTasks(this.AllTasks[taskId])
    this.RemoveCounterpartTask(this.AllTasks[taskId])
    this.RemoveTransferTask(this.AllTasks[taskId])
    this.AllTasks[taskId] = nil
  end
  EventManager.Dispatch(Event.Task_Update, nil)
end

function TaskData.RefreshTaskState(task)
  for _, oldTask in pairs(TaskData.AllTasks) do
    if oldTask.taskId == taskInfo.taskId then
      oldTask = taskInfo
      break
    end
  end
end

function TaskData.TaskGoalInfoChange(goalInfo)
  for _, oldTask in pairs(TaskData.TotalTasks) do
    if oldTask.taskId == goalInfo.taskId then
      for _, goal in pairs(oldTask.goals) do
        if goal.goalId == goalInfo.goalId then
          goal.count = goalInfo.count
          return
        end
      end
    end
  end
end

function TaskData.UpdateTaskState(data)
  for i, v in pairs(this.AllTasks) do
    if v.missionId == data.missionId then
      v:UpdateState(data)
      return
    end
  end
end

function TaskData.UpdateTaskGoal(data)
  for i, v in pairs(this.AllTasks) do
    if v.taskId == data.taskId then
      v:UpdateGoalInfo(data)
      return
    end
  end
end

function TaskData.FindNpcTaskForNpcId(npcID)
  local npcTask
  local npcTaskList = {}
  for i, v in pairs(this.activeTasks) do
    if v.state == TaskStateType.Acceptable then
      if v:GetFromNpc() == npcID then
        npcTaskList[v.taskId] = v
      end
    elseif v:GetToNpc() == npcID then
      npcTaskList[v.taskId] = v
    end
  end
  for i, v in pairs(this.starTasks) do
    if v.state == 0 and v:GetFromNpc() == npcID then
      npcTaskList[v.taskId] = v
    end
  end
  local sortNpcTask = {}
  for k, v in pairs(npcTaskList) do
    if v:GetState() == TaskStateType.Completed then
      table.insert(sortNpcTask, v)
    end
  end
  for k, v in pairs(npcTaskList) do
    if v:GetState() == TaskStateType.Acceptable then
      table.insert(sortNpcTask, v)
    end
  end
  for k, v in pairs(npcTaskList) do
    if v:GetState() == TaskStateType.Accept then
      table.insert(sortNpcTask, v)
    end
  end
  npcTask = sortNpcTask[1]
  return npcTask
end

function TaskData.FindSortingTaskForNpc(npcID)
  local isFindNpcFlag = false
  if not npcID then
    return isFindNpcFlag, nil
  end
  for i, v in pairs(this.activeTasks) do
    if v.state == TaskStateType.Acceptable and v:GetFromNpc() == npcID then
      isFindNpcFlag = true
      return isFindNpcFlag, v
    end
    if v.state == TaskStateType.Completed and v:GetToNpc() == npcID then
      isFindNpcFlag = true
      return isFindNpcFlag, v
    end
  end
  return isFindNpcFlag, nil
end

function TaskData.IsTaskActive(task)
  return task.state == TaskStateType.Acceptable or task.state == TaskStateType.Accept or task.state == TaskStateType.Completed
end

function TaskData.GetMainTask()
  for i, v in pairs(this.AllTasks) do
    if v:GetTaskTypeID() == RoleTaskType.MainTask then
      return v
    end
  end
end

function TaskData.GetOrderMainTask()
  for i, v in pairs(this.activeTasks) do
    if v:GetTaskTypeID() == RoleTaskType.MainTask then
      return v
    end
  end
  return nil
end

function TaskData.GetOrderMainTaskById(taskId)
  for i, v in pairs(this.activeTasks) do
    if v:GetId() == taskId and v:GetTaskTypeID() == RoleTaskType.MainTask then
      return v
    end
  end
  return nil
end

this.allUnionTasks = {}
this.meUnionTasks = {}
this.helpUnionTasks = {}
this.activeUnionTasks = {}
this.canAcceptCount = 5
this.canAssistCount = 5
this.freeFlushCount = 3
this.flushCount = nil
this.sumSingleCount = {}
this.diamondNumList = {}

function TaskData.InitUnionTasks(unionTasks)
  this.meUnionTasks = {}
  this.activeUnionTasks = {}
  this.canAcceptCount = unionTasks.canAcceptCount
  this.canAssistCount = unionTasks.canAssistCount
  this.freeFlushCount = unionTasks.freeFlushCount
  this.flushCount = unionTasks.flushCount + 1
  for i = 1, table.count(unionTasks.tasks) do
    if unionTasks.tasks[i].owner == ViewData.meData.id or unionTasks.tasks[i].owner == 0 then
      local unionTask = this.ConvertToUnionTask(unionTasks.tasks[i])
      table.insert(this.meUnionTasks, unionTask)
      this.allUnionTasks[unionTask.taskId] = unionTask
      if unionTask.state == TaskStateType.Accept or unionTask.state == TaskStateType.Completed then
        table.insert(this.activeUnionTasks, unionTask)
      end
    elseif unionTasks.tasks[i].helper == ViewData.meData.id then
      local helpTask = this.ConvertToHelpTask(unionTasks.tasks[i])
      table.insert(this.helpUnionTasks, helpTask)
      this.allUnionTasks[helpTask.taskId] = helpTask
      table.insert(this.activeUnionTasks, helpTask)
    end
  end
  this.SortingUnionTasks()
  EventManager.Dispatch(Event.GradTask_Update, nil)
end

function TaskData.InitUnionConfigData()
  this.OnSetUnionTask()
  this.diamondNumList = {}
  local diamondNum = 10090002
  local diamondList = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(diamondNum)
  if diamondList ~= nil then
    local singleDiaNum = string.split(diamondList, "#")
    for i, v in pairs(singleDiaNum) do
      if tonumber(v) > 0 then
        this.diamondNumList[i] = tonumber(v)
      end
    end
  end
  local sumCount = 10090001
  local sumCountList = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(sumCount)
  if sumCountList ~= nil then
    local singleSumCount = string.split(sumCountList, "#")
    for i, v in pairs(singleSumCount) do
      if tonumber(v) > 0 then
        this.sumSingleCount[i] = tonumber(v)
      end
    end
  end
  this.allMonsterLevel = {}
  local monsterLevelTable = ClientTable.cfg_Task_rewardManager:GetDic()
  for k, v in pairs(monsterLevelTable) do
    table.insert(this.allMonsterLevel, v.levelReward)
  end
end

function TaskData.GetDiamondNumToUpdatePage()
  local curDiaNum
  if this.flushCount ~= nil then
    curDiaNum = this.diamondNumList[this.flushCount] or this.diamondNumList[table.count(this.diamondNumList)]
  end
  return curDiaNum
end

function TaskData.GetCanUnionTaskCount()
  local count = 0
  if this.sumSingleCount then
    count = this.sumSingleCount[1] or 0
  end
  return count
end

function TaskData.GetCanHelpUnionTaskCount()
  local count = 0
  if this.sumSingleCount then
    count = this.sumSingleCount[2] or 0
  end
  return count
end

function TaskData.GetUnionTaskOfIndex(unionTaskId)
  local unionTask = {}
  for i, v in pairs(this.allUnionTasks) do
    if v.taskId == unionTaskId then
      unionTask = v
    end
  end
  return unionTask
end

function TaskData.GetTotalFreeUnionTaskCount()
  local count = 0
  if this.sumSingleCount then
    count = this.sumSingleCount[3] or 0
  end
  return count
end

function TaskData.SetTaskPickLimit(taskID)
  if TaskData.PickLimitTaskID == nil then
    local TaskPickLimitGlobal = ClientTable.cfg_Global_globalManager:TryGetValue(5)
    if TaskPickLimitGlobal ~= nil then
      TaskData.PickLimitTaskID = tonumber(TaskPickLimitGlobal.effect)
    end
  end
  if taskID ~= TaskData.PickLimitTaskID then
    return
  end
  QiJiHelperController.SetCantPickupType(false, EItemType.Equipe, "101#102")
  EventManager.Dispatch(Event.QiJiHelper_SetAutoPickup)
end

function TaskData.OnSetUnionTask()
  this.allUnionTasks = {}
  this.meUnionTasks = {}
  this.activeUnionTasks = {}
end

function TaskData.ConvertToUnionTask(msg)
  local unionTask = UnionTask(msg)
  return unionTask or nil
end

function TaskData.ConvertToHelpTask(msg)
  local helpTask = HelpTask(msg)
  return helpTask or nil
end

function TaskData.SortingUnionTasks()
  table.sort(this.meUnionTasks, function(a, b)
    if a.level ~= b.level then
      return a.level < b.level
    end
  end)
  table.sort(this.activeUnionTasks, function(a, b)
    if a.level ~= b.level then
      return a.level < b.level
    end
  end)
end

function TaskData.UpdateUnionTask(resUnionTask)
  if resUnionTask.type == WarAllianceTaskType.Single then
    if resUnionTask.owner == ViewData.meData.id or resUnionTask.owner == 0 then
      if this.allUnionTasks[resUnionTask.taskId] then
        this.UpdateTask(resUnionTask.taskId)
      else
        local unionTask = this.ConvertToUnionTask(resUnionTask)
        this.allUnionTasks[unionTask.taskId] = unionTask
        table.insert(this.meUnionTasks, unionTask)
        if unionTask.state == TaskStateType.Accept or unionTask.state == TaskStateType.Completed then
          table.insert(this.activeUnionTasks, unionTask)
        end
      end
    elseif resUnionTask.helper == ViewData.meData.id then
      if this.allUnionTasks[resUnionTask.taskId] then
        this.UpdateTask(resUnionTask.taskId)
      else
        local helpTask = this.ConvertToHelpTask(resUnionTask)
        this.allUnionTasks[helpTask.taskId] = helpTask
        table.insert(this.helpUnionTasks, helpTask)
        if helpTask.state == TaskStateType.Accept or helpTask.state == TaskStateType.Completed then
          table.insert(this.activeUnionTasks, helpTask)
        end
      end
    end
    EventManager.Dispatch(Event.GradTask_Update, nil)
  end
  if resUnionTask.type == WarAllianceTaskType.Common then
    if this.allUnionTasks[resUnionTask.taskId] then
      this.UpdateTask(resUnionTask)
    else
      local unionTask = this.ConvertToUnionTask(resUnionTask)
      this.allUnionTasks[unionTask.taskId] = unionTask
      table.insert(this.unionCommonTask, unionTask)
    end
    EventManager.Dispatch(Event.WarAllianceCommonTask_Update)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
  end
end

function TaskData.IsUnionTaskProgress()
  local isInProgress = false
  for i, v in pairs(this.meUnionTasks) do
    if v.state == TaskStateType.Accept then
      isInProgress = true
    end
  end
  return isInProgress
end

function TaskData.RefreshUnionCommonTask(data)
  this.unionCommonTask = {}
  for i = 1, table.count(data.tasks) do
    local unionTask = this.ConvertToUnionTask(data.tasks[i])
    table.insert(this.unionCommonTask, unionTask)
    this.allUnionTasks[unionTask.taskId] = unionTask
  end
  this.unionCommonTaskTime = data.time
  EventManager.Dispatch(Event.WarAllianceCommonTask_Update)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function TaskData.GetUnionCommonTaskCount(taskId)
  if this.completedTasksCount[taskId] ~= nil then
    return this.completedTasksCount[taskId].count
  else
    return 0
  end
end

this.completedTasksCount = {}

function TaskData.SaveCompletedTasksCount(tasks)
  for i = 1, table.count(tasks) do
    local task = tasks[i]
    this.completedTasksCount[task.id] = task
    this.TaskSpecialDealForGold(task)
    EventManager.Dispatch(Event.TaskCount_Update)
  end
  if RoleManager.me then
    EventManager.Dispatch(Event.Fuc_Refresh)
  end
end

function TaskData.TaskSpecialDealForGold(task)
  if task.id == 10013 then
    EventManager.Dispatch(Event.Scene_SmallBossShow, true)
  end
end

function TaskData.GetCompletedTasksCount(taskId)
  if this.completedTasksCount[taskId] ~= nil then
    return this.completedTasksCount[taskId]
  else
    return false
  end
end

function TaskData.GetTimeTasks()
  return (this.timeTasks == nil or #this.timeTasks == 0) and {} or this.timeTasks
end

function TaskData.SetNewBossBountyReward(msg)
  this.timeTasks = {}
  if msg and msg.resultMsg then
    for k, v in pairs(msg.resultMsg) do
      local taskTbl = ConfigManager.GetConfig("cfg_Task_task", v.id, "taskId")
      if taskTbl then
        taskTbl.v = v
        table.insert(this.timeTasks, taskTbl)
      end
    end
  end
  EventManager.Dispatch(Event.BossBountyReward, msg)
end

function TaskData.GetTimeTaskByLevel(level, state)
  if this.timeTasks ~= nil and #this.timeTasks > 0 then
    for k, v in pairs(this.timeTasks) do
      if level == v.subtype then
        if state ~= nil then
          v.v.state = state
        end
        return v
      end
    end
  end
  return nil
end

function TaskData.GetTimeClose()
  if TaskData.TabOpen() and this.timeTasks ~= nil and #this.timeTasks > 0 then
    for k, v in pairs(this.timeTasks) do
      local totalTime = math.floor(v.v.previewTime - Time.GetServerSecondTime())
      if 0 < totalTime then
        return true
      end
    end
  end
  return false
end

function TaskData.GetNewTimeClose()
  local down = LoginData.GetOpenServerDay()
  if down <= 7 and TaskData.TabOpen() then
    return true
  end
  return false
end

function TaskData.TabOpen()
  local tabCondition = TaskData.GetLevelAndCondition()
  if tabCondition <= ViewData.meData.level then
    return true
  end
  return false
end

function TaskData.GetTimeSize(isMax)
  local time = 0
  if this.timeTasks ~= nil and 0 < #this.timeTasks then
    local tbl = {}
    tbl = this.timeTasks
    table.sort(tbl, function(a, b)
      local totalTime_a = a.v.previewTime
      local totalTime_b = b.v.previewTime
      return totalTime_a < totalTime_b
    end)
    for k, v in pairs(tbl) do
      local totalTime = math.floor(v.v.previewTime - Time.GetServerSecondTime())
      if 0 < totalTime then
        time = v.v.previewTime
        break
      end
    end
    if isMax then
      time = tbl[table.count(this.timeTasks)].v.previewTime
    end
  end
  return time
end

function TaskData.GetStateClose()
  return this.GetNewPeriodicalTaskByLevel()
end

function TaskData.HandleGiftTblData(tblData)
  local copyTbl = {}
  table.copy(copyTbl, tblData)
  local tempTbl = {}
  for i = 1, #copyTbl do
    if copyTbl[i].condition ~= nil then
      local isMatch = ConditionManager.Check4D(copyTbl[i].condition)
      if isMatch then
        table.insert(tempTbl, copyTbl[i])
      end
    else
      table.insert(tempTbl, copyTbl[i])
    end
  end
  return tempTbl
end

function TaskData.SetCarrerReward(tblData)
  local award = string.split(tblData, "&")
  local tabReward = {}
  for k, v in pairs(award) do
    if string.find(v, "_") then
      if RoleUtility.CareerJudge(ViewData.meData.career, tonumber(string.split(v, "_")[1])) then
        award = string.split(string.split(v, "_")[2], "#")
        for kk, vv in pairs(award) do
          table.insert(tabReward, {
            itemId = tonumber(vv),
            count = 1
          })
        end
      end
    else
      local awardInAll = string.split(v, "#")
      for kk, vv in pairs(awardInAll) do
        table.insert(tabReward, vv)
      end
    end
  end
  return tabReward
end

function TaskData.GetLevelAndCondition()
  if this.levelAndCondition == nil then
    this.levelAndCondition = {}
    local data = ConfigManager.GetConfig("cfg_Global_global", 2490007).effect
    local allData = string.split(data, "&")
    this.tabCondition = tonumber(allData[1])
    table.remove(allData, 1)
    local nowData = string.split(allData[1], "#")
    for i = 1, table.count(nowData) do
      if this.levelAndCondition[nowData[i]] == nil then
        table.insert(this.levelAndCondition, tonumber(nowData[i]))
      end
    end
  end
  table.sort(this.levelAndCondition, function(a, b)
    return a < b
  end)
  return this.tabCondition, this.levelAndCondition
end
