local AnniversaryActivityStoreTemplate = {}

function AnniversaryActivityStoreTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
end

function AnniversaryActivityStoreTemplate:InitControls()
  self.Img_bg2 = self:GetControl("Img_bg/Img_bg2")
  self.btn_3DItem = self:GetControl("btn_3DItem")
  self.btn_money = self:GetControl("btn_money")
  self.lab_num = self:GetControl("btn_money/lab_num")
  self.lab_buylimit = self:GetControl("lab_buylimit")
end

function AnniversaryActivityStoreTemplate:RegistUIEvents()
  self.btn_money:SetOnClick(self, self.btn_moneyOnClick)
end

function AnniversaryActivityStoreTemplate:btn_moneyOnClick(control)
  networkRequest.ReqBuy(self.giftShowData.id, 1)
end

function AnniversaryActivityStoreTemplate:Refresh(data, ui)
  self.root = ui
  self.giftShowData = data
  if data.buyLimitCount then
    self.lab_buylimit:SetText(data.buyLimitCount .. "A")
  end
  if data.buyLimitCount == 0 then
    self.btn_money:SetInteractable(false)
    self.Img_bg2:SetColor(EUIColor.Gray)
    self.btn_money:SetColor(EUIColor.Gray)
  end
  if not data.reward then
    return
  end
  local showData = {}
  local giftData = string.split(data.reward, "#")
  showData.itemId = tonumber(giftData[1])
  showData.count = tonumber(giftData[2])
  self:ShowModel(showData.itemId, showData.count, self.btn_3DItem, true)
  local itemId = tonumber(AnniversaryActivity_StoreData.GetStoreCurrencyModel())
  local giftPrice = 0
  if data.cost then
    giftPrice = string.split(data.cost, "#")[2]
  end
  self:ShowModel(itemId, giftPrice, self.btn_money, false)
end

function AnniversaryActivityStoreTemplate:ShowModel(itemId, count, control, bindClick)
  local itemData = ItemUtility.GenerateItemData(itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = count or 0
  if not control.itemCellData then
    control.itemCellData = ItemCellData()
  elseif control.itemCellData.model then
    control.itemCellData:RecycleRes()
  end
  control.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(control, control.itemCellData, self.root, bindClick)
end

return AnniversaryActivityStoreTemplate
