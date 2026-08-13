Commercial_LimitedTimeActivityUI = class(BaseUI)
Commercial_LimitedTimeActivityUI.layer = UILayer.Panel
Commercial_LimitedTimeActivityUI.orderInLayer = 2
Commercial_LimitedTimeActivityUI.hideType = UIHideType.WaitDestroy
Commercial_LimitedTimeActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_LimitedTimeActivityUI.escClose = UIEscClose.DontClose

function Commercial_LimitedTimeActivityUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.sw_HolidayActivityList = self:GetControl("sw_HolidayActivityList")
  self.Btn_Holiday = self:GetControl("sw_HolidayActivityList/Viewport/Content/Btn_Holiday")
  self.go_holidayFireworks = self:GetControl("go_holidayFireworks")
  self.btn_FireworkShow = self:GetControl("go_holidayFireworks/CigaretteShow/sw_FireworkProp/Viewport/Content/btn_FireworkShow")
  self.FireworkProp = self:GetControl("go_holidayFireworks/CigaretteShow/sw_FireworkBuy/Viewport/Content/FireworkProp")
  self.FullServerTitle = self:GetControl("go_holidayFireworks/expLog/FullServerTitle")
  self.PersonalTitle = self:GetControl("go_holidayFireworks/expLog/PersonalTitle")
  self.lab_Event = self:GetControl("go_holidayFireworks/expLog/expLogs/scroll_logs/Viewport/Content/lab_Event")
  self.FireworksfireTime = self:GetControl("go_holidayFireworks/FireworksfireTime")
  self.sw_Accumulates = self:GetControl("go_holidayFireworks/sw_Accumulates")
  self.lab_FireworksCount = self:GetControl("go_holidayFireworks/sw_Accumulates/NumberOfTimes/lab_FireworksCount")
  self.Accumulates_Content = self:GetControl("go_holidayFireworks/sw_Accumulates/Viewport/Accumulates_Content")
  self.FireworkGiftProp = self:GetControl("go_holidayFireworks/sw_Accumulates/Viewport/Accumulates_Content/FireworkGiftProp")
  self.Img_AccumulatesArrow = self:GetControl("go_holidayFireworks/sw_Accumulates/Img_AccumulatesArrow")
  self.Img_AccumulatesArrow2 = self:GetControl("go_holidayFireworks/sw_Accumulates/Img_AccumulatesArrow2")
  self.go_holidayGift = self:GetControl("go_holidayGift")
  self.sw_holidayGift = self:GetControl("go_holidayGift/sw_holidayGift")
  self.holidayGift_Content = self:GetControl("go_holidayGift/sw_holidayGift/Viewport/holidayGift_Content")
  self.bg_holidayGist = self:GetControl("go_holidayGift/sw_holidayGift/Viewport/holidayGift_Content/bg_holidayGist")
  self.go_holidayGiftItemBuy = self:GetControl("go_holidayGiftItemBuy")
  self.bg_holidayGiftItemBuy = self:GetControl("go_holidayGiftItemBuy/sw_holidayGift/Viewport/holidayGift_Content/bg_holidayGist")
  self.sw_holidayGiftItemBuy = self:GetControl("go_holidayGiftItemBuy/sw_holidayGift")
  self.holidayGiftItemBuy_Content = self:GetControl("go_holidayGiftItemBuy/sw_holidayGift/Viewport/holidayGift_Content")
  self.Img_itemBuyArrow = self:GetControl("go_holidayGiftItemBuy/sw_holidayGift/Img_rechangeArrow")
  self.Img_itemBuyArrow2 = self:GetControl("go_holidayGiftItemBuy/sw_holidayGift/Img_rechangeArrow2")
  self.Img_rechangeArrow = self:GetControl("go_holidayGift/sw_holidayGift/Img_rechangeArrow")
  self.Img_rechangeArrow2 = self:GetControl("go_holidayGift/sw_holidayGift/Img_rechangeArrow2")
  self.go_holidayBoos = self:GetControl("go_holidayBoos")
  self.lab_BoosnotRefresh = self:GetControl("go_holidayBoos/lab_BoosnotRefresh")
  self.btn_DropDisItem = self:GetControl("go_holidayBoos/DropDisplay/sw_DropDisplay/Viewport/Content/btn_DropDisItem")
  self.GoPiont = self:GetControl("go_holidayBoos/content/GoPiont")
  self.go_holidayCollect = self:GetControl("go_holidayCollect")
  self.Item_holidayCollect = self:GetControl("go_holidayCollect/sw_holidayCollect/Viewport/Content/Item_holidayCollect")
  self.go_holidayExperience = self:GetControl("go_holidayExperience")
  self.btn_goExperience = self:GetControl("go_holidayExperience/btn_goExperience")
  self.tip_Experience = self:GetControl("go_holidayExperience/tip_Experience")
  self.go_holidayShop = self:GetControl("go_holidayShop")
  self.go_Shopitem = self:GetControl("go_holidayShop/Viewport/Content/go_Shopitem")
  self.btn_3DItem = self:GetControl("go_holidayShop/Viewport/Content/go_Shopitem/btn_3DItem")
  self.lab_buy = self:GetControl("go_holidayShop/Viewport/Content/go_Shopitem/btn_buy/lab_buy")
  self.img_redPoint = self:GetControl("go_holidayShop/Viewport/Content/go_Shopitem/btn_buy/img_redPoint")
  self.holidayShopcoin = self:GetControl("go_holidayShop/bg/holidayShopcoin")
  self.lab_holidayShopcoin = self:GetControl("go_holidayShop/lab_holidayShopcoin")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
  self.go_rechangeGet = self:GetControl("go_rechangeGet")
  self.sw_rechangeGet = self:GetControl("go_rechangeGet/sw_rechangeGet")
  self.Btn_rechangeGet = self:GetControl("go_rechangeGet/sw_rechangeGet/Viewport/Content/Btn_rechangeGet")
  self.img_datarankBg = self:GetControl("go_rechangeGet/sw_spirtsrankList/Viewport/Content/img_datarankBg")
  self.img_dataSelfTaskBg = self:GetControl("go_rechangeGet/img_dataSelfTaskBg")
  self.SelfTaskbtn_Item = self:GetControl("go_rechangeGet/img_dataSelfTaskBg/sw_gift/Viewport/Content/SelfTaskbtn_Item")
  self.btn_SelfTaskRecharge = self:GetControl("go_rechangeGet/img_dataSelfTaskBg/btns/btn_SelfTaskRecharge")
  self.btn_SelfTaskGet = self:GetControl("go_rechangeGet/img_dataSelfTaskBg/btns/btn_SelfTaskGet")
  self.lab_SelfTaskReceived = self:GetControl("go_rechangeGet/img_dataSelfTaskBg/btns/lab_SelfTaskReceived")
  self.go_turntable = self:GetControl("go_turntable")
  self.go_holidayLuckyTurntable = self:GetControl("go_holidayLuckyTurntable")
  self.go_EquipZhuFuAngel = self:GetControl("go_EquipZhuFuAngel")
  self.lab_Text = self:GetControl("go_EquipZhuFuAngel/Viewport/Content/suitContainer/lab_TipSuitAdditional/lab")
  self.go_mountShow = self:GetControl("go_mountShow")
  self.img_Mount1 = self:GetControl("go_mountShow/Viewport/Content/img_liuguang")
  self.img_Mount2 = self:GetControl("go_mountShow/Viewport/Content/img_liuguang2")
  self.img_Mount3 = self:GetControl("go_mountShow/Viewport/Content/img_liuguang3")
  self.go_WorldCup = self:GetControl("go_WorldCup")
  self.go_holidayDailyGifts = self:GetControl("go_holidayDailyGifts")
  self.go_holidayPetInvest = self:GetControl("go_holidayPetInvest")
  self.go_holidaySevenDayGifts = self:GetControl("go_holidaySevenDayGifts")
  self.go_holidayBaoZhuTreasure = self:GetControl("go_holidayBaoZhuTreasure")
  self.go_holidayRechargeInvestment = self:GetControl("go_holidayRechargeInvestment")
  self.go_combineWarOrderPass = self:GetControl("go_combineWarOrderPass")
end

function Commercial_LimitedTimeActivityUI:Init()
  self.modeViewerList = {}
  self.mountUITab = {}
  self.mountModelTab = {}
  CommercialTimeLimitedActivityData.InitInfo()
end

function Commercial_LimitedTimeActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function GetUIText(title)
  if string.isNullOrEmpty(title) then
    return ""
  end
  return LocalizationUtility.GetContentByKey(title)
end

local function OnBtnItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnBtnItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnBtnHolidayCreat(ctr)
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnBtnHolidayRefresh(ctr, _, data, ui)
  ctr.lab_name:SetText(data.commerceName)
  ctr.img_clickeffect:SetActive(data.Selected)
  ctr.img_redPoint:SetActive(RedPointChecker_Ext:GetTogTimeLimitedRedPoint(CommerceTimeLimitedRedTogType[data.group]))
  ctr.data = data
  ctr:SetOnClick(ui, ui.BtnHolidayOnClick)
end

local function OnHolidayGistCreat(ctr)
  ctr.lab_holidayGistName = UIControl(ctr.transform, "lab_holidayGistName")
  ctr.lab_limitNum = UIControl(ctr.transform, "lab_limit/lab_limitNum")
  ctr.btn_Item = UIControl(ctr.transform, "go_holidayGistItem/sw_ItemSecondary/Viewport/Content/btn_Item")
  ctr.btn_freePrize = UIControl(ctr.transform, "btn_freePrize")
  ctr.lab_buy = UIControl(ctr.transform, "btn_freePrize/lab_buy")
  ctr.img_sellOut = UIControl(ctr.transform, "img_sellOut")
end

