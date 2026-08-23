Bag_3DEquipInfoUI = class(BaseUI)
Bag_3DEquipInfoUI.layer = UILayer.Panel
Bag_3DEquipInfoUI.orderInLayer = 0
Bag_3DEquipInfoUI.hideType = UIHideType.Hide
Bag_3DEquipInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_3DEquipInfoUI.escClose = UIEscClose.DontClose

function Bag_3DEquipInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_title = self:GetControl("lab_title")
  self.btn_close = self:GetControl("btn_close")
  self.btn_taozhuang = self:GetControl("btn_taozhuang")
  self.btn_xiangbao = self:GetControl("btn_xiangbao")
  self.go_DragCheck = self:GetControl("go_DragCheck")
  self.go_DragEdge = self:GetControl("go_DragCheck/go_DragEdge")
  self.img_select = self:GetControl("go_DragCheck/img_select")
  self.img_pet = self:GetControl("go_DragCheck/img_pet")
  self.img_armor = self:GetControl("go_DragCheck/img_armor")
  self.btn_EquipType = self:GetControl("btn_EquipType")
  self.lab_sort = self:GetControl("btn_EquipType/lab_sort")
  self.go_gold = self:GetControl("currency/go_gold")
  self.go_integral = self:GetControl("currency/go_integral")
  self.go_gem = self:GetControl("currency/go_gem")
  self.go_meltingPoint = self:GetControl("currency/go_meltingPoint")
  self.panel_attribute = self:GetControl("panel_attribute")
  self.img_bg = self:GetControl("panel_attribute/img_bg")
  self.lab_attribute = self:GetControl("panel_attribute/lab_attribute")
  self.bg_stoneCombinationAttribute = self:GetControl("bg_stoneCombinationAttribute")
  self.btn_closeAttribute = self:GetControl("bg_stoneCombinationAttribute/btn_closeAttribute")
end

function Bag_3DEquipInfoUI:OnPreLoad()
end

function Bag_3DEquipInfoUI:Init()
end

function Bag_3DEquipInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_3DEquipInfoUI:InitUI()
  local ctrTbl = {}
  ctrTbl[1] = self.img_pet
  ctrTbl[2] = self.img_armor
  self.dragTbl = UIFixedCellContainer(self, nil, nil, ctrTbl)
end

function Bag_3DEquipInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  ItemCellTblData.curCellTbls[self.name] = self.dragTbl
end

function Bag_3DEquipInfoUI:OnHide()
  ItemCellTblData.curCellTbls[self.name] = nil
end

function Bag_3DEquipInfoUI:OnDestroy()
end

function Bag_3DEquipInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_taozhuang:SetOnClick(self, self.btn_taozhuangOnClick)
  self.btn_xiangbao:SetOnClick(self, self.btn_xiangbaoOnClick)
  self.img_pet:SetOnClick(self, self.img_petOnClick)
  self.img_armor:SetOnClick(self, self.img_armorOnClick)
  self.btn_EquipType:SetOnClick(self, self.btn_EquipTypeOnClick)
  self.go_gold:SetOnClick(self, self.go_goldOnClick)
  self.go_integral:SetOnClick(self, self.go_integralOnClick)
  self.go_gem:SetOnClick(self, self.go_gemOnClick)
  self.go_meltingPoint:SetOnClick(self, self.go_meltingPointOnClick)
  self.btn_closeAttribute:SetOnClick(self, self.btn_closeAttributeOnClick)
end

function Bag_3DEquipInfoUI:btn_closeBgOnClick(control)
end

function Bag_3DEquipInfoUI:btn_closeOnClick(control)
  UIManager.Hide(self.name)
end

function Bag_3DEquipInfoUI:btn_taozhuangOnClick(control)
end

function Bag_3DEquipInfoUI:btn_xiangbaoOnClick(control)
end

function Bag_3DEquipInfoUI:img_petOnClick(control)
end

function Bag_3DEquipInfoUI:img_armorOnClick(control)
end

function Bag_3DEquipInfoUI:btn_EquipTypeOnClick(control)
end

function Bag_3DEquipInfoUI:go_goldOnClick(control)
end

function Bag_3DEquipInfoUI:go_integralOnClick(control)
end

function Bag_3DEquipInfoUI:go_gemOnClick(control)
end

function Bag_3DEquipInfoUI:go_meltingPointOnClick(control)
end

function Bag_3DEquipInfoUI:btn_closeAttributeOnClick(control)
end

function Bag_3DEquipInfoUI:RegistEvents()
end

function Bag_3DEquipInfoUI:Refresh()
  self.dragTbl:SetData({})
end
