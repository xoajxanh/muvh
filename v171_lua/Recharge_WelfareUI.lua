Recharge_WelfareUI = class(BaseUI)
Recharge_WelfareUI.layer = UILayer.Panel
Recharge_WelfareUI.orderInLayer = 3
Recharge_WelfareUI.hideType = UIHideType.WaitDestroy
Recharge_WelfareUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_WelfareUI.escClose = UIEscClose.DontClose

function Recharge_WelfareUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.tog_prizeList = self:GetControl("sw_welfareList/Viewport/Content/tog_prizeList")
  self.tog_everyDayRechang = self:GetControl("sw_welfareList/Viewport/Content/tog_everyDayRechang")
  self.tog_rechangeList = self:GetControl("sw_welfareList/Viewport/Content/tog_rechangeList")
  self.tog_dailyRechang = self:GetControl("sw_welfareList/Viewport/Content/tog_dailyRechang")
  self.tog_lifeLimitBuy = self:GetControl("sw_welfareList/Viewport/Content/tog_lifeLimitBuy")
  self.sw_prize = self:GetControl("sw_prize")
  self.PrizeOne = self:GetControl("sw_prize/PrizeOne")
  self.btn_prizeAllbuy = self:GetControl("sw_prize/PrizeOne/BuyAllGift/btn_buy")
  self.lab_prizeAllbuy = self:GetControl("sw_prize/PrizeOne/BuyAllGift/btn_buy/lab_buy")
  self.price_top_one = self:GetControl("sw_prize/PrizeOne/price_top_one")
  self.btn_prizeone = self:GetControl("sw_prize/PrizeOne/btn_prizeone")
  self.img_redPoint = self:GetControl("sw_prize/PrizeOne/btn_prizeone/img_redPoint")
  self.price_one = self:GetControl("sw_prize/PrizeOne/price_one")
  self.PrizeOneContent = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent")
  self.bg_freePrize = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize")
  self.lab_freePrizeName = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize/lab_freePrizeName")
  self.btn_freePrize = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize/btn_freePrize")
  self.lab_RecePrize = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize/lab_RecePrize")
  self.lab_countDown = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize/lab_countDown ")
  self.sw_freePrizeItem = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_freePrize/sw_freePrizeItem")
  self.bg_buyPrize = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize")
  self.lab_buyPrizeName = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize/lab_buyPrizeName")
  self.btn_buyPrize = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize/btn_buyPrize")
  self.lab_buy = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize/btn_buyPrize/lab_buy")
  self.gogem = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize/lab_gem/gogem")
  self.sw_buyPrizeItem = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/PrizeOneContent/bg_buyPrize/sw_buyPrizeItem")
  self.btn_3DItem = self:GetControl("sw_prize/PrizeOne/price_one/Viewport/btn_3DItem")
  self.PrizeTwo = self:GetControl("sw_prize/PrizeTwo")
  self.price_two = self:GetControl("sw_prize/PrizeTwo/price_two")
  self.price_twoContent = self:GetControl("sw_prize/PrizeTwo/price_two/Viewport/price_twoContent")
  self.get_price_item_free = self:GetControl("sw_prize/PrizeTwo/price_two/Viewport/price_twoContent/get_price_item_free")
  self.price_top_two = self:GetControl("sw_prize/PrizeTwo/price_top_two")
  self.btn_prizetwo = self:GetControl("sw_prize/PrizeTwo/btn_prizetwo")
  self.price_count = self:GetControl("sw_prize/prize_count/price_count")
  self.sw_rechange = self:GetControl("sw_rechange")
  self.rechange_Content = self:GetControl("sw_rechange/Viewport/rechange_Content")
  self.bg_rechange = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange")
  self.img_rechagePicture = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/img_rechagePicture")
  self.go_gem3D = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/go_gem3D")
  self.btn_rechange = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/btn_rechange")
  self.go_gemReward = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/img_fristReward/lab_fristGemReward/go_gemReward")
  self.sw_fristItemReward = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/img_fristReward/sw_fristItemReward")
  self.btn_rechangeSwItem = self:GetControl("sw_rechange/Viewport/rechange_Content/bg_rechange/img_fristReward/sw_fristItemReward/Viewport/Content/btn_rechangeSwItem")
  self.Img_rechangeArrow = self:GetControl("sw_rechange/Img_rechangeArrow")
  self.sw_lifeLimitBuy = self:GetControl("sw_lifeLimitBuy")
  self.PrizeOne_Limit = self:GetControl("sw_lifeLimitBuy/PrizeOne_Limit")
  self.bg_buyPrize_limit = self:GetControl("sw_lifeLimitBuy/PrizeOne_Limit/price_one_limit/Viewport/PrizeOneContent/bg_buyPrize_limit")
  self.go_everyDayRechang = self:GetControl("go_everyDayRechang")
  self.btn_Itemprecious = self:GetControl("go_everyDayRechang/go_show/sw_show/Viewport/Content/btn_Itemprecious")
  self.sw_everyDayRechang = self:GetControl("go_everyDayRechang/sw_everyDayRechang")
  self.img_dataBgevery = self:GetControl("go_everyDayRechang/img_dataBgevery")
  self.lab_taskName = self:GetControl("go_everyDayRechang/img_dataBgevery/lab_taskName")
  self.descBtnevery = self:GetControl("go_everyDayRechang/descBtnevery")
  self.go_dailyRechang = self:GetControl("go_dailyRechang")
  self.img_dataBgdaily = self:GetControl("go_dailyRechang/sw_dailyRechang/Viewport/Content/img_dataBgdaily")
  self.descBtndaily = self:GetControl("go_dailyRechang/descBtndaily")
  self.tog_TimeLimitBuy = self:GetControl("sw_welfareList/Viewport/Content/tog_TimeLimitBuy")
  self.sw_TimeLimitBuy = self:GetControl("sw_TimeLimitBuy")
  self.bg_TimeLimitBuyPrize = self:GetControl("sw_TimeLimitBuy/TimeLimitGift/TimeLimit_gift/Viewport/PrizeOneContent/bg_buyPrize")
  self.timeLimit_gift = self:GetControl("sw_TimeLimitBuy/TimeLimitGift/TimeLimit_gift")
  self.TimeLimit_time = self:GetControl("sw_TimeLimitBuy/TimeLimitGift/TimeLimit_time")
  self.tog_AccumulativeGift = self:GetControl("sw_welfareList/Viewport/Content/tog_AccumulativeGift")
  self.go_AccumulativeGift = self:GetControl("go_AccumulativeGift")
  self.img_dataBgAccumulative = self:GetControl("go_AccumulativeGift/sw_AccumulativeGift/Viewport/Content/img_dataBgAccumulative")
  self.descAccumulativeBtn = self:GetControl("go_AccumulativeGift/descBtndaily")
  self.sw_AccumulativeGift = self:GetControl("go_AccumulativeGift/sw_AccumulativeGift")
  self.AccumulativeGiftImage = self:GetControl("go_AccumulativeGift/img_bg")
  self.tog_LuckyStar = self:GetControl("sw_welfareList/Viewport/Content/tog_LuckyStar")
  self.go_LuckyStar = self:GetControl("go_LuckyStar")
  self.lab_desc_count = self:GetControl("go_everyDayRechang/lab_desc_count")
  self.tog_rechargeReward = self:GetControl("sw_welfareList/Viewport/Content/tog_rechargeReward")
  self.sw_rechargeReward = self:GetControl("sw_rechargeReward")
  self.tog_DirectPurchaseGift = self:GetControl("sw_welfareList/Viewport/Content/tog_DirectPurchaseGift")
  self.sw_DirectPurchaseGift = self:GetControl("sw_DirectPurchaseGift")
  self.bg_buyPrize_DirectPurchaseGift = self:GetControl("sw_DirectPurchaseGift/PurchaseGift/PurchasePrice_one/Viewport/PriceOneContent/bg_buyPrize")
  self.sw_PurchasePrice_one = self:GetControl("sw_DirectPurchaseGift/PurchaseGift/PurchasePrice_one")
  self.price_one_limit = self:GetControl("sw_lifeLimitBuy/PrizeOne_Limit/price_one_limit")
  self.tog_rechargeDaiBi = self:GetControl("sw_welfareList/Viewport/Content/tog_rechargeDaibi")
  self.sw_reChangeDaiBi = self:GetControl("sw_rechangeDaibi")
  self.bg_reChange = self:GetControl("sw_rechangeDaibi/Viewport/rechange_Content/bg_rechange")
end

function Recharge_WelfareUI:OnPreLoad()
end

local ToggerGroup = {}
local Page = {
  EveryDay = 1,
  Daily = 2,
  Prize = 3,
  Rechange = 4,
  LimitBuy = 5,
  TimeLimitBuy = 6,
  AccumulativeGift = 7,
  LuckyStar = 8,
  DirectPurchaseGift = 9,
  GoldDiamondRecharge = 10,
  TokenRecharge = 11
}
local this = Recharge_WelfareUI

function Recharge_WelfareUI:Init()
  self.prize = false
  self.directPurchaseGift = false
  self.rechange = false
  self.everyDay = true
  self.dailyDay = false
  self.LimitBuy = false
  self.timeLimitBuy = false
end

function Recharge_WelfareUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function GetUIText(title)
  return LocalizationUtility.GetContentByKey(title)
end

local function OnEveryPreciousCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnEveryDayPreciousRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  if _ <= 4 and not ctr.effobj then
    ctr.effobj = UIEffectUtility.SetUIEffect("Eff_UI_xuanshangjiangli02", ctr, true, Vector3(2.1, 2.1, 500))
  end
end

