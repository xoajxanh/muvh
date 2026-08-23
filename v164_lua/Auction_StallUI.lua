Auction_StallUI = class(BaseUI)
Auction_StallUI.layer = UILayer.Panel
Auction_StallUI.orderInLayer = 2
Auction_StallUI.hideType = UIHideType.Destroy
Auction_StallUI.hideFunc = UIHideFunc.MoveOutOfScreen
Auction_StallUI.escClose = UIEscClose.DontClose

function Auction_StallUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.salePanel = self:GetControl("salePanel")
  self.ScrollRect = self:GetControl("salePanel/ScrollRect")
  self.Viewport = self:GetControl("salePanel/ScrollRect/Viewport")
  self.Content = self:GetControl("salePanel/ScrollRect/Viewport/Content")
  self.Button_goodsItem = self:GetControl("salePanel/ScrollRect/Viewport/Content/Button_SaleRackItem")
  self.lab_SellTitil = self:GetControl("img_bg/lab_SellTitil")
  self.btn_sendCloseStall = self:GetControl("btn_sendCloseStall")
  self.btn_openPutAwayPanel = self:GetControl("btn_openPutAwayPanel")
end

function Auction_StallUI:OnPreLoad()
end

function Auction_StallUI:Init()
  self.recTimer = {}
  self.page = 1
  self.pageAuctionItemTab = {}
  self.loadType = true
end

function Auction_StallUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Auction_StallUI:InitUI()
  self:InitContent()
end

local function OnGoodsItemCreate(control)
  control.btn_3DItem = UIControl(control.transform, "itemPanel/btn_3DItem")
  control.lab_name = UIControl(control.transform, "itemPanel/lab_name")
  control.price_value = UIControl(control.transform, "itemPanel/price/price_value")
  control.timeType = UIControl(control.transform, "itemPanel/lab_timeType")
  control.lab_time = UIControl(control.transform, "itemPanel/lab_time")
  control.img_icon = UIControl(control.transform, "itemPanel/price/img_icon")
  control.MyName = UIControl(control.transform, "itemPanel/MyName")
  control.buyNumBG = UIControl(control.transform, "itemPanel/buyNum")
  control.img_buy = UIControl(control.transform, "itemPanel/buyNum/img_buy")
  control.buyNum = UIControl(control.transform, "itemPanel/buyNum/lab_buyNum")
  control.isMeBg = UIControl(control.transform, "itemPanel/isMeBg")
  control.MyNameAutoScrollText = control.MyName.transform:GetComponent("AutoScrollText")
end

function Auction_StallUI:InitContent()
  self.Button_goodsItemTemp = UIContainer(self.Button_goodsItem, self, OnGoodsItemCreate)
end

function Auction_StallUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:ReqAuctionInfo()
end

function Auction_StallUI:OnHide()
  self:RecycleItemModelRes(self.Button_goodsItemTemp)
end

function Auction_StallUI:RecycleItemModelRes(itemTemp)
  for i = 1, #itemTemp.items do
    local showCellData = itemTemp.items[i].itemCellData
    if showCellData then
      showCellData:RecycleRes()
      showCellData = nil
    end
  end
end

function Auction_StallUI:Refresh()
end

function Auction_StallUI:OnDestroy()
end

function Auction_StallUI:RegistEvents()
  self:RegistEvent(Event.Auction_UpdateAuctionData, self.UpdateStallInfoPanel, self)
  self:RegistEvent(Event.Auction_SetPanel, self.Auction_SetPanel, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
end

function Auction_StallUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_sendCloseStall:SetOnClick(self, self.SendCloseStallOnClick)
  self.btn_openPutAwayPanel:SetOnClick(self, self.OpenPutAwayPanelOnClick)
  self.ScrollRect:SetOnEndDrag(self, self.ScrollRectOnEndDrag)
  self.Content = self.Content.transform
end

function Auction_StallUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Auction_StallUI)
  if RoleManager.me.TargetAvatar then
    RoleManager.me.TargetAvatar:OnCancelTouch()
    RoleManager.me.TargetAvatar = nil
  end
end

