require("GamePlay/MapMonster/MapMonsterConfigInfo")
MapMonsterLockManager = {}
local this = MapMonsterLockManager
MapLock = {
  killGoldMonster = enum(0),
  ClickGoldMonster = enum(),
  AutoFight = enum(),
  killGoldMonster = enum()
}

function MapMonsterLockManager.SetOperater()
end

function MapMonsterLockManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.SwitchRole()
end

function MapMonsterLockManager.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.SwitchRole)
end

function MapMonsterLockManager.RegistEvent()
  this.eventContainer:Regist(Event.Task_PathStop, this.TaskPathStop)
end

function MapMonsterLockManager.SwitchRole()
  this.InitBehavior()
  this.RemoveSockTragte()
  this.RemoveTime()
end

function MapMonsterLockManager.InitBehavior()
  this.pathfindingState = PathfindingState.taskNone
  this.targetMonsterType = TaskTargetMonsterType.None
  this.MapMonsterLockManageManage = nil
  this.startCircle = false
  this.index = 0
end

function MapMonsterLockManager.TaskPathStop()
  this.ClickOnTask = nil
  this.startCircle = false
  this.pathfindingState = PathfindingState.taskStop
end

function MapMonsterLockManager.SetMapMonsterLockState()
  if not this.startCircle then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end
end

function MapMonsterLockManager.AddSockTarget()
  RoleTargetManager.SetLookUpMonsterFunc(RoleTargetId.Task, MapMonster.GetMonster, 2)
end

function MapMonsterLockManager.RemoveSockTragte()
  RoleTargetManager.RemoveLookUpMonsterFunc(RoleTargetId.Task)
end

function MapMonsterLockManager.SetTaskPickUpDrop()
  if this.pathfindingState ~= PathfindingState.taskNone and this.pathfindingState ~= PathfindingState.taskStop and this.pathfindingState ~= PathfindingState.taskPickUp and this.pathfindingState ~= PathfindingState.taskDrop and QiJiHelperData.isAutoFight == false and this.startCircle then
    this.pathfindingState = PathfindingState.taskDrop
  end
end

function MapMonsterLockManager.PauseTaskGo()
  if this.pathfindingState == PathfindingState.taskDrop or this.pathfindingState == PathfindingState.taskPickUp then
    if this.countDownTimer then
      return
    end
    
    local function WaitPickUp()
      if not TaskManager.NeedPickUp() then
        if RoleManager.me and this.pathfindingState == PathfindingState.taskPickUp then
          if RoleManager.me:CanMove() then
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
            this.FindMonserLine()
          else
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
          end
        end
      elseif QiJiHelperData.isAutoFight == false then
        if DropItemManager.IsHasPowerToAutoPickUp() then
          RoleManager.me:StopMove()
          this.pathfindingState = PathfindingState.taskPickUp
        else
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
          this.pathfindingState = PathfindingState.taskPickUp
        end
      end
      this.RemoveTime()
      return
    end
    
    this.RemoveTime()
    this.countDownTimer = Timer.StartLoop(0.05, 1, WaitPickUp)
  end
end

function MapMonsterLockManager.StopMonsterMonitoring()
  this.targetMonsterType = TaskTargetMonsterType.None
  this.startCircle = false
  this.RemoveSockTragte()
end

function MapMonsterLockManager.TaskStateStopCircle(id, taskId)
  if MapMonsterConfigInfo.GetCurMonsterSeekInfo() ~= nil and this.startCircle and tonumber(MapMonsterConfigInfo.GetCurMonsterSeekInfo().taskId) == tonumber(taskId) and TaskData.GetTaskById(tonumber(taskId)).state ~= TaskStateType.Accept then
    this.OnSetTargetMonsterType()
    RoleManager.me:StopMove()
    if QiJiHelperData.isAutoFight == false then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end
end

function MapMonsterLockManager.OnSetTargetMonsterType()
  this.targetMonsterType = TaskTargetMonsterType.None
  this.startCircle = false
  this.RemoveTime()
  this.TaskPathStop()
end

function MapMonsterLockManager.Update()
  if this.index > 5 then
    this.StartLockMonster()
    this.MonsterMonitoring()
    this.PauseTaskGo()
    this.index = 0
  end
  this.index = this.index + 1
end

