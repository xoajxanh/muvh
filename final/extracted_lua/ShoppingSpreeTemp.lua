local ShoppingSpreeTemp = {}

function ShoppingSpreeTemp:Init(rootUI)
  self.rootUI = rootUI
  self:InitControls()
  self:InitData()
end

local function OnGoodsItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
  ctr.txt_day = UIControl(ctr.transform, "txt_day")
  ctr.btn_Item = UIControl(ctr.transform, "sw_gift/Viewport/Content/btn_Item")
  ctr.img_money_ground = UIControl(ctr.transform, "btns/ScrollLab/Viewport/Content/btn_money/img_money_ground")
  ctr.lab_num = UIControl(ctr.transform, "btns/ScrollLab/Viewport/Content/btn_money/lab_num")
  ctr.btn_goRecharge = UIControl(ctr.transform, "btns/btn_goRecharge")
  ctr.btn_get = UIControl(ctr.transform, "btns/btn_get")
end

local function OnGoodsItemOnClick(ctr)
  if ctr.userData == nil then
    return
  end
  networkRequest.ReqAddToCar(ctr.userData.tbl.id)
end

local function OnGoodsItemRefresh(ctr, index, data, ui)
  ctr.userData = data
  ctr.txt_day:SetText(data.tbl.title)
  local cost = TableParse:SplitStringToIntList(data.tbl.cost, "#")
  ctr.lab_num:SetText(cost[2])
  ctr.btn_get:SetOnClick(ctr, OnGoodsItemOnClick)
  local reward = TableParse:SplitStringToIntList(data.tbl.reward, "#")
  local itemData = ItemUtility.GenerateItemData(reward[1])
  itemData.count = reward[2]
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.btn_Item, ctr.itemCellData, ui.rootUI, true)
  ctr.btn_get:SetActive(not QuickFind:GetShoppingSpreeDataMgr():IsExistCar(ctr.userData.tbl.id))
  ui.rootUI:SetSprite("Atlas_Common", ui.moneyIcon, ctr.img_money_ground, false)
end

local function OnShoppingGoodsItemCreate(ctr)
  ctr.panel_unbuy = UIControl(ctr.transform, "panel_unbuy")
  ctr.lab_price = UIControl(ctr.transform, "panel_unbuy/lab_price")
  ctr.panel_buy = UIControl(ctr.transform, "panel_buy")
  ctr.btn_3DItem = UIControl(ctr.transform, "panel_buy/btn_3DItem")
  ctr.num = UIControl(ctr.transform, "panel_buy/go_price/img_icon/num")
  ctr.img_icon = UIControl(ctr.transform, "panel_buy/go_price/img_icon")
  ctr.btn_buy = UIControl(ctr.transform, "panel_buy/btn_buy")
  ctr.itemCellData = ItemCellData()
end

local function OnShoppingGoodsItemOnClick(ctr)
  if ctr.userData == nil and ctr.userData.tbl then
    return
  end
  networkRequest.ReqRemoveOutCar(ctr.userData.tbl.id)
end

local function OnShoppingGoodsItemRefresh(ctr, index, data, ui)
  ctr.userData = data
  if data.tbl == nil then
    ctr.panel_buy:SetActive(false)
    ctr.panel_unbuy:SetActive(true)
    local discount = 100 - math.floor(ui.buyDiscount[index][2] * 0.01) .. "%"
    ctr.lab_price:SetText(string.format("Mua 1 l\225\186\167n %d m\195\179n \196\145\198\176\225\187\163c h\198\176\225\187\159ng chi\225\186\191t kh\225\186\165u %s", index, discount))
  else
    ctr.panel_buy:SetActive(true)
    ctr.panel_unbuy:SetActive(false)
    local reward = TableParse:SplitStringToIntList(data.tbl.reward, "#")
    local itemData = ItemUtility.GenerateItemData(reward[1])
    itemData.count = reward[2]
    ctr.itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(ctr.btn_3DItem, ctr.itemCellData, ui.rootUI, true)
    local cost = TableParse:SplitStringToIntList(data.tbl.cost, "#")
    ctr.num:SetText(cost[2])
    ctr.btn_buy:SetOnClick(ctr, OnShoppingGoodsItemOnClick)
    ui.rootUI:SetSprite("Atlas_Common", ui.moneyIcon, ctr.img_icon, false)
  end
end

