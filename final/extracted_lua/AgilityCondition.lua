AgilityCondition = class(ConditionBase)
setgetters(AgilityCondition, {})
AgilityCondition.comparatorMap = {
  [0] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.agility] > self.strength
  end,
  [1] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.agility] >= self.strength
  end,
  [2] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.agility] == self.strength
  end,
  [3] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.agility] <= self.strength
  end,
  [4] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.agility] < self.strength
  end
}

function AgilityCondition:InitParam(param)
  self.strength = tonumber(param)
end
