AutoTaskManage = {}
local this = AutoTaskManage

function AutoTaskManage.Init()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
  this.OnReset()
end

function AutoTaskManage.OnReset()
  this.taskChange = false
  this.autoTask = false
  this.curRoleOperate = false
  this.curAutoTask = nil
  this.curAutoTaskState = nil
  this.autoTaskStack = {}
  this.RemoveAutoTask(true)
  this.frameIndex = 1
end

function AutoTaskManage.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.StopAutoTask)
  this.messageContainer:Regist(MapMessage.ResMonsterDie, this.AddMonitorAutoTask)
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnReset)
end

function AutoTaskManage.RegistEvent()
  this.eventContainer:Regist(Event.Load_PreLoadEnd, this.SceneTranscript)
  this.eventContainer:Regist(Event.Map_RealOperation, this.MapEffectiveclick)
  this.eventContainer:Regist(Event.Task_Update, this.SetAutoTaskStateUpdate)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.StopAutoTask)
end

function AutoTaskManage.SceneTranscript()
  if TranScriptData.InTranscript then
    this.SetAutoTask(false)
    this.CloseFlyShoeUI()
  else
    this.SetAutoTask(true)
  end
end

function AutoTaskManage.CloseFlyShoeUI()
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
end

function AutoTaskManage.NewPeriod()
  return RoleManager.me ~= nil and RoleManager.me.level < ClientTable.cfg_Global_globalManager:GetAutoTaskLevel()
end

function AutoTaskManage.StopAutoTask()
  if RoleManager.me then
    RoleManager.me:StopMove()
    this.autoTaskStack = {}
  end
  this.RemoveAutoTask()
end

function AutoTaskManage.SetAutoTask(isAuto)
  this.autoTask = isAuto
  if isAuto == false then
    this.RemoveAutoTask(true)
  end
end

function AutoTaskManage.GetAutoTask()
  return this.autoTask
end

function AutoTaskManage.SetCurWorkingAutoTask(task)
  if this.curAutoTask == nil and task:GetTaskTypeID() == RoleTaskType.MainTask then
    this.curAutoTask = task
    this.curAutoTaskState = task:GetState()
  end
  if task:GetTaskTypeID() == RoleTaskType.MainTask and this.curAutoTask ~= nil and this.curAutoTask:GetId() ~= Task:GetId() then
    this.curAutoTask = task
    this.curAutoTaskState = task:GetState()
  end
end

function AutoTaskManage.SetAutoTaskStateUpdate()
  if RoleManager.me and not this.NewPeriod() then
    return
  end
  if this.GetAutoTask() == false then
    return
  end
  if this.curAutoTask == nil then
    this.StartCurAutoTask(true)
    return
  else
    local task = TaskData.GetOrderMainTaskById(this.curAutoTask.taskId)
    if task ~= nil then
      if this.curAutoTaskState ~= task:GetState() then
        this.curAutoTaskState = task:GetState()
        this.StartCurAutoTask(true)
      end
    else
      this.curAutoTask = nil
      this.curAutoTaskState = nil
      this.StartCurAutoTask(true)
    end
  end
end

function AutoTaskManage.AddListenerRoleCommitFail(task)
  if this.curAutoTask ~= nil then
    if task:GetId() == this.curAutoTask:GetId() then
      this.RemoveAutoTask()
      this.StartCurAutoTask(true)
    end
  elseif task:GetTaskTypeID() == 1 then
    this.curAutoTask = task
    this.curAutoTaskState = task:GetState()
    this.StartCurAutoTask(true)
  end
end

function AutoTaskManage.SetCurAutoTask()
  if this.curAutoTask == nil then
    this.curAutoTask = TaskData.GetOrderMainTask()
    if this.curAutoTask ~= nil then
      this.curAutoTaskState = this.curAutoTask:GetState()
    end
  else
    local task = TaskData.GetOrderMainTaskById(this.curAutoTask.taskId)
    if task ~= nil then
      this.curAutoTask = task
      this.curAutoTaskState = task:GetState()
    end
  end
  return this.curAutoTask
