Login_ChildProtectionUI = class(BaseUI)
Login_ChildProtectionUI.layer = UILayer.Panel
Login_ChildProtectionUI.orderInLayer = 10
Login_ChildProtectionUI.hideType = UIHideType.Destroy
Login_ChildProtectionUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_ChildProtectionUI.escClose = UIEscClose.DontClose

function Login_ChildProtectionUI:InitControls()
  self.go_ChildProtection = self:GetControl("go_ChildProtection")
  self.btn_closePolicy = self:GetControl("go_ChildProtection/btn_closePolicy")
  self.sv_PolicyContent = self:GetControl("go_ChildProtection/sv_PolicyContent")
  self.lab_PolicyContent = self:GetControl("go_ChildProtection/sv_PolicyContent/Viewport/Content/lab_PolicyContent")
end

function Login_ChildProtectionUI:Init()
end

function Login_ChildProtectionUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_ChildProtectionUI:InitUI()
end

function Login_ChildProtectionUI:RegistUIEvents()
  self.btn_closePolicy:SetOnClick(self, self.btn_closePolicyOnClick)
end

function Login_ChildProtectionUI:btn_closePolicyOnClick(control)
  UIManager.Hide(UIID.Login_ChildProtectionUI)
end

function Login_ChildProtectionUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_ChildProtectionUI:RegistEvents()
end

function Login_ChildProtectionUI:Refresh()
  if self.sv_PolicyContent.scrollRect ~= nil then
    self.sv_PolicyContent.scrollRect.content.anchoredPosition = Vector3.New(0, 0, 0)
  end
end

function Login_ChildProtectionUI:OnHide()
end

function Login_ChildProtectionUI:OnDestroy()
end
