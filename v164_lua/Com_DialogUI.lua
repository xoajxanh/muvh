Com_DialogUI = class(BaseUI)
Com_DialogUI.layer = UILayer.Dialog
Com_DialogUI.orderInLayer = 0
Com_DialogUI.hideType = UIHideType.WaitDestroy
Com_DialogUI.hideFunc = UIHideFunc.MoveOutOfScreen
Com_DialogUI.escClose = UIEscClose.DontClose

function Com_DialogUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Text = self:GetControl("Text")
  self.BtnClose = self:GetControl("BtnClose")
end

function Com_DialogUI:Init()
end

function Com_DialogUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Com_DialogUI:InitUI()
end

function Com_DialogUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Com_DialogUI:OnHide()
end

function Com_DialogUI:OnDestroy()
end

function Com_DialogUI:RegistUIEvents()
  self.BtnClose:SetOnClick(self, self.BtnCloseOnClick)
  self.btn_closeBg:SetOnClick(self, self.BtnCloseOnClick)
end

function Com_DialogUI:BtnCloseOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.DialogUI)
end

function Com_DialogUI:RegistEvents()
end

function Com_DialogUI:Refresh()
  if self.args and self.args.talk then
    self.Text:SetText(self.args.talk)
  end
end
