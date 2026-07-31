Login_WelcomeServerUI = class(BaseUI)
Login_WelcomeServerUI.layer = UILayer.Tooltip
Login_WelcomeServerUI.orderInLayer = 25
Login_WelcomeServerUI.hideType = UIHideType.Destroy
Login_WelcomeServerUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_WelcomeServerUI.escClose = UIEscClose.DontClose

function Login_WelcomeServerUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.go_Welcome = self:GetControl("go_Welcome")
  self.btn_go = self:GetControl("go_Welcome/btn_go")
  self.lab_welcome = self:GetControl("go_Welcome/lab_welcome")
  self.img_bg = self:GetControl("go_Welcome/bg/img_bg")
end

function Login_WelcomeServerUI:Init()
end

function Login_WelcomeServerUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_WelcomeServerUI:InitUI()
end

function Login_WelcomeServerUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_go:SetOnClick(self, self.btn_closeBgOnClick)
end

function Login_WelcomeServerUI:btn_closeBgOnClick(control)
  AutoTaskManage.ImmediatelyAutoTask()
  UIManager.Hide(UIID.Login_WelcomeServerUI)
end

function Login_WelcomeServerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_WelcomeServerUI:RegistEvents()
end

function Login_WelcomeServerUI:Refresh()
  local pid = LoginData.externalNet and LoginData.pId or LoginData.internalPId
  local tbl = ClientTable.cfg_Login_Welcome_NewManager:GetTblByIdAndCondition(pid)
  if tbl == nil then
    return
  end
  if not string.isNullOrEmpty(tbl.image) then
    self:SetSprite("Atlas_Common", tbl.image, self.img_bg)
  end
  if not string.isNullOrEmpty(tbl.btn) then
    self:SetSprite("Atlas_Common", tbl.btn, self.btn_go)
  end
  if type(tbl.content) == "string" then
    self.lab_welcome:SetText(tbl.content)
  end
end

function Login_WelcomeServerUI:OnHide()
  if UIManager.IsVisible(UIID.Main_StartGame) then
    UIManager.Hide(UIID.Main_StartGame)
  end
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function Login_WelcomeServerUI:OnDestroy()
end
