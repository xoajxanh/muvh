require("GameModel/Recharge_Welfare/LuckyStarData")
require("GameModel/Recharge_Welfare/GoldDiamondRechargeData")
RechargeData = {}
local this = RechargeData
local TimeBuyPrizeData, BuyPrizeData
local RechargePrizeData = {}
local FreePrizeData
local MonthCardItemInfor = {}
local CurrentEquipmentInfo = {}
local FirstChargeInfo, FirstChargGift, FirstChargCountdown
RechargeData.FIRSTCHARGGIFT = "FIRSTCHARGGIFT"
RechargeData.RecomTime = 60
RechargeData.TotalRechargeNum = nil
RechargeData.EveryDayGiftTypeEnum = {
  Diamond = enum(1),
  RMB = enum(),
  Mix = enum()
}
RechargeData.EveryDayGiftType = RechargeData.EveryDayGiftTypeEnum.Diamond
RechargeData.LuckyStarData = LuckyStarData
RechargeData.GoldDiamondRechargeData = GoldDiamondRechargeData
this.UIWordContainer = {}
this.ItemCount = {}

local function FindRechargeConfigs(key, value, isSort)
  local result, data = {}, {}
  if value == 60 then
    data = ConfigManager.FindConfigs("cfg_Item_buy", key, value)
  else
    data = ConfigManager.FindConfigs("cfg_Recharge_recharge", key, value)
  end
  for k, v in pairs(data) do
    if PlatformData.PlatformCheck(v.channelControl) then
      v.payType = value == 60 and RechargeData.EveryDayGiftTypeEnum.Diamond or RechargeData.EveryDayGiftTypeEnum.RMB
      table.insert(result, v)
    end
  end
  if isSort == true then
    table.sort(result, function(a, b)
      if a.sortId and b.sortId then
        return a.sortId < b.sortId
      elseif a.commodityRanking and b.commodityRanking then
        return a.commodityRanking < b.commodityRanking
      end
    end)
  end
  return result
end

local function GetPrizeData()
  local globalTab = GlobalConfig.GetGlobalConfig(17)
  if not string.isNullOrEmpty(globalTab) then
    local giftData = {}
    RechargeData.EveryDayGiftType = tonumber(globalTab)
    if RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Diamond then
      giftData = FindRechargeConfigs("type", 60, true)
    elseif RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.RMB then
      giftData = FindRechargeConfigs("type", 6, true)
    elseif RechargeData.EveryDayGiftType == RechargeData.EveryDayGiftTypeEnum.Mix then
      giftData = table.combine(FindRechargeConfigs("type", 6, true), FindRechargeConfigs("type", 60, true))
    end
    BuyPrizeData = giftData
  end
end

local function FindTimeRechargeConfigs(key, value)
  local result = {}
  local datas = ConfigManager.FindConfigs("cfg_Item_buy", key, value)
  for k, v in pairs(datas) do
    if PlatformData.PlatformCheck(v.channelControl) then
      table.insert(result, v)
    end
  end
  return datas
end

local function GetTimePrizeData()
  TimeBuyPrizeData = FindTimeRechargeConfigs("type", 30)
  table.sort(TimeBuyPrizeData, function(a, b)
    return a.commodityRanking < b.commodityRanking
  end)
end

local function GetRechargeData()
  local configData = FindRechargeConfigs("type", 1)
  for k, v in pairs(configData) do
    RechargePrizeData[v.sortId] = v
  end
end

local function GetMonthCardPrizeId(equipId, giftTab)
  for k, v in pairs(giftTab) do
    local conditionStr = string.split(v.buyCondition, "#")
    if equipId == tonumber(conditionStr[2]) then
      return v.id, v.title, v.countKey
    end
  end
  return equipId
end

local function SetMonthCardData(equipTab)
end

local function GetMonthCardData()
end

local function GetMaxandMinCountKey(data)
  local max, min
  for i, v in pairs(data) do
    if max == nil then
      max = v.countKey
    end
    if max < v.countKey then
      max = v.countKey
    end
    if min == nil then
      min = v.countKey
    end
    if min > v.countKey then
      min = v.countKey
    end
  end
  return min, max
end

