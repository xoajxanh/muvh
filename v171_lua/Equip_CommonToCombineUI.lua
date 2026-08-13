Equip_CommonToCombineUI = class(BaseUI)
Equip_CommonToCombineUI.layer = UILayer.Panel
Equip_CommonToCombineUI.orderInLayer = 0
Equip_CommonToCombineUI.hideType = UIHideType.WaitDestroy
Equip_CommonToCombineUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_CommonToCombineUI.escClose = UIEscClose.DontClose

function Equip_CommonToCombineUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Windows = self:GetControl("Windows")
end

function Equip_CommonToCombineUI:Init()
end

function Equip_CommonToCombineUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_CommonToCombineUI:InitUI()
end

function Equip_CommonToCombineUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
end

function Equip_CommonToCombineUI:btn_closeBgOnClick(control)
end

function Equip_CommonToCombineUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_CommonToCombineUI:RegistEvents()
end

function Equip_CommonToCombineUI:Refresh()
end

function Equip_CommonToCombineUI:OnHide()
end

function Equip_CommonToCombineUI:OnDestroy()
end
