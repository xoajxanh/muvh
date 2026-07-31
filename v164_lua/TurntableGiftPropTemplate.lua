local TurntableGiftPropTemplate = {}

function TurntableGiftPropTemplate:Init()
  self:InitControls()
end

function TurntableGiftPropTemplate:InitControls()
  self.nowControl = self:GetControl()
  self.lab_GiftCount = self:GetControl("btn_GiftProp/img_GiftCount/lab_GiftCount")
  self.img_mask = self:GetControl("btn_GiftProp/img_mask")
  self.btn_GiftProp = self:GetControl("btn_GiftProp")
  self.getEffect = self:GetControl("btn_GiftProp/getEffect")
  self.Eff_UI_annuikuang09 = self:GetControl("btn_GiftProp/getEffect/Eff_UI_annuikuang09")
  self.getEffect:SetOnClick(self, self.btn_GiftPropOnClick)
  self.itemCellData = ItemCellData()
end

function TurntableGiftPropTemplate:Refresh(data, ui)
  if data == nil then
    self:DestroyItemCellData()
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  self.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_GiftProp, self.itemCellData, ui, true, nil, 3, 3)
  self.lab_GiftCount:SetText(tostring(data.luckyTimes) .. " l\225\186\167n")
  self.state = data.state
  self.id = data.id
  if data.state == GuardRewardStateEnum.NotGet then
    self.getEffect:SetActive(false)
    self.img_mask:SetActive(false)
  elseif data.state == GuardRewardStateEnum.CanGet then
    self.getEffect:SetActive(true)
    self.Eff_UI_annuikuang09:SetActive(true)
    self.img_mask:SetActive(false)
  elseif data.state == GuardRewardStateEnum.Got then
    self.getEffect:SetActive(true)
    self.Eff_UI_annuikuang09:SetActive(false)
    self.img_mask:SetActive(true)
  end
end

function TurntableGiftPropTemplate:DestroyItemCellData()
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function TurntableGiftPropTemplate:btn_GiftPropOnClick()
  if self.state == GuardRewardStateEnum.Got then
    return
  end
  NetManager.Send(CommerceMessage.ReqTreasureHuntAccumulatedAward, {
    id = self.id
  })
end

return TurntableGiftPropTemplate
