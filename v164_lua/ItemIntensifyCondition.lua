ItemIntensifyConditon = class(ConditionBase)
ItemIntensifyConditon.comparatorMap = {
  [0] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and intensify < equipeData.intensify
    end
  end,
  [1] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and intensify <= equipeData.intensify
    end
  end,
  [2] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and equipeData.intensify == intensify
    end
  end,
  [3] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and intensify >= equipeData.intensify
    end
  end,
  [4] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and intensify > equipeData.intensify
    end
  end,
  [5] = function(self, equipeData)
    local intensify = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and equipeData.intensify ~= intensify
    end
  end
}

function ItemIntensifyConditon:Check(targetArg)
  return self:comparator(targetArg)
end