local function OnHolidayGistRefresh(ctr, _, data, ui)
  local Title = GetUIText(data.title)
  ctr.lab_holidayGistName:SetText(Title)
  ctr.btn_freePrize:SetActive(data.Received)
  ctr.img_sellOut:SetActive(not data.Received)
  if data.RefreshCount then
    ctr.lab_limitNum:SetText("L\198\176\225\187\163t mua c\195\178n: " .. data.RefreshCount)
  else
    local countTbl = CommercialTimeLimitedActivityData.GetCountInfoFun(data.countKey)
    ctr.lab_limitNum:SetText("L\198\176\225\187\163t mua c\195\178n: " .. countTbl.refreshCountLimit)
  end
  if ctr.GistBtnItemContainer == nil then
    ctr.GistBtnItemContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  local Gift
  if data.rmb then
    local rmb = math.floor(data.rmb)
    if #tostring(rmb) > 4 then
      ctr.lab_buy:SetText("" .. math.floor(rmb / 1000) .. "K VND")
    else
      ctr.lab_buy:SetText("" .. rmb .. "VND")
    end
    local BoxItem = CommercialTimeLimitedActivityData.GetBoxinfoFun(data.reward)
    ctr.GistBtnItemContainer:SetData(BoxItem)
    local Title = GetUIText(data.title) ~= "" and string.format(GetUIText(data.title), rmb) or ""
    ctr.lab_holidayGistName:SetText(Title)
  else
    Gift = {}
    local cost = string.split(data.cost, "#")
    local costlab = CommercialTimeLimitedActivityData.GetItemInfoFun(EBindCoinsType[tonumber(cost[1])]).name
    Gift.cost = tonumber(cost[1])
    Gift.count = tonumber(cost[2])
    ctr.lab_buy:SetText(cost[2] .. costlab)
    local BoxItem = CommercialTimeLimitedActivityData.GetBoxinfoFun(data.reward)
    ctr.GistBtnItemContainer:SetData(BoxItem)
    local Title = GetUIText(data.title) ~= "" and string.format(GetUIText(data.title), cost[1]) or ""
    ctr.lab_holidayGistName:SetText(Title)
  end
  ctr.btn_freePrize.data = data
  ctr.btn_freePrize.Gift = Gift
  ctr.btn_freePrize:SetOnClick(ui, ui.btn_PrizeBuyOnClick)
end

local function OnBoosAwardItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local EffectScale = Vector3(2.3, 2.3, 500)

local function OnBoosAwardItemRefresh(ctr, _, awardData, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(awardData.id))
  itemData.count = tonumber(awardData.count)
  ctr.itemCellData:RefreshData(itemData)
  if awardData.isEff and not ctr.Eff then
    ctr.Eff = UIEffectUtility.SetUIEffect("Eff_UI_xuanshangjiangli02", ctr, true, EffectScale)
  elseif not awardData.isEff and ctr.Eff then
    ctr.Eff:SetActive(false)
  elseif awardData.isEff and ctr.Eff then
    ctr.Eff:SetActive(true)
  end
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

local function OnPointCreate(ctr)
  ctr.mapPiont = UIControl(ctr.transform, "mapPiont")
  ctr.txtPiont = UIControl(ctr.transform, "txtCont")
end

local function OnPointRefresh(ctr, i, data, ui)
  local mapname = CommercialTimeLimitedActivityData.GetMapInfoFun(data.mapId).name
  ctr.mapPiont:SetText(mapname)
  ctr.txtPiont:SetText(data.num .. " ch\225\187\137 ")
  local ZhiHui = data.num <= 0 and MaterialUtility.GetGreyMat() or nil
  ctr:SetMaterial(ZhiHui)
  ctr.data = data
  ctr:SetOnClick(ui, ui.btn_DropDispointOnClick)
end

local function OnFireworkPropCreate(ctr)
  ctr.btn_FireworkProp = UIControl(ctr.transform, "btn_FireworkProp")
  ctr.btn_FireworkBuy = UIControl(ctr.transform, "btn_FireworkBuy")
  ctr.lab_FireworkBuy = UIControl(ctr.transform, "btn_FireworkBuy/lab_FireworkBuy")
  ctr.img_FireworkBuy = UIControl(ctr.transform, "btn_FireworkBuy/img_FireworkBuy")
  ctr.itemCtr = ItemUtility.InitItemCell(ctr.btn_FireworkProp)
  ctr.modelData = ItemCellData()
end

local function OnFireworkPropRefresh(ctr, i, data, ui)
  local reward = string.split(data.reward, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(reward[1]))
  itemData.count = tonumber(reward[2])
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local cost = string.split(data.cost, "#")
  local Gift = {}
  Gift.cost = tonumber(cost[1])
  Gift.count = tonumber(cost[2])
  local color = BagInfoData.GetItemTotalCountByItemId(Gift.cost) < Gift.count and "#ff2323" or "#fbd994"
  ctr.lab_FireworkBuy:SetText(string.GetColorText(Gift.count, color))
  ui:SetSprite("Atlas_Common", EBindCoinsType[Gift.cost], ctr.img_FireworkBuy)
  ctr.btn_FireworkBuy.data = data
  ctr.btn_FireworkBuy.Gift = Gift
  ctr.btn_FireworkBuy:SetOnClick(ui, ui.btn_PrizeBuyOnClick)
end

local function OnFireworkBulletinPropCreate(ctr)
  ctr.ImgTop = UIControl(ctr.transform, "ImgTop")
end

local function OnFireworkBulletinPropRefresh(ctr, i, data, ui)
  ctr.ImgTop:SetActive(data.Top == true)
  local chat = CommercialTimeLimitedActivityData.FireworksBulletinChat
  local inputData, itemname = CommercialTimeLimitedActivityData.GetChatTextFun(data.configId)
  local text = string.format(chat, data.name, ItemQuality2ColorDic[inputData["[system:1]"].itemData.tblItem.colorShow], itemname)
  text = data.Top and "           " .. text or text
  ctr:SetText(text)
  ctr.inputData = inputData
  ctr:SetOnTextPointerClick(ui, ui.ExecuteTextOrder)
end

local function OnfinishItemCreat(ctr)
  ctr.img_mask = UIControl(ctr.transform, "img_mask")
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnfinishItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  local bagcount = BagInfoData.GetItemTotalCountByItemId(data.itemId)
  itemData.count = 1 < bagcount and bagcount or 1
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  ctr.img_mask:SetActive(data.finish)
end

local function OnCollectCreate(ctr)
  ctr.exchange_Item = UIControl(ctr.transform, "sw_exchange/Viewport/Content/exchange_Item")
  ctr.exchange_gift = UIControl(ctr.transform, "exchange_gift")
  ctr.img_mask = UIControl(ctr.transform, "exchange_gift/img_mask")
  ctr.btn_exchange = UIControl(ctr.transform, "btn_exchange")
  ctr.img_redPoint = UIControl(ctr.transform, "btn_exchange/img_redPoint")
  ctr.lab_exchange = UIControl(ctr.transform, "btn_exchange/lab_exchange")
  ctr.lab_notimes = UIControl(ctr.transform, "lab_notimes")
  ctr.itemCtr = ItemUtility.InitItemCell(ctr.btn_exchange)
  ctr.modelData = ItemCellData()
end

local function OnCollectRefresh(ctr, i, data, ui)
  local CollectGroup = {}
  local Collect = string.split(data.itemId, "&")
  local finishCount = 0
  for i, v in pairs(Collect) do
    local split = string.split(v, "#")
    local itemData = {}
    itemData.itemId = tonumber(split[1])
    itemData.count = tonumber(split[2])
    itemData.finish = BagInfoData.GetItemTotalCountByItemId(itemData.itemId) < itemData.count
    if not itemData.finish then
      finishCount = finishCount + 1
    end
    table.insert(CollectGroup, itemData)
  end
  if ctr.BtnItemContainer == nil then
    ctr.BtnItemContainer = UIContainer(ctr.exchange_Item, ui, OnfinishItemCreat, OnfinishItemRefresh)
  end
  ctr.BtnItemContainer:SetData(CollectGroup)
  local reward = {}
  if string.contains(data.reward, "_") then
    local Group = string.split(data.reward, "&")
    for i, v in pairs(Group) do
      local Items = string.split(v, "_")
      if RoleUtility.CareerJudge(ViewData.meData.career, tonumber(Items[1])) then
        local item = string.split(Items[2], "#")
        reward = {
          [1] = item[1],
          [2] = item[2]
        }
      end
    end
  else
    reward = string.split(data.reward, "#")
  end
  local itemData = ItemUtility.GenerateItemData(tonumber(reward[1]))
  itemData.count = tonumber(reward[2])
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.exchange_gift, ctr.modelData, ui, true)
  local Refresh, count = CommercialTimeLimitedActivityData.GetRefreshCountFun(data.countkey)
  count = count or CommercialTimeLimitedActivityData.GetCountInfoFun(data.countkey).refreshCountLimit
  local Str = string.format(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalitem2"), count)
  ctr.lab_notimes:SetText(Str)
  local Allfinish = finishCount >= #CollectGroup and 0 < count
  ctr.img_mask:SetActive(not Allfinish)
  ctr.img_redPoint:SetActive(Allfinish)
  local lab_exchange = 0 < count and (finishCount >= #CollectGroup and "Nh\225\186\173n" or "Ch\198\176a ho\195\160n th\195\160nh") or "\196\144\195\163 nh\225\186\173n xong"
  ctr.lab_exchange:SetText(lab_exchange)
  local ZhiHui = not Allfinish and MaterialUtility.GetGreyMat() or nil
  ctr.btn_exchange:SetMaterial(ZhiHui)
  ctr.btn_exchange.finish = Allfinish
  ctr.btn_exchange.data = data
  ctr.btn_exchange.count = count
  ctr.btn_exchange:SetOnClick(ui, ui.btn_exchangeOnClick)
end

local function OnShopCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_3DItem"))
  ctr.itemCtr.img_grrow.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = false
  ctr.itemModelData = ItemCellData()
  ctr.moneyCtr = UIControl(ctr.transform, "btn_money")
  ctr.txt_buylimit = UIControl(ctr.transform, "txt_buylimit")
  ctr.buyCtr = UIControl(ctr.transform, "Img_bg")
  ctr.costModelData = ItemCellData()
  ctr.Img_bg = UIControl(ctr.transform, "Img_bg")
  ctr.bgBlack = UIControl(ctr.transform, "bgBlack")
  ctr.lab_buylimit = UIControl(ctr.transform, "lab_buylimit")
  ctr.img_money_ground = UIControl(ctr.transform, "btn_money/img_money_ground")
  ctr.lab_num = UIControl(ctr.transform, "btn_money/lab_num")
end

local function OnShopRefresh(ctr, _, data, ui)
  local shopInfo = ParseUtility.ParseSingleCost(data.reward)
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  itemData.count = shopInfo.count
  ctr.itemModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.itemModelData, ui, true)
  local tbl = CommercialTimeLimitedActivityData.GetItemInfoFun(shopInfo.itemId)
  local itemName = tbl.name
  if tbl.colorShow > 0 then
    itemName = string.format("<color=%s>%s</color>", ItemQuality2ColorDic[tbl.colorShow], itemName)
  end
  ctr.itemCtr.nameCtr:SetText(itemName)
  local RefreshCount = data.RefreshCount
  if RefreshCount then
    ctr.lab_buylimit:SetText(RefreshCount .. "A")
  else
    local countTbl = CommercialTimeLimitedActivityData.GetCountInfoFun(data.countKey)
    RefreshCount = countTbl.refreshCountLimit
    ctr.lab_buylimit:SetText(RefreshCount .. "A")
  end
  ctr.bgBlack:SetActive(RefreshCount <= 0)
  local Gift = {}
  local cost = string.split(data.cost, "#")
  Gift.cost = tonumber(cost[1])
  Gift.count = tonumber(cost[2])
  local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(Gift.cost)
  local numStr = Gift.count
  if bagCoinCount < Gift.count then
    numStr = string.format("<color=red>%s</color>", numStr)
  end
  ctr.lab_num:SetText(numStr)
  local img = CommercialTimeLimitedActivityData.GetItemInfoFun(Gift.cost).icon
  ui:SetSprite("Atlas_Common", img, ctr.img_money_ground, false)
  ctr.Img_bg.data = data
  ctr.Img_bg.itemData = itemData
  ctr.Img_bg:SetOnClick(ui, ui.btn_ShopBuyOnClick)
end

local function OnFireworkGiftPropCreate(ctr)
  ctr.lab_GiftCount = UIControl(ctr.transform, "lab_GiftCount")
  ctr.btn_GiftProp = UIControl(ctr.transform, "btn_GiftProp")
  ctr.img_mask = UIControl(ctr.transform, "btn_GiftProp/img_mask")
  ctr.btn_Getgift = UIControl(ctr.transform, "btn_Getgift")
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.btn_GiftProp.transform))
  ctr.modelData = ItemCellData()
