Conditional_PickUpBag = class(BaseConditional)
Conditional_PickUpBag.name = "Conditional_PickUpBag"

function Conditional_PickUpBag:Calc(dropItemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(dropItemData.itemId)
  local isEnough = BagInfoData.BagSpaceJudge2(dropItemData.itemId, dropItemData.item.count) or itemConfig.quickUse > 1 or dropItemData.item.quickUse > 0
  return isEnough
end

function Conditional_PickUpBag:CalcTips(dropItemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(dropItemData.itemId)
  local isEnough = BagInfoData.BagSpaceJudge2(dropItemData.itemId, dropItemData.item.count) or itemConfig.quickUse > 1 or dropItemData.item.quickUse > 0
  if isEnough then
    return true
  else
    local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("beibaoyiman").content
    FloatingWordUtility.QuickMsg(uiWord)
    return false
  end
end