local function GetFirstChargGiftInfo()
  FirstChargGift = {}
  local Gift = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 3)
  table.sort(Gift, function(a, b)
    return a.sortId < b.sortId
  end)
  for i, v in pairs(Gift) do
    local gift = {}
    gift.countKey = v.countKey
    gift.reward = v.reward
    gift.buyCond = {}
    local buyCond = string.split(v.buyCondition, "/")
    for k = 1, #buyCond do
      local BuyConditem = string.split(buyCond[k], "#")
      gift.buyCond[tonumber(BuyConditem[2])] = tonumber(BuyConditem[3])
    end
    table.insert(FirstChargGift, gift)
  end
  return Gift
end

local function GetFirstChargeeData()
  local Rechargedata = FindRechargeConfigs("type", 3)
  local ReceiveShowdata = GetFirstChargGiftInfo()
  local RechargedataKey = {}
  for i, v in pairs(Rechargedata) do
    local keyd = v.countKey
    RechargedataKey[keyd] = v
  end
  table.sort(RechargedataKey, function(a, b)
    return a.sortId < b.sortId
  end)
  for k, v in pairs(ReceiveShowdata) do
    local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", v.reward)
    v.BoxItem = BoxItem
    local uiWord = string.split(v.title, "#")
    v.titleshow = ClientTable.cfg_Ui_wordManager:TryGetValue(uiWord[1], "id").content
    v.Btnmoney = uiWord[2]
    local buyCond = string.split(v.buyCondition, "/")
    v.buyCond = {}
    for i = 1, #buyCond do
      local BuyConditem = string.split(buyCond[i], "#")
      v.buyCond[tonumber(BuyConditem[2])] = BuyConditem[3]
    end
  end
  FirstChargeInfo = {}
  FirstChargeInfo.ReceiveShowdata = ReceiveShowdata
  FirstChargeInfo.Rechargedata = RechargedataKey
  FirstChargeInfo.FirstSetKey, FirstChargeInfo.LastSetKey = GetMaxandMinCountKey(Rechargedata)
  FirstChargeInfo.FirstGetKey, FirstChargeInfo.LastGetKey = GetMaxandMinCountKey(ReceiveShowdata)
end

local function SetFirstChargeRecom()
  FirstChargCountdown = {}
  local image = ClientTable.cfg_Global_globalManager:TryGetValue(4010401, "id").effect
  local grop = string.split(image, "&")
  for i, v in pairs(grop) do
    local images = string.split(v, "#")
    local index = tonumber(images[1])
    local imageGrop = string.split(images[2], "/")
    FirstChargCountdown[index] = {}
    FirstChargCountdown[index].image = imageGrop
  end
  local one = ClientTable.cfg_Global_globalManager:TryGetValue(4010402, "id").effect
  local strTab1 = string.split(one, "/")
  FirstChargCountdown[1].Condition = strTab1
  local two = ClientTable.cfg_Global_globalManager:TryGetValue(4010403, "id").effect
  local strTab2 = string.split(two, "/")
  FirstChargCountdown[2].Condition = strTab2
  local three = ClientTable.cfg_Global_globalManager:TryGetValue(4010404, "id").effect
  local strTab3 = string.split(three, "/")
  FirstChargCountdown[3].Condition = strTab3
  this.RecomTime = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(4010405, "id").effect) / 1000
end

local function FindWordInConfig(word, config)
  for k, v in pairs(config) do
    if v.id == word and not this.UIWordContainer[word] then
      this.UIWordContainer[word] = v.content
    end
  end
end

local function DataConfig()
  local configData = ClientTable.cfg_Recharge_rechargeManager:GetDic()
  local UIWordCfg = ClientTable.cfg_Ui_wordManager:GetDic()
  for k, v in pairs(configData) do
    if not string.isNullOrEmpty(v.title) then
      local words = string.split(v.title, "#")
      if 1 < #words then
        for i = 1, #words - 1 do
          FindWordInConfig(words[i], UIWordCfg)
        end
      end
    end
  end
end

function RechargeData.Init()
  GetPrizeData()
  GetRechargeData()
  GetMonthCardData()
  FreePrizeData = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 1)
  DataConfig()
  GetTimePrizeData()
end