end

local function OnBtn_rechangeGetCreat(ctr)
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnBtn_rechangeGetRefresh(ctr, _, data, ui)
  local imag = _ == 1 and "holidayAcBtnc2" or "holidayAcBtnc1"
  ui:SetSprite("Atlas_Common", imag, ctr, true)
  ctr.lab_name:SetText(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun(data.title))
  ctr.img_redPoint:SetActive(RedPointChecker_Ext.TimeLimitedContinuousRecharge[CommerceTimeLimitedContinuousRechargeRed[data.group]])
  ctr.count = _
  ctr.info = data.info
  ctr:SetOnClick(ui, ui.BtnRechangeGetOnClick)
  if _ == ui.ContinuousRechargeIndex then
    data.count = ui.ContinuousRechargeIndex
    ui:BtnRechangeGetOnClick(data)
  end
end

local function OnFireworkGiftPropfresh(ctr, _, data, ui)
  local giftInfo = data.Msg.giftInfo[1]
  local reward = data.GiftTbl.reward
  local Item = CommercialTimeLimitedActivityData.GetBoxinfoFun(reward)[1]
  local ItemId = Item.itemId
  local itemData = ItemUtility.GenerateItemData(ItemId)
  itemData.count = Item.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local count = data.refreshCountLimit - giftInfo.roleCount
  local labcount = ""
  local taskid = CommercialTimeLimitedActivityData.Getcfg_Commerce_1Fun(data.Msg.taskId).goals
  local goalstbl = CommercialTimeLimitedActivityData.Getcfg_Task_goalFun(tonumber(taskid))
  local goalCount = goalstbl.goalCount
  local Residuals = goalCount - CommercialTimeLimitedActivityData.FireworksBulletin.count
  if 0 < count then
    local color = "#ff2323"
    local mun = CommercialTimeLimitedActivityData.FireworksBulletin.count
    if goalCount <= mun then
      color = "#1add1f"
      mun = goalCount
    end
    labcount = string.format("<color=%s>%d</color>/%d", color, mun, goalCount)
  else
    labcount = string.format("<color=#1add1f>%d</color>/%d", goalCount, goalCount)
  end
  ctr.img_mask:SetActive(count <= 0)
  ctr.lab_GiftCount:SetText(labcount)
  local GuideEffecName = "Eff_UI_xuanshangjiangli03"
  local effectItem = ctr.transform:Find(GuideEffecName)
  if 0 < count and Residuals <= 0 then
    if not effectItem then
      effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(1, 1), Vector3(0, 10, 0))
    else
      effectItem.gameObject:SetActive(true)
    end
  elseif effectItem then
    effectItem.gameObject:SetActive(false)
  end
  ctr.btn_Getgift:SetActive(0 < count and Residuals <= 0)
  ctr.btn_Getgift.giftid = giftInfo.giftId
  ctr.btn_Getgift.count = count
  ctr.btn_Getgift.Residuals = Residuals
  ctr.btn_Getgift:SetOnClick(ui, ui.ReceiveGiftOnClick)
end

local function Onimg_datarankBgCreat(ctr)
  ctr.txt_day = UIControl(ctr.transform, "txt_day")
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.btn_goRecharge = UIControl(ctr.transform, "btns/btn_goRecharge")
  ctr.btn_get = UIControl(ctr.transform, "btns/btn_get")
  ctr.lab_Received = UIControl(ctr.transform, "btns/lab_Received")
  ctr.lab_notReached = UIControl(ctr.transform, "btns/lab_notReached")
end

local function Onimg_datarankBgRefresh(ctr, _, data, ui)
  local tbl = data.tbl
  ctr.txt_day:SetText(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun(tbl.describe))
  if not ctr.rewardContainer then
    ctr.rewardContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  local GiftTbl = CommercialTimeLimitedActivityData.GetGiftInfoFun(tbl.giftId)
  local Reward = CommercialTimeLimitedActivityData.GetBoxinfoFun(GiftTbl.reward)
  Reward = CommercializeData.GetMeetConditionBoxTbl(Reward)
  ctr.rewardContainer:SetData(Reward)
  local Msg = data.Msg
  local extra = not string.isNullOrEmpty(Msg.extra)
  ctr.btn_goRecharge:SetActive(not Msg.giftInfo[1].canGet and extra)
  ctr.btn_get:SetActive(Msg.giftInfo[1].canGet and 1 > Msg.giftInfo[1].roleCount)
  ctr.lab_Received:SetActive(Msg.giftInfo[1].canGet and 1 <= Msg.giftInfo[1].roleCount)
  ctr.lab_notReached:SetActive(not Msg.giftInfo[1].canGet and not extra)
  ctr.btn_goRecharge.PayType = BusinessPayType.ContinuousRecharge
  ctr.btn_goRecharge:SetOnClick(ui, ui.btn_goRechargeOnClick)
  ctr.btn_get.giftId = tbl.giftId
  ctr.btn_get:SetOnClick(ui, ui.btn_get)
end

