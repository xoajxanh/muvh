GemUtility = {}
GemUtility.EquipGemPanelChooseEquipIndex = nil

function GemUtility.CallGemRedPoint(chooseEquipIndex)
  if type(chooseEquipIndex) ~= "number" then
    return
  end
  GemUtility.EquipGemPanelChooseEquipIndex = chooseEquipIndex
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Equip_GemUI
  })
end
