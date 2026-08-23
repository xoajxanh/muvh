local Appear_Couture_StrengthenTemplate = {}

function Appear_Couture_StrengthenTemplate:Init(rootUI)
  self:InitControls(rootUI)
end

function Appear_Couture_StrengthenTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.Model = self:GetControl("Model")
  self.lab_name = self:GetControl("lab_name")
  self.lab_num = self:GetControl("lab_num")
  self.btn_obtain = self:GetControl("btn_obtain")
  self.go_modelData = ItemCellData()
end

function Appear_Couture_StrengthenTemplate:Refresh(data, ui)
  self.lab_name:SetText("T\195\170n \196\145\225\186\161o c\225\187\165")
  self.lab_num:SetText(123456)
  self.btn_obtain:SetActive(false)
  local itemData = ItemUtility.GenerateItemData(2010050)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.Model, self.go_modelData, ui, false)
end

return Appear_Couture_StrengthenTemplate