function Auction_StallUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Auction_StallUI)
  if RoleManager.me.TargetAvatar then
    RoleManager.me.TargetAvatar:OnCancelTouch()
    RoleManager.me.TargetAvatar = nil
  end
end

function Auction_StallUI:OpenPutAwayPanelOnClick(control)
  UIManager.Hide(UIID.Auction_StallUI)
  UIManager.Show(UIID.Auction_AuctionUI, {
    openFirstTab = AuctionTileTabType.MyAuction,
    openSecondTab = {}
  })
  if RoleManager.me.TargetAvatar then
    RoleManager.me.TargetAvatar:OnCancelTouch()
    RoleManager.me.TargetAvatar = nil
  end
end

function Auction_StallUI:SendCloseStallOnClick(control)
  local textContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Stall_7")
  local title = {
    title = "",
    textContent = textContent,
    cancelText = nil,
    okText = nil,
    cancel = nil,
    ok = self.btn_SendCloseStallOnClick,
    okArgs = nil
  }
  UIManager.Show(UIID.PromptTipUI, title)
end

function Auction_StallUI.btn_SendCloseStallOnClick()
  AuctionController.ReqCloseAuctionMessage(TradeMessage.ReqCloseAuction)
  UIManager.Hide(UIID.Auction_StallUI)
end

function Auction_StallUI:Button_btn_buy(control)
  if AuctionData.RoleID == control.itemInfo.sellerId then
    TipUtility.ShowPrompt("tishi", "AuctionTips_4")
    return
  end
  self.OnePriceItem = control.itemInfo
  local itemInfo = AuctionData.GetItemConfigInfo(control.itemInfo.item)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemInfo,
    ctrl = control,
    rightOperate = EItemOperateType.Show,
    openType = TipsOpenType.AuctionOpen,
    buyType = control.buyType,
    contrast = true,
    isAuction = true
  })
end

function Auction_StallUI:ReqAuctionInfo()
  if self.args and self.args.position then
    local toServerMsg = {}
    toServerMsg.position = self.args.position
    AuctionController.ReqAuctionInfo(TradeMessage.ReqAuctionInfo, toServerMsg)
  end
end

