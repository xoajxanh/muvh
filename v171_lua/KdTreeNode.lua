KDTreeNode = class()
local this = KDTreeNode

function KDTreeNode:ctor(medianPoint, divisionType, leftChild, rightChild)
  self.divisionPoint = medianPoint
  self.divisionType = divisionType
  self.leftChild = leftChild
  self.rightChild = rightChild
end