end

function AutoTaskManage.StartCurAutoTask(isForcedUpdating)
  if this.GetAutoTask() == false then
    this.SetAutoTask(false)
    return
  end
  if isForcedUpdating then
    this.taskChange = isForcedUpdating
    local autoTaskStack = this.GetAutoTaskStack()
    if autoTaskStack then
      this.RemoveAutoTaskStack(autoTaskStack[1])
    end
    this.RemoveAutoTask(true)
  end
  if RoleManager.me and RoleManager.me.hp > 0 and LoginData.reconnectState == false and this.NewPeriod() then
    local mainTask = this.SetCurAutoTask()
    if mainTask ~= nil then
      if mainTask:GetState() == TaskStateType.Accept and not mainTask:IsAutoFind() then
        return
      end
      if mainTask.state == TaskStateType.Acceptable then
        this.AutoAcceptableTask(isForcedUpdating)
      elseif mainTask.state == TaskStateType.Accept then
        this.AutoAcceptTask(isForcedUpdating)
      elseif mainTask.state == TaskStateType.Completed then
        this.AutoCompletedTask(isForcedUpdating)
      end
    end
  else
    this.RemoveAutoTask()
  end
end

function AutoTaskManage.CoolDownAutoPath(autoTime, isForcedUpdating)
  if this.countDownTimer then
    Timer.Stop(this.countDownTimer)
    this.countDownTimer = nil
  end
  
  local function DownTimer()
    if isForcedUpdating == false and QiJiHelperData.isAutoFight then
      this.RemoveAutoTask()
      return
    end
    if RoleManager.me and this.curAutoTask and not SmallGameData.GetRunningStatus() then
      if RoleManager.me:CanMove() and not TaskManager.NeedPickUp() then
        this.taskChange = false
        this.ClosePanel()
        TaskManager.TaskGo(this.curAutoTask.taskId, TaskTriggeringConditionType.AutoTask)
        this.RemoveAutoTask(true)
        AutoTaskManage.RemoveAutoTaskStack(this.curAutoTask.taskId)
      else
        this.AddAutoTaskStack(this.curAutoTask.taskId)
      end
    end
  end
  
  this.countDownTimer = Timer.StartLoop(autoTime / 1000, 1, DownTimer)
end

function AutoTaskManage.ClosePanel()
  if UIManager.IsVisible(UIID.Main_StartGame) then
    UIManager.Hide(UIID.Main_StartGame)
  end
  if UIManager.IsVisible(UIID.Login_WelcomeServerUI) then
    UIManager.Hide(UIID.Login_WelcomeServerUI)
  end
end

function AutoTaskManage.RemoveAutoTask(force)
  if force then
    if this.countDownTimer then
      Timer.Stop(this.countDownTimer)
      this.countDownTimer = nil
    end
  elseif this.taskChange then
    return
  elseif this.countDownTimer then
    Timer.Stop(this.countDownTimer)
    this.countDownTimer = nil
  end
end

function AutoTaskManage.AutoAcceptableTask(isForcedUpdating)
  if isForcedUpdating then
    this.RemoveMonitorAutoTask()
    this.RemoveAutoTask(true)
    local weakBooting = this.curAutoTask:GetWeakBooting()
    local autoTime = 50
    if weakBooting then
      return
    end
    this.CoolDownAutoPath(autoTime, isForcedUpdating)
  elseif this.countDownTimer then
    return
  else
    local autoTime = this.curAutoTask:GetAutoTime()
    autoTime = 0 < autoTime and autoTime or 15000
    this.CoolDownAutoPath(autoTime, isForcedUpdating)
  end
end

function AutoTaskManage.AutoAcceptTask(isForcedUpdating)
  if isForcedUpdating then
    this.RemoveMonitorAutoTask()
    this.RemoveAutoTask(true)
    local weakBooting = this.curAutoTask:GetWeakBooting()
    local autoTime = 50
    if weakBooting then
      return
    end
    this.CoolDownAutoPath(autoTime, isForcedUpdating)
  elseif this.countDownTimer then
    return
  else
    local autoTime = this.curAutoTask:GetAutoTime()
    autoTime = 0 < autoTime and autoTime or 15000
    this.CoolDownAutoPath(autoTime, isForcedUpdating)
  end
