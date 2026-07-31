Conditional_PickUpLimitCount = class(BaseConditional)
Conditional_PickUpLimitCount.name = "Conditional_PickUpLimitCount"

function Conditional_PickUpLimitCount:Calc(itemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  local pickKey = itemConfig.pickKey
  if pickKey == 0 then
    return true
  end
  local surplusCount = RefreshData.GetLimitCount(pickKey)
  if 0 < surplusCount then
    return true
  else
    return false
  end
end

function Conditional_PickUpLimitCount:CalcTips(itemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  local pickKey = itemConfig.pickKey
  if pickKey == 0 then
    return true
  end
  local surplusCount = RefreshData.GetLimitCount(pickKey)
  if 0 < surplusCount then
    return true
  else
    FloatingWordUtility.QuickMsg("\196\144\195\163 \196\145\225\186\161t gi\225\187\155i h\225\186\161n l\198\176\225\187\163t nh\225\186\183t, kh\195\180ng th\225\187\131 nh\225\186\183t th\195\170m")
    return false
  end
end
