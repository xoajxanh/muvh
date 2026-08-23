require("GamePlay/Task/GreedyAlgorithm")
PathFinding = {}
local this = PathFinding

function PathFinding.Reset()
  this.targetSceneId = 0
  this.line = nil
  this.targetPos = 0
  this.isFind = false
  this.path = nil
  this.range = 1
  this.onArrive = nil
  this.param = nil
  this.purpose = nil
end

function PathFinding.InitTransData()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
  this.Reset()
  GreedyAlgorithm.initConfig()
end

function PathFinding.RegistEvent()
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnSceneStateChange, nil, 2)
  this.eventContainer:Regist(Event.Role_ChangePos, this.OnSceneStateChange, nil, 2)
end

function PathFinding.RegistMessages()
end

function PathFinding.SetMoveTarget(mapId, targetPos, transferId, line, onArrive, range, param, purpose)
  if not (mapId or targetPos) or Scene.tileData == nil then
    return
  end
  if this.targetSceneId == mapId and this.targetPos == targetPos then
    return
  end
  this.Reset()
  this.targetSceneId = mapId
  this.line = line
  this.targetPos = targetPos
  this.transferId = transferId
  this.range = range ~= nil and range or 1
  this.onArrive = onArrive
  this.param = param
  this.purpose = purpose
  this.MoveToMapTarget(mapId, targetPos)
end

function PathFinding.MoveToMapTarget(mapId, position)
  if SceneData.groupId == mapId then
    local reachable, path, bestGuidePath = Scene.SearchTilePath(RoleManager.me.cellPos, position, 0)
    if not reachable and path == nil then
      this.FindPathTrans(mapId, position, true)
    else
      this.MoveNearPosition(mapId, position)
    end
  else
    this.FindPathTrans(mapId, position, false)
  end
end

function PathFinding.FindPathTrans(mapId, position, same)
  if this.isFind == false then
    this.isFind, this.path = GreedyAlgorithm.FindSortWay(SceneData.groupId, mapId, position, same)
  end
  if this.isFind == false or this.path == nil then
    this.OnFailArriveTarget()
    PathFinderManager.ResetData()
    return
  end
  this.MoveToLine()
end

function PathFinding.MoveToLine(mapId)
  if #this.path > 0 and this.path[1].curMapId ~= nil then
    local isFindScene = false
    for k, v in pairs(this.path) do
      if v.curMapId == SceneData.groupId then
        isFindScene = true
        this.MoveExactPosition(v.curMapId, Vector3(v.curMapTransPos[1].x, 0, v.curMapTransPos[1].y))
        table.remove(this.path, 1)
      end
    end
    if isFindScene == false then
      this.MoveNearPosition(this.targetSceneId, this.targetPos)
    end
  else
    this.MoveNearPosition(this.targetSceneId, this.targetPos)
  end
end

function PathFinding.MoveNearPosition(mapId, position)
  if SceneData.groupId ~= mapId then
    return
  end
  if this.IsReachPoint(position, this.range) then
    this.OnReachTarget(ENavigateStatus.Arrived)
    return
  end
  RoleManager.me:MoveTo(Scene.GetCellByPos(Vector3(position.x, 0, position.y)), 0, this.OnReachTarget)
  PathFinderManager.PathOnOpenFly(this.transferId, this.line, this.param, this.purpose, this.onArrive)
end

function PathFinding.MoveExactPosition(mapId, position)
  RoleManager.me:MoveTo(Scene.GetCellByPos(position), 0, this.OnArriveTransferPhase)
  PathFinderManager.PathOnOpenFly(this.transferId, this.line, this.param, this.purpose, this.onArrive)
end

function PathFinding.OnSceneStateChange(id, data)
  if this.isFind then
    this.MoveToLine()
  else
    return
  end
end

function PathFinding.OnArriveTransferPhase(moveRes)
  this.CloseFlyShoeUI()
end

function PathFinding.OnReachTarget(moveRes)
  if moveRes == ENavigateStatus.Interrupted then
    this.OnInterruptArriveTarget()
  end
  if moveRes == ENavigateStatus.Failed then
    this.OnFailArriveTarget()
  end
  if moveRes == ENavigateStatus.Arrived or moveRes == ENavigateStatus.EndBlockBreak or moveRes == ENavigateStatus.BlockBreak then
    this.OnArriveTarget()
  end
end

function PathFinding.OnInterruptArriveTarget()
  this.CloseFlyShoeUI()
end

function PathFinding.OnFailArriveTarget()
  this.CloseFlyShoeUI()
end

function PathFinding.OnArriveTarget()
  if SceneData.groupId ~= this.targetSceneId then
    return
  end
  if this.onArrive then
    this.onArrive()
  end
  this.CloseFlyShoeUI()
  this.Reset()
end

function PathFinding.CloseFlyShoeUI()
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
end

function PathFinding.FindNearByWalkPoint(posData, range)
  range = range == nil and 1 or range
  if not posData or Scene.tileData == nil then
    return nil
  end
  for i = -range, range do
    for j = -range, range do
      if not Scene.tileData:IsBlock(posData.x + i, posData.y + j) then
        local newPosDaata = {
          x = posData.x + i,
          y = posData.y + j
        }
        return newPosDaata
      end
    end
  end
  return nil
end

function PathFinding.FindRandomNearPoint(posData, range)
  range = range == nil and 1 or range
  if not posData or Scene.tileData == nil then
    return nil
  end
  local randomX = Mathf.Random(-range, range)
  local randomY = Mathf.Random(-range, range)
  local newPosDaata = {
    x = posData.x + randomX,
    y = posData.y + randomY
  }
  return newPosDaata
end

function PathFinding.IsReachPoint(posData, range)
  range = range == nil and 1 or range
  return this.Compare(posData.x, RoleManager.me.cellPos.x, range) and this.Compare(posData.y, RoleManager.me.cellPos.y, range)
end

function PathFinding.Compare(a, b, range)
  range = range == nil and 1 or range
  return range >= Mathf.Abs(a - b)
end

function PathFinding.IsDetectionRangePoint(centralPoint, checkPoint, range)
  range = range == nil and 1 or range
  return this.Compare(centralPoint.x, checkPoint.x, range) and this.Compare(centralPoint.y, checkPoint.y, range)
end

function PathFinding.GetDistance(point, targetPoint)
  if point == nil or targetPoint == nil then
    return 0
  end
  local distance = Mathf.Sqrt((targetPoint.y - point.y) ^ 2 + (targetPoint.x - point.x) ^ 2)
  distance = Mathf.Abs(distance)
  distance = Mathf.Ceil(distance)
  return distance
end
