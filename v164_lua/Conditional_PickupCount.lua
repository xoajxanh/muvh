Conditional_PickUpCount = class(BaseConditional)
Conditional_PickUpCount.name = "Conditional_PickUpCount"

function Conditional_PickUpCount:Calc(itemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  local getKey = itemConfig.getKey
  if getKey == 0 then
    return true
  end
  local surplusCount = RefreshData.GetLimitCount(getKey)
  if 0 < surplusCount then
    return true
  else
    return false
  end
end

function Conditional_PickUpCount:CalcTips(itemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  local getKey = itemConfig.getKey
  if getKey == 0 then
    return true
  end
  local surplusCount = RefreshData.GetLimitCount(getKey)
  if 0 < surplusCount then
    return true
  else
    FloatingWordUtility.QuickMsg("L\198\176\225\187\163t nh\225\186\183t h\195\180m nay \196\145\195\163 \196\145\225\186\161t gi\225\187\155i h\225\186\161n, h\195\163y th\225\187\173 l\225\186\161i v\195\160o ng\195\160y mai")
    return false
  end
end
