BlockerUtility = {}
local this = BlockerUtility

function BlockerUtility.Show(displayUI)
  if displayUI:GetActive() == true then
    return
  end
  displayUI:SetActive(true)
  local popupCanvas = this.GetOrAddComponent(displayUI, typeof(CS.UnityEngine.Canvas))
  this.GetOrAddComponent(displayUI, typeof(CS.UnityEngine.UI.GraphicRaycaster))
  displayUI.gameObject:SetLayer(UI_LAYER)
  popupCanvas.overrideSorting = true
  popupCanvas.sortingOrder = 1000
  displayUI.popupCanvas = popupCanvas
  UIManager.Show(UIID.BlockerUI, {displayUI = displayUI})
end

function BlockerUtility.Hide()
  UIManager.Hide(UIID.BlockerUI)
end

function BlockerUtility.GetOrAddComponent(go, component)
  local comp = go.gameObject:AddMissingComponent(component)
  return comp
end