function Commercial_LimitedTimeActivityUI:InitUI()
  CommercialTimeLimitedActivityData.GetHolidayGlobal()
  self.BtnHolidayContainer = UIUtility.BindUIContainerTemp(self.Btn_Holiday, LuaComponentTemplates.Activity_CommercialTimeLimited_Page, self)
  self.HolidayGistContainer = UIContainer(self.bg_holidayGist, self, OnHolidayGistCreat, OnHolidayGistRefresh)
  self.HolidayGiftItemBuyContainer = UIContainer(self.bg_holidayGiftItemBuy, self, OnHolidayGistCreat, OnHolidayGistRefresh)
  self.BoosAwardItemContainer = UIContainer(self.btn_DropDisItem, self, OnBoosAwardItemCreate, OnBoosAwardItemRefresh)
  self.pointPosContainer = UIContainer(self.GoPiont, self, OnPointCreate, OnPointRefresh)
  self.FireworksItemContainer = UIContainer(self.btn_FireworkShow, self, OnBoosAwardItemCreate, OnBoosAwardItemRefresh)
  self.FireworkBuyContainer = UIContainer(self.FireworkProp, self, OnFireworkPropCreate, OnFireworkPropRefresh)
  self.FireworkBulletinContainer = UIContainer(self.lab_Event, self, OnFireworkBulletinPropCreate, OnFireworkBulletinPropRefresh)
  self.CollectContainer = UIContainer(self.Item_holidayCollect, self, OnCollectCreate, OnCollectRefresh)
  self.ShopContainer = UIContainer(self.go_Shopitem, self, OnShopCreate, OnShopRefresh)
  self.FireworkGiftPropContainer = UIContainer(self.FireworkGiftProp, self, OnFireworkGiftPropCreate, OnFireworkGiftPropfresh)
  self.Btn_rechangeGetContainer = UIContainer(self.Btn_rechangeGet, self, OnBtn_rechangeGetCreat, OnBtn_rechangeGetRefresh)
  self.img_datarankBgContainer = UIContainer(self.img_datarankBg, self, Onimg_datarankBgCreat, Onimg_datarankBgRefresh)
  self.holidayLuckyTurntableTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayLuckyTurntable, LuaComponentTemplates.HolidayLuckyTurntableTemplate, self)
  self.worldCupGuessTemplate = luaTemplateManager.GetNewTemplate(self.go_WorldCup, LuaComponentTemplates.WorldCupGuessTemplate, self)
  self.holidayPetInvestTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayPetInvest, LuaComponentTemplates.holidayPetInvestTemplate, self)
  self.sevenDayGiftTemplate = luaTemplateManager.GetNewTemplate(self.go_holidaySevenDayGifts, LuaComponentTemplates.SevenDayGiftTemplate, self)
  self.SpringPanelUITemp = luaTemplateManager.GetNewTemplate(self.go_holidayDailyGifts, LuaComponentTemplates.SpringPanelUITemp, self)
  self.openServerInvestTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayRechargeInvestment, LuaComponentTemplates.OpenServerInvestTemplate, self)
  self.warOrderPassTemplate = luaTemplateManager.GetNewTemplate(self.go_combineWarOrderPass, LuaComponentTemplates.WarOrderPassTemplate, {
    rootUI = self,
    activityBaseType = ActivityBaseType.LimitedTimeActivity,
    activityIdType = TimeLimitedActivityIdType.MiracleBattlePass
  })
  self.firecrackerTreasureHuntingTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayBaoZhuTreasure, LuaComponentTemplates.FirecrackerTreasureHuntingTemplate, self)
  local ItemId = ClientTable.cfg_Commerce_globalManager:TryGetValue(309001, "id").effect
  self:SetSprite("Atlas_Common", ItemId, self.holidayShopcoin)
  self.PlanType = {
    [CommercializeTimeLimitedGrop.DirectPurchase] = self.go_holidayGift,
    [CommercializeTimeLimitedGrop.GiftPack] = self.go_holidayGift,
    [CommercializeTimeLimitedGrop.BoosActivity] = self.go_holidayBoos,
    [CommercializeTimeLimitedGrop.Exp] = self.go_holidayExperience,
    [CommercializeTimeLimitedGrop.Fireworks] = self.go_holidayFireworks,
    [CommercializeTimeLimitedGrop.Collect] = self.go_holidayCollect,
    [CommercializeTimeLimitedGrop.Shop] = self.go_holidayShop,
    [CommercializeTimeLimitedGrop.ContinuousRecharge] = self.go_rechangeGet,
    [CommercializeTimeLimitedGrop.TurntableType] = self.go_turntable,
    [CommercializeTimeLimitedGrop.HolidayLuckyTurntable] = self.go_holidayLuckyTurntable,
    [CommercializeTimeLimitedGrop.Preview] = self.go_EquipZhuFuAngel,
    [CommercializeTimeLimitedGrop.MountShow] = self.go_mountShow,
    [CommercializeTimeLimitedGrop.WorldCupGuess] = self.go_WorldCup,
    [CommercializeTimeLimitedGrop.PetInvest] = self.go_holidayPetInvest,
    [CommercializeTimeLimitedGrop.SevenDayGift] = self.go_holidaySevenDayGifts,
    [CommercializeTimeLimitedGrop.FirecrackerTreasureHunting] = self.go_holidayBaoZhuTreasure,
    [CommercializeTimeLimitedGrop.SpringActivity] = self.go_holidayDailyGifts,
    [CommercializeTimeLimitedGrop.LimitedTime_SpecialGiftPackageItemBuy] = self.go_holidayGiftItemBuy,
    [CommercializeHolidayGrop.OpenServerInvest] = self.go_holidayRechargeInvestment,
    [CommercializeHolidayGrop.WarOrderPass] = self.go_combineWarOrderPass
  }
  self.descBtnGroup = {
    [CommercializeTimeLimitedGrop.BoosActivity] = {
      id = 1051,
      pos = Vector3(473, -25, 0)
    },
    [CommercializeTimeLimitedGrop.Fireworks] = {
      id = 1052,
      pos = Vector3(95, 152, 0)
    },
    [CommercializeTimeLimitedGrop.Collect] = {
      id = 1053,
      pos = Vector3(465, 152, 0)
    },
    [CommercializeTimeLimitedGrop.DirectPurchase] = {
      id = 1054,
      pos = Vector3(465, 152, 0)
    },
    [CommercializeTimeLimitedGrop.Shop] = {
      id = 1055,
      pos = Vector3(465, 152, 0)
    }
  }
  self.coinRefreshPlan = {
    [CommercializeTimeLimitedGrop.Fireworks] = {
      id = 1000030,
      bin = 1000050,
      item1 = 53090004,
      item2 = 53090005
    },
    [CommercializeTimeLimitedGrop.Shop] = {
      id = tonumber(ItemId)
    }
  }
  local rechangeGridLayoutGroup = self.holidayGift_Content.transform:GetComponent("GridLayoutGroup")
  self.rechangeContentcellSize = rechangeGridLayoutGroup.cellSize
  self.rechangeContentOffset = rechangeGridLayoutGroup.padding.left + math.modf(self.holidayGift_Content.transform.anchoredPosition.x)
  self.rechangeArrowPos = self.Img_rechangeArrow.gameObject.transform.localPosition
  self.rechangeArrowPos2 = self.Img_rechangeArrow2.gameObject.transform.localPosition
  local itemBuyGridLayoutGroup = self.holidayGiftItemBuy_Content.transform:GetComponent("GridLayoutGroup")
  self.itemBuyContentcellSize = itemBuyGridLayoutGroup.cellSize
  self.itemBuyContentOffset = itemBuyGridLayoutGroup.padding.left + math.modf(self.holidayGiftItemBuy_Content.transform.anchoredPosition.x)
  self.itemBuyArrowPos = self.Img_itemBuyArrow.gameObject.transform.localPosition
  self.itemBuyArrowPos2 = self.Img_itemBuyArrow2.gameObject.transform.localPosition
  local sw_AccumulatesLayoutGroup = self.Accumulates_Content.transform:GetComponent("GridLayoutGroup")
  self.sw_AccumulatesSize = sw_AccumulatesLayoutGroup.cellSize
  self.sw_AccumulatesOffset = sw_AccumulatesLayoutGroup.padding.top + math.modf(self.Accumulates_Content.transform.anchoredPosition.y)
  self.AccumulatesArrowPos = self.Img_AccumulatesArrow.gameObject.transform.localPosition
  self.TurntableUI_Templates = luaTemplateManager.GetNewTemplate(self.go_turntable, LuaComponentTemplates.TurntableUI_Templates, self)
  for i = 1, self.img_Mount1.transform.childCount do
    local child = self.img_Mount1:GetChild("img" .. i)
    table.insert(self.mountUITab, child)
  end
  for i = 1, self.img_Mount2.transform.childCount do
    local child = self.img_Mount2:GetChild("img" .. i)
    table.insert(self.mountUITab, child)
  end
  for i = 1, self.img_Mount3.transform.childCount do
    local child = self.img_Mount3:GetChild("img" .. i)
    table.insert(self.mountUITab, child)
  end
end

function Commercial_LimitedTimeActivityUI:OnShow()
  self:RegistEvents()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.LimitedTime
  })
  self:Refresh()
end

function Commercial_LimitedTimeActivityUI:OnHide()
  self:SetDestroyTime()
  self:RefreshShowPanel({})
  self:ResetMountModel()
  self:PageExit()
  self.BtnHolidayInfo = nil
  CommercialTimeLimitedActivityData.HolidayTogSerInfo = {}
  self.holidayLuckyTurntableTemplate:OnHide()
  self:ExitWorldCupGuess()
  self:OnHolidayPetInvestOnHide()
  self:ExitFirecrackerTreasureHunting()
  self:ExitSevenDayGift()
  self:ExitOpenServerInvestment()
  self:ExitWarOrderPass()
  if self.modeViewerList then
    for i = #self.modeViewerList, 1, -1 do
      self.modeViewerList[i]:Destroy()
      table.remove(self.modeViewerList)
    end
  end
end

function Commercial_LimitedTimeActivityUI:PageExit()
  local pageTemplate
  if type(self.BtnHolidayContainer) == "table" and type(self.BtnHolidayContainer.items) == "table" then
    for k, v in pairs(self.BtnHolidayContainer.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.Exit ~= nil then
        pageTemplate:Exit()
      end
    end
  end
end

function Commercial_LimitedTimeActivityUI:OnSortByCount(data)
  local acc = 0
  for i = 1, #data do
    i = i + acc
    local Refresh, count = CommercialTimeLimitedActivityData.GetRefreshCountFun(data[i].countKey)
    if Refresh then
      local item = data[i]
      item.Received = true
      item.RefreshCount = count
    else
      local item = data[i]
      item.Received = false
      item.RefreshCount = count
      table.remove(data, i)
      table.insert(data, item)
      acc = acc - 1
    end
  end
end

function Commercial_LimitedTimeActivityUI:OnSortByTask(data)
  local acc = 0
  local Red = false
  for i = 1, #data do
    i = i + acc
    local Msg = data[i].Msg
    local giftInfo = Msg.giftInfo[1]
    local GiftTbl = CommercialTimeLimitedActivityData.GetGiftInfoFun(giftInfo.giftId)
    data[i].GiftTbl = GiftTbl
    local countTbl = CommercialTimeLimitedActivityData.GetCountInfoFun(GiftTbl.countKey)
    data[i].refreshCountLimit = countTbl.refreshCountLimit
    if giftInfo.roleCount < data[i].refreshCountLimit then
      local item = data[i]
      item.Received = true
      if giftInfo.canGet and giftInfo.roleCount < data[i].refreshCountLimit then
        Red = true
      end
    else
      local item = data[i]
      item.Received = false
      table.remove(data, i)
      table.insert(data, item)
      acc = acc - 1
    end
  end
  if not Red and data[1] then
    RedPointChecker_Ext:TimeLimitedRedPointRefreshState({
      redId = CommerceTimeLimitedRedTogType[data[1].group],
      state = false
    })
    CommercialTimeLimitedActivityData.RedPointTogRefresh(data[1].group)
  end
end

function Commercial_LimitedTimeActivityUI:btn_PrizeBuyOnClick(control)
  local data = control.data
  if data.rmb then
    DataToCSharpMgr.Pay({
      amount = math.floor(data.rmb / 100),
      product_Id = data.id,
      product_name = data.name,
      BusinessPayType = BusinessPayType.Holiday_Prize
    })
  else
    local Gift = control.Gift
    if BagInfoData.GetItemTotalCountByItemId(Gift.cost) < Gift.count then
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("FestivalYanhua1"),
        cancelText = "",
        okText = "",
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          UIManager.Hide(UIID.PromptTipUI)
          RechargeData.BuyDiamond(BusinessPayType.Holiday_Fireworks)
        end
      })
      return
    end
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = data.id,
      buyCount = 1
    })
  end
end

function Commercial_LimitedTimeActivityUI:ReceiveGiftOnClick(control)
  local Count = control.count
  local Residuals = control.Residuals
  if 0 < Count and Residuals <= 0 then
    local giftid = control.giftid
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {giftid}
    })
  end
end

function Commercial_LimitedTimeActivityUI:btn_ShopBuyOnClick(control)
  local data = control.data
  local itemData = control.itemData
  ShopData.CreatBuyItemInfo(data.id)
  local posy = -85
  if itemData.itemId == 7200000 then
    posy = 0
  end
  itemData.tipsPosition = Vector3(0, posy, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    openType = TipsOpenType.ShopOpen,
    showType = itemData.showPos
  })
end

