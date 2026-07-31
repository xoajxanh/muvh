Commercial_HolidayActivityUI = class(BaseUI)
Commercial_HolidayActivityUI.layer = UILayer.Panel
Commercial_HolidayActivityUI.orderInLayer = 2
Commercial_HolidayActivityUI.hideType = UIHideType.WaitDestroy
Commercial_HolidayActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_HolidayActivityUI.escClose = UIEscClose.DontClose

function Commercial_HolidayActivityUI:InitControls()
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
  self.holidayShopItem = self:GetControl("go_holidayShop/bg/btn_3DItem")
  self.lab_holidayShopcoin = self:GetControl("go_holidayShop/lab_holidayShopcoin")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
  self.bg_holidayGratiaGist = self:GetControl("go_holidayGratiaGift/sw_holidayGift/Viewport/holidayGift_Content/bg_holidayGist")
  self.Img_GratArrow = self:GetControl("go_holidayGratiaGift/sw_holidayGift/Img_rechangeArrow")
  self.Img_GratArrow2 = self:GetControl("go_holidayGratiaGift/sw_holidayGift/Img_rechangeArrow2")
  self.holidayGratGift_Content = self:GetControl("go_holidayGratiaGift/sw_holidayGift/Viewport/holidayGift_Content")
  self.sw_holidayGratGift = self:GetControl("go_holidayGratiaGift/sw_holidayGift")
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
  self.mountTitle = self:GetControl("go_mountShow/Viewport/Content/suitContainer/lab_TipSuitAdditional/lab")
  self.go_WorldCup = self:GetControl("go_WorldCup")
  self.go_holidayDailyGifts = self:GetControl("go_holidayDailyGifts")
  self.go_holidayPetInvest = self:GetControl("go_holidayPetInvest")
  self.go_holidaySevenDayGifts = self:GetControl("go_holidaySevenDayGifts")
  self.go_holidayBaoZhuTreasure = self:GetControl("go_holidayBaoZhuTreasure")
  self.go_holidayInvest = self:GetControl("go_holidayInvest")
  self.go_holidayConnectionGift = self:GetControl("go_holidayConnectionGift")
  self.go_holidayLuckyRebates = self:GetControl("go_holidayLuckyRebates")
  self.go_holidayGratiaGift = self:GetControl("go_holidayGratiaGift")
  self.go_diamondGashapon = self:GetControl("go_holidayDiamondGashapon")
  self.go_ShoppingSpree = self:GetControl("go_ShoppingSpree")
  self.go_holidayChristmasMonsterComing = self:GetControl("go_holidayChristmasMonsterComing")
  self.go_ChristmasNpcDailyGift = self:GetControl("go_holidayChristmasNpcDailyGift")
  self.btn_goChristmasExperience = self:GetControl("go_holidayChristmasNpcDailyGift/btn_goExperience")
  self.plane_left = self:GetControl("plane_left")
end

function Commercial_HolidayActivityUI:OnPreLoad()
end

function Commercial_HolidayActivityUI:Init()
  self.modeViewerList = {}
  self.mountUITab = {}
  self.mountModelTab = {}
end

