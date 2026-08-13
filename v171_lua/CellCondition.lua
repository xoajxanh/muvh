CellCondition = class(ConditionBase)
setgetters(CellCondition, {
  data = function(self)
    return ViewData.meData.equipsData.Data
  end
})
CellCondition.comparatorMap = {
  [2] = function(self)
    return self.data[self.bagIndex] ~= nil
  end
}

function CellCondition:InitParam(param)
  if tonumber(param) then
    self.bagIndex = param
  end
end