function Commercial_LimitedTimeActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Btn_Holiday:SetOnClick(self, self.Btn_HolidayOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.FullServerTitle:SetOnClick(self, self.FullServerTitleOnClick)
  self.PersonalTitle:SetOnClick(self, self.PersonalTitleOnClick)
  self.btn_goExperience:SetOnClick(self, self.btn_goExperienceOnClick)
  self.sw_holidayGift:SetOnEndDrag(self, self.sw_rechangeOnEndDragTeam)
  self.sw_holidayGiftItemBuy:SetOnEndDrag(self, self.sw_itemBuyOnEndDragTeam)
  self.sw_Accumulates:SetOnEndDrag(self, self.AccumulatesOnEndDragTeam)
  self.holidayShopcoin:SetOnClick(self, self.holidayShopcoinOnClick)
end

function Commercial_LimitedTimeActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_LimitedTimeActivityUI)
end

function Commercial_LimitedTimeActivityUI:Btn_HolidayOnClick(control)
end

function Commercial_LimitedTimeActivityUI:descBtnOnClick(control)
  local id = self.descBtnGroup[control.group].id
  UIManager.Show(UIID.System_DescUI, {id = id})
end

function Commercial_LimitedTimeActivityUI:BtnHolidayOnClick(control)
  local data = control.data
  self.BtnHolidayInfo = data
  if not data then
    return
  end
  if control.onClick and data.group == CommercializeTimeLimitedGrop.DirectPurchase then
    NetManager.Send(CountMessage.ReqCountByType, {
      type = RefreshData.TypeEnum.HolidayPackagermb
    })
  elseif data.group == CommercializeTimeLimitedGrop.TurntableType then
    NetManager.Send(CommerceMessage.ReqLuckTurntable, {type = 0})
  elseif data.group == CommercializeTimeLimitedGrop.HolidayLuckyTurntable then
    NetManager.Send(CommerceMessage.ReqTreasureHunt, {type = 0})
  elseif data.group == CommercializeTimeLimitedGrop.SevenDayGift then
    NetManager.Send(CommerceMessage.ReqSevenDaysGiftsInfo)
  end
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.LimitedTime, data.group, 1)
  for i, v in pairs(self.BtnGroup) do
    if v.group == data.group then
      local tog = self.BtnHolidayContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(true)
      end
    else
      local tog = self.BtnHolidayContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(false)
      end
    end
  end
end

function Commercial_LimitedTimeActivityUI:btn_DropDispointOnClick(control)
  local BossInfo = control.data
  if BossInfo.num > 0 then
    if TranScriptData.InTranscript then
      FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
      return
    end
    local transferId = 0
    local effect = CommercialTimeLimitedActivityData.GetCommerce_globalFun(305014)
    local transferIds = string.split(effect, "&")
    for i, v in pairs(transferIds) do
      local Group = string.split(v, "#")
      if tonumber(Group[1]) == BossInfo.mapId then
        transferId = tonumber(Group[2])
      end
    end
    local mapData = {mapId = transferId, line = 1}
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
    self:btn_closeOnClick()
  else
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("FestivalBoss2")
    FloatingTipUtility.QuickMsg(uiWord)
  end
end

function Commercial_LimitedTimeActivityUI:FullServerTitleOnClick()
  self.FullServerTitle:GetChild("img_clickeffect"):SetActive(true)
  self.PersonalTitle:GetChild("img_clickeffect"):SetActive(false)
  self:RefreshFireworksBulletin(FireworksBulletinType.serverAnnounce)
end

function Commercial_LimitedTimeActivityUI:PersonalTitleOnClick()
  self.FullServerTitle:GetChild("img_clickeffect"):SetActive(false)
  self.PersonalTitle:GetChild("img_clickeffect"):SetActive(true)
  self:RefreshFireworksBulletin(FireworksBulletinType.roleAnnounce)
end

function Commercial_LimitedTimeActivityUI:ExecuteTextOrder(control, eventData, key)
  local inputData = control.inputData[key]
  ChatUtility.GetChatInfoTab(inputData.type, inputData, control, eventData)
end

function Commercial_LimitedTimeActivityUI:btn_exchangeOnClick(control)
  local finish = control.finish
  local data = control.data
  if control.count <= 0 then
    FloatingTipUtility.QuickMsg(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalitem3"))
    return
  end
  if finish then
    NetManager.Send(CommerceMessage.ReqExchange, {
      commerceId = data.id
    })
  else
    FloatingTipUtility.QuickMsg(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalitem1"))
  end
end

function Commercial_LimitedTimeActivityUI:btn_goExperienceOnClick()
  UIManager.Show(UIID.Instance_BossUI)
end

function Commercial_LimitedTimeActivityUI:sw_rechangeOnEndDragTeam()
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.holidayGift_Content.rectTransform)
  local endPos = -math.modf(self.holidayGift_Content.transform.sizeDelta.x)
  local curPos = math.modf(self.holidayGift_Content.transform.anchoredPosition.x)
  if endPos > curPos then
    self.Img_rechangeArrow:SetActive(false)
    self.Img_rechangeArrow.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_rechangeArrow, self.rechangeArrowPos, "X")
    self.Img_rechangeArrow:SetActive(true)
  end
  if -100 < curPos then
    self.Img_rechangeArrow2:SetActive(false)
    self.Img_rechangeArrow2.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_rechangeArrow2, self.rechangeArrowPos2, "X")
    self.Img_rechangeArrow2:SetActive(true)
  end
end

function Commercial_LimitedTimeActivityUI:sw_itemBuyOnEndDragTeam()
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.holidayGiftItemBuy_Content.rectTransform)
  local endPos = -math.modf(self.holidayGiftItemBuy_Content.transform.sizeDelta.x)
  local curPos = math.modf(self.holidayGiftItemBuy_Content.transform.anchoredPosition.x)
  if endPos > curPos then
    self.Img_itemBuyArrow:SetActive(false)
    self.Img_itemBuyArrow.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_itemBuyArrow, self.itemBuyArrowPos, "X")
    self.Img_itemBuyArrow:SetActive(true)
  end
  if -100 < curPos then
    self.Img_itemBuyArrow2:SetActive(false)
    self.Img_itemBuyArrow2.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_itemBuyArrow2, self.itemBuyArrowPos2, "X")
    self.Img_itemBuyArrow2:SetActive(true)
  end
end

function Commercial_LimitedTimeActivityUI:AccumulatesOnEndDragTeam()
  local endPos = 3 * self.sw_AccumulatesSize.y - self.sw_AccumulatesOffset
  local curPos = math.modf(self.Accumulates_Content.transform.anchoredPosition.y)
  if curPos > endPos - 50 then
    self.Img_AccumulatesArrow:SetActive(false)
    self.Img_AccumulatesArrow.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_AccumulatesArrow, self.AccumulatesArrowPos, "Y")
    self.Img_AccumulatesArrow:SetActive(true)
  end
end

function Commercial_LimitedTimeActivityUI:SetAnimation(btn, pos, Axles)
  btn.gameObject.transform:DOKill()
  if Axles == "X" then
    local left = false
    
    local function MoveLeftX()
      btn.gameObject.transform:DOLocalMoveX(left and pos.x - 10 or pos.x + 10, 1):OnComplete(function()
        left = not left
        btn.gameObject.transform:DOLocalMoveX(left and pos.x - 10 or pos.x + 10, 1):OnComplete(function()
          left = not left
          MoveLeftX()
        end)
      end)
    end
    
    MoveLeftX()
  else
    local function MoveLeftY()
      local top = false
      
      btn.gameObject.transform:DOLocalMoveY(top and pos.y - 10 or pos.y + 10, 1):OnComplete(function()
        top = not top
        btn.gameObject.transform:DOLocalMoveY(top and pos.y - 10 or pos.y + 10, 1):OnComplete(function()
          top = not top
          MoveLeftY()
        end)
      end)
    end
    
    MoveLeftY()
  end
end