function Auction_StallUI:Auction_SetPanel(_, msg)
  self.buyType = msg.type
  self.lab_count = msg.lab_count
  self.input_price = msg.AuctionInputPrice
  self.inputText_price = msg.AuctionInputTextPrice
  self.MaxCount = msg.itemInfo.count
  self.PutOnBtn = msg.AuctionBtn
  self.input_price:SetInputText(1)
  self.input_price:SetInteractable(true)
  self.lab_count.transform:GetComponent("Text").color = Color.white
  self.lab_count:SetText(self.MinNum)
  if msg.itemInfo.tblItem.salenum == 0 then
    self.MinNum = 1
  else
    self.MinNum = msg.itemInfo.tblItem.salenum
  end
  if msg.itemInfo.count <= 1 then
    msg.count:SetActive(false)
    msg.price.transform.localPosition = Vector3(17, 40, 0)
  else
    msg.count:SetActive(true)
    msg.price.transform.localPosition = Vector3(17, 15, 0)
  end
  if self.buyType == AuctionTipOpenType.putOn then
  elseif self.buyType == AuctionTipOpenType.appoint then
    msg.priceTitle:SetText("Gi\195\161")
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_subscribe"))
    local needCount = tonumber(self.OnePriceItem.highPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.lab_count:SetText(msg.itemInfo.count)
    self.input_price:SetInteractable(false)
  elseif self.buyType == AuctionTipOpenType.putOff then
  elseif self.buyType == AuctionTipOpenType.unionBuy then
  elseif self.buyType == AuctionTipOpenType.unionOneBuy then
  else
    msg.priceTitle:SetText("Gi\195\161")
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_buy"))
    local needCount = tonumber(self.OnePriceItem.highPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.input_price:SetInteractable(false)
    self.lab_count:SetText(msg.itemInfo.count)
  end
  local itemMoney = ClientTable.cfg_Item_itemManager:TryGetValue(msg.itemInfo.itemId, "id").auction
  if itemMoney ~= "" then
    local iconId = string.split(string.split(itemMoney, "&")[1], "#")[2]
    local moneyData = ItemUtility.GenerateItemData(tonumber(iconId) or 1000020)
    msg.img_icon.moneyModel:RefreshData(moneyData)
    ItemUtility.ShowItemCell(msg.img_icon, msg.img_icon.moneyModel, nil, false)
  end
  msg.AuctionBtn:SetOnClick(self, self.AuctionBtnOnClick)
end

function Auction_StallUI:OnCoinChanged(_, msg)
  self:RefreshCoin()
  self:RefreshUIGrid()
end

function Auction_StallUI:RefreshCoin()
end

function Auction_StallUI:RefreshUIGrid()
  local toServerMsg = {}
  toServerMsg.position = AuctionData.stallAuctionInfo.position
  AuctionController.ReqAuctionInfo(TradeMessage.ReqAuctionInfo, toServerMsg)
end

function Auction_StallUI:ScrollRectOnEndDrag(id, msg)
end

function Auction_StallUI:AuctionBtnOnClick()
  if self.buyType == AuctionTipOpenType.putOn then
  elseif self.buyType == AuctionTipOpenType.appoint then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.GetColorText("Sau khi k\225\186\191t th\195\186c th\225\187\157i k\225\187\179 c\195\180ng b\225\187\145, <color=#1add1f>b\225\187\145c ra 1 ng\198\176\225\187\157i ch\198\161i nh\225\186\173n v\225\186\173t ph\225\186\169m n\195\160y</color> t\225\187\171 trong ng\198\176\225\187\157i ch\198\161i \196\145\225\186\183t mua tr\198\176\225\187\155c\nNg\198\176\225\187\157i ch\198\161i kh\195\161c ho\195\160n tr\225\186\163 ti\225\187\129n \196\145\225\186\183t mua qua th\198\176", "#DCE1E5"),
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        self:btn_directBuyPanelBuyOnClick()
      end
    })
  elseif self.buyType == AuctionTipOpenType.putOff then
  elseif self.buyType == AuctionTipOpenType.unionBuy then
  elseif self.buyType == AuctionTipOpenType.unionOneBuy then
  else
    self:btn_directBuyPanelBuyOnClick()
  end
end

function Auction_StallUI:btn_directBuyPanelBuyOnClick()
  local scaleNum = 0
  if self.OnePriceItem.item ~= nil then
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(self.OnePriceItem.item.itemId)
    if itemConfig.salenum == 0 then
      scaleNum = 1
    else
      scaleNum = itemConfig.salenum
    end
  end
  local price = tonumber(self.input_price:GetInputText())
  if price > BagInfoData.GetItemCountByItemConfigId(tonumber(self.OnePriceItem.pItemId)) and self.OnePriceItem.pItemId == 1000030 then
    UIManager.Hide(UIID.ItemTipUI)
    UIManager.Hide(UIID.PromptTipUI)
    RechargeData.BuyDiamond()
    return
  end
  if self.OnePriceItem.preBuyer ~= nil and 0 < #self.OnePriceItem.preBuyer and self:IsMeBuyer(self.OnePriceItem.preBuyer) then
    FloatingTipUtility.QuickMsg("B\225\186\161n \196\145\195\163 thanh to\195\161n r\225\187\147i")
    UIManager.Hide(UIID.ItemTipUI)
    return
  elseif price > BagInfoData.GetItemCountByItemConfigId(self.OnePriceItem.pItemId) then
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
    UIManager.Hide(UIID.ItemTipUI)
    return
  end
  NetManager.Send(TradeMessage.ReqStartBuy, {
    centerHostId = 0,
    hostId = 0,
    tid = self.OnePriceItem.tid,
    buyPrice = price,
    type = self.OnePriceItem.type,
    count = tonumber(self.lab_count:GetText())
  })
  UIManager.Hide(UIID.ItemTipUI)
end