local function OnRechItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnRechItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnDailyRechCreat(ctr)
  ctr.lab_taskName = UIControl(ctr.transform, "lab_taskName")
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.btn_get = UIControl(ctr.transform, "go_state/btn_get")
  ctr.lab_buy = UIControl(ctr.transform, "go_state/btn_get/lab_buy")
  ctr.lab_alreadyGet = UIControl(ctr.transform, "go_state/lab_alreadyGet")
  ctr.sl_progress = UIControl(ctr.transform, "sl_progress")
  ctr.lab_progress = UIControl(ctr.transform, "sl_progress/lab_progress")
  ctr.img_Fill = UIControl(ctr.transform, "sl_progress/Fill Area/Fill")
end

local function OnDailyRechRefresh(ctr, _, data, ui)
  local title = GetUIText(data.giftdata.title)
  if ctr.DailyItemContainer == nil then
    ctr.DailyItemContainer = UIContainer(ctr.btn_Item, ui, OnRechItemCreat, OnRechItemRefresh)
  end
  ctr.DailyItemContainer:SetData(data.giftitem)
  ui:StopSetSpriteCoroutine(ctr.spriteCol)
  ctr.btn_get:SetActive(false)
  ctr.lab_alreadyGet:SetActive(false)
  if data.goaldata.goalCount == 1 then
    ctr.sl_progress:SetActive(false)
  else
    ctr.sl_progress:SetActive(true)
    local slider = data.massge.count / data.goaldata.goalCount
    slider = 1 <= slider and 1 or 0 < slider and slider <= 0.06 and 0.06 or slider
    ctr.img_Fill:SetFillAmount(slider)
    local mssgecout = math.modf(data.massge.count)
    local goalCount = math.modf(data.goaldata.goalCount)
    ctr.lab_progress:SetText(mssgecout .. "/" .. goalCount)
    title = string.format(title, ColorUtility.GetConsumableCountStr(mssgecout, goalCount, EConsumableStrType.Normal))
  end
  if data.massge.count >= data.goaldata.goalCount then
    if data.Received then
      ctr.lab_alreadyGet:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(false)
    else
      ctr.spriteCol = ui:SetSprite("Atlas_Common", "ty_btn_short3_new_yellow", ctr.btn_get)
      ctr.lab_buy:SetText("Nh\225\186\173n th\198\176\225\187\159ng")
      ctr.btn_get.id = data.giftdata.id
      ctr.btn_get:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(true)
    end
  else
    ctr.spriteCol = ui:SetSprite("Atlas_Common", "ty_btn_short3_new", ctr.btn_get)
    ctr.lab_buy:SetText("\196\144i n\225\186\161p")
    ctr.btn_get.id = nil
    ctr.btn_get:SetActive(true)
    ctr.btn_get:GetChild("img_redPoint"):SetActive(false)
  end
  ctr.btn_get:SetOnClick(ui, ui.DayGetGiftBtn)
  ctr.lab_taskName:SetText(title)
end

local function BuyPrizeRewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function BuyPrizeRewardRefresh(ctr, index, data, ui)
  if data == nil or data.itemId == 2220051 then
    ctr:SetActive(false)
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  local count
  if data.count / 1000 >= 1 then
    local divided = data.count / 1000
    if divided % 1 == 0 then
      count = string.format("%dA", divided)
    else
      count = string.format("%sA", divided)
    end
  else
    count = data.count
  end
  itemData.count = count
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local atlasStr = "Atlas_Common"

local function SetItemImage(itemId, ctr)
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  this:SetSprite(atlasStr, itemData.tblItem.icon, ctr)
end

local function OnBuyPrizeCreat(ctr)
  ctr.title = UIControl(ctr.transform, "lab_buyPrizeName")
  ctr.lab_buy = UIControl(ctr.transform, "btn_buyPrize/lab_buy")
  ctr.lab_buyRMB = UIControl(ctr.transform, "btn_buyPrize/lab_buyRMB")
  ctr.image_redpoint = UIControl(ctr.transform, "btn_buyPrize/img_Gift_redPoint")
  ctr.lab_gem = UIControl(ctr.transform, "lab_gem")
  ctr.gemitemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "lab_gem/gogem/img_icon"))
  ctr.gemmodelData = ItemCellData()
  ctr.subTitle = UIControl(ctr.transform, "lab_buyPrizelimit")
  ctr.btn_rewardItem = UIControl(ctr.transform, "sw_buyPrizeItem/Viewport/Content/btn_3DItem")
  ctr.btn_reward_Content = UIControl(ctr.transform, "sw_buyPrizeItem/Viewport/Content")
  ctr.item_btn_Buy = UIControl(ctr.transform, "btn_buyPrize")
  ctr.lab_Received = UIControl(ctr.transform, "lab_Received")
end

function Recharge_WelfareUI.SetGroupConstraintCount(ContentObject, dataCount)
  if ContentObject == nil or ContentObject.transform == nil or dataCount == nil then
    return
  end
  local btn_reward_ContentLayoutGroup = ContentObject.transform:GetComponent("GridLayoutGroup")
  if btn_reward_ContentLayoutGroup ~= nil then
    if dataCount <= 4 then
      btn_reward_ContentLayoutGroup.constraintCount = 2
    else
      btn_reward_ContentLayoutGroup.constraintCount = 3
    end
  end
end

local GuideEffecName = "Eff_UI_annuikuang06"

local function OnFreePrizeRefresh(ctr, index, data, ui)
  if not data then
    ctr.gameObject:SetActive(false)
    return
  end
  local effectItem = ctr.transform:Find(GuideEffecName)
  if effectItem ~= nil then
    effectItem.gameObject:SetActive(false)
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_everydayRMBgift
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_Pccharge
  })
  local titleInfor = string.split(data.title, "#")
  local subtitleStr = ""
  ctr.lab_buyRMB:SetActive(false)
  ctr.lab_buy:SetActive(true)
  ctr.item_btn_Buy:GetChild("diamondIma"):SetActive(false)
  ctr.lab_buy.transform.localPosition = Vector2.New(8, 0)
  ctr.lab_buy:SetText("Nh\225\186\173n")
  ctr.image_redpoint.gameObject:SetActive(true)
  ctr.title:SetText(ConfigManager.FindConfigs("cfg_Ui_word", "id", titleInfor[1])[1].content)
  ctr.subTitle:SetText(subtitleStr)
  if data.diamond ~= nil and data.diamond ~= 0 then
    ctr.lab_gem:SetActive(true)
    local diamondInfo = RechargeData.GetItemIdAndCount(data.diamond)
    local itemData = ItemUtility.GenerateItemData(diamondInfo[1].itemId)
    itemData.count = diamondInfo[1].count
    ctr.gemmodelData:RefreshData(itemData)
    ctr.gemmodelData.itemData.tipsPosition = Vector3(0, -35, 0)
    ItemUtility.ShowItemCell(ctr.gemitemCtr, ctr.gemmodelData, ui, true)
  else
    ctr.lab_gem:SetActive(false)
  end
  local rewardInfors = RechargeData.GetItemIdAndCount(data.reward)
  if ctr.rewardContainer == nil then
    ctr.rewardContainer = UIContainer(ctr.btn_rewardItem, ui, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
  end
  if 0 < #rewardInfors then
    ctr.rewardContainer:SetData(rewardInfors)
  end
  ui:StopSetSpriteCoroutine(ctr.spriteCol)
  if 0 >= data.residueTime then
    ctr.item_btn_Buy:SetActive(false)
    ctr.lab_Received:SetActive(true)
  else
    ctr.spriteCol = ui:SetSprite("Atlas_Common", "ty_btn_short3_new_yellow", ctr.item_btn_Buy)
    ctr.lab_Received:SetActive(false)
    ctr.item_btn_Buy:SetActive(true)
    ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
      NetManager.Send(RechargeMessage.ReqGetGift, {
        id = {
          data.id
        }
      })
    end)
  end
end

local function DiamondPopUpTwice(data)
  local playerPrefs = string.format("%s_DailyGiftPackTodayIsShowPromptTipUI", ViewData.meData.id, data.payType)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = data.id,
      buyCount = 1
    })
  else
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = data.id,
      buyCount = 1
    })
  end
end

