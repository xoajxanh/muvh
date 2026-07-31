Conditional_AutoPickVipPower = class(BaseConditional)
Conditional_AutoPickVipPower.name = "Conditional_AutoPickVipPower"

function Conditional_AutoPickVipPower:Calc(dropItemData)
  if PlayerControlForceData.autoPickupState then
    return true
  end
  if dropItemData.fromInfo ~= nil and dropItemData.fromInfo.type == EItemFromType.Gift then
    return true
  end
  return false
end
