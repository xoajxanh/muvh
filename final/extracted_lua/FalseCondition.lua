FalseCondition = class(ConditionBase)
setgetters(FalseCondition, {})
FalseCondition.comparatorMap = {
  [99] = function(self)
    return false
  end
}

function FalseCondition:InitParam(param)
end
