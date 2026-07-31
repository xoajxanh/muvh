require("GamePlay/KdTree/KdTreeNode")
require("GameConst/DivisionTypeEnum")
KDTree = class()
local this = KDTree

function KDTree:ctor()
  self.rootNode = nil
  self.backtrackStack = Stack:New()
end

function KDTree:CreateKdTree(pointList)
  self.rootNode = self:CreateTreeNode(pointList)
end

function KDTree:CreateTreeNode(pointList)
  if 0 < #pointList then
    local xObtainVariance = self:ObtainVariance(self:CreateXList(pointList))
    local yObtainVariance = self:ObtainVariance(self:CreateYList(pointList))
    local divisionType = self:SortListByXOrYVariances(xObtainVariance, yObtainVariance, pointList)
    local medianPoint = self:ObtainMedian(pointList)
    local medianIndex = Mathf.Ceil(#pointList / 2)
    local leftChild = table.move(pointList, 1, medianIndex - 1, 1, {})
    local rightChild = table.move(pointList, medianIndex + 1, #pointList, 1, {})
    local treeNode = KDTreeNode(medianPoint, divisionType, self:CreateTreeNode(leftChild), self:CreateTreeNode(rightChild))
    return treeNode
  else
    return nil
  end
end

function KDTree:ObtainVariance(numbers)
  local sumValue = 0
  for i, v in ipairs(numbers) do
    sumValue = sumValue + v
  end
  local average = sumValue / #numbers
  sumValue = 0
  for i, v in ipairs(numbers) do
    sumValue = sumValue + Mathf.Pow(v - average, 2)
  end
  return sumValue / #numbers
end

function KDTree:CreateXList(pointList)
  local list = {}
  for i, v in ipairs(pointList) do
    table.insert(list, v.x)
  end
  return list
end

function KDTree:CreateYList(pointList)
  local list = {}
  for i, v in ipairs(pointList) do
    table.insert(list, v.y)
  end
  return list
end

function KDTree:SortListByXOrYVariances(xVariance, yVariance, pointList)
  if yVariance < xVariance then
    table.sort(pointList, function(a, b)
      return a.x < b.x
    end)
    return DivisionTypeEnum.X
  else
    table.sort(pointList, function(a, b)
      return a.y < b.y
    end)
    return DivisionTypeEnum.Y
  end
end

function KDTree:ObtainMedian(pointList)
  return pointList[Mathf.Ceil(#pointList / 2)]
end

function KDTree:FindNearestInRadius(searchPoint, radius)
  local list = {}
  self:SearchInRadius(self.rootNode, searchPoint, list, radius)
  return list
end

function KDTree:SearchInRadius(node, searchPoint, list, radius)
  local distance = self:ObtainDistanceFromTwoPoint(node.divisionPoint, searchPoint)
  if radius >= distance then
    list[#list + 1] = node
  end
  local value = node.divisionType == DivisionTypeEnum.X and searchPoint.x or searchPoint.y
  local median = node.divisionType == DivisionTypeEnum.X and node.divisionPoint.x or node.divisionPoint.y
  local diffValue = value - median
  if diffValue <= 0 then
    if node.leftChild then
      self:SearchInRadius(node.leftChild, searchPoint, list, radius)
    end
    if node.rightChild and radius >= Mathf.Abs(diffValue) then
      self:SearchInRadius(node.rightChild, searchPoint, list, radius)
    end
  else
    if node.rightChild then
      self:SearchInRadius(node.rightChild, searchPoint, list, radius)
    end
    if node.leftChild and radius >= Mathf.Abs(diffValue) then
      self:SearchInRadius(node.leftChild, searchPoint, list, radius)
    end
  end
end

function KDTree:FindNearest(searchPoint)
  local nearestPoint = self:DFSSearch(self.rootNode, searchPoint)
  return self:BackTrackSearch(searchPoint, nearestPoint)
end

function KDTree:DFSSearch(node, searchPoint, pushStack)
  if pushStack == nil then
    pushStack = true
  end
  if pushStack == true then
    self.backtrackStack:Push(node)
  end
  if node.divisionType == DivisionTypeEnum.X then
    return self:DFSXSearch(node, searchPoint)
  else
    return self:DFSYSearch(node, searchPoint)
  end
end

function KDTree:DFSXSearch(node, searchPoint)
  if node.divisionPoint.x > searchPoint.x then
    return self:DFSLeftSearch(node, searchPoint)
  else
    return self:DFSRightSearch(node, searchPoint)
  end
end

function KDTree:DFSYSearch(node, searchPoint)
  if node.divisionPoint.y > searchPoint.y then
    return self:DFSLeftSearch(node, searchPoint)
  else
    return self:DFSRightSearch(node, searchPoint)
  end
end

function KDTree:DFSLeftSearch(node, searchPoint)
  if node.leftChild then
    return self:DFSSearch(node.leftChild, searchPoint)
  else
    return node.divisionPoint
  end
end

function KDTree:DFSRightSearch(node, searchPoint)
  if node.rightChild then
    return self:DFSSearch(node.rightChild, searchPoint)
  else
    return node.divisionPoint
  end
end

function KDTree:BackTrackSearch(searchPoint, nearestPoint)
  if self.backtrackStack:Count() == 0 then
    return nearestPoint
  end
  local trackNode = self.backtrackStack:Pop()
  local backtrackDistance = self:ObtainDistanceFromTwoPoint(searchPoint, trackNode.divisionPoint)
  local nearestPointDistance = self:ObtainDistanceFromTwoPoint(searchPoint, nearestPoint)
  if backtrackDistance < nearestPointDistance then
    local divisionPoint = trackNode.divisionPoint
    local divisionType = trackNode.divisionType
    local leftChild = trackNode.leftChild
    local rightChild = trackNode.rightChild
    local searchNode = KDTreeNode(divisionPoint, divisionType, leftChild, rightChild)
    nearestPoint = self:DFSBackTrackingSearch(searchNode, searchPoint)
  end
  return self:BackTrackSearch(searchPoint, nearestPoint)
end

function KDTree:ObtainDistanceFromTwoPoint(startPoint, endPoint)
  return Mathf.Sqrt(Mathf.Pow(startPoint.x - endPoint.x, 2) + Mathf.Pow(startPoint.y - endPoint.y, 2))
end

function KDTree:DFSBackTrackingSearch(node, searchPoint)
  self.backtrackStack:Push(node)
  if node.divisionType == DivisionTypeEnum.X then
    return self:DFSBackTrackingXSearch(node, searchPoint)
  else
    return self:DFSBackTrackingYSearch(node, searchPoint)
  end
end

function KDTree:DFSBackTrackingXSearch(node, searchPoint)
  if node.divisionPoint.x > searchPoint.x then
    node.leftChild = nil
    local rightSearchPoint = self:DFSBackTrackRightSearch(node, searchPoint)
    node.rightChild = nil
    return rightSearchPoint
  else
    node.rightChild = nil
    local leftSearchPoint = self:DFSBackTrackLeftSearch(node, searchPoint)
    node.leftChild = nil
    return leftSearchPoint
  end
end

function KDTree:DFSBackTrackingYSearch(node, searchPoint)
  if node.divisionPoint.y > searchPoint.y then
    node.leftChild = nil
    local rightSearchPoint = self:DFSBackTrackRightSearch(node, searchPoint)
    node.rightChild = nil
    return rightSearchPoint
  else
    node.rightChild = nil
    local leftSearchPoint = self:DFSBackTrackLeftSearch(node, searchPoint)
    node.leftChild = nil
    return leftSearchPoint
  end
end

function KDTree:DFSBackTrackLeftSearch(node, searchPoint)
  if node.leftChild then
    return self:DFSSearch(node.leftChild, searchPoint, false)
  else
    return node.divisionPoint
  end
end

function KDTree:DFSBackTrackRightSearch(node, searchPoint)
  if node.rightChild then
    return self:DFSSearch(node.rightChild, searchPoint, false)
  else
    return node.divisionPoint
  end
end