function Commercial_LimitedTimeActivityUI:holidayShopcoinOnClick(control)
  local itemid = self.coinRefreshPlan[CommercializeTimeLimitedGrop.Shop].id
  local itemData = ItemUtility.GenerateItemData(itemid)
  itemData.tipsPosition = Vector3(0, -85, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Commercial_LimitedTimeActivityUI:RegistEvents()
  self:RegistEvent(Event.Commer_HolidayTog, self.Commer_HolidayTog, self)
  self:RegistEvent(Event.Commer_Holidayinfo, self.Commer_Holidayinfo, self)
  self:RegistEvent(Event.Commer_HolidayserReqinfo, self.Commer_HolidayserReqinfo, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
  self:RegistEvent(Event.ServerAnnounceRefresh, self.ServerAnnounceRefresh, self)
  self:RegistEvent(Event.RoleAnnounceRefresh, self.RoleAnnounceRefresh, self)
  self:RegistEvent(Event.CollectRefresh, self.CollectRefresh, self)
  self:RegistEvent(Event.RefreshZeroTime, self.RefreshZeroTime, self)
  self:RegistEvent(Event.HolidayLuckyTurntableRefresh, self.RefreshHolidayLuckyTurntable, self)
  self:RegistEvent(Event.LuckyDrawEffect, self.LuckyDrawEffect, self)
  self:RegistEvent(Event.TurntableUI, self.TurntableUI, self)
  self:RegistEvent(Event.GiftLogTurntableUI, self.GiftLogTurntableUI, self)
  self:RegistEvent(Event.WorldCupGuessRefresh, self.OnWorldCupGuessRefresh, self)
  self:RegistEvent(Event.WorldCupGuessPanelOpen, self.OnWorldCupGuessPanelOpen, self)
  self:RegistEvent(Event.PetInvestRefresh, self.OnHolidayPetInvestRefresh, self)
  self:RegistEvent(Event.SevenDayGiftRefresh, self.OnSevenDayGiftRefresh, self)
  self:RegistEvent(Event.RefreshViewOnDrawnReward, self.FTHOnDrawnRewardRefresh, self)
  self:RegistEvent(Event.FTHCumulativeRewardsRefresh, self.FTHCumulativeRewardsRefresh, self)
  self:RegistEvent(Event.SpringActivityItemDataChange, self.SpringActivityItemDataChange, self)
  self:RegistEvent(Event.Commer_TimeWelfar, self.SpecialGiftPackageCountRefresh, self)
  self:RegistEvent(Event.OpenServerInvestmentRefresh, self.OnOpenServerInvestmentRefresh, self)
  self:RegistEvent(Event.CombineWarOrderPassRefesh, self.OnWarOrderPassRefresh, self)
  self:RegistEvent(Event.CombineWarOrderPassRefeshRare, self.OnWarOrderPassRefreshRare, self)
end

function Commercial_LimitedTimeActivityUI:SpecialGiftPackageCountRefresh(_)
  self:Commer_Holidayinfo(nil, nil, true)
end

function Commercial_LimitedTimeActivityUI:SpringActivityItemDataChange(_)
  self:RefreshSpringActivityUI()
end

function Commercial_LimitedTimeActivityUI:TurntableUI(_)
  self.TurntableUI_Templates:Refresh()
end

function Commercial_LimitedTimeActivityUI:Commer_HolidayTog(_)
  self.BtnGroup = CommercialTimeLimitedActivityData.RefreshHolidayTogIdInfo(1)
  if table.count(self.BtnGroup) == 0 then
    self:btn_closeOnClick()
    return
  end
  self.BtnHolidayContainer:SetData(self.BtnGroup)
  self:RefreshShowBtn(self.BtnGroup)
end

function Commercial_LimitedTimeActivityUI:Commer_Holidayinfo(_, msg, Refresh)
  local CurrentInfo = CommercialTimeLimitedActivityData.HolidaytypeDistinguish()
  if CurrentInfo.Msg ~= nil and CurrentInfo.Msg.changePage == 1 then
    self.curPageGroupId = CurrentInfo.group
    self:RefreshShowPanel(CurrentInfo)
  end
  self:ResetMountModel()
  if CurrentInfo.type == CommerceOverviewType.TaskType then
    print("\228\187\187\229\138\161")
  elseif CurrentInfo.type == CommerceOverviewType.GiftType then
    local ShowBuyInfo, ItemBuyInfo, RechargeInfo = CommercialTimeLimitedActivityData.RefreshHolidayGiftTypeInfo(CurrentInfo)
    self:OnSortByCount(ShowBuyInfo)
    if CurrentInfo.group == CommercializeTimeLimitedGrop.Shop then
      self.ShopContainer:SetData(ShowBuyInfo)
      local Shopcoin = BagInfoData.GetItemTotalCountByItemId(self.coinRefreshPlan[CommercializeTimeLimitedGrop.Shop].id)
      self.lab_holidayShopcoin:SetText(Shopcoin)
      local redstart = RedPointChecker_Ext.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop]]
      RedPointChecker_Ext:TimeLimitedRedPointRefreshState({
        redId = CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop],
        state = false
      })
      if redstart then
        CommercialTimeLimitedActivityData.RedPointTogRefresh(CurrentInfo.group)
      end
    elseif CurrentInfo.group == CommercializeTimeLimitedGrop.GiftPack then
      if CurrentInfo.commerceId == CommerceIdEnum.Holiday_SpecialGiftPackageMix then
        self.HolidayGistContainer:SetData(ShowBuyInfo)
      elseif table.contains(CommercialTimeLimitedActivityData.LimitedTimeCommerceId_SpecialGiftPackageRecharge, CurrentInfo.commerceId) then
        self.HolidayGistContainer:SetData(RechargeInfo)
      end
      self:sw_rechangeOnEndDragTeam()
    elseif CurrentInfo.group == CommercializeTimeLimitedGrop.LimitedTime_SpecialGiftPackageItemBuy then
      if table.contains(CommercialTimeLimitedActivityData.LimitedTimeCommerceId_SpecialGiftPackageItemBuy, CurrentInfo.commerceId) then
        self.HolidayGiftItemBuyContainer:SetData(ItemBuyInfo)
      end
      self:sw_itemBuyOnEndDragTeam()
    end
  elseif CurrentInfo.type == CommerceOverviewType.RankInfo then
    print("\230\142\146\232\161\140\230\166\156")
  elseif CurrentInfo.type == CommerceOverviewType.Exp then
    self:RefreshExpActivity(CurrentInfo)
  elseif CurrentInfo.type == CommerceOverviewType.BoosActivity then
    local BoosInfo = CommercialTimeLimitedActivityData.RefreshHolidayBoosActivityInfo(CurrentInfo)
    self:RefreshBoosActivity(BoosInfo)
  elseif CurrentInfo.type == CommerceOverviewType.Fireworks then
    self:RefreshFireworksActivity(CurrentInfo, Refresh)
    self:AccumulatesOnEndDragTeam()
  elseif CurrentInfo.type == CommerceOverviewType.Collect then
    self:RefreshCollectActivity(CurrentInfo)
  elseif CurrentInfo.type == CommerceOverviewType.TurntableType then
    self.TurntableUI_Templates:ShowUI()
    self.TurntableUI_Templates:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.ContinuousRecharge then
    self:RefreshContinuousRecharge(CurrentInfo)
  elseif CurrentInfo.type == CommerceOverviewType.HolidayLuckyTurntable then
  elseif CurrentInfo.type == CommerceOverviewType.Preview then
    local global_text = ClientTable.cfg_Commerce_globalManager:TryGetValue(312001, "id")
    self.lab_Text:SetText(global_text and global_text.effect or "")
    self:RefreshEquipZhuFuAngel()
  elseif CurrentInfo.type == CommerceOverviewType.MountShow then
    self:RefreshMountShow()
  elseif CurrentInfo.type == CommerceOverviewType.SpringActivity then
    self:RefreshSpringActivityUI()
  elseif CurrentInfo.type == CommerceOverviewType.PetInvest then
    self.holidayPetInvestTemplate:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.OpenServerInvest then
    self:OnOpenServerInvestmentRefresh()
  elseif CurrentInfo.type == CommerceOverviewType.WarOrderPass then
    self:OnWarOrderPassRefresh()
  end
  self:RefreshCountdownTime(CurrentInfo)
  self:HideHolidayLuckyTurntable()
  self:ExitWorldCupGuess()
  self:ExitSevenDayGift()
  self:OnHolidayPetInvestOnHide()
  self:ExitFirecrackerTreasureHunting()
  if CurrentInfo.type ~= CommerceOverviewType.Preview and self.modeViewerList then
    for i = #self.modeViewerList, 1, -1 do
      self.modeViewerList[i]:Destroy()
      table.remove(self.modeViewerList)
    end
  end
end

function Commercial_LimitedTimeActivityUI:RefreshSpringActivityUI()
  local itemData = QuickFind:GetSpringActivityDataMgr():RefreshSpringData()
  if not itemData then
    return
  end
  table.sort(itemData.qianDaoInfos, function(a, b)
    return a.goalId < b.goalId
  end)
  local data = {}
  for i, v in ipairs(itemData.qianDaoInfos) do
    if v.hasReward == false then
      table.insert(data, v)
    end
  end
  for i, v in ipairs(itemData.qianDaoInfos) do
    if v.hasReward then
      table.insert(data, v)
    end
  end
  self.SpringPanelUITemp:Refresh(data)
end

function Commercial_LimitedTimeActivityUI:RefreshEquipZhuFuAngel()
  local Listtable = {}
  local Listequip = {}
  local itetName = {}
  local img_liuguang = self:GetControl("go_EquipZhuFuAngel/Viewport/Content/img_liuguang")
  local img_liuguang2 = self:GetControl("go_EquipZhuFuAngel/Viewport/Content/img_liuguang2")
  CommercialTimeLimitedActivityData.EquipZhuFuAngel(Listtable, Listequip, itetName, img_liuguang, img_liuguang2)
  if Listequip == nil or Listtable == nil or itetName == nil then
    return
  end
  for i, v in ipairs(Listequip) do
    local modelViewer = self.modeViewerList[i]
    local go_model = Listtable[i]:GetChild("Model" .. i .. "/go_model")
    local txl = Listtable[i]:GetChild("tip")
    txl:SetText(itetName[i])
    local viewRoleData = {}
    local equipData = RoleEquipData(Listequip[i])
    viewRoleData.equipsData = equipData
    viewRoleData.career = ViewData.meData.career
    viewRoleData.modelType = EModelType.Charactor
    viewRoleData.model = 1003
    viewRoleData.id = 1003
    viewRoleData.parent = go_model.transform
    viewRoleData.serverCoord = Vector2Int()
    viewRoleData.roleType = ERoleType.Player
    if not modelViewer then
      modelViewer = ViewRole(viewRoleData)
      if modelViewer then
        modelViewer:SetPosition(0, -120, -80)
        table.insert(self.modeViewerList, i, modelViewer)
      end
    else
      modelViewer:RefreshModel(viewRoleData)
    end
    if modelViewer then
      modelViewer:SetRotation(0, -180, 0)
    end
  end
end

function Commercial_LimitedTimeActivityUI:ResetMountModel()
  if self.mountCoroutine then
    Coroutine.Stop(self.mountCoroutine)
  end
  if self.mountModelTab and table.count(self.mountModelTab) > 0 then
    for i, v in pairs(self.mountModelTab) do
      UnityEngineLua.GameObject.Destroy(v)
    end
  end
  self.mountModelTab = {}
  self.mountCoroutine = nil
end

function Commercial_LimitedTimeActivityUI:RefreshMountShow()
  self.mountCoroutine = Coroutine.Start(self.InsMountModel, self)
end

function Commercial_LimitedTimeActivityUI:InsMountModel()
  local data = CommercialTimeLimitedActivityData.GetMountExhibitionData()
  if data then
    for index, v in ipairs(data) do
      local request = self:LoadAssetAsync(v.modelPath, typeof(CS.UnityEngine.GameObject))
      Coroutine.Yield(request)
      if request.isError then
        Coroutine.Break()
      else
        if self.mountModelTab[index .. v.modelPath] == nil then
          self.mountModelTab[index .. v.modelPath] = Instantiate(request.res)
        end
        self:SetMountName(index, v.name)
        self:SetMountModel(index, self.mountModelTab[index .. v.modelPath])
      end
    end
  end
end

function Commercial_LimitedTimeActivityUI:SetMountName(index, name)
  if self.mountUITab[index] then
    local nameUI = self.mountUITab[index]:GetChild("tip")
    nameUI:SetText(name)
  end
end

