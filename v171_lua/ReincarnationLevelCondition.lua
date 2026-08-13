ReincarnationLevelCondition = class(ConditionBase)
setgetters(ReincarnationLevelCondition, {
  level = function()
    return ViewData.meData.reincarnationLevel
  end
})
ReincarnationLevelCondition.comparatorMap = {
  [0] = function(self)
    return self.level > self.targetLevel
  end,
  [1] = function(self)
    return self.level >= self.targetLevel
  end,
  [2] = function(self)
    return self.level == self.targetLevel
  end,
  [3] = function(self)
    return self.level <= self.targetLevel
  end,
  [4] = function(self)
    return self.level < self.targetLevel
  end,
  [5] = function(self)
    return self.level ~= self.targetLevel
  end
}

function ReincarnationLevelCondition:InitParam(param)
  self.targetLevel = tonumber(param)
end
