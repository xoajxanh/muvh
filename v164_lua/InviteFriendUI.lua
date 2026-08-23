InviteFriendUI = class(BaseUI)
InviteFriendUI.layer = UILayer.Tip
InviteFriendUI.orderInLayer = 10
InviteFriendUI.hideType = UIHideType.Hide
InviteFriendUI.hideFunc = UIHideFunc.MoveOutOfScreen
InviteFriendUI.escClose = UIEscClose.DontClose

function InviteFriendUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.panel_Invite = self:GetControl("panel_Invite")
  self.InputField_inviteCode = self:GetControl("panel_Invite/InputField_inviteCode")
  self.Button_OK = self:GetControl("panel_Invite/Button_OK")
  self.Text_OK = self:GetControl("panel_Invite/Button_OK/Text_OK")
  self.Button_Cancel = self:GetControl("panel_Invite/Button_Cancel")
  self.Text_Cancel = self:GetControl("panel_Invite/Button_Cancel/Text_Cancel")
  self.btn_close = self:GetControl("panel_Invite/btn_close")
end

function InviteFriendUI:OnPreLoad()
end

function InviteFriendUI:Init()
end

function InviteFriendUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function InviteFriendUI:InitUI()
end

function InviteFriendUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function InviteFriendUI:OnHide()
  self.InputField_inviteCode:SetInputText("")
end

function InviteFriendUI:OnDestroy()
end

function InviteFriendUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
  self.btn_close:SetOnClick(self, self.Button_CancelOnClick)
end

function InviteFriendUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.InviteFriendUI)
end

function InviteFriendUI:Button_OKOnClick(control)
  NetManager.Send(UserMessage.ReqInputInviteCode, {
    code = self.InputField_inviteCode:GetInputText()
  })
end

function InviteFriendUI:Button_CancelOnClick(control)
  UIManager.Hide(UIID.InviteFriendUI)
end

function InviteFriendUI:RegistEvents()
  self:RegistEvent(Event.UpdateInviteCodeState, self.UpdateInviteCodeState, self)
end

function InviteFriendUI:UpdateInviteCodeState()
  UIManager.Hide(UIID.InviteFriendUI)
end

function InviteFriendUI:Refresh()
end
