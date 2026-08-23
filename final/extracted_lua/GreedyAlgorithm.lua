LinedTye = {
  TransType = enum(0),
  PathType = enum()
}
GreedyAlgorithm = {}
local this = GreedyAlgorithm

local function copy(list)
  local newList = {}
  for k, v in pairs(list) do
    newList[k] = v
  end
  return newList
end

local function isContain(list, value)
  local isContain = false
  for k, v in pairs(list) do
    if v == value then
      isContain = true
    end
  end
  return isContain
end

this.startIndex = nil
this.endIndex = nil

function GreedyAlgorithm.FindStartWay(startIndex, endIndex)
  this.startIndex = startIndex
  this.endIndex = endIndex
  this.init()
end

this.curAllPathList = {}
this.waitCheckList = {}
this.checkList = {}
this.minValue = nil
this.minPathList = nil

function GreedyAlgorithm.init()
  this.curAllPathList = {}
  this.waitCheckList = {}
  this.checkList = {}
  this.minValue = nil
  this.minPathList = nil
end

function GreedyAlgorithm.getValue(index1, index2)
  local line
  for k, v in pairs(this.lineList) do
    line = v.line
    if line[1] == index1 and line[2] == index2 or line[1] == index2 and line[2] == index1 then
      return v.value
    end
  end
  return nil
end

function GreedyAlgorithm.printPathList(pathList)
  if pathList == nil then
    return
  end
  for k, v in pairs(pathList) do
    if this.selectShortLine ~= nil then
      if v.value < this.selectShortLine.value then
        this.selectShortLine = v
      end
    else
      this.selectShortLine = v
    end
  end
end

