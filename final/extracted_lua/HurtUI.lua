HurtUI = class(BaseUI)
HurtUI.layer = UILayer.Background
HurtUI.orderInLayer = 0
HurtUI.hideType = UIHideType.Hide
HurtUI.hideFunc = UIHideFunc.MoveOutOfScreen
HurtUI.escClose = UIEscClose.DontClose

function HurtUI:InitControls()
  self.kuang = self:GetControl("Eff_UI_yujing/kuang")
end

function HurtUI:OnPreLoad()
end

function HurtUI:Init()
end

function HurtUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function HurtUI:InitUI()
  local sizeX, sizeY = self.root.canvas.transform:GetRectSize()
  self.kuang:SetLocalScale(sizeX, sizeY)
end

function HurtUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function HurtUI:OnHide()
end

function HurtUI:OnDestroy()
end

function HurtUI:RegistUIEvents()
end

function HurtUI:RegistEvents()
end

function HurtUI:Refresh()
end
