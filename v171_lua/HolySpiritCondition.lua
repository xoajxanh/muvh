HolySpiritCondition = class(ConditionBase)
setgetters(HolySpiritCondition, {
  getPoint = function(self)
    return HolySpiritPointData.GetNowTypeActivePointCount(self.holySpiritType)
  end
})
HolySpiritCondition.comparatorMap = {
  [0] = function(self)
    local curUnlock = self.getPoint
    return curUnlock > self.holySpititPoint
  end,
  [1] = function(self)
    local curUnlock = self.getPoint
    return curUnlock >= self.holySpititPoint
  end,
  [2] = function(self)
    local curUnlock = self.getPoint
    return curUnlock == self.holySpititPoint
  end,
  [3] = function(self)
    local curUnlock = self.getPoint
    return curUnlock <= self.holySpititPoint
  end,
  [4] = function(self)
    local curUnlock = self.getPoint
    return curUnlock < self.holySpititPoint
  end
}

function HolySpiritCondition:InitParam(param)
  if type(param) ~= "number" then
    local array = string.split(param, "#")
    if #array ~= 2 then
      logError("L\225\187\151i c\225\186\165u h\195\172nh transCondition c\225\187\167a trang b\225\187\139 Th\195\161nh H\225\187\147n")
      return
    end
    self.holySpiritType = tonumber(array[1])
    self.holySpititPoint = tonumber(array[2])
  end
end
