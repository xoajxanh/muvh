require("GamePlay/Task/MapMonster")
LookForTask = {}
local this = LookForTask

function LookForTask.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.SwitchRole()
end

function LookForTask.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.SwitchRole)
end

function LookForTask.RegistEvent()
  this.eventContainer:Regist(Event.Task_PathStop, this.TaskPathStop)
  this.eventContainer:Regist(Event.Task_ProgressChange, this.TaskProgressChange)
  this.eventContainer:Regist(Event.Task_StateChange, this.TerminationLookForTask)
end

function LookForTask.SwitchRole()
  this.RemoveTime()
  this.InitBehavior()
  this.RemoveSockTragte()
end

function LookForTask.InitBehavior()
  this.taskPathfindingState = PathfindingState.taskNone
  this.targetMonsterType = TaskTargetMonsterType.None
  this.lookForTask = nil
  this.index = 0
end

function LookForTask.TaskPathStop()
  this.ClickOnTask = nil
  this.taskPathfindingState = PathfindingState.taskStop
end

function LookForTask.GoAcceptTask(task, taskConditionType)
  this.SetLookForTaskState(task, taskConditionType)
  this.lookForTask = task
  this.StopMonsterMonitoring()
  local npcId = task:GetFromNpc()
  local transferId = task:GetFromTransferId()
  if npcId ~= nil and 0 < npcId then
    PathFinderManager.JumpMapMoveToNpc({npcId = npcId}, transferId, Purpose.ForTask, this.ReachTaskNpc, nil, false)
  end
end

function LookForTask.DetermineGeneralTaskTypes(task, taskConditionType)
  this.SetLookForTaskState(task, taskConditionType)
  this.lookForTask = task
  this.SetDetermineTaskMonster()
  if this.targetMonsterType ~= TaskTargetMonsterType.Random then
    local transferTbl = task:GetTransferId()
    if transferTbl ~= nil and table.count(transferTbl) > 0 and not string.isNullOrEmpty(transferTbl[1]) then
      PathFinderManager.FlyTransferScene(tonumber(transferTbl[1]), SceneData.line, nil, Purpose.ForTask, this.ReachTaskNpc)
      return
    end
  end
  local mulPos, groupId, point, transId, type, range = task:GetPosition()
  if groupId == nil or point == nil then
    if this.targetMonsterType == TaskTargetMonsterType.MapLock then
      this.taskPathfindingState = PathfindingState.taskFinish
    end
    return
  end
  if transId ~= nil and not string.isNullOrEmpty(transId) and 0 < tonumber(transId) then
  else
    transId = nil
  end
  if this.targetMonsterType ~= TaskTargetMonsterType.MapLock then
    point = PathFinderManager.GetCalcPosData(point)
  end
  if not string.isNullOrEmpty(range) then
    point = PathFinderManager.pathFinding.FindRandomNearPoint(point, range)
  end
  local goalParam = this.lookForTask:GetTaskGola().goalTbl.goalParam
  if task:GetId() == 10001 then
    PathFinderManager.JumpMapToMoveToPos(groupId, point, transId, nil, {npcId = goalParam}, Purpose.ForTask, this.ReachTaskNpc, 2, false)
  else
    PathFinderManager.JumpMapToMoveToPos(groupId, point, transId, nil, {npcId = goalParam}, Purpose.ForTask, this.ReachTaskNpc, nil, false)
  end
end

function LookForTask.DetermineNpcTaskTypes(task, toNpcId, taskConditionType)
  this.SetLookForTaskState(task, taskConditionType)
  this.lookForTask = task
  this.StopMonsterMonitoring()
  local transferId = task:GetTransferId()
  PathFinderManager.JumpMapMoveToNpc({
    npcId = toNpcId,
    guide = task:GetNaviNpc()
  }, transferId[1], Purpose.ForTask, this.ReachTaskNpc, nil, false)
end

