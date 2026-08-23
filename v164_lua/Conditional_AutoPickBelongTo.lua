Conditional_AutoPickBelongTo = class(BaseConditional)
Conditional_AutoPickBelongTo.name = "Conditional_AutoPickBelongTo"

function Conditional_AutoPickBelongTo:Calc(dropItemData)
  return PickupManager.IsOnlyBelongToYourDropItem(dropItemData)
end