function MapMonsterLockManager.MonsterMonitoring()
  if RoleManager.me == nil or not this.startCircle then
    return
  end
  if TranScriptData.InTranscript then
    this.OnSetTargetMonsterType()
    PathFinderManager.CloseFlyShoeUI()
    return
  end
  local sockTragetMonster = MapMonster.GetMonster()
  if this.pathfindingState == PathfindingState.taskNone then
    return
  end
  if this.pathfindingState == PathfindingState.taskAutoStart then
    if sockTragetMonster then
      if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
        this.pathfindingState = PathfindingState.taskInterruption
      end
    elseif TaskManager.NeedPickUp() then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      this.pathfindingState = PathfindingState.taskInterruption
    end
  end
  if this.pathfindingState == PathfindingState.taskOnClickStart and sockTragetMonster and QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    this.pathfindingState = PathfindingState.taskInterruption
  end
  if this.pathfindingState == PathfindingState.taskInterruption then
    if not sockTragetMonster then
      if not TaskManager.NeedPickUp() then
        if RoleManager.me and RoleManager.me:CanMove() then
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
          this.FindMonserLine()
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
  if this.pathfindingState == PathfindingState.taskDrop and not sockTragetMonster then
    this.pathfindingState = PathfindingState.taskPickUp
  end
  if this.pathfindingState == PathfindingState.taskFinish then
    if not sockTragetMonster then
      if not TaskManager.NeedPickUp() then
        if RoleManager.me and RoleManager.me:CanMove() then
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
          this.FindMonserLine()
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
  if this.pathfindingState == PathfindingState.taskStop then
    return
  end
end

function MapMonsterLockManager.StartLockMonster()
  if QiJiHelperData.isAutoFight == true and MapMonsterConfigInfo.IsNeedFind() and this.startCircle == false then
    LookForTask.StopMonsterMonitoring()
    this.AddSockTarget()
    this.startCircle = true
    if MapMonster.FindMonsterData() ~= nil then
      this.FindMonsterGo(MapMonster.FindMonsterData())
    end
  end
end

function MapMonsterLockManager.StartCircleMonster()
  if this.startCircle == false and RoleManager.me and MapMonsterConfigInfo.NeedFind() then
    LookForTask.StopMonsterMonitoring()
    this.AddSockTarget()
    this.startCircle = true
    this.SetMonserPosition()
  end
end

function MapMonsterLockManager.SetMonserPosition()
  MapMonsterConfigInfo.InitPosIndex(RoleManager.me.cellPos)
  this.pathfindingState = PathfindingState.taskFinish
end

function MapMonsterLockManager.FindMonserLine()
  if this.pathfindingState == PathfindingState.taskFinish then
    MapMonsterConfigInfo.SetPosIndex()
  end
  local groupId, position = MapMonsterConfigInfo.GetPosition()
  if groupId == nil or position == 0 then
    return
  end
  position = PathFinderManager.GetCalcPosData(position)
  this.pathfindingState = PathfindingState.taskAutoStart
  PathFinderManager.pathFinding.Reset()
  PathFinderManager.MoveToPos(groupId, position, nil, nil, {stopAutoFight = true}, Purpose.ForTask, function()
    if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
      this.pathfindingState = PathfindingState.taskFinish
    end
  end, 2, false)
end

function MapMonsterLockManager.FindMonsterGo(monsterData)
  this.pathfindingState = PathfindingState.taskAutoStart
  local sockTragetMonster = MapMonster.GetMonster()
  if sockTragetMonster then
    MapMonsterConfigInfo.InitPosIndex(sockTragetMonster.cellPos)
    this.pathfindingState = PathfindingState.taskFinish
    return
  end
  MapMonsterConfigInfo.InitPosIndex(Vector2(monsterData.x, monsterData.y))
  PathFinderManager.pathFinding.Reset()
  PathFinderManager.MoveToPos(SceneData.groupId, Vector2(monsterData.x, monsterData.y), nil, nil, {stopAutoFight = true}, Purpose.ForTask, function()
    if QiJiHelperData.isAutoFight == false and RoleManager.me and RoleManager.me.hp > 0 then
      this.pathfindingState = PathfindingState.taskFinish
    end
  end, 2, false)
end

function MapMonsterLockManager.RemoveTime()
  if this.countDownTimer then
    Timer.Stop(this.countDownTimer)
    this.countDownTimer = nil
  end
end

MapMonsterLockManager.Init()
