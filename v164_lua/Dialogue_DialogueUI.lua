Dialogue_DialogueUI = class(BaseUI)
Dialogue_DialogueUI.layer = UILayer.Panel
Dialogue_DialogueUI.orderInLayer = 0
Dialogue_DialogueUI.hideType = UIHideType.WaitDestroy
Dialogue_DialogueUI.hideFunc = UIHideFunc.MoveOutOfScreen
Dialogue_DialogueUI.escClose = UIEscClose.DontClose

function Dialogue_DialogueUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_enter = self:GetControl("btn_enter")
end

function Dialogue_DialogueUI:OnPreLoad()
end

function Dialogue_DialogueUI:Init()
end

function Dialogue_DialogueUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Dialogue_DialogueUI:InitUI()
end

function Dialogue_DialogueUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Dialogue_DialogueUI:OnHide()
end

function Dialogue_DialogueUI:OnDestroy()
end

function Dialogue_DialogueUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.ClosePanel)
  self.btn_closeBg:SetOnClick(self, self.ClosePanel)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

function Dialogue_DialogueUI:ClosePanel()
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Dialogue_DialogueUI)
end

function Dialogue_DialogueUI:btn_enterOnClick(control)
  self:ClosePanel()
  PathFinderManager.FlyTransferScene(104201)
end

function Dialogue_DialogueUI:RegistEvents()
end

function Dialogue_DialogueUI:Refresh()
end
