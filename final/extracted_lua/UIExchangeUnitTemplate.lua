local UIExchangeUnitTemplate = {}

function UIExchangeUnitTemplate:Init(data)
  self.clickBtnCallBack = data.clickCallBack
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function UIExchangeUnitTemplate:InitParams()
  self.parentTbl = nil
  self.coinData = nil
  self.targetData = nil
  self.btnSpriteName = {
    [true] = "ty_btn_short3_new",
    [false] = "ty_btn_short_grey"
  }
end

function UIExchangeUnitTemplate:InitControls()
  self.coinModel = self:GetControl("lab_price/btn_SmallItem")
  self.coinNum = self:GetControl("lab_price/lab_priceNum")
  self.targetModel = self:GetControl("lab_exchange/btn_exchangeItem")
  self.targetNum = self:GetControl("lab_exchange/lab_exchangeNum")
  self.btn_exchange = self:GetControl("btn_exchange")
end

function UIExchangeUnitTemplate:BindUIEvent()
  self.btn_exchange:SetOnClick(self, self.ClickExchangeBtnCallBack)
end

function UIExchangeUnitTemplate:ClickExchangeBtnCallBack()
  if self.exchangeData and self.clickBtnCallBack then
    self.clickBtnCallBack(self.exchangeData, self.btn_exchange)
  end
end

function UIExchangeUnitTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.exchangeData = data
  self:RefreshView()
end

function UIExchangeUnitTemplate:RefreshView()
  if self.exchangeData == nil then
    return
  end
  self:RefreshCoinView()
  self:RefreshTargetView()
end

function UIExchangeUnitTemplate:RefreshCoinView()
  local itemData = ItemUtility.GenerateItemData(self.exchangeData.coinItemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  if self.coinModel.cellData == nil then
    self.coinModel.cellData = ItemCellData()
  end
  self.coinModel.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.coinModel, self.coinModel.cellData, self.parentTbl, true)
  self.coinModel.itemData = itemData
  self.coinModel.OpenTipsType = EOpenTipsType.FastBuy
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.exchangeData.coinItemId)
  local isMeet = bagCount >= self.exchangeData.coinNum
  local numColor = isMeet and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  self.coinNum:SetText(string.GetColorText(self.exchangeData.coinNum, numColor))
end

function UIExchangeUnitTemplate:RefreshTargetView()
  local itemData = ItemUtility.GenerateItemData(self.exchangeData.targetItemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  if self.targetModel.cellData == nil then
    self.targetModel.cellData = ItemCellData()
  end
  self.targetModel.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.targetModel, self.targetModel.cellData, self.parentTbl, true)
  self.targetModel.itemData = itemData
  self.targetModel.OpenTipsType = EOpenTipsType.FastBuy
  self.targetNum:SetText(tostring(self.exchangeData.targetNum))
end

function UIExchangeUnitTemplate:RefrshBtnView(state)
  if self.parentTbl then
    self.parentTbl:SetSprite("Atlas_Common", self.btnSpriteName[state], self.btn_exchange)
  end
end

return UIExchangeUnitTemplate