local function OnRechargePrizeRefresh(ctr, index, data, ui)
  if not data then
    ctr.gameObject:SetActive(false)
    return
  end
  ctr.image_redpoint.gameObject:SetActive(false)
  ctr.lab_buy:SetActive(false)
  ctr.lab_buyRMB:SetActive(false)
  local count, limitCount = RechargeData.GetBuyPrizeLimitCountData(data.countKey)
  local subtitleStr = ""
  subtitleStr = string.format("<color=green><size=22>%s</size></color>", count)
  subtitleStr = string.format(RechargeData.UIWordContainer.RechargeSubtitle_1, subtitleStr)
  ctr.subTitle:SetText(subtitleStr)
  if data.diamond ~= nil and data.diamond ~= 0 then
    ctr.lab_gem:SetActive(true)
    local diamondInfo = RechargeData.GetItemIdAndCount(data.diamond)
    local itemData = ItemUtility.GenerateItemData(diamondInfo[1].itemId)
    itemData.count = diamondInfo[1].count
    ctr.gemmodelData:RefreshData(itemData)
    ctr.gemmodelData.itemData.tipsPosition = Vector3(0, -35, 0)
    ItemUtility.ShowItemCell(ctr.gemitemCtr, ctr.gemmodelData, ui, true)
  else
    ctr.lab_gem:SetActive(false)
  end
  ui:StopSetSpriteCoroutine(ctr.spriteCol)
  local effectItem = ctr.transform:Find(GuideEffecName)
  if effectItem ~= nil then
    effectItem.gameObject:SetActive(false)
  end
  if 0 >= data.residueTime then
    ctr.item_btn_Buy:SetActive(false)
    ctr.lab_Received:SetActive(true)
  else
    local isShopID = false
    if ui.args and ui.args.shopID ~= nil and string.find(ui.args.shopID, "|") then
      for i, v in pairs(string.split(ui.args.shopID, "|")) do
        if tonumber(v) == data.id then
          isShopID = true
          break
        end
      end
    end
    if ui.args and (ui.args.ZhuanZhong == data.id or ui.args.ZhuanZhongII == data.id or ui.args.ZhuanZhongIII == data.id or isShopID == true) then
      if not effectItem then
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(2.1, 2.5), Vector3(0, -180, 0))
      else
        effectItem.gameObject:SetActive(true)
      end
      ui.args.ZhuanZhong = nil
    end
    ctr.spriteCol = ui:SetSprite("Atlas_Common", "ty_btn_short3_new", ctr.item_btn_Buy)
    ctr.lab_Received:SetActive(false)
    ctr.item_btn_Buy:SetActive(true)
  end
  if data.payType == RechargeData.EveryDayGiftTypeEnum.Diamond then
    ctr.item_btn_Buy:GetChild("diamondIma"):SetActive(true)
    ctr.lab_buy:SetActive(true)
    ctr.lab_buy.transform.localPosition = Vector2.New(30, 0)
    local cost = string.split(data.cost, "#")[2]
    local costDiamond = math.floor(tonumber(cost))
    local TitleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data.title)
    ctr.title:SetText(TitleStr)
    ctr.lab_buy:SetText(costDiamond)
    local rewardList = string.split(data.reward, "#")
    local itemItemData = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(rewardList[1]))
    local rewardInfors = RechargeData.GetItemIdAndCount(tonumber(string.split(itemItemData.useParam, "#")[2]))
    if ctr.rewardContainer == nil then
      ctr.rewardContainer = UIContainer(ctr.btn_rewardItem, ui, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
    end
    if 0 < #rewardInfors then
      Recharge_WelfareUI.SetGroupConstraintCount(ctr.btn_reward_Content, #rewardInfors)
      ctr.rewardContainer:SetData(rewardInfors)
    end
    ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
      local costArray = string.split(data.cost, "#")
      if #costArray == 2 then
        local costItemId = tonumber(costArray[1])
        local costItemNum = tonumber(costArray[2])
        local bagcount = BagInfoData.GetItemTotalCountByItemId(costItemId)
        if costItemNum > bagcount then
          if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
            UIManager.Show(UIID.Recharge_FirstChargeUI, {
              PayType = BusinessPayType.None
            })
          else
            ToggerGroup[Page.Rechange]:SetIsOn(true)
          end
        else
          DiamondPopUpTwice(data)
        end
      else
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = data.id,
          buyCount = 1
        })
      end
    end)
  elseif data.payType == RechargeData.EveryDayGiftTypeEnum.RMB then
    ctr.item_btn_Buy:GetChild("diamondIma"):SetActive(false)
    ctr.lab_buyRMB:SetActive(true)
    local cost = data.rmb
    local costRMB = math.floor(tonumber(cost))
    local TitleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data.title)
    ctr.title:SetText(TitleStr)
    if #tostring(costRMB) > 4 then
      ctr.lab_buyRMB:SetText(string.format("%sK VND", math.floor(costRMB / 1000)))
    else
      ctr.lab_buyRMB:SetText(string.format("%sVND", math.floor(costRMB)))
    end
    local rewardInfors = RechargeData.GetItemIdAndCount(data.reward)
    if ctr.rewardContainer == nil then
      ctr.rewardContainer = UIContainer(ctr.btn_rewardItem, ui, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
    end
    if 0 < #rewardInfors then
      Recharge_WelfareUI.SetGroupConstraintCount(ctr.btn_reward_Content, #rewardInfors)
      ctr.rewardContainer:SetData(rewardInfors)
    end
    local itemPrice = math.ceil(cost / 100)
    ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
      DataToCSharpMgr.Pay({
        amount = itemPrice,
        product_Id = data.id,
        product_name = data.name,
        BusinessPayType = BusinessPayType.Welfare_Gift
      })
      NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
    end)
  end
end

local function OnRechargeTimePrizeRefresh(ctr, index, data, ui)
  if not data then
    ctr.gameObject:SetActive(false)
    return
  end
  local needCost = false
  local bagcount = 0
  local costItemNum = 0
  ctr.image_redpoint.gameObject:SetActive(false)
  ctr.lab_buyRMB:SetActive(false)
  ctr.lab_gem:SetActive(false)
  ctr.item_btn_Buy:GetChild("diamondIma"):SetActive(true)
  local count, limitCount = RechargeData.GetBuyPrizeLimitCountData(data.countKey)
  local subtitleStr = ""
  subtitleStr = string.format("<color=green><size=22>%s</size></color>", count)
  subtitleStr = string.format(RechargeData.UIWordContainer.RechargeSubtitle_1, subtitleStr)
  ctr.subTitle:SetText(subtitleStr)
  if 0 >= data.residueTime then
    ctr.item_btn_Buy:SetActive(false)
    ctr.lab_Received:SetActive(true)
  else
    local effectItem = ctr.transform:Find(GuideEffecName)
    if ui.args and (ui.args.ZhuanZhong == data.id or ui.args.ZhuanZhongII == data.id or ui.args.ZhuanZhongIII == data.id) then
      if not effectItem then
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(2.1, 2.5), Vector3(0, -180, 0))
      else
        effectItem.gameObject:SetActive(true)
      end
      ui.args.ZhuanZhong = nil
    elseif effectItem then
      effectItem.gameObject:SetActive(false)
    end
    ctr.spriteCol = ui:SetSprite("Atlas_Common", "ty_btn_short3_new", ctr.item_btn_Buy)
    ctr.lab_Received:SetActive(false)
    ctr.item_btn_Buy:SetActive(true)
  end
  local cost = string.split(data.cost, "#")[2]
  local costDiamond = math.floor(tonumber(cost))
  local TitleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data.title)
  ctr.title:SetText(TitleStr)
  local labBuyStr = ""
  local costArray = string.split(data.cost, "#")
  if #costArray == 2 then
    local costItemId = tonumber(costArray[1])
    needCost = true
    costItemNum = tonumber(costArray[2])
    bagcount = BagInfoData.GetItemTotalCountByItemId(costItemId)
    if costItemNum > bagcount then
      labBuyStr = string.GetColorText(tostring(costDiamond), ItemQuality2ColorDic[7])
    else
      labBuyStr = string.GetColorText(tostring(costDiamond), ItemQuality2ColorDic[0])
    end
  end
  ctr.lab_buy:SetText(labBuyStr)
  local rewardList = string.split(data.reward, "#")
  local itemItemData = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(rewardList[1]))
  local rewardInfors = RechargeData.GetItemIdAndCount(tonumber(string.split(itemItemData.useParam, "#")[2]))
  if ctr.rewardContainer == nil then
    ctr.rewardContainer = UIContainer(ctr.btn_rewardItem, ui, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
  end
  if 0 < #rewardInfors then
    ctr.rewardContainer:SetData(rewardInfors)
  end
  ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
    if needCost then
      if bagcount < costItemNum then
        if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
          UIManager.Show(UIID.Recharge_FirstChargeUI, {
            PayType = BusinessPayType.None
          })
        else
          ToggerGroup[Page.Rechange]:SetIsOn(true)
        end
      else
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = data.id,
          buyCount = 1
        })
      end
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = data.id,
        buyCount = 1
      })
    end
  end)
end

local function OnBuyPrizeRefresh(ctr, index, data, ui)
  if data.giftType == 1 or data.giftType == 29 then
    OnFreePrizeRefresh(ctr, index, data, ui)
  elseif data.giftType == 11 then
    OnRechargePrizeRefresh(ctr, index, data, ui)
  end
end

local function OnRechargeItemCreat(ctr)
  ctr.rechargePrice = UIControl(ctr.transform, "btn_rechange/lab_buy")
  ctr.diamondParent = UIControl(ctr.transform, "go_gem/img_icon")
  ctr.goodsCount = UIControl(ctr.transform, "go_gem/img_icon/num")
  ctr.item_Picture = UIControl(ctr.transform, "img_rechagePicture")
  ctr.item_FirstRewardInfor = UIControl(ctr.transform, "img_fristReward")
  ctr.item_GemReward = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward")
  ctr.img_GemRewardIcon = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward/go_gemReward/img_icon")
  ctr.lab_GemRewardnum = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward/go_gemReward/img_icon/num")
  ctr.item_FristReward = UIControl(ctr.transform, "img_fristReward/sw_fristItemReward")
  ctr.item_FristRewardItem = UIControl(ctr.transform, "img_fristReward/sw_fristItemReward/Viewport/Content/btn_rechangeSwItem")
  ctr.rewardContainer = UIContainer(ctr.item_FristRewardItem, this, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
  ctr.item_btn_Buy = UIControl(ctr.transform, "btn_rechange")
end

local function OnRechargeItemRefresh(ctr, index, data, ui)
  local rmb = DataToCSharpMgr.ChangeAmountToSec(tonumber(data.rmb))
  if rmb / 1000 >= 1 then
    ctr.rechargePrice:SetText(string.format("%sK VND", math.ceil(rmb / 1000)))
  else
    ctr.rechargePrice:SetText(string.format("%sVND", math.ceil(rmb)))
  end
  local diamondItem = RechargeData.GetItemIdAndCount(data.diamond)
  ctr.goodsCount:SetText(diamondItem[1].count)
  local iconStr = ClientTable.cfg_Item_itemManager:TryGetValue(diamondItem[1].itemId, "id").icon
  this:SetSprite(atlasStr, iconStr, ctr.diamondParent, false)
  this:SetSprite("Atlas_Main", data.title, ctr.item_Picture, true)
  ctr.item_FirstRewardInfor.gameObject:SetActive(not (RechargeData.GetCount(data.rewardKey) > 0))
  if 0 < data.reward then
    local rewardInfors = RechargeData.GetItemIdAndCount(data.reward)
    if #rewardInfors == 1 and rewardInfors[1].itemId == 1000030 then
      ctr.item_GemReward.gameObject:SetActive(true)
      ctr.item_FristReward.gameObject:SetActive(false)
      SetItemImage(rewardInfors[1].itemId, ctr.img_GemRewardIcon)
      ctr.lab_GemRewardnum:SetText(rewardInfors[1].count)
    else
      ctr.item_GemReward.gameObject:SetActive(false)
      ctr.item_FristReward.gameObject:SetActive(true)
      local info = CommercializeData.CurrentOccupation(rewardInfors)
      ctr.rewardContainer:SetDataKTable(info)
    end
  end
  ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
    local PayType = ui.BusinessPayType and ui.BusinessPayType or BusinessPayType.None
    DataToCSharpMgr.Pay({
      amount = math.ceil(data.rmb / 100),
      product_Id = data.id,
      product_name = data.name,
      BusinessPayType = PayType
    })
  end)
  local effectItem = ctr.transform:Find(GuideEffecName)
  if ui.args and ui.args.rechargeID and (data.id == ui.args.rechargeID or data.id == ui.args.rechargeID + 100) or ui.args and ui.args.openSecondTab and index == ui.args.openSecondTab then
    if not effectItem then
      effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr, true, Vector2(1.5, 1.6), Vector3(0, -110, 0))
      ui.args.openSecondTab = nil
    else
      effectItem.gameObject:SetActive(true)
      ui.args.openSecondTab = nil
    end
  elseif effectItem then
    effectItem.gameObject:SetActive(false)
  end
