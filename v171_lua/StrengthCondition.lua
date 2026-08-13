StrengthCondition = class(ConditionBase)
setgetters(StrengthCondition, {})
StrengthCondition.comparatorMap = {
  [0] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.strength] > self.strength
  end,
  [1] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.strength] >= self.strength
  end,
  [2] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.strength] == self.strength
  end,
  [3] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.strength] <= self.strength
  end,
  [4] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.strength] < self.strength
  end
}

function StrengthCondition:InitParam(param)
  self.strength = tonumber(param)
end
