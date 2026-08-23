require("GameModel/TaskData")
require("GamePlay/Task/LookForTask")
require("GamePlay/Task/DirectTask")
TaskManager = {}
local this = TaskManager

function TaskManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.SwitchRole()
end

function TaskManager.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.SwitchRole)
end

function TaskManager.RegistEvent()
  this.eventContainer:Regist(Event.GamePlay_Leave, this.SwitchRole)
end

function TaskManager.SwitchRole()
  this.clickTask = nil
  this.curTask = nil
end

function TaskManager.AddTaskClick(taskId)
  this.clickTask = taskId
end

function TaskManager.TaskGo(taskId, taskConditionType)
  local task = TaskData.AllTasks[taskId]
  if task then
    this.curTask = task
    this.clickTask = nil
    AutoTaskManage.SetCurWorkingAutoTask(task)
    if task:GetTaskTypeID() == RoleTaskType.MainTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.BranchTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.MiracleTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.SkillTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.TranscriptTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.TransferTask then
      this.GeneralTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.UnionTask then
      this.RewardSTask(task, taskConditionType)
    end
    if task:GetTaskTypeID() == RoleTaskType.StarTask then
      this.SamsungTask(task, taskConditionType)
    end
  end
end

function TaskManager.GeneralTask(task, taskConditionType)
  if task:GetState() == TaskStateType.Acceptable then
    this.GoAcceptTask(task, taskConditionType)
  elseif task:GetState() == TaskStateType.Accept then
    if taskConditionType ~= nil then
      if taskConditionType == TaskTriggeringConditionType.OnClick then
        this.GoExecuteTask(task, taskConditionType)
      elseif task:GetNavi() and this.curTask:GetTaskGola() ~= nil and this.curTask:GetAutoLogic() then
        DirectTask.OpenNav(task)
      else
        this.GoExecuteTask(task, taskConditionType)
      end
    end
  elseif task:GetState() == TaskStateType.Completed then
    if task:GetToNpc() ~= nil and task:GetToNpc() > 0 then
      this.GoSubmitTask(task, taskConditionType)
    else
      this.GoSubmitTaskEffect(task)
    end
  end
end

function TaskManager.RewardSTask(task, taskConditionType)
  if task:GetState() == TaskStateType.Acceptable then
    UIManager.Show(UIID.Task_TaskReward)
  elseif task:GetState() == TaskStateType.Accept then
    this.GoExecuteTask(task, taskConditionType)
  elseif task:GetState() == TaskStateType.Completed then
    UIManager.Show(UIID.Task_TaskReward)
  end
end

function TaskManager.SamsungTask(task, taskConditionType)
  if task:GetState() == TaskStateType.Acceptable then
    this.GoAcceptTask(task, taskConditionType)
  elseif task:GetState() == TaskStateType.Accept then
    this.GoExecuteTask(task, taskConditionType)
  elseif task:GetState() == TaskStateType.Completed then
    UIManager.Show(UIID.Task_TaskStart)
  end
end

function TaskManager.UnionTaskGo(unionTask)
  this.curTask = unionTask
  if RoleManager.me then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  if unionTask then
    this.curTask = unionTask
    if unionTask:GetState() == TaskStateType.Acceptable then
    elseif unionTask:GetState() == TaskStateType.Accept then
      this.GoExecuteTask(unionTask)
    elseif unionTask:GetState() == TaskStateType.Completed then
      UIManager.Show(UIID.WarAlliance_Task)
    end
  end
end

function TaskManager.UnionCommonTaskGo(unionTask)
  this.curTask = unionTask
  if RoleManager.me then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  if unionTask then
    this.curTask = unionTask
    if unionTask:GetState() == TaskStateType.Acceptable then
    elseif unionTask:GetState() == TaskStateType.Accept then
      local navigation = unionTask:GetNavigation()
      if navigation then
        local navigationFunction = unionTask:GetNavigationFunction()
        if navigationFunction ~= nil and not ConditionManager.Check(navigationFunction.condition[1]) then
          local tipStr = LocalizationUtility.GetContentByKey("TaskStar_05")
          FloatingTipUtility.QuickMsg(tipStr)
          return
        end
        NavigationUtility.OpenPanel(navigation)
      else
        this.GoExecuteTask(unionTask)
      end
    elseif unionTask:GetState() == TaskStateType.Completed then
      UIManager.Show(UIID.WarAlliance_TaskUI)
    end
  end
end

function TaskManager.StopAutoFight(task, taskConditionType)
  if RoleManager.me then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None, AutoFightReson.AutoTask)
  end
  local contuineTask = true
  if taskConditionType == TaskTriggeringConditionType.OnClick and RoleManager.me and not RoleManager.me:CanMove() then
    this.AddTaskClick(task.taskId)
    contuineTask = false
    return contuineTask
  end
  return contuineTask