end

local function OnGivebackCreat(ctr)
  ctr.txt_title = UIControl(ctr.transform, "txt_title")
  ctr.txt_progress = UIControl(ctr.transform, "txt_progress")
  ctr.btn_3DItem = UIControl(ctr.transform, "Viewport/Content/btn_3DItem")
  ctr.btn_price = UIControl(ctr.transform, "btn_price")
  ctr.diamondIma = UIControl(ctr.transform, "diamondIma")
  ctr.btn_get = UIControl(ctr.transform, "btn_get")
  ctr.image_PayRedPoint = UIControl(ctr.transform, "btn_get/img_Pay_redPoint")
  ctr.lab_Received = UIControl(ctr.transform, "lab_Received")
  ctr.sl_progress = UIControl(ctr.transform, "sl_progress")
  ctr.lab_progress = UIControl(ctr.transform, "sl_progress/lab_progress")
end

local function OnGivebackRefresh(ctr, _, data, ui)
  local isShowDiamondIma = data.type == RechargeData.EveryDayGiftTypeEnum.Diamond and true or false
  ctr.diamondIma:SetActive(isShowDiamondIma)
  local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Meirilibao")
  local rechargePoint = math.floor(data.rechargePoint)
  local txt_title = string.format(title, rechargePoint)
  local Color = rechargePoint <= ui.direct and "#1ADD1F" or "red"
  local txt_progress = string.format("<color=%s>(%s/%s)</color>", Color, ui.direct, rechargePoint)
  ctr.txt_title:SetText(txt_title)
  ctr.txt_progress:SetText(txt_progress)
  if ctr.ItemContainer == nil then
    ctr.ItemContainer = UIContainer(ctr.btn_3DItem, ui, OnRechItemCreat, OnRechItemRefresh)
  end
  local BoxItem = CommercializeData.CurrentOccupation(data.boxdata)
  ctr.ItemContainer:SetData(BoxItem)
  ctr.btn_price:SetActive(false)
  ctr.btn_get:SetActive(false)
  ctr.lab_Received:SetActive(false)
  if data.Msgdata then
    if data.Msgdata.canGet then
      if data.Msgdata.alreadyGet then
        ctr.lab_Received:SetActive(true)
        ctr.image_PayRedPoint:SetActive(false)
      else
        ctr.btn_get:SetActive(true)
        ctr.image_PayRedPoint:SetActive(true)
        ctr.btn_get:SetOnClick(ui, function()
          NetManager.Send(RechargeMessage.ReqGetGift, {
            id = {
              data.giftdata.id
            }
          })
        end)
      end
    else
      ctr.btn_price:SetActive(true)
      ctr.btn_price:SetOnClick(ui, function()
        ui:btn_prizetwoOnClick()
      end)
    end
  else
    ctr.lab_Received:SetActive(true)
  end
  if CommercializeData.DirectRepayInfo.current > 0 and data.id == ui.currentDirectid then
    local current = data.type == RechargeData.EveryDayGiftTypeEnum.Diamond and math.floor(CommercializeData.DirectRepayInfo.current) or math.floor(CommercializeData.DirectRepayInfo.current / 10)
    local slider = current / data.rechargePoint
    slider = 1 <= slider and 1 or 0 < slider and slider <= 0.08 and 0.08 or slider
    ctr.sl_progress.slider.value = slider
    ctr.sl_progress:SetActive(true)
  else
    ctr.sl_progress:SetActive(false)
  end
end

local function AccumulativeGiftCreate(ctr)
  ctr.lab_taskName = UIControl(ctr.transform, "lab_taskName")
  ctr.img_Fill = UIControl(ctr.transform, "sl_progress/Fill Area/Fill")
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.btn_get = UIControl(ctr.transform, "go_state/btn_get")
  ctr.lab_buy = UIControl(ctr.transform, "go_state/btn_get/lab_buy")
  ctr.lab_alreadyGet = UIControl(ctr.transform, "go_state/lab_alreadyGet")
end

local function AccumulativeGiftRefresh(ctr, _, data, ui)
  local commerceRechargeCfg = ClientTable.cfg_Commerce_RechargeManager:TryGetValue(data.id)
  local taskGoalCfg = ClientTable.cfg_Task_goalManager:TryGetValue(commerceRechargeCfg.goalId)
  local giftGiftCfg = ClientTable.cfg_Gift_giftManager:TryGetValue(commerceRechargeCfg.giftId)
  if commerceRechargeCfg and taskGoalCfg and giftGiftCfg then
    local title = "T\195\173ch n\225\186\161p N\225\186\161p %s VN\196\144"
    local totalCount = math.modf(DataToCSharpMgr.ChangeAmountToSec(taskGoalCfg.goalCount))
    local currentCount = math.modf(DataToCSharpMgr.ChangeAmountToSec(data.rechargeNum))
    title = string.format(title, ColorUtility.GetConsumableCountStr(currentCount, totalCount, EConsumableStrType.Normal))
    ctr.lab_taskName:SetText(title)
    local slider = currentCount / totalCount
    slider = 1 <= slider and 1 or 0 < slider and slider <= 0.06 and 0.06 or slider
    ctr.img_Fill:SetFillAmount(slider)
    if ctr.AccumulativeItemContainer == nil then
      ctr.AccumulativeItemContainer = UIContainer(ctr.btn_Item, ui, OnRechItemCreat, OnRechItemRefresh)
    end
    local rewardTab = ConfigManager.FindConfigs("cfg_Box_box", "boxId", giftGiftCfg.reward)
    local rewardList = {}
    for i, v in pairs(rewardTab) do
      if v.condition ~= nil and ConditionManager.Check4D(v.condition) or v.condition == nil then
        table.insert(rewardList, v)
      end
    end
    ctr.AccumulativeItemContainer:SetData(rewardList)
    local param
    ctr.btn_get:SetActive(false)
    ctr.lab_alreadyGet:SetActive(false)
    ui:StopSetSpriteCoroutine(ctr.spriteCor)
    if data.receiveState then
      ctr.btn_get:SetActive(false)
      ctr.lab_alreadyGet:SetActive(true)
    elseif totalCount <= currentCount then
      ctr.spriteCor = ui:SetSprite("Atlas_Common", "ty_btn_short3_new_yellow", ctr.btn_get)
      ctr.lab_buy:SetText("Nh\225\186\173n th\198\176\225\187\159ng")
      ctr.btn_get:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(true)
      param = data.id
    else
      ctr.spriteCor = ui:SetSprite("Atlas_Common", "ty_btn_short3_new", ctr.btn_get)
      ctr.lab_buy:SetText("\196\144i n\225\186\161p")
      ctr.btn_get:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(false)
    end
    ctr.btn_get:SetOnClickParam(ui, ui.AccumulativeGiftGetBtn, param)
  end
end

