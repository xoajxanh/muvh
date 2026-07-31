Conditional_AutoPickType = class(BaseConditional)
Conditional_AutoPickType.name = "Conditional_AutoPickType"

function Conditional_AutoPickType:Calc(dropItemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(dropItemData.itemId)
  local pickKey = itemConfig.pickKey
  return pickKey == 0
end