end

function TaskManager.GoAcceptTask(task, taskConditionType)
  local contuineTask = this.StopAutoFight(task, taskConditionType)
  if contuineTask == nil or contuineTask == false then
    return
  end
  LookForTask.GoAcceptTask(task, taskConditionType)
end

function TaskManager.GoExecuteTask(task, taskConditionType)
  if task:GetTaskGola() == nil or string.isNullOrEmpty(task:GetTaskGola()) then
    print("\230\149\176\230\141\174\228\184\141\229\175\185", task.taskId, task:GetState())
    return
  end
  local target = task:GetTaskGola().goalTbl.target
  if target == nil or string.isNullOrEmpty(target) then
    local multiCoordinate, type = this.curTask:GetTaskTypePosition()
    if tonumber(type) == TaskTargetMonsterType.MapLock then
      this.DetermineGeneralTaskTypes(task, taskConditionType)
    elseif tonumber(type) == TaskTargetMonsterType.AutoFight and not QiJiHelperData.isAutoFight then
      MapMonsterLockManager.SetMapMonsterLockState()
    else
      DirectTask.GoExecuteTask(task)
    end
  else
    local multiCoordinate, type = this.curTask:GetTaskTypePosition()
    if tonumber(type) == TaskTargetMonsterType.AutoFight and not QiJiHelperData.isAutoFight then
      MapMonsterLockManager.SetMapMonsterLockState()
      return
    end
    local targetList = string.split(target, "#")
    this.DetermineGeneralTaskTypes(task, taskConditionType)
  end
end

function TaskManager.DetermineGeneralTaskTypes(task, taskConditionType)
  local contuineTask = this.StopAutoFight(task, taskConditionType)
  if contuineTask == nil or contuineTask == false then
    return
  end
  LookForTask.DetermineGeneralTaskTypes(task, taskConditionType)
end

function TaskManager.DetermineNpcTaskTypes(task, toNpcId, taskConditionType)
  local contuineTask = this.StopAutoFight(task, taskConditionType)
  if contuineTask == nil or contuineTask == false then
    return
  end
  LookForTask.DetermineNpcTaskTypes(task, toNpcId, taskConditionType)
end

function TaskManager.GoSubmitTask(task, taskConditionType)
  local contuineTask = this.StopAutoFight(task, taskConditionType)
  if contuineTask == nil or contuineTask == false then
    return
  end
  LookForTask.GoSubmitTask(task, taskConditionType)
end

function TaskManager.GoSubmitTaskEffect(task)
  LookForTask.CommitTaskJudge(task:GetId())
  if task:GetTaskTypeID() == RoleTaskType.MainTask then
    EventManager.Dispatch(Event.Task_CompleteTaskGo, task)
  else
    this.ShowTaskStatePanel(task)
  end
end

function TaskManager.Update()
  LookForTask.Update()
  if this.clickTask ~= nil and RoleManager.me and RoleManager.me:CanMove() then
    this.TaskGo(this.clickTask, TaskTriggeringConditionType.OnClick)
    this.clickTask = nil
  end
end

function TaskManager.StopMonsterMonitoring()
  LookForTask.StopMonsterMonitoring()
end

function TaskManager.OnSetTargetMonsterType()
  LookForTask.OnSetTargetMonsterType()
  MapMonsterLockManager.OnSetTargetMonsterType()
end

function TaskManager.TaskPathStop()
  LookForTask.TaskPathStop()
end

function TaskManager.SetTaskPickUpDrop()
  LookForTask.SetTaskPickUpDrop()
  MapMonsterLockManager.SetTaskPickUpDrop()
  PathFinderManager.PickUpDropItems()
end

function TaskManager.GetLookForTaskState()
  return LookForTask.taskPathfindingState
end

function TaskManager.NeedPickUp()
  local need = false
  if DropItemManager.IsHasPowerToAutoPickUp() and VipManager.GetIsHaveAutoPickupDrop() then
    need = true
  end
  if DropItemManager.GetNearestDropItem() then
    need = true
  end
  return need
end

function TaskManager.ShowTaskStatePanel(task)
  if task:GetSubmitPanel() == TaskCompletePanel.TalkPanel and not UIManager.IsVisible(UIID.TaskInfoUI) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.TaskInfoUI, task)
  end
  if task:GetSubmitPanel() == TaskCompletePanel.TransferPanel and not UIManager.IsVisible(UIID.Task_TransferUI) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Task_TransferUI, task)
  end
end

TaskManager.Init()
