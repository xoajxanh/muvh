Logo_18 = class(BaseUI)
Logo_18.layer = UILayer.Dialog
Logo_18.orderInLayer = 0
Logo_18.hideType = UIHideType.WaitDestroy
Logo_18.hideFunc = UIHideFunc.MoveOutOfScreen
Logo_18.escClose = UIEscClose.DontClose

function Logo_18:InitControls()
  self.Bg = self:GetControl("Bg")
  self.img_Bg = self:GetControl("Bg/img_Bg")
end

function Logo_18:Init()
end

function Logo_18:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Logo_18:InitUI()
end

function Logo_18:RegistUIEvents()
end

function Logo_18:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Logo_18:RegistEvents()
end

function Logo_18:Refresh()
end

function Logo_18:OnHide()
end

function Logo_18:OnDestroy()
end