function Commercial_HolidayActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function GetUIText(title)
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
  ctr.img_redPoint:SetActive(RedPointChecker_Ext:GetTogHolidayRedPoint(CommerceHolidayRedTogType[data.group]))
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
    local countTbl = CommercialHolidayData.GetCountInfoFun(data.countKey)
    ctr.lab_limitNum:SetText("L\198\176\225\187\163t mua c\195\178n: " .. countTbl.refreshCountLimit)
  end
  if ctr.GistBtnItemContainer == nil then
    ctr.GistBtnItemContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  local Gift
  if data.rmb then
    local rmb
    if data.rmb / 1000 > 1 then
      rmb = math.floor(data.rmb / 1000)
    else
      rmb = math.floor(data.rmb / 100)
    end
    ctr.lab_buy:SetText("" .. rmb .. "K VND")
    local BoxItem = CommercialHolidayData.GetBoxinfoFun(data.reward)
    ctr.GistBtnItemContainer:SetData(BoxItem)
    local Title = string.format(GetUIText(data.title), rmb)
    ctr.lab_holidayGistName:SetText(Title)
  else
    Gift = {}
    local cost = string.split(data.cost, "#")
    local costlab = CommercialHolidayData.GetItemInfoFun(EBindCoinsType[tonumber(cost[1])]).name
    Gift.cost = tonumber(cost[1])
    Gift.count = tonumber(cost[2])
    ctr.lab_buy:SetText(cost[2] .. costlab)
    local reward = string.split(data.reward, "#")
    local ItemuseParam = CommercialHolidayData.GetItemInfoFun(tonumber(reward[1])).useParam
    local ItemBox = string.split(ItemuseParam, "#")
    local BoxItem = CommercialHolidayData.GetBoxinfoFun(tonumber(ItemBox[2]))
    ctr.GistBtnItemContainer:SetData(BoxItem)
    local Title = string.format(GetUIText(data.title), cost[1])
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
  local mapname = CommercialHolidayData.GetMapInfoFun(data.mapId).name
  ctr.mapPiont:SetText(mapname)
  ctr.txtPiont:SetText(data.num .. " con ")
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
  local chat = CommercialHolidayData.FireworksBulletinChat
  local inputData, itemname = CommercialHolidayData.GetChatTextFun(data.configId)
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
  local Refresh, count = CommercialHolidayData.GetRefreshCountFun(data.countkey)
  count = count or CommercialHolidayData.GetCountInfoFun(data.countkey).refreshCountLimit
  local Str = string.format(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalitem2"), count)
  ctr.lab_notimes:SetText(Str)
  local Allfinish = finishCount >= #CollectGroup and 0 < count
  ctr.img_mask:SetActive(not Allfinish)
  ctr.img_redPoint:SetActive(Allfinish)
  local lab_exchange = 0 < count and (finishCount >= #CollectGroup and "Nh\225\186\173n" or "Ch\198\176a ho\195\160n th\195\160nh") or "\196\144\195\163 nh\225\186\173n xong"
  ctr.lab_exchange:SetText(lab_exchange)
  if not Allfinish then
    Commercial_HolidayActivityUI:SetSprite("Atlas_Common", "ty_btn_short_grey", ctr.itemCtr)
  else
    Commercial_HolidayActivityUI:SetSprite("Atlas_Common", "ty_btn_short3_new_yellow", ctr.itemCtr)
  end
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
  ctr.holidayItem = UIControl(ctr.transform, "btn_money/btn_3DItem")
  ctr.holidayItemData = ItemCellData()
end

local function OnShopRefresh(ctr, _, data, ui)
  local shopInfo = ParseUtility.ParseSingleCost(data.reward)
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  itemData.count = shopInfo.count
  ctr.itemModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.itemModelData, ui, true)
  local tbl = CommercialHolidayData.GetItemInfoFun(shopInfo.itemId)
  local itemName = tbl.name
  if tbl.colorShow > 0 then
    itemName = string.format("<color=%s>%s</color>", ItemQuality2ColorDic[tbl.colorShow], itemName)
  end
  ctr.itemCtr.nameCtr:SetText(itemName)
  local RefreshCount = data.RefreshCount
  if RefreshCount then
    ctr.lab_buylimit:SetText(RefreshCount .. "A")
  else
    local countTbl = CommercialHolidayData.GetCountInfoFun(data.countKey)
    if countTbl and countTbl.refreshCountLimit then
      RefreshCount = countTbl.refreshCountLimit
      ctr.lab_buylimit:SetActive(true)
      ctr.lab_buylimit:SetText(RefreshCount .. "A")
    elseif not countTbl then
      ctr.lab_buylimit:SetActive(false)
    end
  end
  if not RefreshCount then
    ctr.bgBlack:SetActive(false)
  else
    ctr.bgBlack:SetActive(RefreshCount <= 0)
  end
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
  local img = CommercialHolidayData.GetItemInfoFun(Gift.cost).icon
  ctr.Img_bg.data = data
  ctr.Img_bg.itemData = itemData
  ctr.Img_bg:SetOnClick(ui, ui.btn_ShopBuyOnClick)
  local getGlobalConfig = ClientTable.cfg_Global_globalManager:TryGetValue(75000001)
  if getGlobalConfig ~= nil and not string.isNullOrEmpty(getGlobalConfig.effect) and tonumber(getGlobalConfig.effect) ~= nil then
    local getItemId = tonumber(getGlobalConfig.effect)
    local getItemData = ItemUtility.GenerateItemData(getItemId)
    ctr.holidayItemData:RefreshData(getItemData)
    ItemUtility.ShowItemCell(ctr.holidayItem, ctr.holidayItemData, ui, true)
  end
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
  ctr.lab_name:SetText(CommercialHolidayData.Getcfg_Ui_wordFun(data.title))
  ctr.img_redPoint:SetActive(RedPointChecker_Ext.HolidayContinuousRecharge[CommerceHolidayContinuousRechargeRed[data.group]])
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
  local Item = CommercialHolidayData.GetBoxinfoFun(reward)[1]
  local ItemId = Item.itemId
  local itemData = ItemUtility.GenerateItemData(ItemId)
  itemData.count = Item.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local count = data.refreshCountLimit - giftInfo.roleCount
  local labcount = ""
  local taskid = CommercialHolidayData.Getcfg_Commerce_1Fun(data.Msg.taskId).goals
  local goalstbl = CommercialHolidayData.Getcfg_Task_goalFun(tonumber(taskid))
  local goalCount = goalstbl.goalCount
  local Residuals = goalCount - CommercialHolidayData.FireworksBulletin.count
  if 0 < count then
    local color = "#ff2323"
    local mun = CommercialHolidayData.FireworksBulletin.count
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
  ctr.txt_day:SetText(CommercialHolidayData.Getcfg_Ui_wordFun(tbl.describe))
  if not ctr.rewardContainer then
    ctr.rewardContainer = UIContainer(ctr.btn_Item, ui, OnBtnItemCreat, OnBtnItemRefresh)
  end
  local GiftTbl = CommercialHolidayData.GetGiftInfoFun(tbl.giftId)
  local Reward = CommercialHolidayData.GetBoxinfoFun(GiftTbl.reward)
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

function Commercial_HolidayActivityUI:InitUI()
  CommercialHolidayData.GetHolidayGlobal()
  self.BtnHolidayContainer = UIUtility.BindUIContainerTemp(self.Btn_Holiday, LuaComponentTemplates.Activity_CommercialHoliday_Page, self)
  self.HolidayGistContainer = UIContainer(self.bg_holidayGist, self, OnHolidayGistCreat, OnHolidayGistRefresh)
  self.HolidayGratiaGiftContainer = UIContainer(self.bg_holidayGratiaGist, self, OnHolidayGistCreat, OnHolidayGistRefresh)
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
  self.ConnectionGiftPanelUITemp = luaTemplateManager.GetNewTemplate(self.go_holidayConnectionGift, LuaComponentTemplates.ConnectionGiftPanelUITemp, self)
  self.luckyRebateTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayLuckyRebates, LuaComponentTemplates.LuckyRebateTemplate, self)
  self.firecrackerTreasureHuntingTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayBaoZhuTreasure, LuaComponentTemplates.FirecrackerTreasureHuntingTemplate, self)
  self.go_holidayInvestTemplate = luaTemplateManager.GetNewTemplate(self.go_holidayInvest, LuaComponentTemplates.HolidayInvestTemplate, self)
  self.go_diamondGashaponTemp = luaTemplateManager.GetNewTemplate(self.go_diamondGashapon, LuaComponentTemplates.Commercial_CommerceNiudanTemp, self)
  self.go_ShoppingSpreeTemp = luaTemplateManager.GetNewTemplate(self.go_ShoppingSpree, LuaComponentTemplates.ShoppingSpreeTemp, self)
  local ItemId = ClientTable.cfg_Commerce_globalManager:TryGetValue(309001, "id").effect
  local getGlobalConfig = ClientTable.cfg_Global_globalManager:TryGetValue(75000001)
  if getGlobalConfig ~= nil and not string.isNullOrEmpty(getGlobalConfig.effect) and tonumber(getGlobalConfig.effect) ~= nil then
    local getItemId = tonumber(getGlobalConfig.effect)
    local getItemData = ItemUtility.GenerateItemData(getItemId)
    local holidayShopcoinData = ItemCellData()
    holidayShopcoinData:RefreshData(getItemData)
    ItemUtility.ShowItemCell(self.holidayShopItem, holidayShopcoinData, self, true, false, 3)
  end
  self.PlanType = {
    [CommercializeHolidayGrop.DirectPurchase] = self.go_holidayGift,
    [CommercializeHolidayGrop.GiftPack] = self.go_holidayGift,
    [CommercializeHolidayGrop.BoosActivity] = self.go_holidayBoos,
    [CommercializeHolidayGrop.Exp] = self.go_holidayExperience,
    [CommercializeHolidayGrop.Fireworks] = self.go_holidayFireworks,
    [CommercializeHolidayGrop.Collect] = self.go_holidayCollect,
    [CommercializeHolidayGrop.Shop] = self.go_holidayShop,
    [CommercializeHolidayGrop.ContinuousRecharge] = self.go_rechangeGet,
    [CommercializeHolidayGrop.TurntableType] = self.go_turntable,
    [CommercializeHolidayGrop.HolidayLuckyTurntable] = self.go_holidayLuckyTurntable,
    [CommercializeHolidayGrop.Preview] = self.go_EquipZhuFuAngel,
    [CommercializeHolidayGrop.MountShow] = self.go_mountShow,
    [CommercializeHolidayGrop.WorldCupGuess] = self.go_WorldCup,
    [CommercializeHolidayGrop.PetInvest] = self.go_holidayPetInvest,
    [CommercializeHolidayGrop.SevenDayGift] = self.go_holidaySevenDayGifts,
    [CommercializeHolidayGrop.FirecrackerTreasureHunting] = self.go_holidayBaoZhuTreasure,
    [CommercializeHolidayGrop.SpringActivity] = self.go_holidayDailyGifts,
    [CommercializeHolidayGrop.HolidayInvest] = self.go_holidayInvest,
    [CommercializeHolidayGrop.ConnectionGift] = self.go_holidayConnectionGift,
    [CommercializeHolidayGrop.LuckyRebate] = self.go_holidayLuckyRebates,
    [CommercializeHolidayGrop.CommercialNiudan] = self.go_diamondGashapon,
    [CommercializeHolidayGrop.HolidayGratiaGift] = self.go_holidayGratiaGift,
    [CommercializeHolidayGrop.ShoppingSpree] = self.go_ShoppingSpree,
    [CommercializeHolidayGrop.HolidayChristmasMonster] = self.go_holidayChristmasMonsterComing,
    [CommercializeHolidayGrop.ChristmasActivity] = self.go_ChristmasNpcDailyGift
  }
  self.descBtnGroup = {
    [CommercializeHolidayGrop.BoosActivity] = {
      id = 1051,
      pos = Vector3(473, -25, 0)
    },
    [CommercializeHolidayGrop.Fireworks] = {
      id = 1052,
      pos = Vector3(95, 152, 0)
    },
    [CommercializeHolidayGrop.Collect] = {
      id = 1053,
      pos = Vector3(465, 152, 0)
    },
    [CommercializeHolidayGrop.DirectPurchase] = {
      id = 1054,
      pos = Vector3(465, 152, 0)
    },
    [CommercializeHolidayGrop.Shop] = {
      id = 1055,
      pos = Vector3(465, 152, 0)
    },
    [CommercializeHolidayGrop.HolidayLuckyTurntable] = {
      id = 1088,
      pos = Vector3(465, 152, 0)
    }
  }
  self.coinRefreshPlan = {
    [CommercializeHolidayGrop.Fireworks] = {
      id = 1000030,
      bin = 1000050,
      item1 = 53090004,
      item2 = 53090005
    },
    [CommercializeHolidayGrop.Shop] = {
      id = tonumber(ItemId)
    }
  }
  local rechangeGridLayoutGroup = self.holidayGift_Content.transform:GetComponent("GridLayoutGroup")
  self.rechangeContentcellSize = rechangeGridLayoutGroup.cellSize
  self.rechangeContentOffset = rechangeGridLayoutGroup.padding.left + math.modf(self.holidayGift_Content.transform.anchoredPosition.x)
  self.rechangeArrowPos = self.Img_rechangeArrow.gameObject.transform.localPosition
  self.rechangeArrowPos2 = self.Img_rechangeArrow2.gameObject.transform.localPosition
  local rechangeGratGridLayoutGroup = self.holidayGratGift_Content.transform:GetComponent("GridLayoutGroup")
  self.rechangeGratContentcellSize = rechangeGratGridLayoutGroup.cellSize
  self.rechangeGratContentOffset = rechangeGratGridLayoutGroup.padding.left + math.modf(self.holidayGratGift_Content.transform.anchoredPosition.x)
  self.gratArrow = self.Img_GratArrow.gameObject.transform.localPosition
  self.gratArrow2 = self.Img_GratArrow2.gameObject.transform.localPosition
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

