GemCondition = class(ConditionBase)
setgetters(GemCondition, {
  totalLevelFunc = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetTotalLevel(self.calculateType)
  end
})
GemCondition.comparatorMap = {
  [0] = function(self)
    return self.totalLevelFunc > self.totalLevel
  end,
  [1] = function(self)
    return self.totalLevelFunc >= self.totalLevel
  end,
  [2] = function(self)
    return self.totalLevelFunc == self.totalLevel
  end,
  [3] = function(self)
    return self.totalLevelFunc <= self.totalLevel
  end,
  [4] = function(self)
    return self.totalLevelFunc < self.totalLevel
  end
}

function GemCondition:InitParam(param)
  if type(param) ~= "number" then
    return
  end
  self.totalLevel = param % 10000
  self.calculateType = math.floor(param / 10000)
end
