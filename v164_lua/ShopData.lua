ShopData = class()
local this = ShopData
this.currentBuyControl = nil
this.shopShowTbl = {}
local itemBuyTableByItemId = {}

function ShopData.GetItemBuyTableByItemId(itemId)
  return itemBuyTableByItemId[itemId]
end

local function BuildBuyTableByItemId()
  local configTbl = ClientTable.cfg_Item_buyManager:GetDic()
  for i = 1, #configTbl do
    local itemID = string.split(configTbl[i].reward, "#")
    itemBuyTableByItemId[tonumber(itemID[1])] = configTbl[i]
  end
end

function ShopData.Init()
  BuildBuyTableByItemId()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.OpenQuickToBuy, this.OpenItemBuyTips)
  this.eventContainer:Regist(Event.ShowShopBuyPanel, this.ShowShopBuyPanel)
end

local function sort(a, b)
  return a.commodityRanking < b.commodityRanking
end

function ShopData.GetPortableShopInfo()
  local configTbl = ClientTable.cfg_Item_buyManager:GetDic()
  local shopShowTbl = {}
  for _, shopConfig in pairs(configTbl) do
    if shopConfig.type == 0 and (ConditionManager.Check4D(shopConfig.showCondition) or string.isNullOrEmpty(shopConfig.showCondition)) then
      table.insert(shopShowTbl, shopConfig)
    end
  end
  table.sort(shopShowTbl, sort)
  this.shopShowTbl = shopShowTbl
  return shopShowTbl
end

function ShopData.GetShopInfo()
  local configTbl = ClientTable.cfg_Item_buyManager:GetDic()
  local shopShowTbl = {}
  local countTbl, SellShort
  for _, shopConfig in pairs(configTbl) do
    if shopConfig.shopShow == 1 then
      SellShort = false
      if shopConfig.countKey ~= 0 and RefreshData.GetLimitCount(shopConfig.countKey) == 0 then
        countTbl = ClientTable.cfg_Count_countManager:TryGetValue(shopConfig.countKey, "key")
        if string.isNullOrEmpty(countTbl.refreshRule) then
          SellShort = true
        end
      end
      if not SellShort and (shopConfig ~= nil and shopConfig.showCondition == nil or ConditionManager.Check4D(shopConfig.showCondition)) then
        table.insert(shopShowTbl, shopConfig)
      end
    end
  end
  return shopShowTbl
end

function ShopData.GetShopInfo2(type, subType)
  local configTbl = ClientTable.cfg_Item_buyManager:GetDic()
  local shopShowTbl = {}
  local countTbl, SellShort
  if not type or not subType then
    return shopShowTbl
  end
  for _, shopConfig in pairs(configTbl) do
    if shopConfig.shopShow == 1 and shopConfig.type == type and shopConfig.subtype == subType then
      SellShort = false
      if shopConfig.countKey ~= 0 and RefreshData.GetLimitCount(shopConfig.countKey) == 0 then
        countTbl = ClientTable.cfg_Count_countManager:TryGetValue(shopConfig.countKey, "key")
        if string.isNullOrEmpty(countTbl.refreshRule) then
          SellShort = true
        end
      end
      if not SellShort and (shopConfig ~= nil and shopConfig.showCondition == nil or ConditionManager.Check4D(shopConfig.showCondition)) then
        table.insert(shopShowTbl, shopConfig)
      end
    end
  end
  return shopShowTbl
end

function ShopData.OpenItemBuyTips(_, showType)
  this.CreatBuyItemInfo(showType.tbl.id)
  UIManager.Show(UIID.ItemTipUI, {
    item = this.currentBuyControl.itemInfo,
    openType = TipsOpenType.ShopOpen,
    showType = showType.showPos
  })
end

local function CheckCountPriceEnough(countPrice)
  local coinConfigId = this.currentBuyControl.costTbl.itemId
  local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(coinConfigId)
  if countPrice > bagCoinCount then
    return false
  else
    return true
  end
end

