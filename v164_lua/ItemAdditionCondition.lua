ItemAdditionConditon = class(ConditionBase)
ItemAdditionConditon.comparatorMap = {
  [0] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and additional < equipeData.additional
    end
  end,
  [1] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and additional <= equipeData.additional
    end
  end,
  [2] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and equipeData.additional == additional
    end
  end,
  [3] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and additional >= equipeData.additional
    end
  end,
  [4] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and additional > equipeData.additional
    end
  end,
  [5] = function(self, equipeData)
    local additional = tonumber(self.param)
    if equipeData == nil then
      return true
    else
      return equipeData.tblItem.type == EItemType.Equipe and equipeData.additional ~= additional
    end
  end
}

function ItemAdditionConditon:Check(targetArg)
  return self:comparator(targetArg)
end
