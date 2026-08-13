LintType = {
  None = enum(0),
  PathLine = enum(),
  MapClickSwitch = enum(),
  MovePosLint = enum()
}
SwitchLineMove = {}
local this = SwitchLineMove

function SwitchLineMove.Init()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
end

function SwitchLineMove.RegistEvent()
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.SwitchPointLineFinish, nil, 2)
end

function SwitchLineMove.RegistMessages()
end

function SwitchLineMove.ResetData()
  this.groupId = nil
  this.pos = nil
  this.transferId = nil
  this.param = nil
  this.purpose = Purpose.None
  this.OnArrive = nil
  this.range = nil
  this.isStopTask = nil
  this.curFinder = {}
  this.switchLineType = LintType.None
  this.curSwitchLine = nil
end

function SwitchLineMove.MoveToLinePos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  this.curSwitchLine = line
  if SceneData.line == line or not this.JudgeHaveMapLine(SceneData.groupId, line) then
    SwitchLineMove.MoveLinePos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  else
    this.DifferentSplitPathfinding(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  end
end

function SwitchLineMove.ChatMoveToLinePos(mapId, pos)
  local configMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  if configMap.line < 0 then
    local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("MapDesc_1")
    FloatingWordUtility.QuickMsg(titleStrCon)
    return
  end
  EventManager.Dispatch(Event.Task_PathStop)
  if SceneData.line == configMap.cline then
    PathFinderManager.MoveToLinePos(configMap.groupId, pos)
  else
    this.DifferentSplitPathfinding(configMap.groupId, pos, nil, configMap.cline)
  end
end

function SwitchLineMove.MoveLinePos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
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

function SwitchLineMove.JudgeHaveMapLine(groupId, line)
  return true
end

function SwitchLineMove.JudgeLine(mapId)
  local configMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  if configMap.line < 0 then
    return false
  else
    return true
  end
end

function SwitchLineMove.ChatMoveToLinePos(mapId, pos)
  local configMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  if configMap.line < 0 then
    local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("MapDesc_1")
    FloatingWordUtility.QuickMsg(titleStrCon)
    return
  end
  EventManager.Dispatch(Event.Task_PathStop)
  if SceneData.line == configMap.cline then
    SwitchLineMove.MoveLinePos(configMap.groupId, pos)
  else
    PathFinderManager.DifferentSplitPathfinding(configMap.groupId, pos, nil, configMap.cline)
  end
end

function SwitchLineMove.DifferentSplitPathfinding(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  this.SwitchLine(LintType.PathLine, line)
  this.ResetData()
  this.curSwitchLine = line
  this.curFinder.groupId = groupId
  this.curFinder.pos = pos
  this.curFinder.transferId = transferId
  this.curFinder.param = param
  this.curFinder.purpose = purpose == nil and Purpose.None or purpose
  this.curFinder.OnArrive = OnArrive
  this.curFinder.range = range
end

function SwitchLineMove.SwitchLine(type, line)
  local transferId = PathFinderManager.GetTransIdByGroupId()
  if string.isNullOrEmpty(transferId) then
  end
  this.ResetData()
  local mapData = {mapId = transferId, line = line}
  SwitchLineMove.SwitchPointLine(type, SceneData.line, line)
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
end

function SwitchLineMove.SwitchPointLine(type, beforeLine, afterLine)
  this.switchLineType = type
  this.FlyJudge(Purpose.None)
end

function SwitchLineMove.FlyJudge(purpose)
  if purpose ~= Purpose.ForTask then
    EventManager.Dispatch(Event.Task_PathStop)
  end
  PathFinderManager.CloseFlyShoeUI()
end

function SwitchLineMove.SwitchPointLineFinish()
  if this.switchLineType == LintType.None then
    this.RestoreLine()
  end
  if this.switchLineType == LintType.PathLine then
    this.MoveLinePos(this.curFinder.groupId, this.curFinder.pos, this.curFinder.transferId, this.curFinder.line, this.curFinder.param, this.curFinder.purpose, this.curFinder.OnArrive, this.curFinder.range, this.curFinder.isStopTask)
  end
  if this.switchLineType == LintType.MapClickSwitch then
    this.RestoreLine()
  end
  if this.switchLineType == LintType.MovePosLint then
    this.OnArriveTarget()
  end
end

function SwitchLineMove.RestoreLine()
end

function SwitchLineMove.Update()
  if this.curFinder ~= nil and this.curFinder.groupId ~= nil and RoleManager.me and RoleManager.me.hp > 0 and RoleManager.me:CanMove() then
    this.MoveLinePos(this.curFinder.groupId, this.curFinder.pos, this.curFinder.transferId, this.curFinder.line, this.curFinder.param, this.curFinder.purpose, this.curFinder.OnArrive, this.curFinder.range, this.curFinder.isStopTask)
  end
end

function SwitchLineMove.OnArriveTarget()
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

function SwitchLineMove.OnLineMoveArrive()
  if this.curSwitchLine ~= nil and this.curSwitchLine ~= SceneData.line and this.JudgeHaveMapLine(SceneData.groupId, this.curSwitchLine) then
    this.SwitchLine(LintType.MovePosLint, this.curSwitchLine)
  else
    this.OnArriveTarget()
  end
end

function SwitchLineMove.OnArriveToNone()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function SwitchLineMove.OnArriveToNpc()
  PathFinderManager.OpenNpcPanelParam(this.param)
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function SwitchLineMove.OnArriveToTask()
  if this.OnArrive ~= nil then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function SwitchLineMove.OnFailArriveTarget()
  if this.groupId == nil or this.pos ~= nil then
  end
end

SwitchLineMove.Init()
