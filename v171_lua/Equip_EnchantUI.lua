Equip_EnchantUI = class(BaseUI)
Equip_EnchantUI.layer = UILayer.Panel
Equip_EnchantUI.orderInLayer = 0
Equip_EnchantUI.hideType = UIHideType.WaitDestroy
Equip_EnchantUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_EnchantUI.escClose = UIEscClose.DontClose

function Equip_EnchantUI:InitControls()
  self.lab_Name = self:GetControl("lab_Name")
  self.btn_Hole3DItem = self:GetControl("hole/btn_Hole3DItem")
  self.btn_Delete = self:GetControl("hole/btn_Delete")
  self.btn_Equip3DItem = self:GetControl("btn_Equip3DItem")
  self.itemAttribute = self:GetControl("attributeScrollView/Viewport/Content/itemAttribute")
  self.btn_Bag3DItem = self:GetControl("bagScrollView/Viewport/Content/btn_Bag3DItem")
  self.btn_Replace = self:GetControl("btn_Replace")
  self.btn_Desc = self:GetControl("btn_Desc")
  self.btn_Close = self:GetControl("btn_Close")
  self.img_NoEquip = self:GetControl("img_NoEquip")
  self.panel_Role = self:GetControl("toggle/panel_Role")
  self.btn_Role = self:GetControl("toggle/panel_Role/btn_Role")
  self.panel_Bag = self:GetControl("toggle/panel_Bag")
  self.btn_Bag = self:GetControl("toggle/panel_Bag/btn_Bag")
  self.panel_RedEquip = self:GetControl("toggle/panel_RedEquip")
  self.btn_RedEquip = self:GetControl("toggle/panel_RedEquip/btn_RedEquip")
end

function Equip_EnchantUI:Init()
end

function Equip_EnchantUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_EnchantUI:InitUI()
end

function Equip_EnchantUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
end

function Equip_EnchantUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Equip_EnchantUI)
end

function Equip_EnchantUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_EnchantUI:RegistEvents()
end

function Equip_EnchantUI:Refresh()
end

function Equip_EnchantUI:OnHide()
end

function Equip_EnchantUI:OnDestroy()
end
