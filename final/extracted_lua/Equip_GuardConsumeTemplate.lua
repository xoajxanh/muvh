local Equip_GuardConsumeTemplate = {}

function Equip_GuardConsumeTemplate:Init()
  self.go_model_Icon = self:GetControl("Model")
  self.lab_name = self:GetControl("lab_name")
  self.btn_obtain = self:GetControl("btn_obtain")
  self.lab_num = self:GetControl("lab_num")
  self.go_modelData = ItemCellData()
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Equip_GuardConsumeTemplate:Refresh(params, ui)
  if params == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(params.ItemID)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(params.ItemID)
  local Text = bagCount .. " / " .. params.Count
  if bagCount < params.Count then
    Text = string.format("<color=red>%s</color>", Text)
  end
  self.lab_num:SetText(Text)
  self.lab_name:SetText(itemData.tblItem.name)
  local itemData = ItemUtility.GenerateItemData(params.ItemID)
  self.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.go_model_Icon, self.go_modelData, ui, true)
  self.btn_obtain:SetActive(bagCount < params.Count)
  self.btn_obtain.itemData = itemData
  self.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
end

return Equip_GuardConsumeTemplate