function RechargeData.FreePrizeRefresh()
  local currentPrize
  for k, v in pairs(FreePrizeData) do
    local count = RefreshData.GetRefreshByKey(v.countKey)
    count = count or {count = 0}
    if count.count < 1 then
      currentPrize = v
      break
    end
  end
  if not currentPrize then
    return nil
  end
  currentPrize.residueTime = this.GetBuyPrizeLimitCountData(currentPrize.countKey)
  currentPrize.giftType = 1
  return currentPrize
end

function RechargeData.FreePrizeNoClose()
  local currentPrize = FreePrizeData[#FreePrizeData]
  currentPrize.residueTime = this.GetBuyPrizeLimitCountData(currentPrize.countKey)
  currentPrize.giftType = 1
  return currentPrize
end

function RechargeData.GetBuyPrizeInfor()
  local resultTab = {}
  for k, v in pairs(BuyPrizeData) do
    local residueTime = this.GetBuyPrizeLimitCountData(v.countKey)
    if (ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition)) and 0 < residueTime then
      table.insert(resultTab, v)
    end
  end
  return resultTab
end

function RechargeData.GetNewBuyPrizeInfor()
  local resultTab = {}
  local finishTab = {}
  for k, v in pairs(BuyPrizeData) do
    local residueTime = this.GetBuyPrizeLimitCountData(v.countKey)
    if v.showCondition and ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition) then
      if 0 < residueTime then
        local data = v
        v.residueTime = residueTime
        table.insert(resultTab, data)
      else
        local data = v
        v.residueTime = residueTime
        table.insert(finishTab, data)
      end
    end
    v.giftType = 11
  end
  return resultTab, finishTab
end

function RechargeData.GetFreeDirectPurchaseGiftInfor()
  local freeDirectPurchaseGift
  local giftTbl = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 29)
  if table.count(giftTbl) > 0 then
    freeDirectPurchaseGift = giftTbl[1]
    freeDirectPurchaseGift.residueTime = this.GetBuyPrizeLimitCountData(giftTbl[1].countKey)
    freeDirectPurchaseGift.giftType = 29
  end
  return freeDirectPurchaseGift
end

function RechargeData.GetDirectPurchaseGiftInfor()
  local resultTab = {}
  local finishTab = {}
  local directPurchaseGiftData = FindRechargeConfigs("type", 6, true)
  for k, v in pairs(directPurchaseGiftData) do
    local residueTime = this.GetBuyPrizeLimitCountData(v.countKey)
    if v.showCondition and ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition) then
      if 0 < residueTime then
        local data = v
        v.residueTime = residueTime
        table.insert(resultTab, data)
      else
        local data = v
        v.residueTime = residueTime
        table.insert(finishTab, data)
      end
    end
    v.giftType = 11
  end
  return resultTab, finishTab
end

function RechargeData.GetPrizeAllBug()
  local resultTab = {}
  local recharge = ConfigManager.FindConfigs("cfg_Recharge_recharge", "type", 14)
  for k, v in pairs(recharge) do
    local residueTime = this.GetBuyPrizeLimitCountData(v.countKey)
    if v.showCondition and ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition) then
      local data = v
      v.residueTime = residueTime
      table.insert(resultTab, data)
    end
    v.giftType = 11
  end
  return resultTab
end

function RechargeData.GetTimeLimitPrizeInfor()
  local resultTab = {}
  local finishTab = {}
  for k, v in pairs(TimeBuyPrizeData) do
    local residueTime = this.GetBuyPrizeLimitCountData(v.countKey)
    if v.showCondition and ConditionManager.Check4D(v.showCondition) then
      if 0 < residueTime then
        local data = v
        v.residueTime = residueTime
        table.insert(resultTab, data)
      else
        local data = v
        v.residueTime = residueTime
        table.insert(finishTab, data)
      end
    end
  end
  return resultTab, finishTab
end

function RechargeData.GetIsOpenTimeRecharge()
  return false
end

function RechargeData.GetRechargePrize(type)
  local resultTab = {}
  for k, v in pairs(RechargePrizeData) do
    if v.showCondition and ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition) then
      if type then
        if type == v.type then
          table.insert(resultTab, v)
        end
      else
        table.insert(resultTab, v)
      end
    end
  end
  return resultTab
end

