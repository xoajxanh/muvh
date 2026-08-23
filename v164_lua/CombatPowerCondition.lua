CombatPowerCondition = class(ConditionBase)
setgetters(CombatPowerCondition, {
  fight = function(self)
    return ViewData.meData:GetAttribute(EAttributeType.fight)
  end
})
CombatPowerCondition.comparatorMap = {
  [0] = function(self)
    return self.fight > self.param
  end,
  [1] = function(self)
    return self.fight >= self.param
  end,
  [2] = function(self)
    return self.fight == self.param
  end,
  [3] = function(self)
    return self.fight <= self.param
  end,
  [4] = function(self)
    return self.fight < self.param
  end,
  [5] = function(self)
    return self.fight ~= self.param
  end
}

function CombatPowerCondition:InitParam(param)
  self.param = tonumber(param)
end
