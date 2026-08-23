RechargeCondition = class(ConditionBase)
setgetters(RechargeCondition, {
  TotalRechargeNum = function(self)
    return RechargeData.TotalRechargeNum
  end
})
RechargeCondition.comparatorMap = {
  [1] = function(self)
    return self.TotalRechargeNum > self.param
  end,
  [2] = function(self)
    return self.TotalRechargeNum <= self.param
  end
}

function RechargeCondition:InitParam(param)
  self.param = tonumber(param)
end
