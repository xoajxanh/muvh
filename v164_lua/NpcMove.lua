NpcMove = {}
local this = NpcMove

function NpcMove.Init()
end

function NpcMove.ResetData()
  this.npcId = nil
  this.groupId = nil
  this.pos = nil
  this.transferId = nil
  this.param = nil
  this.line = nil
  this.purpose = Purpose.None
  this.OnArrive = nil
  this.range = nil
  this.isStopTask = nil
  this.curFinder = {}
end

function NpcMove.MoveToNpc(param, transferId, purpose, OnArrive, range, isStopTask, isForcePath)
  if isForcePath == nil then
    local isFindPath = PathFinderManager.TranscriptPathTo()
    if isFindPath == false then
      return
    end
  end
  if QiJiHelperData.isAutoFight then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  if isStopTask == nil or isStopTask then
    EventManager.Dispatch(Event.Task_PathStop)
  end
  if RoleManager.me and RoleManager.me.hp > 0 then
    if RoleManager.me:CanMove() then
      this.ResetData()
      local npcTbl = ClientTable.cfg_Npc_npcManager:TryGetValue(param.npcId, "npcId")
      local tempPoint = PathFinderManager.GetCalcPosDataWithSymbol(npcTbl.position, "#")
      this.npcId = param.npcId
      this.groupId = npcTbl.groupId
      this.pos = tempPoint
      this.transferId = transferId
      this.param = param
      this.line = nil
      this.purpose = purpose == nil and Purpose.None or purpose
      this.OnArrive = OnArrive
      this.range = range
      PathFinderManager.pathFinding.SetMoveTarget(this.groupId, tempPoint, transferId, nil, this.OnArriveTarget, range, param, this.purpose)
    else
      this.curFinder = {}
      this.curFinder.param = param
      this.curFinder.transferId = transferId
      this.curFinder.purpose = purpose == nil and Purpose.None or purpose
      this.curFinder.OnArrive = OnArrive
      this.curFinder.range = range
      this.curFinder.isStopTask = isStopTask
    end
  end
end

function NpcMove.Update()
  if this.curFinder ~= nil and this.curFinder.param ~= nil and RoleManager.me and RoleManager.me.hp > 0 and RoleManager.me:CanMove() then
    this.MoveToNpc(this.curFinder.param, this.curFinder.transferId, this.curFinder.purpose, this.curFinder.OnArrive, this.curFinder.range, this.curFinder.isStopTask)
  end
end

function NpcMove.OnArriveTarget()
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

function NpcMove.OnArriveToNone()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function NpcMove.OnArriveToNpc()
  PathFinderManager.OpenNpcPanelParam(this.param)
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function NpcMove.OnArriveToTask()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function NpcMove.OnFailArriveTarget()
  if this.groupId == nil or this.pos ~= nil then
  end
end

NpcMove.Init()