function ShoppingSpreeTemp:InitControls()
  self.btn_Shopping = self:GetControl("btn_Shopping")
  self.txt_Buy = self:GetControl("btn_Shopping/txt_Buy")
  self.img_Accumulating = self:GetControl("sw_ShoppingSpreeList/Viewport/Content/img_Accumulating")
  self.tip_Shopping = self:GetControl("tip_Shopping")
  self.ShoppingSpree_Shopping = self:GetControl("ShoppingSpree_Shopping")
  self.btn_close = self:GetControl("ShoppingSpree_Shopping/img_bg/btn_close")
  self.img_information = self:GetControl("ShoppingSpree_Shopping/img_bg/Scroll View/Viewport/Content/img_information")
  self.btn_settlement = self:GetControl("ShoppingSpree_Shopping/img_bg/btn_settlement")
  self.CurrentPriceNum = self:GetControl("ShoppingSpree_Shopping/img_bg/go_CurrentPrice/img_icon/num")
  self.CurrentPriceIcon = self:GetControl("ShoppingSpree_Shopping/img_bg/go_CurrentPrice/img_icon")
  self.DiscountedPriceNum = self:GetControl("ShoppingSpree_Shopping/img_bg/go_DiscountedPrice/img_icon/num")
  self.DiscountedPriceIcon = self:GetControl("ShoppingSpree_Shopping/img_bg/go_DiscountedPrice/img_icon")
  self.txt_DailyGifts_lastTime = self:GetControl("lab_Time/txt_DailyGifts_lastTime")
  self.img_AccumulatingContainer = UIContainer(self.img_Accumulating, self, OnGoodsItemCreate, OnGoodsItemRefresh)
  self.img_informationContainer = UIContainer(self.img_information, self, OnShoppingGoodsItemCreate, OnShoppingGoodsItemRefresh)
  self.btn_Shopping:SetOnClick(self, self.btn_ShoppingOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_settlement:SetOnClick(self, self.btn_settlementOnClick)
end

function ShoppingSpreeTemp:InitData()
  self.settlementsMax = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(320001).effect)
  local discount = ClientTable.cfg_Commerce_globalManager:TryGetValue(320002).effect
  self.buyDiscount = TableParse:SplitStringToIntListList(discount, "&", "#")
  self.moneyIcon = 1000010
  for i, v in pairs(ClientTable.cfg_Commerce_shoppingcartManager:GetDic()) do
    if ConditionManager.Check4D(v.showCondition) then
      local cost = TableParse:SplitStringToIntList(v.cost, "#")
      self.moneyIcon = ClientTable.cfg_Item_itemManager:TryGetValue(cost[1]).icon
      break
    end
  end
  if self.moneyIcon == 1000050 then
    self.moneyIcon = 1000030
  end
end

function ShoppingSpreeTemp:btn_ShoppingOnClick()
  self.ShoppingSpree_Shopping:SetActive(true)
  self:RefreshShoppingSpreeCart()
end

function ShoppingSpreeTemp:btn_closeOnClick()
  self.ShoppingSpree_Shopping:SetActive(false)
end

function ShoppingSpreeTemp:btn_settlementOnClick()
  local playerPrefs = string.format("%s_Commercial_HolidayActivityUI_go_ShoppingSpree", ViewData.meData.id)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    networkRequest.ReqSettlementCrazyCar()
  else
    networkRequest.ReqSettlementCrazyCar()
  end
end

function ShoppingSpreeTemp:Refresh(data)
  self:RefreshItemData()
  self:RefreshBuyInfo()
  if self.ShoppingSpree_Shopping:GetActive() then
    self:RefreshShoppingSpreeCart()
  end
  self:RefreshTimer()
end

function ShoppingSpreeTemp:RefreshTimer()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
  self.timer = Timer.StartLoopForever(1, function()
    self.txt_DailyGifts_lastTime:SetText(QuickFind:GetShoppingSpreeDataMgr():GetRemainTimeDes())
  end)
end

function ShoppingSpreeTemp:RefreshBuyInfo()
  self.tip_Shopping:SetText(string.format("L\198\176\225\187\163t thanh to\195\161n: %d/%d l\225\186\167n", QuickFind:GetShoppingSpreeDataMgr():GetData().historyBuyCount, self.settlementsMax))
  self.txt_Buy:SetText(string.format("Gi\225\187\143 h\195\160ng c\225\187\167a t\195\180i (%d/4)", table.count(QuickFind:GetShoppingSpreeDataMgr():GetData().shoppingCar)))
end

function ShoppingSpreeTemp:RefreshShoppingSpreeCart()
  self.rootUI:SetSprite("Atlas_Common", self.moneyIcon, self.CurrentPriceIcon, false)
  self.rootUI:SetSprite("Atlas_Common", self.moneyIcon, self.DiscountedPriceIcon, false)
  local goods = QuickFind:GetShoppingSpreeDataMgr():GetShoppingSpreeCarGoods()
  self.img_informationContainer:SetData(goods)
  local costSum = 0
  local index = 0
  for i, v in ipairs(goods) do
    if v.tbl ~= nil then
      local cost = TableParse:SplitStringToIntList(v.tbl.cost, "#")
      if cost[2] and 0 < cost[2] then
        costSum = costSum + cost[2]
      end
      index = i
    else
      break
    end
  end
  self.CurrentPriceNum:SetText(costSum)
  if index == 0 then
    self.DiscountedPriceNum:SetText("0")
  else
    local discount = self.buyDiscount[index][2] * 1.0E-4
    self.DiscountedPriceNum:SetText(string.format("%d (Chi\225\186\191t kh\225\186\165u %s) ", math.floor(costSum * discount), 100 - math.floor(discount * 100) .. "%"))
  end
end

function ShoppingSpreeTemp:RefreshItemData()
  local goods = QuickFind:GetShoppingSpreeDataMgr():GetShoppingSpreeShowGoods()
  self.img_AccumulatingContainer:SetData(goods)
end

return ShoppingSpreeTemp