function Recharge_WelfareUI:InitUI()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_lifeLimitBuy
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_everydayRMBgift
  })
  ToggerGroup[Page.EveryDay] = self.tog_everyDayRechang
  ToggerGroup[Page.Daily] = self.tog_dailyRechang
  ToggerGroup[Page.Prize] = self.tog_prizeList
  ToggerGroup[Page.Rechange] = self.tog_rechangeList
  ToggerGroup[Page.LimitBuy] = self.tog_lifeLimitBuy
  ToggerGroup[Page.TimeLimitBuy] = self.tog_TimeLimitBuy
  ToggerGroup[Page.AccumulativeGift] = self.tog_AccumulativeGift
  ToggerGroup[Page.LuckyStar] = self.tog_LuckyStar
  ToggerGroup[Page.DirectPurchaseGift] = self.tog_DirectPurchaseGift
  ToggerGroup[Page.GoldDiamondRecharge] = self.tog_rechargeReward
  ToggerGroup[Page.TokenRecharge] = self.tog_rechargeDaiBi
  self.EveryPreciousContainer = UIContainer(self.btn_Itemprecious, self, OnEveryPreciousCreat, OnEveryDayPreciousRefresh)
  self.DailyRechContainer = UIContainer(self.img_dataBgdaily, self, OnDailyRechCreat, OnDailyRechRefresh)
  self.GivebackContainer = UIContainer(self.get_price_item_free, self, OnGivebackCreat, OnGivebackRefresh)
  local rewardGo = Instantiate(self.btn_3DItem.gameObject)
  rewardGo.name = "btn_3DItem"
  rewardGo.transform:SetParent(self.sw_buyPrizeItem.transform:Find("Viewport/Content"))
  rewardGo.transform.localScale = Vector3.one
  rewardGo.transform.localPosition = Vector3.zero
  self.btn_3DItem.transform:SetParent(self.sw_freePrizeItem.transform:Find("Viewport/Content"))
  self.prizeItemContainer = UIContainer(self.bg_buyPrize, self, OnBuyPrizeCreat, OnBuyPrizeRefresh)
  self.directPurchaseGiftItemContainer = UIContainer(self.bg_buyPrize_DirectPurchaseGift, self, OnBuyPrizeCreat, OnBuyPrizeRefresh)
  self.timeLimitItemContainer = UIContainer(self.bg_TimeLimitBuyPrize, self, OnBuyPrizeCreat, OnRechargeTimePrizeRefresh)
  self.freePrizeRewardContainer = UIContainer(self.btn_3DItem, self, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
  self.rechargeItemContainer = UIContainer(self.bg_rechange, self, OnRechargeItemCreat, OnRechargeItemRefresh)
  self.limitPanel = luaTemplateManager.GetNewTemplate(self.sw_lifeLimitBuy, LuaComponentTemplates.UILiftLimitBuy)
  local rechangeGridLayoutGroup = self.rechange_Content.transform:GetComponent("GridLayoutGroup")
  self.rechangeContentcellSize = rechangeGridLayoutGroup.cellSize
  self.rechangeContentOffset = rechangeGridLayoutGroup.padding.top + math.modf(self.rechange_Content.transform.anchoredPosition.y)
  self.rechangeArrowPos = self.Img_rechangeArrow.gameObject.transform.localPosition
  self.AccumulativeGifContainer = UIContainer(self.img_dataBgAccumulative, self, AccumulativeGiftCreate, AccumulativeGiftRefresh)
  self.luckyStarPanel = luaTemplateManager.GetNewTemplate(self.go_LuckyStar, LuaComponentTemplates.LuckyStarTemp, self)
  self.GoldDiamondRechargePanel = luaTemplateManager.GetNewTemplate(self.sw_rechargeReward, LuaComponentTemplates.GoldDiamondRechargeTemp, self)
  self.ReChangeDaiBiTemp = UIUtility.BindUIContainerTemp(self.bg_reChange, LuaComponentTemplates.TokenRechargeTemplate, self)
end

function Recharge_WelfareUI:OnShow()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    4010103,
    4010104,
    4010105,
    4010106,
    4010107,
    4010108,
    4010109,
    4010113,
    4010111
  })
  self:RegistEvents()
  RechargeController.RefreshTimeRecharge()
  self:Refresh()
  self:RefreshAccumulativeGiftTog()
end

function Recharge_WelfareUI:OnHide()
  self.luckyStarPanel:Exit()
  self.GoldDiamondRechargePanel:Exit()
end

function Recharge_WelfareUI:OnDestroy()
end

local countdown = -1
local formatStr = ""

function Recharge_WelfareUI:Update()
  if countdown < 0 then
    return
  end
  if self.lab_countDown.gameObject.activeSelf then
    countdown = countdown - UnityEngineLua.Time.deltaTime
    local min = math.floor(countdown / 60)
    local sec = math.floor(countdown % 60)
    self.lab_countDown:SetText(string.format(formatStr, string.format("<color=green>%02d:%02d</color>", min, sec)))
    if countdown < 0 then
      local str = LocalizationUtility.GetContentByKey("PrizeCanGet")
      self.lab_countDown:SetText(string.format("<color=green>%s</color>", str))
      self.canBuy = true
    end
  end
end

function Recharge_WelfareUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtnevery:SetOnClick(self, self.descBtneveryOnClick)
  self.descBtndaily:SetOnClick(self, self.descBtndailyOnClick)
  self.btn_prizeone:SetOnClick(self, self.btn_prizeoneOnClick)
  self.btn_prizetwo:SetOnClick(self, self.btn_prizetwoOnClick)
  self.tog_everyDayRechang:SetOnToggleChanged(self, self.tog_everyDayOnChanged)
  self.tog_dailyRechang:SetOnToggleChanged(self, self.tog_dailyOnChanged)
  self.tog_prizeList:SetOnToggleChanged(self, self.tog_prizeListOnChanged)
  self.tog_DirectPurchaseGift:SetOnToggleChanged(self, self.tog_DirectPurchaseGiftOnChanged)
  self.tog_rechangeList:SetOnToggleChanged(self, self.btn_rechangeSwItemOnClick)
  self.tog_lifeLimitBuy:SetOnToggleChanged(self, self.tog_lifeLimitOnChanged)
  self.tog_TimeLimitBuy:SetOnToggleChanged(self, self.tog_TimeLimitOnChanged)
  self.tog_AccumulativeGift:SetOnToggleChanged(self, self.tog_AccumulativeGiftOnChanged)
  self.tog_LuckyStar:SetOnToggleChanged(self, self.tog_LuckyStarOnChanged)
  self.tog_rechargeReward:SetOnToggleChanged(self, self.tog_RechargeRewardOnChanged)
  self.tog_rechargeDaiBi:SetOnToggleChanged(self, self.tog_rechargeDaiBiOnChanged)
  self.sw_rechange:SetOnEndDrag(self, self.sw_rechangeOnEndDragTeam)
end

function Recharge_WelfareUI:sw_rechangeOnEndDragTeam()
  if self.RechargePrizeCount > 8 then
    local slideOffset = 50
    local startPos = self.rechangeContentOffset - slideOffset
    local endPos = 1 * self.rechangeContentcellSize.y - self.rechangeContentOffset
    if endPos < self.rechangeContentOffset then
      endPos = self.rechangeContentOffset
    end
    endPos = endPos + slideOffset
    local curPos = math.modf(self.rechange_Content.transform.anchoredPosition.y)
    if curPos > endPos - 100 then
      self.Img_rechangeArrow:SetActive(false)
      self.Img_rechangeArrow.gameObject.transform:DOKill()
    elseif curPos < startPos + 100 then
      self:SetAnimation()
      self.Img_rechangeArrow:SetActive(true)
    end
  else
    self.Img_rechangeArrow:SetActive(false)
    self.Img_rechangeArrow.gameObject.transform:DOKill()
  end
end

function Recharge_WelfareUI:SetAnimation()
  self.Img_rechangeArrow.gameObject.transform:DOKill()
  local left = false
  
  local function MoveLeft()
    self.Img_rechangeArrow.gameObject.transform:DOLocalMoveY(left and self.rechangeArrowPos.y - 10 or self.rechangeArrowPos.y + 10, 1):OnComplete(function()
      left = not left
      self.Img_rechangeArrow.gameObject.transform:DOLocalMoveY(left and self.rechangeArrowPos.y - 10 or self.rechangeArrowPos.y + 10, 1):OnComplete(function()
        left = not left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end

local function SetTextCole(ctr, ok, txt)
  local Label = UIControl(ctr.transform, "Label")
  if ok then
    Label:SetText(string.GetColorText(txt, "#DCELE5"))
  else
    Label:SetText(string.GetColorText(txt, "#999999"))
  end
end

function Recharge_WelfareUI:tog_everyDayOnChanged(control, eventData)
  self.everyDay = eventData
  SetTextCole(self.tog_everyDayRechang, eventData, "N\225\186\161p M\225\187\151i Ng\195\160y")
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
  self.tog_everyDayRechang.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
  end
  self.go_everyDayRechang:SetActive(eventData)
end

function Recharge_WelfareUI:tog_dailyOnChanged(control, eventData)
  self.dailyDay = eventData
  SetTextCole(self.tog_dailyRechang, eventData, "T\195\173ch N\225\186\161p Ng\195\160y")
  self.tog_dailyRechang.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    NetManager.Send(RechargeMessage.ReqDailyRechargeInfo)
  end
  self.go_dailyRechang:SetActive(eventData)
end

function Recharge_WelfareUI:tog_prizeListOnChanged(control, eventData)
  self.prize = eventData
  SetTextCole(self.tog_prizeList, eventData, "G\195\179i Ng\195\160y")
  self.tog_prizeList.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    CommercializeController.ReqEverydayRecharge()
    NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
  end
  self.sw_prize:SetActive(eventData)
  self.price_one:SetNormalizedPosition(0, 1)
end

function Recharge_WelfareUI:tog_DirectPurchaseGiftOnChanged(control, eventData)
  self.directPurchaseGift = eventData
  SetTextCole(self.tog_DirectPurchaseGift, eventData, "Mua ngay m\225\187\151i ng\195\160y")
  self.tog_DirectPurchaseGift.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    CommercializeController.ReqEverydayRecharge()
    NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
  end
  self.sw_DirectPurchaseGift:SetActive(eventData)
  self.sw_PurchasePrice_one:SetNormalizedPosition(0, 1)
end

function Recharge_WelfareUI:tog_TimeLimitOnChanged(control, eventData)
  self.timeLimitBuy = eventData
  SetTextCole(self.tog_TimeLimitBuy, eventData, "G\195\179i H\225\186\161n Gi\225\187\157")
  self.tog_TimeLimitBuy.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    CommercializeController.ReqTimeBuyChange()
  end
  self.sw_TimeLimitBuy:SetActive(eventData)
end

function Recharge_WelfareUI:tog_AccumulativeGiftOnChanged(control, eventData)
  SetTextCole(self.tog_AccumulativeGift, eventData, "T\195\173ch n\225\186\161p N\225\186\161p")
  self.tog_AccumulativeGift.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    networkRequest.ReqAccumulateRechargeActivityInfo()
  end
  self.go_AccumulativeGift:SetActive(eventData)
end

function Recharge_WelfareUI:btn_rechangeSwItemOnClick(control, eventData)
  self.rechange = eventData
  SetTextCole(self.tog_rechangeList, eventData, "N\225\186\161p")
  self.tog_rechangeList.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    local auctionGridLayoutGroup = self.rechange_Content.transform:GetComponent("GridLayoutGroup")
    if PlatformData.PlatformCheck("Android") then
      auctionGridLayoutGroup.cellSize = Vector2(238, 235)
    else
      auctionGridLayoutGroup.cellSize = Vector2(320, 235)
    end
    CommercializeController.ReqNomalrechange()
  end
  self.sw_rechange:SetActive(eventData)
end

function Recharge_WelfareUI:tog_lifeLimitOnChanged(control, eventData)
  self.LimitBuy = eventData
  SetTextCole(self.tog_lifeLimitBuy, eventData, "Mua tr\225\187\141n \196\145\225\187\157i")
  CommercializeData:SetLimitBuyRed()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_lifeLimitBuy
  })
  self.tog_lifeLimitBuy.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  if eventData then
    CommercializeController.ReqLimitBuyChange()
  end
  self.sw_lifeLimitBuy:SetActive(eventData)
