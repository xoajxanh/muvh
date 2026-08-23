Conditional_ItemCd = class(BaseConditional)
Conditional_ItemCd.name = "Conditional_ItemCd"

function Conditional_ItemCd:Calc(itemId)
  return not ItemUtility.IsCanUseItemCd(itemId)
end