end

function AutoTaskManage.AutoCompletedTask(isForcedUpdating)
  if isForcedUpdating then
    this.RemoveMonitorAutoTask()
    this.RemoveAutoTask(true)
    local autoTime = this.curAutoTask:GetSubmitTime()
    if autoTime < 0 then
      return
    else
      autoTime = 0 < autoTime and autoTime or 3000
      this.CoolDownAutoPath(autoTime, isForcedUpdating)
    end
  elseif this.countDownTimer then
    return
  else
    local autoTime = this.curAutoTask:GetSubmitTime()
    if autoTime < 0 then
      return
    else
      autoTime = 0 < autoTime and autoTime or 3000
      this.CoolDownAutoPath(autoTime, isForcedUpdating)
    end
    this.CoolDownAutoPath(autoTime, isForcedUpdating)
  end
end

function AutoTaskManage.AddAutoTaskStack(taskId)
  if taskId ~= nil then
    if this.autoTaskStack == nil then
      this.autoTaskStack = {}
    end
    if #this.autoTaskStack > 1 then
      this.autoTaskStack = {}
      table.insert(this.autoTaskStack, taskId)
    else
      table.insert(this.autoTaskStack, taskId)
    end
  end
end

function AutoTaskManage.RemoveAutoTaskStack(taskId)
  for k, v in pairs(this.autoTaskStack) do
    if v == taskId then
      table.remove(this.autoTaskStack, k)
    end
  end
end

function AutoTaskManage.GetAutoTaskStack()
  return this.autoTaskStack
end

function AutoTaskManage.Update()
  if RoleManager.me and not this.NewPeriod() then
    this.RemoveAutoTask(true)
    return
  end
  if this.GetAutoTask() == false then
    return
  end
  this.MonitorStartAutoTask()
  if this.frameIndex > 200 and RoleManager.me then
    if RoleManager.me.RoleMoveType == ERoleMoveType.Stand or RoleManager.me.RoleMoveType == ERoleMoveType.SwimIdle then
      if not QiJiHelperData.isAutoFight then
        this.StartCurAutoTask(false)
      else
        this.RemoveAutoTask()
      end
    else
      this.RemoveAutoTask()
    end
  end
  this.frameIndex = this.frameIndex + 1
end

function AutoTaskManage:MonitorStartAutoTask()
  if RoleManager.me and RoleManager.me.hp > 0 and RoleManager.me:CanMove() and this.NewPeriod() then
    local autoTaskStack = this.GetAutoTaskStack()
    if autoTaskStack ~= nil and 0 < #autoTaskStack and LoginData.reconnectState == false and not TaskManager.NeedPickUp() then
      this.taskChange = false
      TaskManager.TaskGo(autoTaskStack[1], TaskTriggeringConditionType.AutoTask)
      this.RemoveAutoTaskStack(autoTaskStack[1])
      this.RemoveAutoTask(true)
    end
  end
end

function AutoTaskManage.MapEffectiveclick(_, msg)
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.MapPosClick)
end

function AutoTaskManage.SetCurRoleOperate(operateType)
  this.taskChange = false
  this.RemoveAutoTask(true)
  this.RemoveMonitorAutoTask()
  TaskManager.OnSetTargetMonsterType()
  this.CloseFlyShoeUI()
  if operateType == AutoTaskOperateType.JoyStick or operateType == AutoTaskOperateType.MouseClick or operateType == AutoTaskOperateType.GeneralAttack or operateType == AutoTaskOperateType.SkillAttack then
    EventManager.Dispatch(Event.RoleOperate, isOperate)
  end
  if operateType == AutoTaskOperateType.JoyStick or operateType == AutoTaskOperateType.MouseClick or operateType == AutoTaskOperateType.GeneralAttack or operateType == AutoTaskOperateType.SkillAttack or operateType == AutoTaskOperateType.AutoFight or operateType == AutoTaskOperateType.MapPosClick or operateType == AutoTaskOperateType.UIClick then
    PathFinderManager.ResetData()
  end
