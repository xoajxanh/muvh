Bag_ShopInfoUI = class(BaseUI)
Bag_ShopInfoUI.layer = UILayer.Panel
Bag_ShopInfoUI.orderInLayer = 3
Bag_ShopInfoUI.hideType = UIHideType.Hide
Bag_ShopInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_ShopInfoUI.escClose = UIEscClose.DontClose

function Bag_ShopInfoUI:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.Item_Content = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content")
  self.img_information = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information")
  self.btn_3DItem = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information/btn_3DItem")
  self.lab_buy = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information/btn_buy/lab_buy")
  self.tog_autoBugDrugs = self:GetControl("img_bg/tog_autoBugDrugs")
  self.go_gold = self:GetControl("img_bg/currency/go_gold")
  self.go_integral = self:GetControl("img_bg/currency/go_integral")
  self.go_gem = self:GetControl("img_bg/currency/go_gem")
  self.go_meltingPoint = self:GetControl("img_bg/currency/go_meltingPoint")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Bag_ShopInfoUI:Init()
  self.shopCtrTbl = nil
  self.goldTbl = {}
  self.integralTbl = {}
  self.gemTbl = {}
  self.meltingTbl = {}
end

function Bag_ShopInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_ShopInfoUI:InitUI()
  self:LocalInit()
  self:ShopInit()
  self:CoinsInit()
end

local function OnCreate(control)
  control.lab_limit = UIControl(control.transform, "lab_limit")
  control.btn_buy = UIControl(control.transform, "btn_buy")
  control.btn_Item = UIControl(control.transform, "btn_3DItem")
  control.lab_btnItem = UIControl(control.transform, "btn_buy/lab_buy")
  control.go_price = UIControl(control.transform, "go_price")
  control.btn_Item = ItemUtility.InitItemCell(control.btn_Item)
  control.go_price = ItemUtility.InitItem(control.go_price)
  control.btn_Item.itemCellData = ItemCellData()
end

local function OnRefresh(shopCtr, _, shop, ui)
  local rewardTbl = ParseUtility.ParseSingleCost(shop.reward)
  local itemData = ItemUtility.GenerateItemData(rewardTbl.itemId)
  itemData.count = rewardTbl.count
  itemData.additional = shop.buildAddtional
  itemData.luck = ItemUtility.GetEquipeLuckIds(shop.buildLucky)
  itemData.intensify = shop.buildIntensify
  shopCtr.btn_Item.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(shopCtr.btn_Item, shopCtr.btn_Item.itemCellData, ui, true)
  if not string.isNullOrEmpty(shop.cost) then
    local costTbl = ParseUtility.ParseSingleCost(shop.cost)
    local tabTemp = ClientTable.cfg_Item_itemManager:TryGetValue(costTbl.itemId)
    if tabTemp and tabTemp.bindEqualItem > 0 then
      tabTemp = ClientTable.cfg_Item_itemManager:TryGetValue(tabTemp.bindEqualItem)
    end
    local priceTbl = ItemUtility.GenerateItemData(tabTemp.id)
    priceTbl.count = costTbl.count
    ItemUtility.ShowItem(ui, shopCtr.go_price, priceTbl, true)
  end
  local buyLimitShow = LimitUtility.GetLimitShow(shop.buyCondition)
  local str, limitType = LimitUtility.GetTipText(buyLimitShow, shop)
  shopCtr.lab_limit:SetText(str)
  shopCtr.btn_buy.shop = shop
  shopCtr.btn_buy.limitType = limitType
  shopCtr.btn_buy.count = 1
  shopCtr.btn_buy:SetOnClick(ui, ui.btn_buy)
  if not string.isNullOrEmpty(shop.cost) then
    shopCtr.lab_btnItem:SetText(LocalizationUtility.GetContentByKey("goumai"))
  else
    shopCtr.lab_btnItem:SetText(LocalizationUtility.GetContentByKey("ShopUi_2"))
  end
end

function Bag_ShopInfoUI:ShopInit()
  self.shopCtrTbl = UIContainer(self.img_information, self, OnCreate, OnRefresh)
  self.shopCtrTbl:SetData({})
end

