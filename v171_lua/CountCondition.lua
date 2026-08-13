CountCondition = class(ConditionBase)
setgetters(CountCondition, {})
CountCondition.comparatorMap = {
  [1] = function(self)
    local count = RefreshData.GetLimitCount(self.countKey)
    return count > self.count
  end,
  [2] = function(self)
    local count = RefreshData.GetLimitCount(self.countKey)
    return count < self.count
  end
}

function CountCondition:InitParam(param)
  if type(param) == "table" then
    self.countKey = tonumber(param[1])
    self.count = tonumber(param[2])
  else
    local strTab = string.split(param, "#")
    self.countKey = tonumber(strTab[1])
    self.count = tonumber(strTab[2])
  end
end
