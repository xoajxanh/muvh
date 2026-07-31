LegionCondition = class(ConditionBase)
setgetters(LegionCondition, {})
LegionCondition.comparatorMap = {
  [1] = function(self)
    local data = WarAllianceData.MyWarAllianceData
    if data == nil then
      return false
    end
    if tonumber(data.position) == nil then
      return false
    end
    return data.position <= self.param
  end,
  [2] = function(self)
    if ViewData.meData then
      return ViewData.meData.unionId ~= 0
    end
  end,
  [4] = function(self)
    return true
  end,
  [10] = function(self)
    local data = WarAllianceData.MyWarAllianceData
    if data == nil then
      return false
    end
    local joinOffset = Time.GetServerTime() - data.joinTime
    return joinOffset >= self.param
  end
}

function LegionCondition:InitParam(param)
  self.param = tonumber(param)
end
