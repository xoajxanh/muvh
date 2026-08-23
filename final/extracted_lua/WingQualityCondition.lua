WingQualityCondition = class(ConditionBase)
WingQualityCondition.comparatorMap = {
  [0] = function(self, tblItem)
    local qualityLevel = tonumber(self.param)
    if tblItem == nil then
      return true
    else
      return qualityLevel < tblItem.quality
    end
  end,
  [1] = function(self, tblItem)
    local qualityLevel = tonumber(self.param)
    if tblItem == nil then
      return true
    else
      return qualityLevel <= tblItem.quality
    end
  end,
  [2] = function(self, tblItem)
    local qualityLevel = tonumber(self.param)
    if tblItem == nil then
      return true
    else
      return tblItem.quality == qualityLevel
    end
  end,
  [3] = function(self, tblItem)
    local qualityLevel = tonumber(self.param)
    if tblItem == nil then
      return true
    else
      return qualityLevel >= tblItem.quality
    end
  end,
  [4] = function(self, tblItem)
    local qualityLevel = tonumber(self.param)
    if tblItem == nil then
      return true
    else
      return qualityLevel > tblItem.quality
    end
  end
}

function WingQualityCondition:Check(targetArg)
  return self:comparator(targetArg)
end