function GreedyAlgorithm.getShortPath()
  this.init()
  this.waitCheckList = {
    this.startIndex
  }
  local index = this.getNextCheckPoint()
  while true do
    this.updateNewPath(index)
    this.checkList[#this.checkList + 1] = index
    index = this.getNextCheckPoint()
    if not index then
      break
    end
  end
  this.printPathList(this.curAllPathList)
end

function GreedyAlgorithm.getPathValue(path)
  local sum = 0
  for i = 1, #path - 1 do
    sum = sum + this.getValue(path[i], path[i + 1])
  end
  return sum
end

function GreedyAlgorithm.getAllCurNextPoint(curPoint)
  local pointList = {}
  local p1, p2
  for k, v in pairs(this.lineList) do
    p1 = v.line[1]
    p2 = v.line[2]
    if p1 == curPoint and not isContain(pointList, p2) then
      pointList[#pointList + 1] = p2
    end
    if p2 == curPoint and not isContain(pointList, p1) then
      pointList[#pointList + 1] = p1
    end
  end
  for k, v in pairs(this.checkList) do
    for k2, v2 in pairs(pointList) do
      if v == v2 then
        table.remove(pointList, k2)
        break
      end
    end
  end
  return pointList
end

function GreedyAlgorithm.updateNewPath(curPoint)
  if #this.curAllPathList == 0 then
    local list = this.getAllCurNextPoint(curPoint)
    for k, v in pairs(list) do
      local path = {curPoint, v}
      this.curAllPathList[#this.curAllPathList + 1] = {
        path = path,
        value = this.getPathValue(path)
      }
    end
    this.addToWaitCheckList(list)
  else
    local newList = {}
    local count = #this.curAllPathList
    for i = 1, count do
      for k, v in pairs(this.curAllPathList) do
        if v.path[#v.path] == curPoint then
          local list = this.getAllCurNextPoint(curPoint)
          this.addToWaitCheckList(list)
          for _, v2 in pairs(list) do
            local oneList = copy(v.path)
            oneList[#oneList + 1] = v2
            newList[#newList + 1] = {
              path = oneList,
              value = this.getPathValue(oneList)
            }
          end
          table.remove(this.curAllPathList, k)
          break
        end
      end
    end
    for k, v in pairs(newList) do
      this.updateCurAllPathList(v)
    end
  end
end

function GreedyAlgorithm.updateCurAllPathList(pathList)
  local function isSameEndPath(pathList1, pathList2)
    return pathList1[1] == pathList2[1] and pathList1[#pathList1] == pathList2[#pathList2]
  end
  
  local function checkAllPathList()
    for k, v in pairs(this.curAllPathList) do
      if v.path[#v.path] == this.endIndex then
        if not this.minValue then
          this.minValue = v.value
          this.minPathList = v
        elseif this.minValue > v.value then
          this.minValue = v.value
          this.minPathList = v
        end
      end
    end
    if this.minValue then
      local count = #this.curAllPathList
      for i = 1, count do
        for k, v in pairs(this.curAllPathList) do
          if v.value > this.minValue then
            table.remove(this.curAllPathList, k)
            break
          end
        end
      end
    end
  end
  
  for k, v in pairs(this.curAllPathList) do
    local path = v.path
    local path2 = pathList.path
    if path[1] == path2[1] and path[#path] == path2[#path2] then
      if v.value > pathList.value then
        table.remove(this.curAllPathList, k)
        this.curAllPathList[#this.curAllPathList + 1] = pathList
        checkAllPathList()
        return
      elseif v.value < pathList.value then
        return
      end
    end
  end
  this.curAllPathList[#this.curAllPathList + 1] = pathList
  checkAllPathList()
end

function GreedyAlgorithm.getNextCheckPoint()
  if #this.waitCheckList == 0 then
    return nil
  end
  local point = this.waitCheckList[1]
  table.remove(this.waitCheckList, 1)
  return point
end

function GreedyAlgorithm.addToWaitCheckList(list)
  for k, v in pairs(list) do
    if not isContain(this.waitCheckList, v) and not isContain(this.checkList, v) and v ~= this.endIndex then
      this.waitCheckList[#this.waitCheckList + 1] = v
    end
  end
end

this.lineList = {}
this.allTransSide = {}
this.allTransDot = {}
this.allShortLine = {}
this.selectShortLine = nil

function GreedyAlgorithm.initConfig()
  this.lineList = {}
  this.allTransSide = {}
  this.allTransDot = {}
  this.selectShortLine = nil
  local mapTbls = ConfigManager.GetConfigTable("map_transfer_phase")
  for i, v in pairs(mapTbls) do
    if v.startSerialNumber ~= 0 and v.endSerialNumber ~= 0 then
      this.AddTransTo(v)
      this.AddSceneTransDot(v)
      this.lineList[i] = {
        line = {
          v.startSerialNumber,
          v.endSerialNumber
        },
        value = 1
      }
    end
  end
end

this.allTransSide = {}

function GreedyAlgorithm.AddTransTo(transItem)
  local startTranPos = this.AnalysePosData(transItem.curMapTrans)
  local endTranPos = this.AnalysePosData(transItem.targetMapTrans)
  if this.allTransSide[transItem.curIndex] == nil then
    this.allTransSide[transItem.curIndex] = {}
    this.allTransSide[transItem.curIndex] = {
      curIndex = transItem.curIndex,
      startSerialNumber = transItem.startSerialNumber,
      curMapId = transItem.curMapId,
      curMapTransPos = startTranPos,
      transferId = transItem.transferId,
      limitLevel = transItem.limitLevel,
      endSerialNumber = transItem.endSerialNumber,
      targetMapId = transItem.targetMapId,
      targetPos = endTranPos,
      isLinedType = transItem.isLinedType
    }
  else
    this.allTransSide[transItem.curIndex] = {
      curIndex = transItem.curIndex,
      startSerialNumber = transItem.startSerialNumber,
      curMapId = transItem.curMapId,
      curMapTransPos = startTranPos,
      transferId = transItem.transferId,
      limitLevel = transItem.limitLevel,
      endSerialNumber = transItem.endSerialNumber,
      targetMapId = transItem.targetMapId,
      targetPos = endTranPos,
      isLinedType = transItem.isLinedType
    }
  end
end

function GreedyAlgorithm.AnalysePosData(pos)
  local posTable = {}
  local posList = string.split(pos, "#")
  local posArray, posTableSingle
  for k, v in pairs(posList) do
    posArray = string.split(v, "_")
    posTableSingle = {
      x = tonumber(posArray[1]),
      y = tonumber(posArray[2])
    }
    table.insert(posTable, posTableSingle)
  end
  return posTable
end

function GreedyAlgorithm.AddSceneTransDot(transItem)
  local startTranPos, endTranPos, node
  if this.allTransDot[transItem.curMapId] then
    local isFind = false
    for k, v in pairs(this.allTransDot[transItem.curMapId]) do
      if v.startSerialNumber == transItem.startSerialNumber then
        isFind = true
      end
    end
    if isFind == false then
      startTranPos = this.AnalysePosData(transItem.curMapTrans)
      endTranPos = this.AnalysePosData(transItem.targetMapTrans)
      node = {
        startSerialNumber = transItem.startSerialNumber,
        curMapId = transItem.curMapId,
        curMapTransPos = startTranPos,
        transferId = transItem.transferId,
        limitLevel = transItem.limitLevel,
        endSerialNumber = transItem.endSerialNumber,
        targetMapId = transItem.targetMapId,
        targetPos = endTranPos,
        isLinedType = transItem.isLinedType
      }
      table.insert(this.allTransDot[transItem.curMapId], node)
    end
  else
    this.allTransDot[transItem.curMapId] = {}
    startTranPos = this.AnalysePosData(transItem.curMapTrans)
    endTranPos = this.AnalysePosData(transItem.targetMapTrans)
    node = {
      startSerialNumber = transItem.startSerialNumber,
      curMapId = transItem.curMapId,
      curMapTransPos = startTranPos,
      transferId = transItem.transferId,
      limitLevel = transItem.limitLevel,
      endSerialNumber = transItem.endSerialNumber,
      targetMapId = transItem.targetMapId,
      targetPos = endTranPos,
      isLinedType = transItem.isLinedType
    }
    table.insert(this.allTransDot[transItem.curMapId], node)
  end
end

function GreedyAlgorithm.FindSortWay(startScene, endScene, endPos, same)
  this.selectShortLine = nil
  local isFind = false
  local path = {}
  this.allSortLine = {}
  local startTransPos
  local isStartPosFind = false
  local endTransPos
  if same then
    isStartPosFind, startTransPos = this.FindStartRoot(startScene)
    if isStartPosFind == false then
      return isFind, path
    end
    endTransPos = this.FindEndTransId(endScene, endPos)
  else
    startTransPos = this.allTransDot[startScene]
    endTransPos = this.allTransDot[endScene]
  end
  if string.isNullOrEmpty(startTransPos) then
    return
  end
  if string.isNullOrEmpty(endTransPos) then
    return
  end
  local startNode, endNode
  for i, v in pairs(startTransPos) do
    startNode = v.startSerialNumber
    for l, t in pairs(endTransPos) do
      endNode = t.startSerialNumber
      this.StratFindWay(startNode, endNode)
    end
  end
  local notIndex, nodData
  if this.selectShortLine ~= nil then
    isFind = true
    for i = 2, #this.selectShortLine.path do
      notIndex = tonumber(this.selectShortLine.path[i - 1] .. this.selectShortLine.path[i])
      if this.allTransSide[notIndex] ~= nil then
        if i % 2 ~= 0 then
          if this.allTransSide[notIndex].curMapId == this.allTransSide[notIndex].targetMapId and this.allTransSide[notIndex].isLinedType == LinedTye.TransType then
            nodData = this.allTransSide[notIndex]
            if nodData ~= nil then
              table.insert(path, nodData)
            end
          end
        else
          nodData = this.allTransSide[notIndex]
          if nodData ~= nil then
            table.insert(path, nodData)
          end
        end
      end
    end
    return isFind, path
  else
    return isFind, path
  end
end

function GreedyAlgorithm.StratFindWay(startPos, endPos)
  this.init()
  this.FindStartWay(startPos, endPos)
  this.getShortPath()
end

function GreedyAlgorithm.FindStartRoot(sceneId)
  local allStartRoot = this.allTransDot[sceneId]
  local isFind = false
  local isPathFindRoot = {}
  if allStartRoot == nil then
    return false
  end
  local startTranPos
  for k, v in pairs(allStartRoot) do
    startTranPos = Vector2(v.curMapTransPos[1].x, v.curMapTransPos[1].y)
    local reachable, path, bestGuidePath = Scene.SearchTilePath(RoleManager.me.cellPos, startTranPos, 0)
    if not reachable or path == nil then
    else
      local root = v
      isFind = true
      table.insert(isPathFindRoot, root)
    end
  end
  return isFind, isPathFindRoot
end

function GreedyAlgorithm.FindEndTransId(endScene, endPos)
  local endTransPos = this.allTransDot[endScene]
  local arriveEndpos = {}
  if endTransPos == nil and #endTransPos < 1 then
    return arriveEndpos
  end
  for k, v in pairs(endTransPos) do
    local endpos = Vector2(v.curMapTransPos[1].x, v.curMapTransPos[1].y)
    local reachable, path, bestGuidePath = Scene.SearchTilePath(endPos, endpos, 0)
    if reachable then
      table.insert(arriveEndpos, v)
    end
  end
  return arriveEndpos
end
