JumpMapToPos = {}
local this = JumpMapToPos

function JumpMapToPos.Init()
end

function JumpMapToPos.ResetData()
  this.groupId = nil
  this.pos = nil
  this.transferId = nil
  this.line = nil
  this.param = nil
  this.purpose = Purpose.None
  this.OnArrive = nil
  this.range = nil
  this.isStopTask = nil
  this.curFinder = {}
end

function JumpMapToPos.MapMoveToPos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  local isFindPath = PathFinderManager.TranscriptPathTo()
  if isFindPath == false then
    return
  end
  if QiJiHelperData.isAutoFight then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  if isStopTask == nil or isStopTask then
    EventManager.Dispatch(Event.Task_PathStop)
  end
  local isCurLine = line ~= nil and SceneData.line ~= line and PathFinderManager.SwitchLineMove.JudgeHaveMapLine(SceneData.groupId, line)
  if SceneData.groupId ~= groupId or isCurLine then
    this.JumpToMap(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
    return
  end
  if RoleManager.me and RoleManager.me.hp > 0 then
    if RoleManager.me:CanMove() then
      this.ResetData()
      this.groupId = groupId
      this.pos = pos
      this.transferId = transferId
      this.line = line
      this.param = param
      this.purpose = purpose == nil and Purpose.None or purpose
      this.OnArrive = OnArrive
      this.range = range
      this.isStopTask = isStopTask
      PathFinderManager.pathFinding.SetMoveTarget(this.groupId, this.pos, transferId, line, this.OnArriveTarget, range, param, this.purpose)
    else
      this.curFinder = {}
      this.curFinder.groupId = groupId
      this.curFinder.pos = pos
      this.curFinder.transferId = transferId
      this.curFinder.line = line
      this.curFinder.param = param
      this.curFinder.purpose = purpose == nil and Purpose.None or purpose
      this.curFinder.OnArrive = OnArrive
      this.curFinder.range = range
      this.curFinder.isStopTask = isStopTask
    end
  end
end

function JumpMapToPos.JumpToMap(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  local curTransferId = PathFinderManager.GetTransIdByGroupId(groupId)
  PathFinderManager.FlyTransferScene(curTransferId, line, nil, nil, function()
    this.MapMoveToPos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  end)
end

function JumpMapToPos.Update()
  if this.curFinder ~= nil and this.curFinder.groupId ~= nil and RoleManager.me and RoleManager.me.hp > 0 and RoleManager.me:CanMove() then
    this.MapMoveToPos(this.curFinder.groupId, this.curFinder.pos, this.curFinder.transferId, this.curFinder.line, this.curFinder.param, this.curFinder.purpose, this.curFinder.OnArrive, this.curFinder.range, this.curFinder.isStopTask)
  end
end

function JumpMapToPos.OnArriveTarget()
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

function JumpMapToPos.OnArriveToNone()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function JumpMapToPos.OnArriveToNpc()
  PathFinderManager.OpenNpcPanelParam(this.param)
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function JumpMapToPos.OnArriveToTask()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function JumpMapToPos.OnFailArriveTarget()
  if this.groupId == nil or this.pos ~= nil then
  end
end

JumpMapToPos.Init()