function Commercial_HolidayActivityUI:OnShow()
  self:RegistEvents()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Holiday
  })
  self:Refresh()
end

function Commercial_HolidayActivityUI:OnHide()
  self:SetDestroyTime()
  self:RefreshShowPanel({})
  self:ResetMountModel()
  self:PageExit()
  self:PanelExit()
  self.BtnHolidayInfo = nil
  CommercialHolidayData.HolidayTogSerInfo = {}
  if self.modeViewerList then
    for i = #self.modeViewerList, 1, -1 do
      self.modeViewerList[i]:Destroy()
      table.remove(self.modeViewerList)
    end
  end
  if self.go_holidayInvestTemplate then
    self.go_holidayInvestTemplate:SetDestroyTime()
  end
end

function Commercial_HolidayActivityUI:PanelExit()
  self:HideHolidayLuckyTurntable()
  self:ExitWorldCupGuess()
  self:OnHolidayPetInvestOnHide()
  self:ExitFirecrackerTreasureHunting()
  self:ExitSevenDayGift()
  self:ExitLuckyRebate()
  self:ConnectionGiftHide()
  self:RefreshNiudanDataHide()
end

function Commercial_HolidayActivityUI:PageExit()
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

function Commercial_HolidayActivityUI:OnDestroy()
end

