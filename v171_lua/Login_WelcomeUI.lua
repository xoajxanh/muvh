Login_WelcomeUI = class(BaseUI)
Login_WelcomeUI.layer = UILayer.Tooltip
Login_WelcomeUI.orderInLayer = 25
Login_WelcomeUI.hideType = UIHideType.Destroy
Login_WelcomeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_WelcomeUI.escClose = UIEscClose.DontClose

function Login_WelcomeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.go_Welcome = self:GetControl("go_Welcome")
  self.btn_go = self:GetControl("go_Welcome/btn_go")
end

function Login_WelcomeUI:Init()
  self.audio = nil
end

function Login_WelcomeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_WelcomeUI:InitUI()
end

function Login_WelcomeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_go:SetOnClick(self, self.btn_closeBgOnClick)
end

function Login_WelcomeUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Login_WelcomeUI)
end

function Login_WelcomeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_WelcomeUI:RegistEvents()
end

function Login_WelcomeUI:Refresh()
  local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(39, "id")
  if audios then
    self.audio = AudioManager.PlayEffect(audios.resourceName, audios.volume, false, nil)
  end
end

function Login_WelcomeUI:OnHide()
  AudioManager.Stop(self.audio)
  self.audio = nil
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function Login_WelcomeUI:OnDestroy()
end