local maxCount = false

local function ItemCountAdd()
  local maxNum = 99
  if this.currentBuyControl.shopInfo.countKey > 0 then
    local limitCount = RefreshData.GetInstanceCount(this.currentBuyControl.shopInfo.countKey)
    if maxNum > limitCount then
      maxNum = limitCount
    end
  end
  this.buyCount = this.buyCount + this.countAdd
  if maxNum <= this.buyCount then
    if not maxCount then
      maxCount = true
      this.buyCount = maxNum
    else
      maxCount = false
      this.buyCount = this.countAdd
    end
  end
  local countPrice = this.buyCount * this.currentBuyControl.costTbl.count
  if not CheckCountPriceEnough(countPrice) then
    countPrice = string.format("<color=red>%s</color>", countPrice)
  end
  this.showText:SetText(countPrice)
  this.lab_count:SetInputText(this.buyCount)
end

local function ItemCountMinus()
  local maxNum = 99
  if this.currentBuyControl.shopInfo.countKey > 0 then
    local limitCount = RefreshData.GetInstanceCount(this.currentBuyControl.shopInfo.countKey)
    if maxNum > limitCount then
      maxNum = limitCount
    end
  end
  if maxCount then
    this.buyCount = this.buyCount - this.countAdd
    maxCount = false
  else
    this.buyCount = this.buyCount - this.countAdd
  end
  if this.buyCount < 1 and not maxCount then
    maxCount = true
    this.buyCount = maxNum
  end
  local countPrice = this.buyCount * this.currentBuyControl.costTbl.count
  if not CheckCountPriceEnough(countPrice) then
    countPrice = string.format("<color=red>%s</color>", countPrice)
  end
  this.showText:SetText(countPrice)
  this.lab_count:SetInputText(this.buyCount)
end

local function InputFieldOnValueChanged(_, v, eventData)
  if string.isNullOrEmpty(eventData) then
    eventData = 1
  end
  eventData = tonumber(eventData)
  if 99 < eventData then
    eventData = 99
  end
  if this.currentBuyControl.shopInfo.countKey > 0 then
    local limitCount = RefreshData.GetInstanceCount(this.currentBuyControl.shopInfo.countKey)
    if eventData > limitCount then
      eventData = limitCount
    end
  end
  this.buyCount = eventData
  local countPrice = this.buyCount * this.currentBuyControl.costTbl.count
  if not CheckCountPriceEnough(countPrice) then
    countPrice = string.format("<color=red>%s</color>", countPrice)
  end
  this.showText:SetText(countPrice)
  this.lab_count:SetInputText(this.buyCount)
end

function ShopData.CreatBuyItemInfo(buyId)
  local cfgData = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(buyId))
  local shopInfo = ParseUtility.ParseSingleCost(cfgData.reward)
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  local costTbl
  if not string.isNullOrEmpty(cfgData.cost) then
    costTbl = ParseUtility.ParseSingleCost(cfgData.cost)
  end
  if not costTbl then
    costTbl = {}
    costTbl.count = 0
    local shopTypeTbl = {
      1000010,
      1000020,
      1000030,
      1000040
    }
    costTbl.itemId = shopTypeTbl[cfgData.type]
  end
  local buyLimitShow = LimitUtility.GetLimitShow(cfgData.buyCondition)
  local str, limitType = LimitUtility.GetTipText(buyLimitShow, cfgData)
  local control = {
    itemInfo = itemData,
    shopInfo = cfgData,
    costTbl = costTbl,
    ctrl = {limitType = limitType},
    args = {subPosition = 0}
  }
  this.currentBuyControl = control
end

local function ClickUp()
end