function LookForTask.SetLookForTaskState(taskId, taskConditionType)
  if taskConditionType == TaskTriggeringConditionType.OnClick then
    this.taskPathfindingState = PathfindingState.taskOnClickStart
  else
    this.taskPathfindingState = PathfindingState.taskAutoStart
  end
end

function LookForTask.TaskProgressChange(_, fightMonsterId)
  local monsterId = string.split(fightMonsterId, "#")
  for k, v in pairs(monsterId) do
    FightMonsterManager.RemoveFightMonster(tonumber(v))
  end
end

function LookForTask.TerminationLookForTask(id, taskId)
  if this.lookForTask ~= nil and this.lookForTask:GetId() == taskId then
    FightMonsterManager.OnRetTraget(taskId)
  end
end

function LookForTask.AddSockTarget()
  MapMonsterLockManager.RemoveSockTragte()
  if this.targetMonsterType == TaskTargetMonsterType.MapLock then
    RoleTargetManager.SetLookUpMonsterFunc(RoleTargetId.Task, MapMonster.GetMonster, 2)
  else
    RoleTargetManager.SetLookUpMonsterFunc(RoleTargetId.Task, FightMonsterManager.GetCurSockMonster, 2)
  end
end

function LookForTask.RemoveSockTragte()
  RoleTargetManager.RemoveLookUpMonsterFunc(RoleTargetId.Task)
end

function LookForTask.SetDetermineTaskMonster()
  local goalsList = this.lookForTask:GetAllGoals()
  local type
  local target = {}
  for k, v in pairs(goalsList) do
    local seekType = string.split(v.goalTbl.seekType, "#")
    if tonumber(seekType[1]) == TaskTargetMonsterType.MonsterTpye then
      type = TaskTargetMonsterType.MonsterTpye
      table.insert(target, type)
    end
    if tonumber(seekType[1]) == TaskTargetMonsterType.MonsterId then
      type = TaskTargetMonsterType.MonsterId
      local monsterId = string.split(v.goalTbl.goalParam, "#")
      for p, t in pairs(monsterId) do
        table.insert(target, t)
      end
    end
    if tonumber(seekType[1]) == TaskTargetMonsterType.MapLock then
      type = TaskTargetMonsterType.MapLock
    end
  end
  if type == TaskTargetMonsterType.MonsterTpye then
    this.targetMonsterType = TaskTargetMonsterType.MonsterTpye
    FightMonsterManager.SetFightMonster(FightTragetType.FightType, target, this.lookForTask:GetId())
    this.AddSockTarget()
  end
  if type == TaskTargetMonsterType.MonsterId then
    this.targetMonsterType = TaskTargetMonsterType.MonsterId
    FightMonsterManager.SetFightMonster(FightTragetType.FightId, target, this.lookForTask:GetId())
    this.AddSockTarget()
  end
  if type == TaskTargetMonsterType.MapLock then
    this.targetMonsterType = TaskTargetMonsterType.MapLock
    this.AddSockTarget()
  end
  if type == nil then
    this.StopMonsterMonitoring()
  end
end

function LookForTask.GoSubmitTask(task, taskConditionType)
  this.SetLookForTaskState(task, taskConditionType)
  this.lookForTask = task
  this.StopMonsterMonitoring()
  local toNpcId = task:GetToNpc()
  local transferId = task:GetToTransferId()
  this.StopMonsterMonitoring()
  if task:GetId() == 10001 then
    PathFinderManager.JumpMapMoveToNpc({npcId = toNpcId}, transferId, Purpose.ForTask, this.ReachTaskNpc, 2, false)
  else
    PathFinderManager.JumpMapMoveToNpc({npcId = toNpcId}, transferId, Purpose.ForTask, this.ReachTaskNpc, nil, false)
  end
end

function LookForTask.SetTaskPickUpDrop()
  if this.taskPathfindingState ~= PathfindingState.taskNone and this.taskPathfindingState ~= PathfindingState.taskStop and this.taskPathfindingState ~= PathfindingState.taskPickUp and this.taskPathfindingState ~= PathfindingState.taskDrop and QiJiHelperData.isAutoFight == false then
    this.taskPathfindingState = PathfindingState.taskDrop
  end
