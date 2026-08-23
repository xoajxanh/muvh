IntensifyCondition = class(ConditionBase)
setgetters(IntensifyCondition, {})
IntensifyCondition.comparatorMap = {
  [0] = function(self)
    return self.targetNum == nil or self:GetValue() > self.targetNum
  end,
  [1] = function(self)
    return self.targetNum == nil or self:GetValue() >= self.targetNum
  end,
  [2] = function(self)
    return self.targetNum == nil or self:GetValue() == self.targetNum
  end,
  [3] = function(self)
    return self.targetNum == nil or self:GetValue() <= self.targetNum
  end,
  [4] = function(self)
    return self.targetNum == nil or self:GetValue() < self.targetNum
  end
}

function IntensifyCondition:InitParam(param)
  self.targetTbl = string.split(param, "#")
  self.tblCount = table.count(self.targetTbl)
  if self.tblCount > 1 then
    self.targetNum = tonumber(self.targetTbl[1])
  end
end

function IntensifyCondition:GetValue()
  if self.targetTbl == nil or self.tblCount <= 1 then
    return 0
  end
  local equipData = ViewData.meData.equipsData.Data
  local equipIndex, totalLevel = 0, 0
  for i = 2, self.tblCount do
    equipIndex = tonumber(self.targetTbl[i])
    if equipData[equipIndex] and equipData[equipIndex].intensify then
      totalLevel = totalLevel + equipData[equipIndex].intensify
    end
  end
  return totalLevel
end