end

function Recharge_WelfareUI:tog_LuckyStarOnChanged(control, eventData)
  self.go_LuckyStar:SetActive(eventData)
  if eventData then
    self.luckyStarPanel:Refresh()
  end
end

function Recharge_WelfareUI:tog_rechargeDaiBiOnChanged(control, eventData)
  self.sw_reChangeDaiBi:SetActive(eventData)
  if eventData then
    local recharged = RechargeData:GetTokenData()
    self.ReChangeDaiBiTemp:SetData(recharged)
  end
end

function Recharge_WelfareUI:tog_RechargeRewardOnChanged(control, eventData)
  self.sw_rechargeReward:SetActive(eventData)
  if eventData then
    self.GoldDiamondRechargePanel:Refresh()
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.welfare_Pccharge
    })
  end
  if self.isNeedRefreshStartGoldDiamondRed ~= eventData and eventData then
    RechargeData.GoldDiamondRechargeData.RefreshStartRed()
  end
  self.isNeedRefreshStartGoldDiamondRed = eventData
end

function Recharge_WelfareUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.RechargeWelfareUI)
end

local function RechargeUIFun(this, control)
  local BusinessPay = control.PayType
  local Total = RefreshData.TotalRefreshTbl
  local RechargeRecord = {}
  local FirstChargeInfo = RechargeData.GetFirstChargeInfo()
  for i, v in pairs(Total) do
    if i >= FirstChargeInfo.FirstSetKey and i <= FirstChargeInfo.LastSetKey and v.count > 0 then
      table.insert(RechargeRecord, i)
    end
  end
  local FirstChargGift = RechargeData.GetFirstChargGift()
  local OpenFirst = true
  local FirstMax = FirstChargGift[3].buyCond
  for i, v in pairs(FirstMax) do
    for k = 1, #RechargeRecord do
      if RechargeRecord[k] == i then
        OpenFirst = false
      end
    end
  end
  if OpenFirst then
    UIManager.Show(UIID.Recharge_FirstChargeUI, {PayType = BusinessPay})
    return
  end
  local Tab = ClientTable.cfg_Function_functionManager:TryGetValue(4010104, "id").condition
  local strTab
  if 1 < #Tab then
    strTab = Tab
    for i = 1, #strTab do
      if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
        this.BusinessPayType = BusinessPay
        this.tog_rechangeList:SetIsOn(true)
        return
      end
    end
  else
    strTab = Tab[1]
    for i = 1, #strTab do
      if not ConditionManager.GenerateSingleCondition(strTab[i]):Check() then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Laifulibao"))
        return
      end
    end
    this.BusinessPayType = BusinessPay
    this.tog_prizeList:SetIsOn(true)
    return
  end
  FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Laifulibao"))
end

function Recharge_WelfareUI:DayGetGiftBtn(control)
  if control.id then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        control.id
      }
    })
  else
    if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
      UIManager.Show(UIID.Recharge_FirstChargeUI, {
        PayType = BusinessPayType.None
      })
    else
      ToggerGroup[Page.Rechange]:SetIsOn(true)
    end
    return
  end
  if self.tog_everyDayRechang.toggle.isOn then
    NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
  else
    NetManager.Send(RechargeMessage.ReqDailyRechargeInfo)
  end
end

function Recharge_WelfareUI:AccumulativeGiftGetBtn(control)
  if control == nil then
    return
  end
  if control.param == nil then
    if RechargeData.IsNeedGotoRecharge(BusinessPayType.None) then
      UIManager.Show(UIID.Recharge_FirstChargeUI, {
        PayType = BusinessPayType.None
      })
    else
      ToggerGroup[Page.Rechange]:SetIsOn(true)
    end
  else
    networkRequest.ReqAccumulateRechargeActivityGetAward(control.param)
  end
end

function Recharge_WelfareUI:descBtneveryOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "iconName", "descBtnevery")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Recharge_WelfareUI:descBtndailyOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "iconName", "descBtndaily")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Recharge_WelfareUI:GlobalTblBack()
  return ClientTable.cfg_Global_globalManager:TryGetValue(6030028)
end

function Recharge_WelfareUI:btn_prizeoneOnClick()
  local GivebackData = CommercializeData:GetTabDirectRepayInfo()
  if self.globalTbl == nil then
    self.globalTbl = self.GlobalTblBack()
  end
  if not ConditionManager.Check(self.globalTbl) then
    local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Zhigouhuikui_1")
    FloatingTipUtility.QuickMsg(text)
    return
  end
  self.PrizeOne:SetActive(false)
  self.PrizeTwo:SetActive(true)
  local Msgdata = CommercializeData.DirectRepayInfo.info
  local isOneGroup = true
  local GivebackShowData = {}
  self.currentDirectid = nil
  for i = 1, #Msgdata do
    local id = Msgdata[i].id
    local data = GivebackData[id]
    data.Msgdata = Msgdata[i]
    if data.type == RechargeData.EveryDayGiftType then
      table.insert(GivebackShowData, data)
    end
  end
  table.sort(GivebackShowData, function(a, b)
    return a.id < b.id
  end)
  for i, v in pairs(GivebackShowData) do
    if not self.currentDirectid and v.Msgdata and not v.Msgdata.canGet then
      self.currentDirectid = v.id
      break
    end
  end
  self.GivebackContainer:SetData(GivebackShowData)
  for i = 1, #GivebackShowData do
    if GivebackShowData[i].id == self.currentDirectid then
      if 4 < i then
        local index = i < #GivebackShowData - 2 and i or #GivebackShowData - 2
        local y = index * 98 - 196
        self.price_twoContent.transform.localPosition = Vector3(0, y, 0)
      end
      break
    end
  end
end

function Recharge_WelfareUI:btn_prizetwoOnClick()
  self.PrizeOne:SetActive(true)
  self.PrizeTwo:SetActive(false)
end

function Recharge_WelfareUI:RegistEvents()
  self:RegistEvent(Event.Commer_WelfareEveryDay, self.RefresheveryDayRech, self)
  self:RegistEvent(Event.Commer_WelfareDailyDay, self.RefreshdailyDayRech, self)
  self:RegistEvent(Event.Recharge_InterfaceRefresh, self.RechargeRefresh, self)
  self:RegistEvent(Event.Recharge_PrizeGiveback, self.PrizeGivebackDataRefesh, self)
  self:RegistEvent(Event.AllCountsRefresh, self.AllCountsRefresh, self)
  self:RegistEvent(Event.Recharge_RechargeSuccess, self.RechargeSuccess, self)
  self:RegistEvent(Event.Recharge_LifeLimitBuyRefresh, self.RefreshLmimtBuyRech, self)
  self:RegistEvent(Event.Commer_TimeWelfar, self.RefreshTimeLmimtBuyRech, self)
  self:RegistEvent(Event.RefreshTimeRecharge, self.RefreshTimeRechargeTog, self)
  self:RegistEvent(Event.Commercialize_AccumulativeGift, self.RefreshAccumulativeGift, self)
  self:RegistEvent(Event.GoldDiamondRechargScheduleChange, self.OnGoldDiamondRechargScheduleChange, self)
  self:RegistEvent(Event.CountsRefresh, self.OnGoldDiamondRechargScheduleCountsRefresh, self)
end

function Recharge_WelfareUI:RechargeRefresh()
  if self.tog_DirectPurchaseGift:GetIsOn() == true then
    self:ShowDirectPurchaseGift()
  elseif self.price_one.gameObject.activeSelf then
    self:ShowPrize()
  end
  if self.sw_rechange.gameObject.activeSelf then
    local RechargePrizeData = RechargeData.GetRechargePrize(1)
    self.RechargePrizeCount = #RechargePrizeData
    self:sw_rechangeOnEndDragTeam()
    self.rechargeItemContainer:SetData(RechargePrizeData)
  end
end

function Recharge_WelfareUI:AllCountsRefresh(id, data)
  local subType = data[1] and math.floor(data[1].key / 100) or nil
  if subType then
    if subType == RefreshData.TypeEnum.DirectRecharge then
      if self.tog_DirectPurchaseGift:GetIsOn() == true then
        self:ShowDirectPurchaseGift()
      elseif self.price_one.gameObject.activeSelf then
        self:ShowPrize()
      end
    elseif subType == RefreshData.TypeEnum.NomalRecharge then
      if self.sw_rechange.gameObject.activeSelf then
        local RechargePrize = RechargeData.GetRechargePrize(1)
        self.RechargePrizeCount = #RechargePrize
        self:sw_rechangeOnEndDragTeam()
        self.rechargeItemContainer:SetData(RechargePrize)
      end
    elseif subType == RefreshData.TypeEnum.LimitBuy then
      self:RefreshLmimtBuyRech()
    elseif subType == RefreshData.TypeEnum.TimeLimitBuy and self.timeLimit_gift.gameObject.activeSelf then
      self:ShowTimePrize()
    end
  end