function Commercial_LimitedTimeActivityUI:SetMountModel(index, go)
  if self.mountUITab[index] then
    local tran = self.mountUITab[index]:GetChild("Model" .. index .. "/go_model")
    if tran then
      go.transform:SetParent(tran.transform, false)
      go.transform.localPosition = Vector3(0, -95, -500)
      go.transform.localEulerAngles = Vector3(0, 135, 0)
      go.transform.localScale = Vector3(38, 38, 38)
      go:SetLayer(UI_LAYER)
      local orderLayer = 500
      if self then
        orderLayer = self.root.canvas.sortingOrder
      end
      local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
      for i = 0, renders.Length - 1 do
        local rend = renders[i]
        rend.sortingOrder = orderLayer + 100
      end
      local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
      for i = 0, sys.Length - 1 do
        local par = sys[i]
        par.gameObject.layer = 5
        par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
      end
      local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
      animator:Play("idle")
    end
  end
end

function Commercial_LimitedTimeActivityUI:Commer_HolidayserReqinfo(_)
  if self.BtnHolidayInfo then
    self:BtnHolidayOnClick({
      data = self.BtnHolidayInfo
    })
  end
  Commercial_LimitedTimeActivityUI:CollectRefresh()
end

function Commercial_LimitedTimeActivityUI:Bag_ResBagChange(_, msg)
  if self.holidayLuckyTurntableTemplate then
    self.holidayLuckyTurntableTemplate:RefreshCostImgAndLab()
  end
  local showItemTbl = msg.showItemTbl
  if self.BtnHolidayInfo then
    for i, v in pairs(self.coinRefreshPlan) do
      if i == self.BtnHolidayInfo.group then
        if showItemTbl[v.id] or v.bin and showItemTbl[v.bin] then
          self:Commer_Holidayinfo(nil, nil, true)
          return
        end
        if self.BtnHolidayInfo.group == CommercializeTimeLimitedGrop.Fireworks and (showItemTbl[v.bin] or showItemTbl[v.item1] or showItemTbl[v.item2]) then
          self:Commer_Holidayinfo(nil, nil, true)
          return
        end
      end
    end
  end
end

function Commercial_LimitedTimeActivityUI:ServerAnnounceRefresh(_)
  if self.go_holidayFireworks:GetActive() and self.FullServerTitle:GetChild("img_clickeffect"):GetActive() then
    self:FullServerTitleOnClick()
  end
end

function Commercial_LimitedTimeActivityUI:RoleAnnounceRefresh(_)
  if self.go_holidayFireworks:GetActive() and self.PersonalTitle:GetChild("img_clickeffect"):GetActive() then
    self:PersonalTitleOnClick()
  end
end

function Commercial_LimitedTimeActivityUI:CollectRefresh()
  if self.PlanType[CommercializeTimeLimitedGrop.Collect]:GetActive() then
    self:RefreshCollectActivity()
    CommercialTimeLimitedActivityData.RedPointCollect()
  end
end

function Commercial_LimitedTimeActivityUI:RefreshZeroTime()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.LimitedTime
  })
end

function Commercial_LimitedTimeActivityUI:Refresh()
end

function Commercial_LimitedTimeActivityUI:RefreshShowBtn(data)
  local index = 1
  if self.args and self.args.openType then
    local group = tonumber(self.args.openType)
    for i = 1, #data do
      if data[i].group == group then
        index = i
        break
      end
    end
  else
    for i, v in pairs(RedPointChecker_Ext.TimeLimitedTogGrop) do
      if v then
        local group = CommerceTimeLimitedTogRed[i]
        for i = 1, #data do
          if data[i].group == group then
            index = i
            break
          end
        end
        break
      end
    end
  end
  self:BtnHolidayOnClick({
    data = data[index]
  })
end

function Commercial_LimitedTimeActivityUI:RefreshShowPanel(data)
  for i, v in pairs(self.PlanType) do
    if data.group == i then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
  if self.descBtnGroup[data.group] then
    self.descBtn.group = data.group
    self.descBtn.transform.localPosition = self.descBtnGroup[data.group].pos
    self.descBtn:SetActive(true)
  else
    self.descBtn:SetActive(false)
  end
end

function Commercial_LimitedTimeActivityUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

local DaojiTime = 0

function Commercial_LimitedTimeActivityUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_LimitedTimeActivityUI:RefreshCountdownTime(data)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = 0
  if 0 < #data.deadline then
    if data.deadline[1][1] == 918 then
      local down = TimeUtility.InTweenyearTimeTheEnd(data.deadline[1][2])
      Difference = TimeUtility.RefreshSec(down)
    else
      local down = TimeUtility.AddDay(LoginData.openServerTime, data.deadline[2][2])
      Difference = TimeUtility.RefreshSec(down)
    end
  end
  if data.group == CommercializeTimeLimitedGrop.Fireworks then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    self:FireworksCountdownTime(Difference)
    return
  elseif data.group == CommercializeTimeLimitedGrop.WorldCupGuess then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    return
  elseif data.group == CommercializeTimeLimitedGrop.WorldCupGuess or data.group == CommercializeTimeLimitedGrop.SevenDayGift or data.group == CommercializeTimeLimitedGrop.SpringActivity or data.group == CommercializeTimeLimitedGrop.FirecrackerTreasureHunting or data.group == CommercializeTimeLimitedGrop.PetInvest or data.group == CommercializeTimeLimitedGrop.OpenServerInvest or data.group == CommercializeTimeLimitedGrop.WarOrderPass then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    return
  end
  if self.PlanType[CommercializeTimeLimitedGrop.PetInvest]:GetActive() then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    return
  end
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTime:SetText("")
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTime:SetText(DaoJiShi)
  else
    self.txt_lastTime:SetText("Th\225\187\157i gian c\195\178n: ")
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTime:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lastTime)
  end
end

local FireworksDaojiTime = 0

function Commercial_LimitedTimeActivityUI:FireworksRefreshTime(FireworksfireTime)
  if 0 < FireworksDaojiTime then
    FireworksDaojiTime = FireworksDaojiTime - 1
    local DaoJiShi = self:FireworksShowDayHourMin(FireworksDaojiTime)
    FireworksfireTime:SetText("AE" .. DaoJiShi)
  else
    FireworksfireTime:SetText("")
  end
end

function Commercial_LimitedTimeActivityUI:FireworksCountdownTime(Difference)
  local DaoJiShi
  if Difference <= 0 then
    self.FireworksfireTime:SetText("")
  else
    DaoJiShi = self:FireworksShowDayHourMin(Difference)
    self.FireworksfireTime:SetText("AE" .. DaoJiShi)
    FireworksDaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.FireworksRefreshTime, self, self.FireworksfireTime)
  end
end

