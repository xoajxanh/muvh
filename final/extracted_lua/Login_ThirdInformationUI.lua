Login_ThirdInformationUI = class(BaseUI)
Login_ThirdInformationUI.layer = UILayer.Panel
Login_ThirdInformationUI.orderInLayer = 10
Login_ThirdInformationUI.hideType = UIHideType.Destroy
Login_ThirdInformationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_ThirdInformationUI.escClose = UIEscClose.DontClose

function Login_ThirdInformationUI:InitControls()
  self.go_ThirdInformation = self:GetControl("go_ThirdInformation")
  self.btn_closePolicy = self:GetControl("go_ThirdInformation/btn_closePolicy")
  self.sv_PolicyContent = self:GetControl("go_ThirdInformation/sv_PolicyContent")
  self.lab_PolicyContent = self:GetControl("go_ThirdInformation/sv_PolicyContent/Viewport/Content/lab_PolicyContent")
end

function Login_ThirdInformationUI:Init()
end

function Login_ThirdInformationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_ThirdInformationUI:InitUI()
end

function Login_ThirdInformationUI:RegistUIEvents()
  self.btn_closePolicy:SetOnClick(self, self.btn_closePolicyOnClick)
end

function Login_ThirdInformationUI:btn_closePolicyOnClick(control)
  UIManager.Hide(UIID.Login_ThirdInformationUI)
end

function Login_ThirdInformationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_ThirdInformationUI:RegistEvents()
end

function Login_ThirdInformationUI:Refresh()
  if self.sv_PolicyContent.scrollRect ~= nil then
    self.sv_PolicyContent.scrollRect.content.anchoredPosition = Vector3.New(0, 0, 0)
  end
end

function Login_ThirdInformationUI:OnHide()
end

function Login_ThirdInformationUI:OnDestroy()
end