end

function LookForTask.PauseTaskGo()
  if this.taskPathfindingState == PathfindingState.taskDrop or this.taskPathfindingState == PathfindingState.taskPickUp then
    if this.countDownTimer then
      return
    end
    
    local function WaitPickUp()
      if not TaskManager.NeedPickUp() then
        if RoleManager.me and this.taskPathfindingState == PathfindingState.taskPickUp and this.lookForTask ~= nil and this.lookForTask:GetState() ~= TaskStateType.Completed then
          if RoleManager.me:CanMove() then
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
            if this.targetMonsterType == TaskTargetMonsterType.MapLock then
              if MapMonster.FindMonsterData() ~= nil then
                this.FindMonsterGo(MapMonster.FindMonsterData())
              end
            else
              TaskManager.TaskGo(this.lookForTask:GetId(), TaskTriggeringConditionType.AutoTask)
            end
          else
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
          end
        end
      elseif QiJiHelperData.isAutoFight == false then
        if DropItemManager.IsHasPowerToAutoPickUp() then
          RoleManager.me:StopMove()
          this.taskPathfindingState = PathfindingState.taskPickUp
        else
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
          this.taskPathfindingState = PathfindingState.taskPickUp
        end
      end
      this.RemoveTime()
      return
    end
    
    this.RemoveTime()
    this.countDownTimer = Timer.StartLoop(0.05, 1, WaitPickUp)
  end
end

function LookForTask.StopMonsterMonitoring()
  this.targetMonsterType = TaskTargetMonsterType.None
  this.RemoveSockTragte()
end

function LookForTask.OnSetTargetMonsterType()
  this.targetMonsterType = TaskTargetMonsterType.None
  this.RemoveTime()
  this.TaskPathStop()
end

function LookForTask.Update()
  if this.index > 5 then
    this.index = 0
    this.MonsterMonitoring()
    this.PauseTaskGo()
  end
  this.index = this.index + 1
end

local multiCoordinate, type, sockTragetMonster

function LookForTask.MonsterMonitoring()
  if this.targetMonsterType == TaskTargetMonsterType.None or this.targetMonsterType == TaskTargetMonsterType.Random or this.lookForTask == nil then
    return
  end
  if this.lookForTask:GetState() ~= TaskStateType.Accept or RoleManager.me == nil then
    return
  end
  multiCoordinate, type = this.lookForTask:GetTaskTypePosition()
  if tonumber(type) == TaskTargetMonsterType.None or tonumber(type) == TaskTargetMonsterType.Random then
    return
  end
  sockTragetMonster = nil
  if this.targetMonsterType == TaskTargetMonsterType.MapLock then
    sockTragetMonster = MapMonster.GetMonster()
  else
    sockTragetMonster = FightMonsterManager.GetMonster()
  end
  if this.taskPathfindingState == PathfindingState.taskNone then
    return
  end
  if this.taskPathfindingState == PathfindingState.taskAutoStart then
    if sockTragetMonster then
      if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
        this.taskPathfindingState = PathfindingState.taskInterruption
      end
    elseif TaskManager.NeedPickUp() then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      this.taskPathfindingState = PathfindingState.taskInterruption
    end
  end
  if this.taskPathfindingState == PathfindingState.taskOnClickStart and sockTragetMonster and QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    this.taskPathfindingState = PathfindingState.taskInterruption
  end
  if this.taskPathfindingState == PathfindingState.taskInterruption then
    if not sockTragetMonster then
      if not TaskManager.NeedPickUp() then
        if RoleManager.me and RoleManager.me:CanMove() then
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
          if this.targetMonsterType == TaskTargetMonsterType.MapLock then
            if MapMonster.FindMonsterData() ~= nil then
              this.FindMonsterGo(MapMonster.FindMonsterData())
            end
          else
            TaskManager.TaskGo(this.lookForTask:GetId(), TaskTriggeringConditionType.AutoTask)
          end
        end
      elseif QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end
      return
    end
    if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end
  if this.taskPathfindingState == PathfindingState.taskDrop and not sockTragetMonster then
    this.taskPathfindingState = PathfindingState.taskPickUp
  end
  if this.taskPathfindingState == PathfindingState.taskFinish then
    if not multiCoordinate then
      if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end
      return
    end
    if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end
  if this.taskPathfindingState == PathfindingState.taskStop then
    return
  end
