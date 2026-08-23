JoinVIP = class(BaseUI)
JoinVIP.layer = UILayer.Tip
JoinVIP.orderInLayer = 10
JoinVIP.hideType = UIHideType.WaitDestroy
JoinVIP.hideFunc = UIHideFunc.MoveOutOfScreen
JoinVIP.escClose = UIEscClose.DontClose

function JoinVIP:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg_SurpriseUIRight = self:GetControl("img_Right/bg_SurpriseUIRight")
  self.text_SurpriseText = self:GetControl("img_Right/text_SurpriseText")
  self.descSurpriseBtn = self:GetControl("descSurpriseBtn")
  self.btn_close = self:GetControl("btn_close")
end

function JoinVIP:Init()
end

function JoinVIP:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function JoinVIP:InitUI()
end

function JoinVIP:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeBgOnClick)
end

function JoinVIP:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.JoinVIP)
end

function JoinVIP:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function JoinVIP:RegistEvents()
end

function JoinVIP:Refresh()
end

function JoinVIP:OnHide()
end

function JoinVIP:OnDestroy()
end
