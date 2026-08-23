Shop_BuyUI = class(BaseUI)
Shop_BuyUI.layer = UILayer.Tip
Shop_BuyUI.orderInLayer = 5
Shop_BuyUI.hideType = UIHideType.WaitDestroy
Shop_BuyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Shop_BuyUI.escClose = UIEscClose.DontClose

function Shop_BuyUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_buyitem = self:GetControl("bg_buy/lab_buyitem")
  self.btn_close = self:GetControl("btn_close")
  self.btn_Item = self:GetControl("btn_Item")
  self.lab_buycount = self:GetControl("lab_buycount")
  self.btn_minus = self:GetControl("btn_minus")
  self.btn_add = self:GetControl("btn_add")
  self.Input_count = self:GetControl("Input_count")
  self.btn_max = self:GetControl("btn_max")
  self.lab_totalprice = self:GetControl("lab_totalprice")
  self.btn_price = self:GetControl("btn_price")
  self.btn_cancel = self:GetControl("btn_cancel")
  self.lab_cancel = self:GetControl("btn_cancel/lab_cancel")
  self.btn_comfirm = self:GetControl("btn_comfirm")
  self.lab_comfirm = self:GetControl("btn_comfirm/lab_comfirm")
end

function Shop_BuyUI:Init()
  self.info = nil
  self.buyCount = 1
  self.unitPrice = 0
  self.itemData = {}
  self.costData = {}
  self.fixMaxCount = 99
end

function Shop_BuyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Shop_BuyUI:InitUI()
  self.btn_Item = ItemUtility.InitItem(self.btn_Item)
  self.btn_price = ItemUtility.InitItem(self.btn_price)
  self:InitLocal()
end

function Shop_BuyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Shop_BuyUI:OnHide()
end

function Shop_BuyUI:OnDestroy()
end

function Shop_BuyUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
  self.btn_max:SetOnClick(self, self.btn_maxOnClick)
  self.btn_price:SetOnClick(self, self.btn_priceOnClick)
  self.btn_cancel:SetOnClick(self, self.btn_closeOnClick)
  self.btn_comfirm:SetOnClick(self, self.btn_comfirmOnClick)
  self.Input_count:SetOnEndEdit(self, self.input_countOnChanged)
end

function Shop_BuyUI:input_countOnChanged(_)
  self.buyCount = Mathf.Min(self:GetMaxCount(), tonumber(self.Input_count:GetInputText()))
  self:OnRefresh()
end

function Shop_BuyUI:btn_closeOnClick(_)
  UIManager.Hide(UIID.ShopBuyUI)
end

function Shop_BuyUI:btn_ItemOnClick(control)
end

function Shop_BuyUI:btn_minusOnClick(control)
  self.buyCount = self.buyCount - 1
  if self.buyCount < 1 then
    self.buyCount = 1
    return
  end
  self:OnRefresh()
end

function Shop_BuyUI:GetMaxCount()
  local maxCount = 0
  if self.unitPrice == 0 then
    maxCount = self.fixMaxCount
  else
    local coinCount = BagInfoData.GetItemCountByItemConfigId(self.costData.itemId)
    maxCount = Mathf.Floor(coinCount / self.unitPrice)
  end
  local limitCount = 0
  if self.info.countKey == 0 then
    limitCount = self.fixMaxCount
  else
    limitCount = Mathf.Min(RefreshData.GetLimitCount(self.info.countKey), self.fixMaxCount)
  end
  maxCount = maxCount > limitCount and limitCount or maxCount
  return maxCount
end

function Shop_BuyUI:btn_addOnClick(control)
  local maxCount = self:GetMaxCount()
  self.buyCount = self.buyCount + 1
  if maxCount < self.buyCount then
    self.buyCount = maxCount
    return
  end
  self:OnRefresh()
end

function Shop_BuyUI:btn_maxOnClick(control)
  local maxCount = self:GetMaxCount()
  if maxCount > self.buyCount then
    self.buyCount = maxCount
    self:OnRefresh()
  end
end

function Shop_BuyUI:btn_priceOnClick(control)
end

function Shop_BuyUI:btn_comfirmOnClick(control)
  if not BagInfoData.SafeBagSpaceJudge(self.itemData.itemId, self.itemData.count * self.buyCount) then
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughBgCell, control)
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = self.args.shopInfo.id,
    buyCount = self.buyCount
  })
  self:btn_closeOnClick()
end

function Shop_BuyUI:RegistEvents()
end

function Shop_BuyUI:Refresh()
  local info = self.args.shopInfo
  self:Reset()
  self.info = info
  local itemInfo = ParseUtility.ParseSingleCost(info.reward)
  local itemData = ItemUtility.GenerateItemData(itemInfo.itemId)
  itemData.count = itemInfo.count
  self.itemData = itemData
  if not string.isNullOrEmpty(info.cost) then
    local costInfo = ParseUtility.ParseSingleCost(info.cost)
    local costData = ItemUtility.GenerateItemData(costInfo.itemId)
    costData.count = costInfo.count
    self.unitPrice = costInfo.count
    self.costData = costData
  else
    self.unitPrice = 0
    self.costData = {}
  end
  self:OnRefresh()
end

function Shop_BuyUI:Reset()
  self.itemData = {}
  self.costData = {}
  self.buyCount = 1
  self.unitPrice = 0
  self.info = nil
end

function Shop_BuyUI:OnRefresh()
  ItemUtility.ShowItem(self, self.btn_Item, self.itemData, true)
  local canInputCount = true
  if self.unitPrice ~= 0 then
    self.btn_price:SetActive(true)
    self.lab_totalprice:SetActive(true)
    self.lab_buycount:SetText(LocalizationUtility.GetContentByKey("ShopUi_3"))
    self.lab_buyitem:SetText(LocalizationUtility.GetContentByKey("ShopUi_5"))
    self.lab_comfirm:SetText(LocalizationUtility.GetContentByKey("goumai"))
    self.costData.count = self.unitPrice * self.buyCount
    ItemUtility.ShowItem(self, self.btn_price, self.costData, true)
  else
    self.btn_price:SetActive(false)
    self.lab_totalprice:SetActive(false)
    self.lab_buycount:SetText(LocalizationUtility.GetContentByKey("ShopUi_4"))
    self.lab_buyitem:SetText(LocalizationUtility.GetContentByKey("ShopUi_2"))
    self.lab_comfirm:SetText(LocalizationUtility.GetContentByKey("ShopUi_1"))
    if self.info.countKey ~= 0 then
      local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(self.info.countKey, "key")
      if countTbl.type == 4 then
        canInputCount = false
        self.buyCount = RefreshData.GetLimitCount(self.info.countKey)
      end
    end
  end
  self.btn_add:SetActive(canInputCount)
  self.btn_minus:SetActive(canInputCount)
  self.btn_max:SetActive(canInputCount)
  self.Input_count.inputField.enabled = canInputCount
  self.Input_count:SetInputText(self.buyCount)
end

function Shop_BuyUI:InitLocal()
  self.lab_cancel:SetText(LocalizationUtility.GetContentByKey("quxiao"))
end
