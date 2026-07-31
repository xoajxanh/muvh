EnergyCondition = class(ConditionBase)
setgetters(EnergyCondition, {})
EnergyCondition.comparatorMap = {
  [0] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.energy] > self.strength
  end,
  [1] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.energy] >= self.strength
  end,
  [2] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.energy] == self.strength
  end,
  [3] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.energy] <= self.strength
  end,
  [4] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.energy] < self.strength
  end
}

function EnergyCondition:InitParam(param)
  self.strength = tonumber(param)
end