end

function Recharge_WelfareUI:PrizeGivebackDataRefesh(id, data, info)
  if type(data) ~= type(1) then
    self.direct = (RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Diamond or RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Mix) and math.floor(CommercializeData.DirectRepayInfo.current) or math.floor(CommercializeData.DirectRepayInfo.current / 10)
    local expenseText = (RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Diamond or RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Mix) and "KC" or " VN\196\144"
    self.price_count:SetText(string.format("<color=#FFFFFF>%s </color>%s%s", "Qu\195\160 mua t\195\173ch l\197\169y hi\225\187\135n t\225\186\161i", self.direct, expenseText))
    if self.PrizeTwo.gameObject.activeSelf then
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.recharge,
        state = true
      })
      self:btn_prizeoneOnClick()
    end
  else
    NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
  end
end

function Recharge_WelfareUI:RechargeSuccess()
  if self.go_everyDayRechang.gameObject.activeSelf then
    self.tog_everyDayRechang:SetIsOn(false)
    self.tog_everyDayRechang:SetIsOn(true)
  elseif self.sw_rechange.gameObject.activeSelf then
    self.tog_rechangeList:SetIsOn(false)
    self.tog_rechangeList:SetIsOn(true)
  end
end

local function SorteveryDayFun(info, mass, every)
  local RoleRechargeData = RefreshData.TotalRefreshTbl
  local EveryDayMinCountKey, EveryDayMaxCountKey, DailyRechMinCountKey, DailyRechMaxCountKey = CommercializeData:GetWelfareMaxandMinCountKey()
  local min, max
  if every then
    min, max = EveryDayMinCountKey, EveryDayMaxCountKey
    for i, v in pairs(info) do
      for k, w in pairs(mass) do
        if v.goalId == w.id then
          v.massge = w
          break
        end
      end
    end
  else
    min, max = DailyRechMinCountKey, DailyRechMaxCountKey
    for i, v in pairs(info) do
      for k, w in pairs(mass) do
        if v.id == w.id then
          v.massge = w
          break
        end
      end
    end
  end
  for i, v in pairs(RoleRechargeData) do
    if i >= min and i <= max then
      local acc = 0
      for k = 1, #info do
        k = k + acc
        if info[k].giftdata.countKey == i then
          if v.count >= info[k].refreshCountLimit then
            info[k].Received = true
            table.insert(info, info[k])
            table.remove(info, k)
            acc = acc - 1
          end
          break
        end
      end
    end
  end
  local lastitem = {}
  local acc = 0
  for i = 1, #info do
    i = i + acc
    if info[i].Received then
      table.insert(lastitem, info[i])
      table.remove(info, i)
      acc = acc - 1
    end
  end
  table.sort(lastitem, function(a, b)
    return a.id < b.id
  end)
  table.combine(info, lastitem)
end

function Recharge_WelfareUI:EveryDayRechTableView()
  self.EveryDayRechtableView = UITableView()
  self.EveryDayRechtableView:SetLowerMargin(0)
  self.EveryDayRechtableView:SetScrollView(self.sw_everyDayRechang)
  self.EveryDayRechtableView:SetScalarForCellInTableView(self, self.ScalarForCellInEveryDayTableView)
  self.EveryDayRechtableView:SetUpperMargin(0)
  self.EveryDayRechtableView:SetTotalCellCount(self, self.NumberOfCellsInEveryDayTableView)
  self.EveryDayRechtableView:SetCellAtIndexInTableView(self, self.CellAtIndexInEveryDayTableView)
  self.EveryDayRechtableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInEquipTableViewWillAppear)
  self.EveryDayRechtableView:ReloadData(1)
end

function Recharge_WelfareUI:ScalarForCellInEveryDayTableView()
  local sizeX, sizeY = self.img_dataBgevery:GetSizeDelta()
  return sizeY
end

function Recharge_WelfareUI:NumberOfCellsInEveryDayTableView()
  return #self.EveryDayRechargeInfo
end

function Recharge_WelfareUI:CellAtIndexInEveryDayTableView(index)
  return self.EveryDayRechtableView:ReuseOrCreateCell(self.img_dataBgevery)
end

function Recharge_WelfareUI:CellAtIndexInEquipTableViewWillAppear(index)
  local data = self.EveryDayRechargeInfo[index]
  local ctr = self.EveryDayRechtableView:GetLoadedCell(index)
  ctr.lab_taskName = UIControl(ctr.transform, "lab_taskName")
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.btn_get = UIControl(ctr.transform, "go_state/btn_get")
  ctr.lab_buy = UIControl(ctr.transform, "go_state/btn_get/lab_buy")
  ctr.lab_alreadyGet = UIControl(ctr.transform, "go_state/lab_alreadyGet")
  ctr.lab_CanNotGet = UIControl(ctr.transform, "go_state/lab_CanNotGet")
  local title = GetUIText(data.giftdata.title)
  ctr.lab_taskName:SetText(title)
  if ctr.EveryItemContainer == nil then
    ctr.EveryItemContainer = UIContainer(ctr.btn_Item, self, OnRechItemCreat, OnRechItemRefresh)
  end
  local BoxItem = CommercializeData.CurrentOccupation(data.giftitem)
  ctr.EveryItemContainer:SetData(BoxItem)
  self:StopSetSpriteCoroutine(ctr.spriteCol)
  ctr.btn_get:SetActive(false)
  ctr.lab_alreadyGet:SetActive(false)
  ctr.lab_CanNotGet:SetActive(false)
  if data.massge.canGet then
    if data.Received then
      ctr.lab_alreadyGet:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(false)
    else
      ctr.spriteCol = self:SetSprite("Atlas_Common", "ty_btn_short3_new_yellow", ctr.btn_get)
      ctr.lab_buy:SetText("Nh\225\186\173n th\198\176\225\187\159ng")
      ctr.btn_get.id = data.giftdata.id
      ctr.btn_get:SetActive(true)
      ctr.btn_get:GetChild("img_redPoint"):SetActive(true)
    end
  else
    if data.massge.canComplete then
      ctr.spriteCol = self:SetSprite("Atlas_Common", "ty_btn_short3_new", ctr.btn_get)
      ctr.lab_buy:SetText("\196\144i n\225\186\161p")
      ctr.btn_get.id = nil
      ctr.btn_get:SetActive(true)
    else
      ctr.lab_CanNotGet:SetActive(true)
    end
    ctr.btn_get:GetChild("img_redPoint"):SetActive(false)
  end
  ctr.btn_get.PayType = BusinessPayType.Welfare_EveryDayRecharge
  ctr.btn_get:SetOnClick(self, self.DayGetGiftBtn)
end

function Recharge_WelfareUI:RefresheveryDayRech()
  local data = CommercializeData.WelfareEveryDayInfo
  local info = CommercializeData:GetEveryAndDailyDataFun(data.info, true)
  local Boxinfo = CommercializeData:GetEveryDatapreciousinfo(info[1])
  local EveryDaypreciousInfo = table.copy(nil, Boxinfo)
  local BoxItem = CommercializeData.CurrentOccupation(EveryDaypreciousInfo)
  self.EveryPreciousContainer:SetData(BoxItem)
  local EveryDayRechargeInfo = table.DeepCopy(info)
  SorteveryDayFun(EveryDayRechargeInfo, data.info, true)
  self.EveryDayRechargeInfo = EveryDayRechargeInfo
  if not self.EveryDayRechtableView then
    self:EveryDayRechTableView()
  end
  self:RefreshEveryDayRMBCount()
  self.EveryDayRechtableView:ReloadData(1)
end

function Recharge_WelfareUI:RefreshEveryDayRMBCount()
  local data = RefreshData.GetRefreshByKey(2460301)
  if data ~= nil and data.count ~= nil then
    local rmb = data.count
    self.lab_desc_count:SetText(string.format("h\195\180m nay N\225\186\161p: %d/339000", rmb))
  else
    self.lab_desc_count:SetActive(false)
  end
end

function Recharge_WelfareUI:RefreshdailyDayRech()
  local data = CommercializeData.WelfareDailyDayInfo
  local info = CommercializeData:GetEveryAndDailyDataFun(data.info, false)
  local DailyRechargeInfo = table.DeepCopy(info)
  SorteveryDayFun(DailyRechargeInfo, data.info, false)
  self.DailyRechContainer:SetData(DailyRechargeInfo)
end

function Recharge_WelfareUI:RefreshAccumulativeGift(_, msg)
  if self.AccumulativeGifContainer ~= nil then
    self.AccumulativeGifContainer:RemoveKTable()
  end
  if msg and msg.groupId then
    local accumulativeData, image = CommercializeData.GetAccumulativeGiftData(msg.groupId)
    self.AccumulativeGifContainer:SetData(accumulativeData)
    self.AccumulativeGiftImage:SetActive(not string.isNullOrEmpty(image))
    self:SetSprite("Atlas_Common", image, self.AccumulativeGiftImage, false)
  end
end

function Recharge_WelfareUI:RefreshLmimtBuyRech()
  self.limitPanel:Refresh(self)
  local com = CommercializeData:GetTabLimitBuyInfo()
  if com then
    for i, v in pairs(com) do
      if v.isBuy == false then
        return
      end
    end
    self.tog_lifeLimitBuy:SetActive(false)
    self:Refresh()
  end
end