function ShopData.ShowShopBuyPanel(_, msg)
  msg.input_price:SetActive(false)
  msg.fixed_price:SetActive(true)
  msg.fixed_price.transform.parent.anchoredPosition = Vector2.right * 17 + Vector2.up * 14.6
  local itemBuyStr = this.currentBuyControl.shopInfo.reward
  this.countAdd = 1
  local priceText = this.currentBuyControl.costTbl.count
  priceText = priceText * this.countAdd
  priceText = CheckCountPriceEnough(priceText) and priceText or string.format("<color=red>%s</color>", priceText)
  msg.fixed_text:SetText(priceText)
  local moneyData = ItemUtility.GenerateItemData(this.currentBuyControl.costTbl.itemId)
  msg.img_icon.moneyModel:RefreshData(moneyData)
  ItemUtility.ShowItemCell(msg.img_icon, msg.img_icon.moneyModel, nil, false, nil, 3, 5)
  msg.lab_InputField:SetInputText(this.countAdd)
  this.buyCount = this.countAdd
  this.showText = msg.fixed_text
  msg.lab_count.transform.parent.gameObject:SetActive(true)
  msg.lab_count:SetActive(false)
  msg.lab_InputField:SetActive(true)
  msg.lab_InputField:SetOnEndEdit(msg.lab_InputField, InputFieldOnValueChanged)
  this.lab_count = msg.lab_InputField
  msg.btn_add:SetActive(true)
  msg.btn_add:SetInteractable(true)
  msg.btn_add:SetOnClick(msg.btn_add, ItemCountAdd)
  msg.btn_add:SetOnPress(msg.btn_add, ItemCountAdd, ClickUp, 1)
  msg.btn_minus:SetActive(true)
  msg.btn_minus:SetInteractable(true)
  msg.btn_minus:SetOnClick(msg.btn_minus, ItemCountMinus)
  msg.btn_minus:SetOnPress(msg.btn_minus, ItemCountMinus, ClickUp, 1)
  msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_buy"))
  
  local function ConfirmBuy()
    local itemLimtType = this.currentBuyControl.ctrl.limitType
    if itemLimtType then
      LimitUtility.NoEnoughPrompt(itemLimtType, msg.buyBtn)
      return
    end
    if this.currentBuyControl.shopInfo.countKey > 0 and this.buyCount > RefreshData.GetInstanceCount(this.currentBuyControl.shopInfo.countKey) then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughCount, msg.buyBtn)
      return
    end
    local coinConfigId = this.currentBuyControl.costTbl.itemId
    local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(coinConfigId)
    if bagCoinCount < this.currentBuyControl.costTbl.count * this.buyCount then
      if coinConfigId == ECoinsType.Score then
        LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughScore, msg.buyBtn)
      else
        LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, msg.buyBtn)
      end
      return
    end
    if not BagInfoData.SafeBagSpaceJudge(this.currentBuyControl.costTbl.itemId, this.buyCount) then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughBgCell, msg.buyBtn)
      return
    end
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = this.currentBuyControl.shopInfo.id,
      buyCount = this.buyCount
    })
    UIManager.Hide(UIID.ItemTipUI)
    msg.buyBtn.transform:GetChild(1).gameObject:SetActive(false)
    if this.currentBuyControl.ctrl.transform then
      local effect = this.currentBuyControl.ctrl.transform:Find("Eff_UI_annuikuang")
      if effect then
        effect.gameObject:SetActive(false)
        if this.currentBuyControl.panel and this.currentBuyControl.panel.args and this.currentBuyControl.panel.args.subPosition then
          this.currentBuyControl.panel.args.subPosition = nil
        end
      end
    end
  end
  
  msg.buyBtn:SetOnClick(msg.buyBtn, function()
    local playerPrefs = string.format("%s_ShopBuyTodayIsShowPromptTipUI_%s", ViewData.meData.id, this.currentBuyControl.shopInfo.type)
    local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
    local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
    if lastRecordTime == 0 or isServerSameDay == false then
      ConfirmBuy()
    else
      ConfirmBuy()
    end
  end)
  if this.currentBuyControl.ctrl and this.currentBuyControl.ctrl.taskType == RoleTaskType.SkillTask then
    msg.buyBtn.transform:GetChild(1).gameObject:SetActive(true)
  end
end