end

function AutoTaskManage.SetBrushStrangePoint(position)
  if this.curAutoTask ~= nil and this.curAutoTask:GetTaskGola().goalTbl.type == TaskGoalType.Upgrade then
    local allBrushStrangePoint = this.curAutoTask:GetAllBrushStrangePoint()
    if allBrushStrangePoint == nil then
      return
    end
    local centerPos = PathFinderManager.GetCalcPosDataWithSymbol(position, "#")
    for k, v in pairs(allBrushStrangePoint) do
      local checkPoint = PathFinderManager.GetCalcPosData(v)
      local isRange = PathFinderManager.pathFinding.IsDetectionRangePoint(centerPos, checkPoint, 10)
      if isRange then
        local defaultpos = string.replace(position, "#", "_")
        this.curAutoTask:OnSetDefaultPos(defaultpos)
        return
      else
        this.curAutoTask:OnSetDefaultPos(nil)
      end
    end
  end
end

function AutoTaskManage.ImmediatelyAutoTask()
  if this.curAutoTask == nil then
    local mainTask = this.SetCurAutoTask()
    if mainTask == nil then
      return
    end
  end
  if this.curAutoTask then
    TaskManager.TaskGo(this.curAutoTask.taskId, TaskTriggeringConditionType.AutoTask)
  end
end

function AutoTaskManage.AddMonitorAutoTask(_, data)
  if RoleManager.me and RoleManager.me.hp > 0 and LoginData.reconnectState == false and this.NewPeriod() then
    if this.curAutoTask == nil then
      local mainTask = this.SetCurAutoTask()
      if mainTask == nil then
        return
      end
    end
    if this.curAutoTask then
      local goalsList = this.curAutoTask:GetAllGoals()
      local type
      local goalTarget = false
      for k, v in pairs(goalsList) do
        local seekType = string.split(v.goalTbl.seekType, "#")
        if tonumber(seekType[1]) == TaskTargetMonsterType.MonsterTpye then
          type = TaskTargetMonsterType.MonsterTpye
          if tonumber(seekType[2]) == 2002 then
            goalTarget = true
          end
        end
        if tonumber(seekType[1]) == TaskTargetMonsterType.MapLock then
          type = TaskTargetMonsterType.MapLock
        end
      end
      if type == TaskTargetMonsterType.MonsterTpye and goalTarget and tonumber(data.type) == 2002 then
        if RoleManager.me:CanMove() and not TaskManager.NeedPickUp() then
          if TaskManager.GetLookForTaskState() == PathfindingState.taskAutoStart then
            return
          end
          this.taskChange = false
          TaskManager.TaskGo(this.curAutoTask.taskId, TaskTriggeringConditionType.AutoTask)
          this.RemoveAutoTask(true)
        else
          this.AddAutoTaskStack(this.curAutoTask.taskId)
        end
      end
      if type == TaskTargetMonsterType.MapLock then
        if RoleManager.me:CanMove() and not TaskManager.NeedPickUp() then
          if TaskManager.GetLookForTaskState() == PathfindingState.taskAutoStart then
            return
          end
          this.taskChange = false
          TaskManager.TaskGo(this.curAutoTask.taskId, TaskTriggeringConditionType.AutoTask)
          this.RemoveAutoTask(true)
        else
          this.AddAutoTaskStack(this.curAutoTask.taskId)
        end
      end
    end
  end
  MapMonsterLockManager.StartCircleMonster()
end

function AutoTaskManage.RemoveMonitorAutoTask()
  local autoTaskStack = this.GetAutoTaskStack()
  if autoTaskStack ~= nil and 0 < #autoTaskStack then
    this.RemoveAutoTaskStack(autoTaskStack[1])
  end
end

AutoTaskManage.Init()
