RechargePointCondition = class(ConditionBase)
setgetters(RechargePointCondition, {
  rechargePoint = function(self)
    return ViewData.meData.rechargePoint
  end
})
RechargePointCondition.comparatorMap = {
  [1] = function(self)
    return self.rechargePoint >= self.param
  end,
  [2] = function(self)
    return self.rechargePoint == self.param
  end,
  [3] = function(self)
    return self.rechargePoint <= self.param
  end
}

function RechargePointCondition:InitParam(param)
  self.param = tonumber(param)
end
