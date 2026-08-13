ActivityCondition = class(ConditionBase)
setgetters(ActivityCondition, {})
ActivityCondition.comparatorMap = {
  [1] = function(self)
    return false
  end,
  [2] = function(self)
    return false
  end,
  [3] = function(self)
    return false
  end
}

function ActivityCondition:InitParam(param)
  self.goalId = nil
  if tonumber(param) then
    self.goalId = tonumber(param)
  end
end
