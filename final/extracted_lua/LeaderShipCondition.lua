LeaderShipCondition = class(ConditionBase)
setgetters(LeaderShipCondition, {})
LeaderShipCondition.comparatorMap = {
  [0] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.leadership] > self.strength
  end,
  [1] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.leadership] >= self.strength
  end,
  [2] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.leadership] == self.strength
  end,
  [3] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.leadership] <= self.strength
  end,
  [4] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.leadership] < self.strength
  end
}

function LeaderShipCondition:InitParam(param)
  self.strength = tonumber(param)
end