end

function LookForTask.FindMonsterGo(monsterData)
  this.taskPathfindingState = PathfindingState.taskAutoStart
  PathFinderManager.JumpMapToMoveToPos(SceneData.groupId, Vector2(monsterData.x, monsterData.y), nil, nil, nil, Purpose.ForTask, function()
    if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
      this.taskPathfindingState = PathfindingState.taskFinish
    end
  end, nil, false)
end

function LookForTask.RemoveTime()
  if this.countDownTimer then
    Timer.Stop(this.countDownTimer)
    this.countDownTimer = nil
  end
end

function LookForTask.ReachTaskNpc(param)
  PathFinderManager.ResetData()
  if not this.lookForTask then
    return false
  end
  if this.lookForTask:GetState() == TaskStateType.Acceptable then
    this.ShowTaskStatePanel()
    this.taskPathfindingState = PathfindingState.taskFinish
    return
  end
  if this.lookForTask:GetState() == TaskStateType.Accept then
    this.OnAcceptArrive(param)
    return
  end
  if this.lookForTask:GetState() == TaskStateType.Completed then
    LookForTask.CompletedDoFor()
  end
  return this.lookForTask ~= nil
end

function LookForTask.OnAcceptArrive(param)
  local goalType = this.lookForTask:GetTaskGola().goalTbl.type
  if goalType == 3010 then
    networkRequest.ReqCompleteTask(this.lookForTask:GetId())
  end
  if this.lookForTask:IsAutoFight() then
    this.lookForTask:SetPurposeful(true)
    this.taskPathfindingState = PathfindingState.taskFinish
    if (this.targetMonsterType == TaskTargetMonsterType.None or this.targetMonsterType == TaskTargetMonsterType.Random) and QiJiHelperData.isAutoFight == false then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  else
    this.taskPathfindingState = PathfindingState.taskFinish
    if goalType == 201 then
      local goalUpdateMsg = {
        id = this.lookForTask:GetTaskGola().goalTbl.goalParam,
        type = 201
      }
      NetManager.Send(TaskMessage.ReqUpdateGoal, goalUpdateMsg)
    end
    local target = this.lookForTask:GetTaskGola().goalTbl.target
    local targetList = string.split(target, "#")
    if tonumber(targetList[1]) == TaskTargetType.NpcTarget then
      local npcTbl = ClientTable.cfg_Npc_npcManager:TryGetValue(param.npcId, "npcId")
      local metaTbl = getmetatable(npcTbl)
      if metaTbl then
        metaTbl = table.copy(nil, metaTbl.__index)
        npcTbl = table.copy(metaTbl, npcTbl)
        npcTbl.param = param
      end
      if npcTbl ~= nil then
        EventManager.Dispatch(Event.OpenNpcPanel, npcTbl)
      end
    end
  end
  return
end

function LookForTask.ShowTaskStatePanel()
  TaskManager.ShowTaskStatePanel(this.lookForTask)
end

function LookForTask.CommitTaskJudge(taskId)
  if this.lookForTask ~= nil and this.lookForTask:GetId() == taskId then
    this.lookForTask = nil
  end
end

function LookForTask.CompletedDoFor()
  this.ShowTaskStatePanel()
  local gola = this.lookForTask:GetTaskGola()
  if gola ~= nil and gola:GetGoldType() == TaskGoalType.AutoFight and QiJiHelperData.isAutoFight == false then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end
end

LookForTask.Init()