function Commercial_HolidayActivityUI:OnSortByCount(data)
  local acc = 0
  for i = 1, #data do
    i = i + acc
    local Refresh, count = CommercialHolidayData.GetRefreshCountFun(data[i].countKey)
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

function Commercial_HolidayActivityUI:OnSortByTask(data)
  local acc = 0
  local Red = false
  for i = 1, #data do
    i = i + acc
    local Msg = data[i].Msg
    local giftInfo = Msg.giftInfo[1]
    local GiftTbl = CommercialHolidayData.GetGiftInfoFun(giftInfo.giftId)
    data[i].GiftTbl = GiftTbl
    local countTbl = CommercialHolidayData.GetCountInfoFun(GiftTbl.countKey)
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
    RedPointChecker_Ext:HolidayRedPointRefreshState({
      redId = CommerceHolidayRedTogType[data[1].group],
      state = false
    })
    CommercialHolidayData.RedPointTogRefresh(data[1].group)
  end
end

function Commercial_HolidayActivityUI:btn_PrizeBuyOnClick(control)
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
    local data = {
      msgid = ItemBuyMessage.ReqBuy,
      message = {
        goodId = data.id,
        buyCount = 1
      }
    }
    self:DiamondPopUpTwice(data)
  end
end

function Commercial_HolidayActivityUI:DiamondPopUpTwice(data)
  local playerPrefs = string.format("%s_Commercial_HolidayActivityUI_go_holidayGratiaGift", ViewData.meData.id)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    NetManager.Send(data.msgid, data.message)
  else
    NetManager.Send(data.msgid, data.message)
  end
end

function Commercial_HolidayActivityUI:ReceiveGiftOnClick(control)
  local Count = control.count
  local Residuals = control.Residuals
  if 0 < Count and Residuals <= 0 then
    local giftid = control.giftid
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {giftid}
    })
  end
end

function Commercial_HolidayActivityUI:btn_ShopBuyOnClick(control)
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

function Commercial_HolidayActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Btn_Holiday:SetOnClick(self, self.Btn_HolidayOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.FullServerTitle:SetOnClick(self, self.FullServerTitleOnClick)
  self.PersonalTitle:SetOnClick(self, self.PersonalTitleOnClick)
  self.btn_goExperience:SetOnClick(self, self.btn_goExperienceOnClick)
  self.sw_holidayGift:SetOnEndDrag(self, self.sw_rechangeOnEndDragTeam)
  self.sw_holidayGratGift:SetOnEndDrag(self, self.sw_rechangeGratOnEndDragTeam)
  self.sw_Accumulates:SetOnEndDrag(self, self.AccumulatesOnEndDragTeam)
  self.holidayShopcoin:SetOnClick(self, self.holidayShopcoinOnClick)
  self.btn_goChristmasExperience:SetOnClick(self, self.btn_goChristmasExperienceOnClick)
end

function Commercial_HolidayActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_HolidayActivityUI)
end

function Commercial_HolidayActivityUI:Btn_HolidayOnClick(control)
end

function Commercial_HolidayActivityUI:descBtnOnClick(control)
  local id = self.descBtnGroup[control.group].id
  UIManager.Show(UIID.System_DescUI, {id = id})
end

function Commercial_HolidayActivityUI:BtnHolidayOnClick(control)
  local data = control.data
  self.BtnHolidayInfo = data
  if not data then
    return
  end
  if control.onClick and data.group == CommercializeHolidayGrop.DirectPurchase then
    NetManager.Send(CountMessage.ReqCountByType, {
      type = RefreshData.TypeEnum.HolidayPackagermb
    })
  elseif data.group == CommercializeHolidayGrop.TurntableType then
    gameMgr:GetAvatarManager():GetOtherPlayer():GetActivityDataMgr():GetTurntableUIDataMgr().turntableData.configId = 0
  elseif data.group == CommercializeHolidayGrop.HolidayLuckyTurntable then
    NetManager.Send(CommerceMessage.ReqTreasureHunt, {type = 0})
  elseif data.group == CommercializeHolidayGrop.SevenDayGift then
    NetManager.Send(CommerceMessage.ReqSevenDaysGiftsInfo)
  elseif data.group == CommercializeHolidayGrop.CommercialNiudan then
    networkRequest:ReqDiamondGashaponInfo()
  end
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Holiday, data.group, 1)
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

function Commercial_HolidayActivityUI:btn_DropDispointOnClick(control)
  local BossInfo = control.data
  if BossInfo.num > 0 then
    if TranScriptData.InTranscript then
      FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
      return
    end
    local transferId = 0
    local effect = CommercialHolidayData.GetCommerce_globalFun(305014)
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

function Commercial_HolidayActivityUI:FullServerTitleOnClick()
  self.FullServerTitle:GetChild("img_clickeffect"):SetActive(true)
  self.PersonalTitle:GetChild("img_clickeffect"):SetActive(false)
  self:RefreshFireworksBulletin(FireworksBulletinType.serverAnnounce)
end

function Commercial_HolidayActivityUI:PersonalTitleOnClick()
  self.FullServerTitle:GetChild("img_clickeffect"):SetActive(false)
  self.PersonalTitle:GetChild("img_clickeffect"):SetActive(true)
  self:RefreshFireworksBulletin(FireworksBulletinType.roleAnnounce)
end

function Commercial_HolidayActivityUI:ExecuteTextOrder(control, eventData, key)
  local inputData = control.inputData[key]
  ChatUtility.GetChatInfoTab(inputData.type, inputData, control, eventData)
end

