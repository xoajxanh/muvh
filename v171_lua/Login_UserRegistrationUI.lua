Login_UserRegistrationUI = class(BaseUI)
Login_UserRegistrationUI.layer = UILayer.Panel
Login_UserRegistrationUI.orderInLayer = 10
Login_UserRegistrationUI.hideType = UIHideType.Destroy
Login_UserRegistrationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_UserRegistrationUI.escClose = UIEscClose.DontClose

function Login_UserRegistrationUI:InitControls()
  self.go_UserRegistration = self:GetControl("go_UserRegistration")
  self.btn_closePolicy = self:GetControl("go_UserRegistration/btn_closePolicy")
  self.sv_PolicyContent = self:GetControl("go_UserRegistration/sv_PolicyContent")
  self.lab_PolicyContent = self:GetControl("go_UserRegistration/sv_PolicyContent/Viewport/Content/lab_PolicyContent")
end

function Login_UserRegistrationUI:Init()
end

function Login_UserRegistrationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_UserRegistrationUI:InitUI()
end

function Login_UserRegistrationUI:RegistUIEvents()
  self.btn_closePolicy:SetOnClick(self, self.btn_closePolicyOnClick)
end

function Login_UserRegistrationUI:btn_closePolicyOnClick(control)
  UIManager.Hide(UIID.Login_UserRegistrationUI)
end

function Login_UserRegistrationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_UserRegistrationUI:RegistEvents()
end

function Login_UserRegistrationUI:Refresh()
  if self.sv_PolicyContent.scrollRect ~= nil then
    self.sv_PolicyContent.scrollRect.content.anchoredPosition = Vector3.New(0, 0, 0)
  end
end

function Login_UserRegistrationUI:OnHide()
end

function Login_UserRegistrationUI:OnDestroy()
end