function Commercial_LimitedTimeActivityUI:FireworksShowDayHourMin(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Ceil(sec % ETimeSec.hour / ETimeSec.min)
  timeStr = string.format(LocalizationUtility.GetContentByKey("FestivalYanhua2"), day, hour, min)
  return timeStr
end

function Commercial_LimitedTimeActivityUI:RefreshBoosActivity(data)
  local BoosInfo = data
  local awardTab = CommercialTimeLimitedActivityData.GetRewardTbl(BoosInfo)
  EffectScale = Vector3(1.8, 1.8, 500)
  self.BoosAwardItemContainer:SetData(awardTab)
  self.lab_BoosnotRefresh:SetActive(#BoosInfo.Msg == 0)
  if #BoosInfo.Msg ~= 0 then
    self.pointPosContainer:SetData(BoosInfo.Msg)
  else
    self.pointPosContainer:SetData({})
  end
end

function Commercial_LimitedTimeActivityUI:RefreshFireworksActivity(data, Refresh)
  local ShowBuyInfo, ShowReward = CommercialTimeLimitedActivityData.RefreshHolidayFireworksInfo(data)
  EffectScale = Vector3(2.3, 2.3, 500)
  self.FireworksItemContainer:SetData(ShowReward)
  self.FireworkBuyContainer:SetData(ShowBuyInfo)
  if not Refresh then
    self:FullServerTitleOnClick()
  end
  local TaskInfo = CommercialTimeLimitedActivityData.RefreshHolidayTaskInfo(data)
  self:OnSortByTask(TaskInfo)
  self.lab_FireworksCount:SetText(CommercialTimeLimitedActivityData.FireworksBulletin.count)
  self.FireworkGiftPropContainer:SetData(TaskInfo)
end

function Commercial_LimitedTimeActivityUI:RefreshFireworksBulletin(type)
  if type == FireworksBulletinType.roleAnnounce then
    table.sort(CommercialTimeLimitedActivityData.FireworksBulletin.roleAnnounce, function(a, b)
      return a.time > b.time
    end)
    self.FireworkBulletinContainer:SetData(CommercialTimeLimitedActivityData.FireworksBulletin.roleAnnounce)
  else
    local serverTopAnnounce = CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce
    for i, v in pairs(serverTopAnnounce) do
      v.Top = true
    end
    local server = table.DeepCopy(CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce)
    table.sort(server, function(a, b)
      return a.time > b.time
    end)
    local serverTop = table.DeepCopy(CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce)
    table.sort(serverTop, function(a, b)
      return a.time > b.time
    end)
    local AllSerBulletin = table.combine(serverTop, server)
    self.FireworkBulletinContainer:SetData(AllSerBulletin)
  end
end

function Commercial_LimitedTimeActivityUI:RefreshCollectActivity(data)
  local ShowCollectInfo = CommercialTimeLimitedActivityData.RefreshCollectInfo()
  self.CollectContainer:SetData(ShowCollectInfo)
end

function Commercial_LimitedTimeActivityUI:RefreshExpActivity(data)
  self.tip_Experience:SetText(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalexp"))
end

local function SetUIEffectFun(exist, ctr, GuideEffecName, scale, pos)
  local effectItem = ctr.transform:Find(GuideEffecName)
  if exist then
    if not effectItem then
      effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, scale, pos)
    else
      effectItem.gameObject:SetActive(true)
    end
  elseif effectItem then
    effectItem.gameObject:SetActive(false)
  end
end

function Commercial_LimitedTimeActivityUI:RefreshTurntable(data)
  if not self.TurnTabisPlayingBg:GetActive() then
    self.turntablepointer.transform.localEulerAngles = Vector3.GetTemp(0, 0, 22.5)
  end
  if self.turntablepointerBg:GetActive() then
    self.turntablepointerBg:SetActive(false)
  end
  local childCount = self.turntable_items.transform.childCount - 4
  if not self.useturntableItems or #self.useturntableItems ~= childCount then
    self:InitturntableUseItemBtn(childCount)
  end
  local luckyTurnTable = data.Msg.luckyTurnTable
  local idAndDrawnTbl = luckyTurnTable.idAndDrawn
  local totalRecharge = luckyTurnTable.totalRecharge
  local lastreminfo, Previous, Previousrecord
  local ShowItemData = {}
  for i = 1, #idAndDrawnTbl do
    local idAndDrawn = idAndDrawnTbl[i]
    local tblid = math.floor(idAndDrawn / 4294967296)
    local StarryTbl = CommercialTimeLimitedActivityData.GetCommerce_CircleFun(tblid)
    local drawn = idAndDrawn % 4294967296
    local rmbAndcount = StarryTbl.rmb
    if not lastreminfo and totalRecharge < rmbAndcount[1] then
      lastreminfo = {
        rmb = rmbAndcount[1],
        count = rmbAndcount[2]
      }
      Previous = Previousrecord and Previousrecord or {rmb = 0, count = 0}
    end
    Previousrecord = {
      rmb = rmbAndcount[1],
      count = rmbAndcount[2]
    }
    StarryTbl.Drawn = drawn == 1
    ShowItemData[i] = StarryTbl
  end
  table.sort(ShowItemData, function(a, b)
    return a.sort > b.sort
  end)
  for i, v in pairs(self.useturntableItems) do
    local ShowData = ShowItemData[i]
    v.tblid = ShowData.id
    local itemIdandCount = string.splitToNumbers(ShowData.itemId)
    local itemData = ItemUtility.GenerateItemData(itemIdandCount[1])
    itemData.count = itemIdandCount[2]
    v.itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(v, v.itemCellData, self, true)
    self.useturntableBlacks[i]:SetActive(ShowData.Drawn)
    SetUIEffectFun(not string.isNullOrEmpty(ShowData.light) and not ShowData.Drawn, v, "Eff_UI_xuanshangjiangli02", Vector2(2.2, 2.5))
  end
  if lastreminfo then
    local count = lastreminfo.count - Previous.count
    local rmb = math.floor((lastreminfo.rmb - totalRecharge) / 100)
    self.turntablerechargeTip:SetText(string.format(string.format(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalplant3"), rmb, count)))
  end
  self.turntableDown:SetActive(lastreminfo ~= nil)
  self.turntablevertex.count = luckyTurnTable.count
  self.turntablevertex.receive = luckyTurnTable.receive
  local color = 0 < luckyTurnTable.count and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  self.turntablevertex:GetChild("Text"):SetText(string.GetColorText(string.format(CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun("Festivalplant1"), luckyTurnTable.count), color))
end

local AllItemModel = {}

local function CollectAllItemModel(modelData)
  if not table.contains(AllItemModel, modelData) then
    table.insert(AllItemModel, modelData)
  end
end

function Commercial_LimitedTimeActivityUI:InitturntableUseItemBtn(Count)
  self.useturntableItems = {}
  self.useturntableBlacks = {}
  for i = 1, Count do
    local btn_useItem = self.turntable_items:GetChild("btn_Item" .. i)
    btn_useItem.itemCellData = ItemCellData()
    CollectAllItemModel(btn_useItem.itemCellData)
    self.useturntableItems[#self.useturntableItems + 1] = btn_useItem
    local btn_Black = self.turntable_BlackContent:GetChild("btn_Black" .. i)
    self.useturntableBlacks[#self.useturntableBlacks + 1] = btn_Black
  end
end

function CommercialTimeLimitedActivityData.GetCommerce_CircleFun(id)
  return ConfigManager.GetConfig("cfg_Commerce_Circle", id, "id")
end

function Commercial_LimitedTimeActivityUI:BtnRechangeGetOnClick(control)
  local info = control.info
  local allcount = #self.Btn_rechangeGetContainer.data
  for i = 1, allcount do
    if i == control.count then
      local tog = self.Btn_rechangeGetContainer:GetOrCreateItem(i)
      tog.img_clickeffect:SetActive(true)
      local effect = i == 1 and "holidayAcBtnn2" or "holidayAcBtnn1"
      self:SetSprite("Atlas_Common", effect, tog.img_clickeffect, true)
    else
      local tog = self.Btn_rechangeGetContainer:GetOrCreateItem(i)
      tog.img_clickeffect:SetActive(false)
    end
  end
  local count = #info
  local ordinary = {}
  local additional = {}
  for i = 1, count do
    if info[i].tbl.type == 1 then
      table.insert(ordinary, info[i])
    else
      additional = info[i]
    end
  end
  self.img_datarankBgContainer:SetData(ordinary)
  if #additional < 1 then
    self.img_dataSelfTaskBg:SetActive(false)
  else
    local GiftTbl = CommercialTimeLimitedActivityData.GetGiftInfoFun(additional.tbl.giftId)
    local Reward = CommercialTimeLimitedActivityData.GetBoxinfoFun(GiftTbl.reward)
    self.SelfTaskbtn_ItemContainer:SetData(Reward)
    local Msg = additional.Msg
    self.btn_SelfTaskRecharge:SetActive(not Msg.giftInfo[1].canGet)
    self.btn_SelfTaskGet:SetActive(Msg.giftInfo[1].canGet and 1 > Msg.giftInfo[1].roleCount)
    self.lab_SelfTaskReceived:SetActive(Msg.giftInfo[1].canGet and 1 <= Msg.giftInfo[1].roleCount)
    self.btn_SelfTaskRecharge.PayType = BusinessPayType.ContinuousRecharge
    self.btn_SelfTaskRecharge:SetOnClick(self, self.btn_goRechargeOnClick)
    self.btn_SelfTaskGet.giftId = additional.tbl.giftId
    self.btn_SelfTaskGet:SetOnClick(self, self.btn_get)
    self.img_dataSelfTaskBg:SetActive(true)
  end
end

function Commercial_LimitedTimeActivityUI:btn_goRechargeOnClick(control)
  local PayType = control.PayType
  RechargeData.BuyDiamond(PayType)
end

function Commercial_LimitedTimeActivityUI:btn_get(control)
  local giftId = control.giftId
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {giftId}
  })
end

function Commercial_LimitedTimeActivityUI:RefreshContinuousRecharge(data)
  local allcount = self.Btn_rechangeGetContainer.data and #self.Btn_rechangeGetContainer.data or 0
  for i = 1, allcount do
    local tog = self.Btn_rechangeGetContainer:GetOrCreateItem(i)
    if tog.img_clickeffect:GetActive() then
      self.ContinuousRechargeIndex = i
    end
  end
  local TogInfo = CommercialTimeLimitedActivityData.GetContinuousRechargeTog(data.Msg.taskInfo, self.CommerceType)
  if not self.ContinuousRechargeIndex then
    self.ContinuousRechargeIndex = 1
  end
  self.ContinuousRechargeIndex = self.ContinuousRechargeIndex and (self.ContinuousRechargeIndex <= #TogInfo and self.ContinuousRechargeIndex or 1) or 1
  self.Btn_rechangeGetContainer:SetData(TogInfo)
end

function Commercial_LimitedTimeActivityUI:HideHolidayLuckyTurntable()
  if not self.PlanType[CommercializeTimeLimitedGrop.HolidayLuckyTurntable]:GetActive() then
    self.holidayLuckyTurntableTemplate:OnHide()
  end
end

function Commercial_LimitedTimeActivityUI:RefreshHolidayLuckyTurntable()
  self.holidayLuckyTurntableTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:LuckyDrawEffect()
  self.holidayLuckyTurntableTemplate:ShowLuckyDrawMoveEffect()
end

function Commercial_LimitedTimeActivityUI:GiftLogTurntableUI()
  self.holidayLuckyTurntableTemplate:RefreshShowGiftLog()
end

function Commercial_LimitedTimeActivityUI:OnWorldCupGuessRefresh()
  self.worldCupGuessTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:OnWorldCupGuessPanelOpen(_, msg)
  self.worldCupGuessTemplate:OnWorldCupGuessPanelOpen(_, msg)
end

function Commercial_LimitedTimeActivityUI:ExitWorldCupGuess()
  if not self.PlanType[CommercializeTimeLimitedGrop.WorldCupGuess]:GetActive() then
    self.worldCupGuessTemplate:Exit()
  end
end

function Commercial_LimitedTimeActivityUI:OnHolidayPetInvestRefresh()
  self.holidayPetInvestTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:OnHolidayPetInvestOnHide()
  if self.holidayPetInvestTemplate and not self.PlanType[CommercializeTimeLimitedGrop.PetInvest]:GetActive() then
    self.holidayPetInvestTemplate:OnHide()
  end
end

function Commercial_LimitedTimeActivityUI:OnSevenDayGiftRefresh()
  self.sevenDayGiftTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:ExitSevenDayGift()
  if not self.PlanType[CommercializeTimeLimitedGrop.SevenDayGift]:GetActive() then
    self.sevenDayGiftTemplate:Exit()
  end
end

function Commercial_LimitedTimeActivityUI:FTHOnDrawnRewardRefresh()
  self.firecrackerTreasureHuntingTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:FTHCumulativeRewardsRefresh()
  self.firecrackerTreasureHuntingTemplate:RefreshCumulativeRewards()
end

function Commercial_LimitedTimeActivityUI:ExitFirecrackerTreasureHunting()
  if not self.PlanType[CommercializeTimeLimitedGrop.FirecrackerTreasureHunting]:GetActive() then
    self.firecrackerTreasureHuntingTemplate:OnHide()
  end
end

function Commercial_LimitedTimeActivityUI:OnOpenServerInvestmentRefresh()
  self.openServerInvestTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:ExitOpenServerInvestment()
  if not self.PlanType[CommercializeHolidayGrop.OpenServerInvest]:GetActive() then
    self.openServerInvestTemplate:Exit()
  end
end

function Commercial_LimitedTimeActivityUI:OnWarOrderPassRefresh()
  self.warOrderPassTemplate:Refresh()
end

function Commercial_LimitedTimeActivityUI:OnWarOrderPassRefreshRare()
  self.warOrderPassTemplate:RefreshRareReward()
end

function Commercial_LimitedTimeActivityUI:ExitWarOrderPass()
  if not self.PlanType[CommercializeHolidayGrop.WarOrderPass]:GetActive() then
    self.warOrderPassTemplate:Exit()
  end
end