function Commercial_HolidayActivityUI:btn_exchangeOnClick(control)
  local finish = control.finish
  local data = control.data
  if control.count <= 0 then
    FloatingTipUtility.QuickMsg(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalitem3"))
    return
  end
  if finish then
    NetManager.Send(CommerceMessage.ReqExchange, {
      commerceId = data.id
    })
  else
    FloatingTipUtility.QuickMsg(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalitem1"))
  end
end

function Commercial_HolidayActivityUI:btn_goExperienceOnClick()
  UIManager.Show(UIID.Instance_BossUI)
end

function Commercial_HolidayActivityUI:sw_rechangeOnEndDragTeam()
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

function Commercial_HolidayActivityUI:sw_rechangeGratOnEndDragTeam()
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.holidayGratGift_Content.rectTransform)
  local endPos = -math.modf(self.holidayGratGift_Content.transform.sizeDelta.x)
  local curPos = math.modf(self.holidayGratGift_Content.transform.anchoredPosition.x)
  if endPos > curPos then
    self.Img_GratArrow:SetActive(false)
    self.Img_GratArrow.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_GratArrow, self.gratArrow, "X")
    self.Img_GratArrow:SetActive(true)
  end
  if -100 < curPos then
    self.Img_GratArrow2:SetActive(false)
    self.Img_GratArrow2.gameObject.transform:DOKill()
  else
    self:SetAnimation(self.Img_GratArrow2, self.gratArrow2, "X")
    self.Img_GratArrow2:SetActive(true)
  end
end

function Commercial_HolidayActivityUI:AccumulatesOnEndDragTeam()
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

function Commercial_HolidayActivityUI:SetAnimation(btn, pos, Axles)
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

function Commercial_HolidayActivityUI:holidayShopcoinOnClick(control)
  local itemid = self.coinRefreshPlan[CommercializeHolidayGrop.Shop].id
  local itemData = ItemUtility.GenerateItemData(itemid)
  itemData.tipsPosition = Vector3(0, -85, 0)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Commercial_HolidayActivityUI:btn_goChristmasExperienceOnClick()
  UIManager.Hide(UIID.Commercial_HolidayActivityUI)
  PathFinderManager.FlyTransferScene(100101, nil, {npcId = 1001028}, Purpose.ClickNpc)
end

function Commercial_HolidayActivityUI:RegistEvents()
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
  self:RegistEvent(Event.ResHolidayInvest, self.ResHolidayInvest, self)
  self:RegistEvent(Event.LuckyRebateRefresh, self.OnLuckyRebateRefresh, self)
  self:RegistEvent(Event.LuckyRebateToggleChange, self.OnLuckyRebateToggleChange, self)
  self:RegistEvent(Event.LuckyRebatePlayAnimStateChange, self.OnLuckyRebatePlayAnimStateChange, self)
  self:RegistEvent(Event.ConnectionGift, self.ConnectionGift, self)
  self:RegistEvent(Event.NiudanDataRefresh, self.RefreshNiudanData, self)
  self:RegistEvent(Event.NiudanEEffectRefresh, self.RefreshNiudanEEffect, self)
  self:RegistEvent(Event.CrazyShoppingCarInfo, self.RefreshShoppingSpreeTemp, self)
end

function Commercial_HolidayActivityUI:SpringActivityItemDataChange(_)
  self:RefreshSpringActivityUI()
end

function Commercial_HolidayActivityUI:TurntableUI(_)
  self.TurntableUI_Templates:Refresh()
end

function Commercial_HolidayActivityUI:Commer_HolidayTog(_)
  self.BtnGroup = CommercialHolidayData.RefreshHolidayTogIdInfo(1)
  if table.count(self.BtnGroup) == 0 then
    self:btn_closeOnClick()
    return
  end
  self.BtnHolidayContainer:SetData(self.BtnGroup)
  self:RefreshShowBtn(self.BtnGroup)
end

function Commercial_HolidayActivityUI:Commer_Holidayinfo(_, msg, Refresh)
  local CurrentInfo = CommercialHolidayData.HolidaytypeDistinguish()
  if CurrentInfo.Msg ~= nil and CurrentInfo.Msg.changePage == 1 then
    self.curPageGroupId = CurrentInfo.group
    self:RefreshShowPanel(CurrentInfo)
  end
  self:ResetMountModel()
  if CurrentInfo.type == CommerceOverviewType.TaskType then
    print("\228\187\187\229\138\161")
  elseif CurrentInfo.type == CommerceOverviewType.GiftType then
    local ShowBuyInfo, ItemBuyInfo, RechargeInfo = CommercialHolidayData.RefreshHolidayGiftTypeInfo(CurrentInfo)
    self:OnSortByCount(ShowBuyInfo)
    self:OnSortByCount(ItemBuyInfo)
    if CurrentInfo.group == CommercializeHolidayGrop.Shop then
      self.ShopContainer:SetData(ShowBuyInfo)
      local Shopcoin = BagInfoData.GetItemTotalCountByItemId(self.coinRefreshPlan[CommercializeHolidayGrop.Shop].id)
      self.lab_holidayShopcoin:SetText(Shopcoin)
      local redstart = RedPointChecker_Ext.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop]]
      RedPointChecker_Ext:HolidayRedPointRefreshState({
        redId = CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop],
        state = false
      })
      if redstart then
        CommercialHolidayData.RedPointTogRefresh(CurrentInfo.group)
      end
    elseif CurrentInfo.group == CommercializeHolidayGrop.HolidayGratiaGift then
      self.HolidayGratiaGiftContainer:SetData(ItemBuyInfo)
      self:sw_rechangeGratOnEndDragTeam()
    else
      self.HolidayGistContainer:SetData(ShowBuyInfo)
      self:sw_rechangeOnEndDragTeam()
    end
  elseif CurrentInfo.type == CommerceOverviewType.RankInfo then
    print("\230\142\146\232\161\140\230\166\156")
  elseif CurrentInfo.type == CommerceOverviewType.Exp then
    self:RefreshExpActivity(CurrentInfo)
  elseif CurrentInfo.type == CommerceOverviewType.BoosActivity then
    local BoosInfo = CommercialHolidayData.RefreshHolidayBoosActivityInfo(CurrentInfo)
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
    self:RefreshEquipZhuFuAngel(CurrentInfo.commerceId)
  elseif CurrentInfo.type == CommerceOverviewType.MountShow then
    self:RefreshMountShow(CurrentInfo.commerceId)
  elseif CurrentInfo.type == CommerceOverviewType.PetInvest then
    self.holidayPetInvestTemplate:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.SpringActivity then
    self:RefreshSpringActivityUI()
  elseif CurrentInfo.type == CommerceOverviewType.PetInvest then
    self.holidayPetInvestTemplate:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.ConnectionGift then
    self.ConnectionGiftPanelUITemp:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.HolidayInvest then
    self.go_holidayInvestTemplate:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.LuckyRebate then
    self:OnLuckyRebateRefresh()
  elseif CurrentInfo.type == CommerceOverviewType.CommercialNiudan then
    self.go_diamondGashaponTemp:Refresh()
  elseif CurrentInfo.type == CommerceOverviewType.ShoppingSpree then
    self.go_ShoppingSpreeTemp:Refresh()
  end
  self:RefreshCountdownTime(CurrentInfo)
  self:PanelExit()
  if CurrentInfo.type ~= CommerceOverviewType.Preview and self.modeViewerList then
    for i = #self.modeViewerList, 1, -1 do
      self.modeViewerList[i]:Destroy()
      table.remove(self.modeViewerList)
    end
  end
