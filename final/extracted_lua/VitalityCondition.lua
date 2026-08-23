VitalityCondition = class(ConditionBase)
setgetters(VitalityCondition, {})
VitalityCondition.comparatorMap = {
  [0] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.vitality] > self.strength
  end,
  [1] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.vitality] >= self.strength
  end,
  [2] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.vitality] == self.strength
  end,
  [3] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.vitality] <= self.strength
  end,
  [4] = function(self)
    return ViewData.meData.attributeMap[EAttributeType.vitality] < self.strength
  end
}

function VitalityCondition:InitParam(param)
  self.strength = tonumber(param)
end