function RechargeData.GetItemIdAndCount(reward)
  return ConfigManager.FindConfigs("cfg_Box_box", "boxId", reward)
end

function RechargeData.GetAutoRecycleVipId()
  local itemConfig = ClientTable.cfg_Global_globalManager:TryGetValue(2140002, "id").effect
  local items = string.split(itemConfig, "/")
  local vip = {}
  for i = 1, #items do
    local item = string.split(items[i], "#")
    vip[tonumber(item[2])] = true
  end
  return vip
end

function RechargeData.CheckIsShowDirectPurchaseGiftRedPoint()
  if FucShowOrHideController.FuncSystemIsOpen(4010113) == false then
    return false
  end
  local currentPrize = RechargeData.GetFreeDirectPurchaseGiftInfor()
  return currentPrize and currentPrize.residueTime > 0
end

function RechargeData.IsHasGoldCard()
  local vip = this.GetAutoRecycleVipId()
  local targetTab = RoleManager.me.data.equipsData.Data
  for k, v in pairs(targetTab) do
    if vip[v.itemId] then
      return true
    end
  end
  return false
end

function RechargeData.GetMonthCardInfor()
  local targetTab = RoleManager.me.data.equipsData.StoneData
  for k, v in pairs(targetTab) do
    this.SetMonthCardTimeData(v.itemId, v.time)
  end
  for k, v in pairs(CurrentEquipmentInfo) do
    this.SetMonthCardTimeData(v.itemId, v.time)
  end
  return MonthCardItemInfor
end

function RechargeData.GetFirstChargeInfo()
  if not FirstChargeInfo then
    GetFirstChargeeData()
  end
  return FirstChargeInfo
end

function RechargeData.GetFristMainPos()
  local Positions = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 3)
  
  local function add(data)
    local job = {}
    for i, v in pairs(data) do
      local mun = tonumber(v)
      table.insert(job, mun)
    end
    return job
  end
  
  local ShowModlePos = {}
  for i = 1, #Positions do
    local Jobdata = {}
    local Job = string.split(Positions[i].showPosition, "&")
    for j = 1, #Job do
      local showpos = string.split(Job[j], "#")
      local jobid = tonumber(showpos[1])
      Jobdata[jobid] = {}
      local posdata = string.split(showpos[2], "|")
      local scaledata = string.split(showpos[3], "|")
      Jobdata[jobid].posdata = add(posdata)
      Jobdata[jobid].scaledata = add(scaledata)
    end
    table.insert(ShowModlePos, Jobdata)
  end
  return ShowModlePos
end

function RechargeData.GetFirstChargeRecom()
  if not FirstChargCountdown then
    SetFirstChargeRecom()
  end
  return FirstChargCountdown
end

function RechargeData.GetFirstChargGift()
  if not FirstChargGift then
    GetFirstChargGiftInfo()
  end
  return FirstChargGift
end

function RechargeData.GetFirstMInandMaxkey()
  return FirstChargeInfo.FirstSetKey, FirstChargeInfo.LastSetKey, FirstChargeInfo.FirstGetKey, FirstChargeInfo.LastGetKey
end

function RechargeData.GetBuyPrizeLimitCountData(id)
  local hasCount = RefreshData.GetRefreshByKey(id)
  hasCount = hasCount or {count = 0}
  local limitCount = ClientTable.cfg_Count_countManager:TryGetValue(id, "key").refreshCountLimit
  return limitCount - hasCount.count, limitCount
end

function RechargeData.GetCount(id)
  local count = RefreshData.GetRefreshByKey(id)
  if not count then
    count = {count = 0}
  else
    for k, v in pairs(MonthCardItemInfor) do
      if id == v.CountKey and count.count == 0 then
        count = {count = 1}
      end
    end
  end
  return count.count
end

function RechargeData.SetMonthCardTimeData(equipId, endTime)
  for k, v in pairs(MonthCardItemInfor) do
    if equipId == v.id then
      v.residualDay = math.ceil((endTime - Time.GetServerTime() - 1000) / 86400000)
    end
  end
end

function RechargeData.SetCurrentEquipmentData(equips)
  if not equips then
    return
  end
  if equips.itemId == 19000010 or equips.itemId == 19000020 then
    CurrentEquipmentInfo[equips.itemId] = equips
    local equipData = ViewData.meData.equipsData:UpdateStoneData(equips)
  end