end

function Commercial_HolidayActivityUI:RefreshSpringActivityUI()
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

function Commercial_HolidayActivityUI:RefreshEquipZhuFuAngel(commerceId)
  if commerceId == nil then
    return
  end
  if self.previewDesTab == nil then
    self.previewDesTab = {}
  end
  if self.previewDesTab[commerceId] == nil then
    local global_text = ClientTable.cfg_Commerce_globalManager:TryGetValue(312001, "id")
    if not string.isNullOrEmpty(global_text.effect) then
      local globalTab = string.split(global_text.effect, "&")
      for i, v in pairs(globalTab) do
        if string.contains(v, "$") then
          local itemDes = string.split(v, "$")
          self.previewDesTab[tonumber(itemDes[1])] = itemDes[2]
        end
      end
    end
  end
  self.lab_Text:SetText(self.previewDesTab[commerceId] and self.previewDesTab[commerceId] or "")
  local Listtable = {}
  local Listequip = {}
  local itetName = {}
  local img_liuguang = self:GetControl("go_EquipZhuFuAngel/Viewport/Content/img_liuguang")
  local img_liuguang2 = self:GetControl("go_EquipZhuFuAngel/Viewport/Content/img_liuguang2")
  CommercialHolidayData.EquipZhuFuAngel(Listtable, Listequip, itetName, img_liuguang, img_liuguang2, commerceId)
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

function Commercial_HolidayActivityUI:ResetMountModel()
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

function Commercial_HolidayActivityUI:RefreshMountShow(commerceId)
  if commerceId == nil then
    return self:RefreshMountTitle()
  end
  self.mountCoroutine = Coroutine.Start(self.InsMountModel, self, commerceId)
  self:RefreshMountTitle(commerceId)
end

function Commercial_HolidayActivityUI:RefreshMountTitle(commerceId)
  if self.mountDesTab == nil then
    self.mountDesTab = {}
  end
  if self.mountDesTab[commerceId] == nil then
    local global_text = ClientTable.cfg_Commerce_globalManager:TryGetValue(312002, "id")
    if not string.isNullOrEmpty(global_text.effect) then
      local globalTab = string.split(global_text.effect, "&")
      for i, v in pairs(globalTab) do
        if string.contains(v, "$") then
          local itemDes = string.split(v, "$")
          self.mountDesTab[tonumber(itemDes[1])] = itemDes[2]
        end
      end
    end
  end
  self.mountTitle:SetText(self.mountDesTab[commerceId] and self.mountDesTab[commerceId] or "")
end

function Commercial_HolidayActivityUI:InsMountModel(commerceId)
  local data = CommercialHolidayData.GetMountExhibitionData(commerceId)
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

function Commercial_HolidayActivityUI:SetMountName(index, name)
  if self.mountUITab[index] then
    local nameUI = self.mountUITab[index]:GetChild("tip")
    nameUI:SetText(name)
  end
end

function Commercial_HolidayActivityUI:SetMountModel(index, go)
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

function Commercial_HolidayActivityUI:Commer_HolidayserReqinfo(_)
  if self.BtnHolidayInfo then
    self:BtnHolidayOnClick({
      data = self.BtnHolidayInfo
    })
  end
  Commercial_HolidayActivityUI:CollectRefresh()
end

function Commercial_HolidayActivityUI:Bag_ResBagChange(_, msg)
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
        if self.BtnHolidayInfo.group == CommercializeHolidayGrop.Fireworks and (showItemTbl[v.bin] or showItemTbl[v.item1] or showItemTbl[v.item2]) then
          self:Commer_Holidayinfo(nil, nil, true)
          return
        end
      end
    end
  end
end

function Commercial_HolidayActivityUI:ServerAnnounceRefresh(_)
  if self.go_holidayFireworks:GetActive() and self.FullServerTitle:GetChild("img_clickeffect"):GetActive() then
    self:FullServerTitleOnClick()
  end
end

function Commercial_HolidayActivityUI:RoleAnnounceRefresh(_)
  if self.go_holidayFireworks:GetActive() and self.PersonalTitle:GetChild("img_clickeffect"):GetActive() then
    self:PersonalTitleOnClick()
  end
end

function Commercial_HolidayActivityUI:CollectRefresh()
  if self.PlanType[CommercializeHolidayGrop.Collect]:GetActive() then
    self:RefreshCollectActivity()
    CommercialHolidayData.RedPointCollect()
  end
end

function Commercial_HolidayActivityUI:RefreshZeroTime()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Holiday
  })
end

function Commercial_HolidayActivityUI:Refresh()
end

function Commercial_HolidayActivityUI:RefreshShowBtn(data)
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
    for i, v in pairs(RedPointChecker_Ext.HolidayTogGrop) do
      if v then
        local group = CommerceHolidayTogRed[i]
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

function Commercial_HolidayActivityUI:RefreshShowPanel(data)
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
    local state = true
    if data.group == CommercializeHolidayGrop.Shop then
      state = false
    end
    self.descBtn:SetActive(state)
  else
    self.descBtn:SetActive(false)
  end
end

function Commercial_HolidayActivityUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

local DaojiTime = 0

