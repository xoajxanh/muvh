StoneCondition = class(ConditionBase)
setgetters(StoneCondition, {})
StoneCondition.comparatorMap = {
  [1] = function(self)
    self.excellenceCount = 0
    return self.excellenceCount >= self.conditionCount
  end
}

function StoneCondition:InitParam(param)
  if type(param) == "table" then
    self.conditionCount = param[2]
  else
    local strTab = string.split(param, "#")
    self.conditionCount = tonumber(strTab[2])
  end
end
