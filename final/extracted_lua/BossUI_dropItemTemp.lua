local BossUI_dropItemTemp = {}

function BossUI_dropItemTemp:Init()
  self.go_model = self:GetControl("go_model")
  self.go_modelData = ItemCellData()
end

function BossUI_dropItemTemp:Refresh(params, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(params))
  self.go_modelData:RefreshData(itemData)
  self:UIControl():SetActive(true)
  ItemUtility.ShowItemCell(self:UIControl(), self.go_modelData, ui, true)
end

return BossUI_dropItemTemp