function Commercial_HolidayActivityUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_HolidayActivityUI:RefreshCountdownTime(data)
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
  if data.group == CommercializeHolidayGrop.Fireworks then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    self:FireworksCountdownTime(Difference)
    return
  elseif data.group == CommercializeHolidayGrop.HolidayLuckyTurntable then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    self.holidayLuckyTurntableTemplate:RefreshCountdownTime(Difference)
    return
  elseif data.group == CommercializeHolidayGrop.WorldCupGuess or data.group == CommercializeHolidayGrop.SevenDayGift or data.group == CommercializeHolidayGrop.SpringActivity or data.group == CommercializeHolidayGrop.FirecrackerTreasureHunting or data.group == CommercializeHolidayGrop.PetInvest or data.group == CommercializeHolidayGrop.LuckyRebate or data.group == CommercializeHolidayGrop.ConnectionGift or data.group == CommercializeHolidayGrop.CommercialNiudan or data.group == CommercializeHolidayGrop.ShoppingSpree then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    return
  end
  if self.PlanType[CommercializeHolidayGrop.PetInvest]:GetActive() then
    self.txt_lastTime:SetText("")
    self.lab_lastTime:SetText("")
    return
  end
  if self.PlanType[CommercializeHolidayGrop.HolidayInvest]:GetActive() then
    if data and data.group == CommercializeHolidayGrop.HolidayInvest then
      self.txt_lastTime:SetText("")
      self.lab_lastTime:SetText("")
      if self.go_holidayInvestTemplate then
        self.go_holidayInvestTemplate:RefreshCountdownTime(Difference)
      end
    end
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

function Commercial_HolidayActivityUI:FireworksRefreshTime(FireworksfireTime)
  if 0 < FireworksDaojiTime then
    FireworksDaojiTime = FireworksDaojiTime - 1
    local DaoJiShi = self:FireworksShowDayHourMin(FireworksDaojiTime)
    FireworksfireTime:SetText("AE" .. DaoJiShi)
  else
    FireworksfireTime:SetText("")
  end
end

function Commercial_HolidayActivityUI:FireworksCountdownTime(Difference)
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