function Recharge_WelfareUI:RefreshTimeLmimtBuyRech()
  if self.timeLimit_gift.gameObject.activeSelf then
    self:ShowTimePrize()
  end
end

function Recharge_WelfareUI:RefreshTimeRechargeTog(_, isOpen)
  self.tog_TimeLimitBuy:SetActive(isOpen)
  if isOpen then
    self:TimeRechargeShowTime(TimeUtility.GetToNextDayTime())
  end
end

function Recharge_WelfareUI:TimeRechargeShowTime(surplusTime)
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
  end
  local timeStr = TimeUtility.ShowHourTime(surplusTime)
  self.TimeLimit_time:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
  
  local function UpdateTimer()
    local timeStr = TimeUtility.ShowHourTime(surplusTime)
    surplusTime = surplusTime - 1
    self.TimeLimit_time:SetText(string.GetColorText(tostring(timeStr), ItemQuality2ColorDic[7]))
    if surplusTime == 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      self.TimeLimit_time:SetText(string.GetColorText("", ItemQuality2ColorDic[7]))
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Recharge_WelfareUI:Refresh()
  self.BusinessPayType = self.args and self.args.PayType and self.args.PayType or BusinessPayType.None
  local isShopID = false
  if self.args and self.args.openFirstTab then
    if ToggerGroup[self.args.openFirstTab].gameObject.activeSelf then
      ToggerGroup[self.args.openFirstTab]:SetIsOn(false)
      ToggerGroup[self.args.openFirstTab]:SetIsOn(true)
      if self.args.openFirstTab ~= Page.LimitBuy then
        self.sw_lifeLimitBuy:SetActive(false)
      end
    else
      for index, value in ipairs(ToggerGroup) do
        value:SetIsOn(false)
        if value.gameObject.activeSelf then
          for i, v in pairs(ToggerGroup) do
            if v.toggle.isOn then
              v:SetIsOn(false)
              break
            end
          end
          value:SetIsOn(true)
        end
      end
    end
    return
  end
  local page
  for index, idx in pairs({
    Page.Prize,
    Page.EveryDay,
    Page.Rechange,
    Page.Daily
  }) do
    local value = ToggerGroup[idx]
    if value.gameObject.activeSelf and page == nil then
      page = idx
      break
    end
  end
  local redPointIsShows = {}
  redPointIsShows[Page.Prize] = 43
  redPointIsShows[Page.EveryDay] = 23
  for index, idx in pairs({
    Page.Prize,
    Page.EveryDay
  }) do
    local cfg = ClientTable.cfg_Red_pointManager:TryGetValue(redPointIsShows[idx], "id")
    if cfg ~= nil then
      local isShow = RedPointChecker_Ext:JudgeUseMethod(cfg.uiName, cfg.parentPosition, cfg.childPosition)
      if isShow then
        page = idx
        break
      end
    end
  end
  local showtog, isopen
  for index, value in ipairs(ToggerGroup) do
    if value.gameObject.activeSelf then
      showtog = showtog or value
      value:SetIsOn(false)
      if index == page then
        for i, v in pairs(ToggerGroup) do
          if v.toggle.isOn then
            v:SetIsOn(false)
            break
          end
        end
        isopen = true
        value:SetIsOn(true)
      end
    end
  end
  if not isopen then
    showtog:SetIsOn(true)
  end
  self:setupTokenRechargeTab()
  self.price_one:SetNormalizedPosition(0, 0)
  self.sw_everyDayRechang:SetNormalizedPosition(0, 1)
  self.sw_rechange:SetNormalizedPosition(0, 1)
  self.timeLimit_gift:SetNormalizedPosition(0, 0)
  self.sw_AccumulativeGift:SetNormalizedPosition(0, 1)
end

function Recharge_WelfareUI:setupTokenRechargeTab()
  local func = ClientTable.cfg_Function_functionManager:TryGetValue(4010112).condition
  self.tog_rechargeDaiBi:SetActive(ConditionManager.Check4D(func))
end

function Recharge_WelfareUI:RefreshAccumulativeGiftTog()
  local state = CommercializeData:CheckAccumulativeGiftTogState()
  self.tog_AccumulativeGift:SetActive(state)
end

function Recharge_WelfareUI:ShowPrize()
  local giftTable = {}
  local finishTable = {}
  local currentPrize = RechargeData.FreePrizeRefresh()
  if not currentPrize then
    currentPrize = RechargeData.FreePrizeNoClose()
    if currentPrize ~= nil then
      table.insert(finishTable, currentPrize)
    end
  elseif currentPrize ~= nil then
    table.insert(giftTable, currentPrize)
  end
  local prizeItemData, finishItemData = RechargeData.GetNewBuyPrizeInfor()
  table.combine(giftTable, prizeItemData)
  table.combine(finishTable, finishItemData)
  table.combine(giftTable, finishTable)
  if self.prizeItemContainer ~= nil then
    self.prizeItemContainer:RemoveKTable()
  end
  self.prizeItemContainer:SetData(giftTable)
  local shopIndex
  if self.args ~= nil and self.args.shopID ~= nil and string.find(self.args.shopID, "|") then
    for i, v in pairs(string.split(self.args.shopID, "|")) do
      for index, y in ipairs(giftTable) do
        if y.id == tonumber(v) and y.residueTime > 0 then
          shopIndex = index
          break
        end
      end
    end
  end
  if shopIndex ~= nil then
    local target_OnlyOne = self:GetScrollViewNormalizedPositionOnlyOne(self.price_one.scrollRect, shopIndex - 2, false, 0)
    self.price_one:SetNormalizedPosition(target_OnlyOne, 1)
  end
  self.PrizeOne:SetActive(true)
  self.PrizeTwo:SetActive(false)
  local prizeItemAllData = RechargeData.GetPrizeAllBug()
  if table.isNullOrEmpty(prizeItemAllData) then
    return
  end
  self.lab_prizeAllbuy:SetText(string.format("A %d", prizeItemAllData[1].rmb))
  local isCanBuy = 0 < prizeItemAllData[1].residueTime
  if not table.isNullOrEmpty(finishItemData) then
    isCanBuy = false
  else
    for i, v in ipairs(prizeItemData) do
      local countTab = ClientTable.cfg_Count_countManager:TryGetValue(v.countKey)
      if countTab and countTab.refreshCountLimit > v.residueTime then
        isCanBuy = false
        break
      end
    end
  end
  if isCanBuy then
    self:SetSprite("Atlas_Common", "ty_btn_firstbutton_red", self.btn_prizeAllbuy, true)
    self.btn_prizeAllbuy:SetOnClick(self, function()
      DataToCSharpMgr.Pay({
        amount = math.ceil(prizeItemAllData[1].rmb / 100),
        product_Id = prizeItemAllData[1].id,
        product_name = prizeItemAllData[1].name,
        BusinessPayType = BusinessPayType.Welfare_Gift
      })
      NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
    end)
  else
    self:SetSprite("Atlas_Common", "ty_btn_firstbutton_grey", self.btn_prizeAllbuy, true)
    self.btn_prizeAllbuy:SetOnClick(self, function()
      FloatingTipUtility.QuickMsg("H\195\180m nay \196\145\195\163 mua qu\195\160, kh\195\180ng th\225\187\131 Mua Nhanh")
    end)
  end
end

function Recharge_WelfareUI:ShowDirectPurchaseGift()
  local giftTable = {}
  local finishTable = {}
  local currentPrize = RechargeData.GetFreeDirectPurchaseGiftInfor()
  if currentPrize then
    if currentPrize.residueTime <= 0 then
      table.insert(finishTable, currentPrize)
    else
      table.insert(giftTable, currentPrize)
    end
  end
  local prizeItemData, finishItemData = RechargeData.GetDirectPurchaseGiftInfor()
  table.combine(giftTable, prizeItemData)
  table.combine(finishTable, finishItemData)
  table.combine(giftTable, finishTable)
  if self.directPurchaseGiftItemContainer ~= nil then
    self.directPurchaseGiftItemContainer:RemoveKTable()
  end
  self.directPurchaseGiftItemContainer:SetData(giftTable)
  self.args = nil
end

function Recharge_WelfareUI:GetScrollViewNormalizedPositionOnlyOne(scrollRect, currentChildIndex, inverse, pixelOffset)
  local childTrans = scrollRect.content:GetChild(0)
  local viewportRect = scrollRect.viewport.rect
  local contentRect = scrollRect.content.rect
  local childrenRect = childTrans.rect
  local diff = 2298 - viewportRect.width
  local elementLength = childrenRect.width + 5
  return Mathf.Clamp01((currentChildIndex * elementLength + pixelOffset) / diff)
end

function Recharge_WelfareUI:ShowTimePrize()
  self.timeLimit_gift:SetNormalizedPosition(0, 0)
  local giftTable = {}
  local prizeItemData, finishItemData = RechargeData.GetTimeLimitPrizeInfor()
  table.combine(giftTable, prizeItemData)
  table.combine(giftTable, finishItemData)
  self.timeLimitItemContainer:SetDataKTable(giftTable)
end

function Recharge_WelfareUI:StopSetSpriteCoroutine(CtrCoroutine)
  if CtrCoroutine then
    Coroutine.Stop(CtrCoroutine)
    CtrCoroutine = nil
  end
end

function Recharge_WelfareUI:OnGoldDiamondRechargScheduleChange()
  self.GoldDiamondRechargePanel:Refresh()
end

function Recharge_WelfareUI:OnGoldDiamondRechargScheduleCountsRefresh()
  if self.tog_rechargeReward == nil or self.tog_rechargeReward.toggle == nil or self.tog_rechargeReward.toggle.isOn == false then
    return
  end
  self.GoldDiamondRechargePanel:Refresh()
  if RechargeData.GoldDiamondRechargeData.IsReceivedAwardAlready() then
    return
  end
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {4010111})
  self:Refresh()
end
