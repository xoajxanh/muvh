CSharpBindFuncUtility = {}
local this = CSharpBindFuncUtility

function CSharpBindFuncUtility.BindDelegateFunc(delegate, delegateObj, func)
  if delegateObj == nil then
    delegateObj = delegate(func)
  else
    delegateObj = delegateObj + func
  end
end

function CSharpBindFuncUtility.RemoveDelegateFunc(delegateObj, func)
  if delegateObj ~= nil then
    delegateObj = delegateObj - func
  end
end

function CSharpBindFuncUtility.BindEventFunc(event, eventObj, func)
  if eventObj == nil then
    eventObj = event(func)
  else
    eventObj = event("+", func)
  end
end

function CSharpBindFuncUtility.RemoveEventFunc(event, eventObj, func)
  if eventObj ~= nil then
    eventObj = event("-", func)
  end
end