function Commercial_HolidayActivityUI:FireworksShowDayHourMin(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Ceil(sec % ETimeSec.hour / ETimeSec.min)
  timeStr = string.format(LocalizationUtility.GetContentByKey("FestivalYanhua2"), day, hour, min)
  return timeStr
end

function Commercial_HolidayActivityUI:RefreshBoosActivity(data)
  local BoosInfo = data
  local awardTab = CommercialHolidayData.GetRewardTbl(BoosInfo)
  EffectScale = Vector3(1.8, 1.8, 500)
  self.BoosAwardItemContainer:SetData(awardTab)
  self.lab_BoosnotRefresh:SetActive(#BoosInfo.Msg == 0)
  if #BoosInfo.Msg ~= 0 then
    self.pointPosContainer:SetData(BoosInfo.Msg)
  else
    self.pointPosContainer:SetData({})
  end
end

function Commercial_HolidayActivityUI:RefreshFireworksActivity(data, Refresh)
  local ShowBuyInfo, ShowReward = CommercialHolidayData.RefreshHolidayFireworksInfo(data)
  EffectScale = Vector3(2.3, 2.3, 500)
  self.FireworksItemContainer:SetData(ShowReward)
  self.FireworkBuyContainer:SetData(ShowBuyInfo)
  if not Refresh then
    self:FullServerTitleOnClick()
  end
  local TaskInfo = CommercialHolidayData.RefreshHolidayTaskInfo(data)
  self:OnSortByTask(TaskInfo)
  self.lab_FireworksCount:SetText(CommercialHolidayData.FireworksBulletin.count)
  self.FireworkGiftPropContainer:SetData(TaskInfo)
end

function Commercial_HolidayActivityUI:RefreshFireworksBulletin(type)
  if type == FireworksBulletinType.roleAnnounce then
    table.sort(CommercialHolidayData.FireworksBulletin.roleAnnounce, function(a, b)
      return a.time > b.time
    end)
    self.FireworkBulletinContainer:SetData(CommercialHolidayData.FireworksBulletin.roleAnnounce)
  else
    local serverTopAnnounce = CommercialHolidayData.FireworksBulletin.serverTopAnnounce
    for i, v in pairs(serverTopAnnounce) do
      v.Top = true
    end
    local server = table.DeepCopy(CommercialHolidayData.FireworksBulletin.serverAnnounce)
    table.sort(server, function(a, b)
      return a.time > b.time
    end)
    local serverTop = table.DeepCopy(CommercialHolidayData.FireworksBulletin.serverTopAnnounce)
    table.sort(serverTop, function(a, b)
      return a.time > b.time
    end)
    local AllSerBulletin = table.combine(serverTop, server)
    self.FireworkBulletinContainer:SetData(AllSerBulletin)
  end
end

function Commercial_HolidayActivityUI:RefreshCollectActivity(data)
  local ShowCollectInfo = CommercialHolidayData.RefreshCollectInfo()
  self.CollectContainer:SetData(ShowCollectInfo)
end

function Commercial_HolidayActivityUI:RefreshExpActivity(data)
  self.tip_Experience:SetText(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalexp"))
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

function Commercial_HolidayActivityUI:RefreshTurntable(data)
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
    local StarryTbl = CommercialHolidayData.GetCommerce_CircleFun(tblid)
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
    self.turntablerechargeTip:SetText(string.format(string.format(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalplant3"), rmb, count)))
  end
  self.turntableDown:SetActive(lastreminfo ~= nil)
  self.turntablevertex.count = luckyTurnTable.count
  self.turntablevertex.receive = luckyTurnTable.receive
  local color = 0 < luckyTurnTable.count and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  self.turntablevertex:GetChild("Text"):SetText(string.GetColorText(string.format(CommercialHolidayData.Getcfg_Ui_wordFun("Festivalplant1"), luckyTurnTable.count), color))
end

local AllItemModel = {}

local function CollectAllItemModel(modelData)
  if not table.contains(AllItemModel, modelData) then
    table.insert(AllItemModel, modelData)
  end
end

function Commercial_HolidayActivityUI:InitturntableUseItemBtn(Count)
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

function CommercialHolidayData.GetCommerce_CircleFun(id)
  return ConfigManager.GetConfig("cfg_Commerce_Circle", id, "id")
end

function Commercial_HolidayActivityUI:BtnRechangeGetOnClick(control)
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
    local GiftTbl = CommercialHolidayData.GetGiftInfoFun(additional.tbl.giftId)
    local Reward = CommercialHolidayData.GetBoxinfoFun(GiftTbl.reward)
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

function Commercial_HolidayActivityUI:btn_goRechargeOnClick(control)
  local PayType = control.PayType
  RechargeData.BuyDiamond(PayType)
end

function Commercial_HolidayActivityUI:btn_get(control)
  local giftId = control.giftId
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {giftId}
  })
end

function Commercial_HolidayActivityUI:RefreshContinuousRecharge(data)
  local allcount = self.Btn_rechangeGetContainer.data and #self.Btn_rechangeGetContainer.data or 0
  for i = 1, allcount do
    local tog = self.Btn_rechangeGetContainer:GetOrCreateItem(i)
    if tog.img_clickeffect:GetActive() then
      self.ContinuousRechargeIndex = i
    end
  end
  local TogInfo = CommercialHolidayData.GetContinuousRechargeTog(data.Msg.taskInfo, self.CommerceType)
  if not self.ContinuousRechargeIndex then
    self.ContinuousRechargeIndex = 1
  end
  self.ContinuousRechargeIndex = self.ContinuousRechargeIndex and (self.ContinuousRechargeIndex <= #TogInfo and self.ContinuousRechargeIndex or 1) or 1
  self.Btn_rechangeGetContainer:SetData(TogInfo)
end

function Commercial_HolidayActivityUI:HideHolidayLuckyTurntable()
  if not self.PlanType[CommercializeHolidayGrop.HolidayLuckyTurntable]:GetActive() then
    self.holidayLuckyTurntableTemplate:OnHide()
  end
end

function Commercial_HolidayActivityUI:RefreshHolidayLuckyTurntable()
  self.holidayLuckyTurntableTemplate:Refresh()
end

function Commercial_HolidayActivityUI:LuckyDrawEffect()
  self.holidayLuckyTurntableTemplate:ShowLuckyDrawMoveEffect()
end

function Commercial_HolidayActivityUI:GiftLogTurntableUI()
  self.holidayLuckyTurntableTemplate:RefreshShowGiftLog()
end

function Commercial_HolidayActivityUI:OnWorldCupGuessRefresh()
  self.worldCupGuessTemplate:Refresh()
end

function Commercial_HolidayActivityUI:OnWorldCupGuessPanelOpen(_, msg)
  self.worldCupGuessTemplate:OnWorldCupGuessPanelOpen(_, msg)
end

function Commercial_HolidayActivityUI:ExitWorldCupGuess()
  if not self.PlanType[CommercializeHolidayGrop.WorldCupGuess]:GetActive() then
    self.worldCupGuessTemplate:Exit()
  end
end

function Commercial_HolidayActivityUI:OnHolidayPetInvestRefresh()
  self.holidayPetInvestTemplate:Refresh()
end

function Commercial_HolidayActivityUI:OnHolidayPetInvestOnHide()
  if self.holidayPetInvestTemplate and not self.PlanType[CommercializeHolidayGrop.PetInvest]:GetActive() then
    self.holidayPetInvestTemplate:OnHide()
  end
end

function Commercial_HolidayActivityUI:OnSevenDayGiftRefresh()
  self.sevenDayGiftTemplate:Refresh()
end

function Commercial_HolidayActivityUI:ExitSevenDayGift()
  if not self.PlanType[CommercializeHolidayGrop.SevenDayGift]:GetActive() then
    self.sevenDayGiftTemplate:Exit()
  end
end

function Commercial_HolidayActivityUI:FTHOnDrawnRewardRefresh()
  self.firecrackerTreasureHuntingTemplate:Refresh()
end

function Commercial_HolidayActivityUI:FTHCumulativeRewardsRefresh()
  self.firecrackerTreasureHuntingTemplate:RefreshCumulativeRewards()
end

function Commercial_HolidayActivityUI:ExitFirecrackerTreasureHunting()
  if not self.PlanType[CommercializeHolidayGrop.FirecrackerTreasureHunting]:GetActive() then
    self.firecrackerTreasureHuntingTemplate:OnHide()
  end
end

function Commercial_HolidayActivityUI:ResHolidayInvest()
  if self.go_holidayInvestTemplate then
    self.go_holidayInvestTemplate:RefreshPositionView()
  end
end

function Commercial_HolidayActivityUI:OnLuckyRebateRefresh()
  self.luckyRebateTemplate:Refresh()
end

function Commercial_HolidayActivityUI:OnLuckyRebateToggleChange(_, msg)
  self.luckyRebateTemplate:RefreshGradePlane(msg.data, msg.isPlayAnim)
end

function Commercial_HolidayActivityUI:OnLuckyRebatePlayAnimStateChange(_, msg)
  self.luckyRebateTemplate:RefreshPlayAnimState(msg)
end

function Commercial_HolidayActivityUI:ConnectionGift()
  self.ConnectionGiftPanelUITemp:Refresh()
end

function Commercial_HolidayActivityUI:ConnectionGiftHide()
  if not self.PlanType[CommercializeHolidayGrop.ConnectionGift]:GetActive() then
    self.ConnectionGiftPanelUITemp:Hide()
  end
end

function Commercial_HolidayActivityUI:ExitLuckyRebate()
  if not self.PlanType[CommercializeHolidayGrop.LuckyRebate]:GetActive() then
    self.luckyRebateTemplate:Exit()
  end
end

function Commercial_HolidayActivityUI:RefreshNiudanData()
  if self.go_diamondGashaponTemp then
    self.go_diamondGashaponTemp:Refresh()
  end
end

function Commercial_HolidayActivityUI:RefreshNiudanEEffect()
  if self.go_diamondGashaponTemp then
    self.go_diamondGashaponTemp:LoadEffectUI()
  end
end

function Commercial_HolidayActivityUI:RefreshNiudanDataHide()
  if not self.PlanType[CommercializeHolidayGrop.CommercialNiudan]:GetActive() then
    self.go_diamondGashaponTemp:Hide()
  end
end

function Commercial_HolidayActivityUI:RefreshShoppingSpreeTemp()
  if self.PlanType[CommercializeHolidayGrop.ShoppingSpree]:GetActive() then
    self.go_ShoppingSpreeTemp:Refresh()
  end
end
