local ObjectEx = CS.Framework.ObjectEx

function IsNil(obj)
  if obj == nil then
    return true
  end
  if ObjectEx then
    return ObjectEx.IsNull(obj)
  end
end
