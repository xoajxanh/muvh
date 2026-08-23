PosMove = {}
local this = PosMove

function PosMove.Init()
end

function PosMove.ResetData()
  this.groupId = nil
  this.pos = nil
  this.transferId = nil
  this.param = nil
  this.purpose = Purpose.None
  this.OnArrive = nil
  this.range = nil
  this.isStopTask = nil
  this.curFinder = {}
end

function PosMove.MoveToPos(groupId, pos, transferId, param, purpose, OnArrive, range, isStopTask)
  local isFindPath = PathFinderManager.TranscriptPathTo()
  if isFindPath == false then
    return
  end
  if QiJiHelperData.isAutoFight then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  if param ~= nil and param.stopAutoFight then
    EventManager.Dispatch(Event.SetFakeAutoFightBtn, true)
  end
  if isStopTask == nil or isStopTask then
    EventManager.Dispatch(Event.Task_PathStop)
  end
  if RoleManager.me and RoleManager.me.hp > 0 then
    if RoleManager.me:CanMove() then
      this.ResetData()
      this.groupId = groupId
      this.pos = pos
      this.transferId = transferId
      this.param = param
      this.purpose = purpose == nil and Purpose.None or purpose
      this.OnArrive = OnArrive
      this.range = range
      PathFinderManager.pathFinding.SetMoveTarget(this.groupId, this.pos, transferId, nil, this.OnArriveTarget, range, param, this.purpose)
    else
      this.curFinder = {}
      this.curFinder.groupId = groupId
      this.curFinder.pos = pos
      this.curFinder.transferId = transferId
      this.curFinder.param = param
      this.curFinder.purpose = purpose == nil and Purpose.None or purpose
      this.curFinder.OnArrive = OnArrive
      this.curFinder.range = range
      this.curFinder.isStopTask = isStopTask
    end
  end
end

function PosMove.MoveToPosHangUpAutoFight(groupId, pos)
  local isFindPath = PathFinderManager.TranscriptPathTo()
  if isFindPath == false then
    return
  end
  EventManager.Dispatch(Event.Task_PathStop)
  if RoleManager.me and RoleManager.me.hp > 0 then
    if RoleManager.me:CanMove() then
      this.ResetData()
      this.groupId = groupId
      this.pos = pos
      this.purpose = Purpose.None
      PathFinderManager.pathFinding.SetMoveTarget(this.groupId, this.pos)
    else
      this.curFinder = {}
      this.curFinder.groupId = groupId
      this.curFinder.pos = pos
      this.curFinder.purpose = Purpose.None
    end
  end
  RoleManager.me:MoveCloseAutoFight()
end

function PosMove.Update()
  if this.curFinder ~= nil and this.curFinder.groupId ~= nil and RoleManager.me and RoleManager.me.hp > 0 and RoleManager.me:CanMove() then
    this.MoveToPos(this.curFinder.groupId, this.curFinder.pos, this.curFinder.transferId, this.curFinder.param, this.curFinder.purpose, this.curFinder.OnArrive, this.curFinder.range, this.curFinder.isStopTask)
  end
end

function PosMove.OnArriveTarget()
  if this.purpose == Purpose.None then
    this.OnArriveToNone()
  end
  if this.purpose == Purpose.ClickNpc then
    this.OnArriveToNpc()
  end
  if this.purpose == Purpose.ForTask then
    this.OnArriveToTask()
  end
end

function PosMove.OnArriveToNone()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function PosMove.OnArriveToNpc()
  PathFinderManager.OpenNpcPanelParam(this.param)
  if this.OnArrive ~= nil then
    this.OnArrive(this.param.npcId)
  end
  this.ResetData()
end

function PosMove.OnArriveToTask()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function PosMove.OnFailArriveTarget()
  if this.groupId == nil or this.pos ~= nil then
  end
end

PosMove.Init()
