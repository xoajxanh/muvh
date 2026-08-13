BlockerUI = class(BaseUI)
BlockerUI.layer = UILayer.Dialog
BlockerUI.orderInLayer = 99
BlockerUI.hideType = UIHideType.Hide
BlockerUI.hideFunc = UIHideFunc.MoveOutOfScreen
BlockerUI.escClose = UIEscClose.DontClose

function BlockerUI:InitControls()
  self.Btn_Hide = self:GetControl("Btn_Hide")
end

function BlockerUI:Init()
end

function BlockerUI:OnCreate()
  self:InitControls()
  self:InitComponent()
  self:InitUI()
  self:RegistUIEvents()
end

function BlockerUI:InitComponent()
  local go = self.request.gameObject
  self.canvas = go:AddMissingComponent(typeof(CS.UnityEngine.Canvas))
end

function BlockerUI:InitUI()
end

function BlockerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function BlockerUI:OnHide()
  self.args.displayUI:SetActive(false)
end

function BlockerUI:OnDestroy()
end

function BlockerUI:RegistUIEvents()
  self.Btn_Hide:SetOnClick(self, self.HideUI)
end

function BlockerUI:HideUI()
  UIManager.Hide(UIID.BlockerUI)
end

function BlockerUI:RegistEvents()
end

function BlockerUI:Refresh()
  self.canvas.sortingLayerID = self.args.displayUI.popupCanvas.sortingLayerID
  self.canvas.sortingOrder = self.args.displayUI.popupCanvas.sortingOrder - 1
end