end

function RechargeData.CountRefresh(msg)
  EventManager.Dispatch(Event.Recharge_InterfaceRefresh, msg)
end

function RechargeData.IsReceive(index)
  local RechargeRecord = FirstChargeInfo.ReceiveShowdata
  local countkey = RechargeRecord[index].countKey
  local Total = RefreshData.TotalRefreshTbl
  if not Total[countkey] or not (Total[countkey].count > 0) then
    return true
  end
  return false
end

function RechargeData.IsNoRecharge(index)
  local RechargeRecord = FirstChargeInfo.ReceiveShowdata
  local countkey = RechargeRecord[index].countKey
  local Total = RefreshData.TotalRefreshTbl
  if not Total[countkey] or not (Total[countkey].count > 0) then
    return true
  end
  return false
end

function RechargeData.IsNeedGotoRecharge(BusinessPay)
  BusinessPay = BusinessPay or BusinessPayType.None
  local Total = RefreshData.TotalRefreshTbl
  local RechargeRecord = {}
  this.GetFirstChargeInfo()
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
  if FucShowOrHideController.IsFirstChargeGetAllGift() then
    return true
  end
  return OpenFirst
end

function RechargeData.BuyDiamond(BusinessPay)
  BusinessPay = BusinessPay or BusinessPayType.None
  local Total = RefreshData.TotalRefreshTbl
  local RechargeRecord = {}
  this.GetFirstChargeInfo()
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
        UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4, PayType = BusinessPay})
        return true
      end
    end
  else
    strTab = Tab[1]
    for i = 1, #strTab do
      if not ConditionManager.GenerateSingleCondition(strTab[i]):Check() then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Laifulibao"))
        return false
      end
    end
    UIManager.Show(UIID.RechargeWelfareUI, {openFirstTab = 4, PayType = BusinessPay})
    return true
  end
  FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Laifulibao"))
  return false
end

function RechargeData:NeedGotoFirstChargeUI(BusinessPay, openfistui)
  local function OpenFun()
    local Open = RechargeData.IsReceive(3)
    
    if Open then
      if openfistui then
        UIManager.Show(UIID.Recharge_FirstChargeUI, {openFirstTab = 1, PayType = BusinessPay})
      end
      return true
    end
    if openfistui then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Laifulibao"))
    end
  end
  
  local flag = false
  local OpenFirst = RechargeData.IsReceive(1)
  if OpenFirst then
    if openfistui then
      UIManager.Show(UIID.Recharge_FirstChargeUI, {openFirstTab = 1, PayType = BusinessPay})
    end
    flag = true
  else
    local Tab = ClientTable.cfg_Function_functionManager:TryGetValue(4010104, "id").condition
    local strTab
    if 1 < #Tab then
      strTab = Tab
      for i = 1, #strTab do
        if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
          return false
        end
      end
    else
      strTab = Tab[1]
      for i = 1, #strTab do
        if not ConditionManager.GenerateSingleCondition(strTab[i]):Check() then
          OpenFun()
          return true
        end
      end
      return false
    end
    OpenFun()
    return true
  end
  return flag
end

function RechargeData:GetTokenData()
  local recharge = ClientTable.cfg_Recharge_rechargeManager:GetTabListByType(29, "type")
  local global = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(71000001).effect, "#")
  for i, v in pairs(recharge) do
    if v.id == tonumber(global[1]) then
      v.global = global
    end
  end
  table.sort(recharge, function(a, b)
    return a.id < b.id
  end)
  return recharge
end

function RechargeData:GetBoxItemTbl(GrowTbl)
  if table.isNullOrEmpty(GrowTbl) then
    return
  end
  self.giftData = {}
  self.boxTbl = {}
  for i, v in ipairs(GrowTbl) do
    self.boxTbl = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(tonumber(v.diamond))
    if table.isNullOrEmpty(self.boxTbl) == false then
      for i, v in ipairs(self.boxTbl) do
        local data = {
          count = v.count,
          itemId = v.itemId
        }
        table.insert(self.giftData, data)
      end
    end
    return self.giftData
  end
end

this.Init()
