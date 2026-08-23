Main_GameUI = class(BaseUI)
Main_GameUI.layer = UILayer.Panel
Main_GameUI.orderInLayer = 0
Main_GameUI.hideType = UIHideType.WaitDestroy
Main_GameUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_GameUI.escClose = UIEscClose.DontClose

function Main_GameUI:InitControls()
  self.Button_Logout = self:GetControl("Button_Logout")
end

function Main_GameUI:Init()
end

function Main_GameUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_GameUI:InitUI()
end

function Main_GameUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_GameUI:OnHide()
end

function Main_GameUI:OnDestroy()
end

function Main_GameUI:RegistUIEvents()
  self.Button_Logout:SetOnClick(self, self.Button_LogoutOnClick)
end

function Main_GameUI:Button_LogoutOnClick(control)
  EventManager.Dispatch(Event.GamePlay_Leave)
end

function Main_GameUI:RegistEvents()
end

function Main_GameUI:Refresh()
end