function Auction_StallUI:UpdateStallInfoPanel()
  if AuctionData.stallAuctionInfo == nil then
    return
  end
  local colorCode = ""
  local isMyStall = false
  if AuctionData.stallAuctionInfo.materId == ViewData.meData.id then
    colorCode = ItemQuality2ColorDic[5]
    isMyStall = true
    self.btn_sendCloseStall:SetActive(true)
    self.btn_openPutAwayPanel:SetActive(true)
  else
    colorCode = ItemQuality2ColorDic[0]
    isMyStall = false
    self.btn_sendCloseStall:SetActive(false)
    self.btn_openPutAwayPanel:SetActive(false)
  end
  local titles = string.split(AuctionData.stallAuctionInfo.title, "#")
  local titleStr = ""
  for i = 1, #titles do
    titleStr = titleStr .. titles[i]
  end
  self.lab_SellTitil:SetText(string.GetColorText(titleStr, colorCode))
  self:DesToryRecTimer()
  for i = 1, #self.pageAuctionItemTab do
    self.pageAuctionItemTab[i]:SetActive(false)
  end
  local PutOnInfo = AuctionData.stallAuctionInfo.shelf
  if #PutOnInfo == 0 then
    UIManager.Show(UIID.PromptTipUI, {
      tile = "Nh\225\186\175c nh\225\187\159",
      textContent = "V\225\186\173t ph\225\186\169m \225\187\159 s\225\186\161p \196\145\195\163 b\225\187\139 mua h\225\186\191t"
    })
  end
  if 0 < #PutOnInfo then
    self.pageAuctionItemTab = {}
    for i = 1, #PutOnInfo do
      local PutOnInfoData = PutOnInfo[i]
      local obj = self.Button_goodsItemTemp:GetOrCreateItem(i)
      local itemInfo = AuctionData.GetItemConfigInfo(PutOnInfoData.items.item)
      local item = ClientTable.cfg_Item_itemManager:TryGetValue(PutOnInfoData.items.item.itemId, "id")
      local price = PutOnInfoData.items.highPrice * self:SwitchPrice(PutOnInfoData.items.item.count, PutOnInfoData.items.item.itemId)
      local haveCount = BagInfoData.GetItemCountByItemConfigId(PutOnInfoData.items.pItemId)
      if price <= haveCount then
        price = string.GetColorText(price, ItemQuality2ColorDic[0])
      else
        price = string.GetColorText(price, ItemQuality2ColorDic[7])
      end
      obj.price_value:SetText(price)
      obj.item = item
      local addTime = math.modf(PutOnInfoData.items.addTime / 1000)
      local endTime = math.modf(PutOnInfoData.items.endTime / 1000)
      self:CreatRecTimer(i, obj, addTime, endTime, AuctionRecTimer.AuctionTab)
      local titleStr = string.GetColorText(itemInfo.tblItem.name, ItemQuality2ColorDic[itemInfo.tblItem.colorShow])
      obj.lab_name:SetText(titleStr)
      local textWidth = obj.lab_name.text.preferredWidth
      local bgWith = obj.lab_name:GetSizeDelta()
      if textWidth > bgWith then
        obj.MyNameAutoScrollText.text = titleStr
        obj.lab_name:SetActive(false)
        obj.MyName:SetActive(true)
      else
        obj.lab_name:SetActive(true)
        obj.MyName:SetActive(false)
      end
      if PutOnInfoData.items.preBuyer ~= nil and 0 < #PutOnInfoData.items.preBuyer then
        obj.img_buy:SetActive(true)
        obj.buyNum:SetActive(true)
        obj.buyNum:SetText(#PutOnInfoData.items.preBuyer or 0)
      else
        obj.img_buy:SetActive(false)
        obj.buyNum:SetActive(false)
      end
      if isMyStall then
        local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
        self:SetSprite("Atlas_headPortrait", AuctionData.CareerType[career], obj.isMeBg, false)
        obj.isMeBg:SetActive(true)
      else
        obj.isMeBg:SetActive(false)
      end
      if item.auction ~= "" then
        local iconId = string.split(string.split(item.auction, "&")[1], "#")[2]
        self:SetSprite("Atlas_Common", iconId, obj.img_icon, false)
      end
      obj.itemInfo = PutOnInfoData.items
      obj.itemCellData = obj.itemCellData or ItemCellData()
      obj:SetOnClick(self, self.Button_btn_buy)
      if itemInfo.count == 1 then
        itemInfo.count = nil
      end
      obj.itemCellData:RefreshData(itemInfo)
      ItemUtility.ShowItemCell(obj.btn_3DItem, obj.itemCellData, self)
      obj:SetActive(true)
      table.insert(self.pageAuctionItemTab, obj.gameObject)
    end
  end
  if self.loadType and 2 <= self.page then
    self.Content.localPosition = Vector3.zero
  end
end

function Auction_StallUI:IsMeBuyer(preBuyer)
  for i = 1, #preBuyer do
    if RoleManager.me.id == preBuyer[i].id then
      return true
    end
  end
  return false
end

function Auction_StallUI:SwitchPrice(beforePrice, itemId)
  local laterPriceCount = beforePrice
  if itemId ~= nil then
    local scaleNum
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
    if itemConfig.salenum == 0 then
      scaleNum = 1
    else
      scaleNum = itemConfig.salenum
    end
    laterPriceCount = math.floor(beforePrice / scaleNum)
  elseif self.MinNum ~= nil then
    laterPriceCount = math.floor(beforePrice / self.MinNum)
  end
  return laterPriceCount
end

function Auction_StallUI:CreatRecTimer(i, obj, addTime, endTime, TimeType)
  local curTime = Time.GetServerSecondTime()
  local surplusTime = endTime - curTime
  local publicTime = math.modf(addTime + obj.item.auctionPublicityTime / 1000 - curTime)
  if publicTime <= 0 then
    publicTime = 0
    obj.buyNumBG:SetActive(false)
  end
  
  local function UpdateRecommendBtn()
    if obj ~= nil and IsNil(obj.gameObject) == false then
      if 0 < publicTime then
        local timeStr = TimeUtility.ShowTimeReserveWithColon(publicTime)
        obj.lab_time:SetText(timeStr)
        obj.timeType:SetText(LocalizationUtility.GetContentByKey("Auction_gongshitime"))
        obj.buyType = AuctionTipOpenType.appoint
        obj.timeType:SetActive(true)
        obj.lab_time:SetActive(true)
        obj.buyNumBG:SetActive(true)
        publicTime = publicTime - 1
        surplusTime = surplusTime - 1
      else
        if surplusTime <= 0 then
          surplusTime = 0
        end
        local timeStr = TimeUtility.ShowTimeReserveWithColon(surplusTime)
        obj.lab_time:SetText(timeStr)
        obj.timeType:SetText("Th\225\187\157i gian l\195\170n k\225\187\135: ")
        obj.buyType = AuctionTipOpenType.buy
        obj.buyNumBG:SetActive(false)
        obj.timeType:SetActive(false)
        obj.lab_time:SetActive(false)
        if self.recTimer[i] then
          Timer.Stop(self.recTimer[i])
          self.recTimer[i] = nil
        end
        surplusTime = surplusTime - 1
      end
    end
  end
  
  if self.recTimer[i] == nil then
    local data = {timeType = TimeType}
    self.recTimer[i] = Timer.StartLoop(1, surplusTime, UpdateRecommendBtn, data)
  end
end

function Auction_StallUI:SetInputTextColor(inputTextColor, needItemId, needCount)
  if inputTextColor == nil then
    return
  end
  local bagCount = BagInfoData.GetItemCountByItemConfigId(needItemId)
  local colorCountStr = needCount <= bagCount and Color.paleYellow or Color.red
  inputTextColor.transform:GetComponent("Text").color = colorCountStr
end

function Auction_StallUI:ResetInputTextColor(inputTextColor, needItemId, needCount)
  if inputTextColor == nil then
    return
  end
  inputTextColor.transform:GetComponent("Text").color = Color.paleYellow
end

function Auction_StallUI:DesToryRecTimer()
  for k, v in pairs(self.recTimer) do
    Timer.Stop(self.recTimer[k])
    self.recTimer[k] = nil
  end
end
