Conditional_AutoPickSelect = class(BaseConditional)
Conditional_AutoPickSelect.name = "Conditional_AutoPickSelect"

function Conditional_AutoPickSelect:Calc(dropItemData)
  if QiJiHelperData.SettingData.selectPickupType == AutoPickupEnum.SelectAll then
    return true
  elseif dropItemData.type ~= EItemType.Equipe and not QiJiHelperData.pickupTab[tostring(dropItemData.type)] then
    return true
  elseif dropItemData.type == EItemType.Equipe and not QiJiHelperData.pickupTab[string.format("%s#%s", dropItemData.type, dropItemData.item.rarity)] then
    return true
  end
  return false
end