function Bag_ShopInfoUI:CoinsInit()
  self.go_gold = ItemUtility.InitItem(self.go_gold)
  self.go_integral = ItemUtility.InitItem(self.go_integral)
  self.go_gem = ItemUtility.InitItem(self.go_gem)
  self.go_meltingPoint = ItemUtility.InitItem(self.go_meltingPoint)
  self.gemTbl = ItemUtility.GenerateItemData(ECoinsType.gem)
  self.integralTbl = ItemUtility.GenerateItemData(ECoinsType.integral)
  self.goldTbl = ItemUtility.GenerateItemData(ECoinsType.gemNotTrade)
  self.meltingTbl = ItemUtility.GenerateItemData(ECoinsType.bindIntegral)
  ItemUtility.ShowItem(self, self.go_gold, self.goldTbl, true)
  ItemUtility.ShowItem(self, self.go_integral, self.integralTbl, true)
  ItemUtility.ShowItem(self, self.go_gem, self.gemTbl, true)
  ItemUtility.ShowItem(self, self.go_meltingPoint, self.meltingTbl, true)
end

function Bag_ShopInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Bag_ShopInfoUI:OnHide()
end

function Bag_ShopInfoUI:OnDestroy()
  self.shopCtrTbl = nil
end

function Bag_ShopInfoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClik)
  self.tog_autoBugDrugs:SetOnToggleChanged(self, self.ToggleChanged)
end

function Bag_ShopInfoUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.BagShopInfoUI)
end

function Bag_ShopInfoUI:descBtnOnClik()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Bag_ShopInfoUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Bag_ShopInfoUI:btn_buy(control)
  if control.limitType then
    LimitUtility.NoEnoughPrompt(control.limitType, control)
    return
  end
  if not string.isNullOrEmpty(control.shop.cost) then
    local costTbl = ParseUtility.ParseSingleCost(control.shop.cost)
    if BagInfoData.GetItemTotalCountByItemId(costTbl.itemId) < costTbl.count then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("CombineFailed_3"))
      return
    end
  end
  local ItemId = string.split(control.shop.reward, "#")
  local buyCount = tonumber(ItemId[2])
  ItemId = tonumber(ItemId[1])
  if not BagInfoData.SafeBagSpaceJudge(ItemId, buyCount) then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("CombineFailed_4"))
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = control.shop.id,
    buyCount = 1
  })
end

function Bag_ShopInfoUI:ToggleChanged(control, isOn)
  if isOn then
    local openDir = PlayerControlForceData.AutoBuyDrug()
    if not openDir then
      local contentKey = ItemUtility.IsJumpRecharge() and "AutoBugDrugsNoVip" or "AutoBugDrugsNoVip_2"
      TipUtility.QuickShowPrompt({
        id = PromptWordType.AutoBuyDrugPrompt
      })
      self.tog_autoBugDrugs:SetIsOn(false)
    else
      PlayerControlForceData.SetAutoBuyDrugState(true)
    end
  else
    PlayerControlForceData.SetAutoBuyDrugState(false)
  end
end

function Bag_ShopInfoUI:RegistEvents()
  self:RegistEvent(Event.RefreshShop, self.OnRefreshShop, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
end

function Bag_ShopInfoUI:OnRefreshShop(_, msg)
  self:OnRefresh()
end

function Bag_ShopInfoUI:OnCoinChanged(_)
  self:ShowCoins()
end

function Bag_ShopInfoUI:Refresh()
  self.tog_autoBugDrugs:SetIsOn(PlayerControlForceData.autoBuyDrugState)
  self:CoinsInit()
  self:OnRefresh()
  self:ShowCoins()
end

function Bag_ShopInfoUI:OnRefresh()
  local shopTbl = ShopData.GetPortableShopInfo()
  self.shopCtrTbl:SetData(shopTbl)
end

function Bag_ShopInfoUI:ShowCoins()
  local coinCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gemNotTrade] then
    coinCount = BagInfoData.CoinInfos[ECoinsType.gemNotTrade]
  end
  self.go_gold.countCtr:SetText(coinCount)
  self.go_gold.iconCtr:SetActive(true)
  local integralCount = 0
  if BagInfoData.CoinInfos[ECoinsType.integral] then
    integralCount = BagInfoData.CoinInfos[ECoinsType.integral]
  end
  self.go_integral.countCtr:SetText(integralCount)
  self.go_integral.iconCtr:SetActive(true)
  local gemCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gem] then
    gemCount = BagInfoData.CoinInfos[ECoinsType.gem]
  end
  self.go_gem.countCtr:SetText(gemCount)
  self.go_gem.iconCtr:SetActive(true)
  local meltingCount = 0
  if BagInfoData.CoinInfos[ECoinsType.bindIntegral] then
    meltingCount = BagInfoData.CoinInfos[ECoinsType.bindIntegral]
  end
  self.go_meltingPoint.countCtr:SetText(meltingCount)
  self.go_meltingPoint.iconCtr:SetActive(true)
end

function Bag_ShopInfoUI:LocalInit()
end
