CommercializeData = {}
local this = CommercializeData

local function GetWordText(title)
  return LocalizationUtility.GetContentByKey(title)
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
  return max, min
end

local function GetGiftCountKey(data)
  local countKeyTbl = {}
  for k, v in pairs(data) do
    table.insert(countKeyTbl, v.countKey)
  end
  return countKeyTbl
end

local FristServerGiftinfo = {}
local SportsLeveInfo = {}
local SportsEquipInfo = {}
local SportsIntensifyInfo = {}
local SportsZhuijiaInfo = {}
local EquipFirstInfo = {}
local BossFirstKill = {}
local SportsExcellenc = {}
local SportsJewelry = {}
local SportsFruitInfo = {}
local SportsFightInfo = {}
local SevenDaysSignIn = {}
local SportsBoss = {}
local GetFristSerMinCountKey, GetFristSerMaxCountKey, GetSportGiftMinCountKey, GetSportGiftMaxCountKey
local LiftLimitBuyData = {}
local GivebackData

local function FindRechargeConfigs(key, value)
  local result = {}
  local datas = ConfigManager.FindConfigs("cfg_Recharge_recharge", key, value)
  for k, v in pairs(datas) do
    if PlatformData.PlatformCheck(v.channelControl) then
      table.insert(result, v)
    end
  end
  return result
end

CommercializeData.OpenSergroupTogId = {}
CommercializeData.OpenSercurTogInfo = {}
CommercializeData.WelfareEveryDayInfo = {}
CommercializeData.WelfareDailyDayInfo = {}
CommercializeData.DirectRepayInfo = {}
CommercializeData.SkyPavilionInfo = {}
CommercializeData.Vip_VipRedRoint = {}
CommercializeData.AccumulativeGiftDataInfo = {}

local function GetFristGiftData(Itembuy, Recharge)
  local itemBuydata = {}
  local Rechargedata = {}
  for i = 1, #Itembuy do
    local BuyItem = ConfigManager.FindConfigs("cfg_Item_buy", "id", tonumber(Itembuy[i]))[1]
    table.insert(itemBuydata, BuyItem)
  end
  for i = 1, #Recharge do
    local RechargeItem = FindRechargeConfigs("id", tonumber(Recharge[i]))[1]
    table.insert(Rechargedata, RechargeItem)
  end
  for i = 1, #itemBuydata do
    local itemreward = string.split(itemBuydata[i].reward, "#")
    local itemitem = ConfigManager.FindConfigs("cfg_Item_item", "id", tonumber(itemreward[1]))
    local itembox = string.split(itemitem[1].useParam, "#")
    local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(itembox[2]))
    itemBuydata[i].BoxItem = BoxItem
    local itembuycost = string.split(itemBuydata[i].cost, "#")
    local itembuy = ConfigManager.FindConfigs("cfg_Item_item", "id", tonumber(itembuycost[1]))
    itemBuydata[i].itembyname = itembuy[1].name
    itemBuydata[i].itembuycount = tonumber(itembuycost[2])
    itemBuydata[i].costs = itembuycost[1]
    local refreshCount = ConfigManager.FindConfigs("cfg_Count_count", "key", itemBuydata[i].countKey)[1]
    itemBuydata[i].refreshCountLimit = refreshCount.refreshCountLimit
    itemBuydata[i].soldout = false
    itemBuydata[i].keycount = 0
  end
  for i = 1, #Rechargedata do
    local diamond = ConfigManager.FindConfigs("cfg_Box_box", "boxId", Rechargedata[i].diamond)
    Rechargedata[i].BoxItem = diamond
    local reward = ConfigManager.FindConfigs("cfg_Box_box", "boxId", Rechargedata[i].reward)
    table.combine(Rechargedata[i].BoxItem, reward)
    local refreshCount = ConfigManager.FindConfigs("cfg_Count_count", "key", Rechargedata[i].countKey)[1]
    Rechargedata[i].refreshCountLimit = refreshCount.refreshCountLimit
    Rechargedata[i].soldout = false
    Rechargedata[i].keycount = 0
  end
  table.combine(itemBuydata, Rechargedata)
  table.sort(itemBuydata, function(a, b)
    return a.commodityRanking < b.commodityRanking
  end)
  local itembuycount = #itemBuydata
  local itemlen = 0
  for i = itembuycount, 1, -1 do
    i = i + itemlen
    local refreshCountLimit = ConfigManager.FindConfigs("cfg_Count_count", "key", itemBuydata[i].countKey)
    itemBuydata[i].refreshCountLimit = refreshCountLimit[1].refreshCountLimit
    if itemBuydata[i].recommend == 1 then
      table.insert(itemBuydata, 1, itemBuydata[i])
      table.remove(itemBuydata, i + 1)
      itemlen = itemlen + 1
    end
  end
  FristServerGiftinfo = itemBuydata
end

local function GetSportDataFun(info)
  for i, v in pairs(info) do
    if v.type ~= CommerceOverviewType.RankInfo then
      local commerce = ConfigManager.FindConfigs("cfg_Commerce_1", "id", v.commerceId)[1]
      v.taskgift = ConfigManager.FindConfigs("cfg_Gift_gift", "id", tonumber(commerce.giftId))[1]
      local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(v.taskgift.reward))
      v.BoxItem = BoxItem
      if v.taskgift.severCountKey ~= 0 then
        v.refreshCountLimitser = ConfigManager.FindConfigs("cfg_Count_count", "key", v.taskgift.severCountKey)[1].refreshCountLimit
      end
      v.refreshCountLimitrole = ConfigManager.FindConfigs("cfg_Count_count", "key", v.taskgift.countKey)[1].refreshCountLimit
      v.Goals = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(commerce.goals), "goalId")
    else
      local RankData = ConfigManager.FindConfigs("cfg_Commerce_3", "commerceId", v.commerceId)
      for k, w in pairs(RankData) do
        w.taskgift = ClientTable.cfg_Gift_giftManager:TryGetValue(w.giftId, "id")
        local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(w.taskgift.reward))
        w.BoxItem = BoxItem
      end
      v.RankData = RankData
    end
  end
end

local function GetEquipFirstFun(info)
  for i, v in pairs(info) do
    local commerce = ClientTable.cfg_Commerce_1Manager:TryGetValue(v.commerceId, "id")
    if commerce == nil then
      logError("ID kh\195\180ng t\225\187\147n t\225\186\161i trong b\225\186\163ng cfg_Commerce_1: " .. v.commerceId)
    else
      v.same = commerce.same
      v.order = commerce.order
      v.taskgift = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(commerce.giftId), "id")
      local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(v.taskgift.reward))
      v.BoxItem = BoxItem
      v.refreshCountLimitser = ClientTable.cfg_Count_countManager:TryGetValue(v.taskgift.severCountKey, "key").refreshCountLimit
      v.refreshCountLimitrole = ClientTable.cfg_Count_countManager:TryGetValue(v.taskgift.countKey, "key").refreshCountLimit
      v.Goals = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(commerce.goals), "goalId")
    end
  end
end

local function GetBoosFirstFun(info)
  for i, v in pairs(info) do
    local commerce = ClientTable.cfg_Commerce_1Manager:TryGetValue(v.commerceId, "id")
    v.same = commerce.same
    v.type = commerce.type
    v.taskKillgift = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(commerce.giftId), "id")
    local BoxKillItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(v.taskKillgift.reward))
    v.BoxKillItem = BoxKillItem
    v.refreshCountLimitrole = ClientTable.cfg_Count_countManager:TryGetValue(v.taskKillgift.countKey, "key").refreshCountLimit
    v.TaskGoalgoalParam = tonumber(ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(commerce.goals), "goalId").goalParam)
  end
end

local function GetSportGiftData()
  SportsLeveInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsLevel)
  GetSportDataFun(SportsLeveInfo)
  SportsEquipInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsEquip)
  GetSportDataFun(SportsEquipInfo)
  SportsIntensifyInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsIntensify)
  GetSportDataFun(SportsIntensifyInfo)
  SportsZhuijiaInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsZhuijia)
  GetSportDataFun(SportsZhuijiaInfo)
  EquipFirstInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.EquipFirstGet)
  GetEquipFirstFun(EquipFirstInfo)
  BossFirstKill = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.BossFirstKill)
  GetBoosFirstFun(BossFirstKill)
  SportsExcellenc = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsExcellenc)
  GetSportDataFun(SportsExcellenc)
  SportsJewelry = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsJewelry)
  GetSportDataFun(SportsJewelry)
  SportsFruitInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsFruit)
  GetSportDataFun(SportsFruitInfo)
  SportsFightInfo = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsFight)
  GetSportDataFun(SportsFightInfo)
  SevenDaysSignIn = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.weekSignIn)
  GetSportDataFun(SevenDaysSignIn)
  SportsBoss = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsBoss)
end

local function GetMinMaxCountKey()
  local itemBuydata = ConfigManager.FindConfigs("cfg_Item_buy", "type", 11)
  local Rechargedata = FindRechargeConfigs("type", 11)
  table.combine(itemBuydata, Rechargedata)
  GetFristSerMaxCountKey, GetFristSerMinCountKey = GetMaxandMinCountKey(itemBuydata)
  local SportGiftMindata = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 4)
  local SportGiftMaxdata = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 9)
  table.combine(SportGiftMindata, SportGiftMaxdata)
  GetSportGiftMaxCountKey, GetSportGiftMinCountKey = GetMaxandMinCountKey(SportGiftMindata)
end

local EveryDaypreciousInfo = {}
local EveryDayMinCountKey, EveryDayMaxCountKey, DailyRechMinCountKey, DailyRechMaxCountKey

local function EveryDaypreciousFun(exhibition)
  EveryDaypreciousInfo = ConfigManager.FindConfigs("cfg_Box_box", "boxId", exhibition)
end

local function GetWelfareMaxandMin()
  local EveryDaydata = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 11)
  EveryDayMaxCountKey, EveryDayMinCountKey = GetMaxandMinCountKey(EveryDaydata)
  local DailyRechdata = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 10)
  DailyRechMaxCountKey, DailyRechMinCountKey = GetMaxandMinCountKey(DailyRechdata)
end

local goLevelMinCountKey, goLevelMaxCountKey
local goLevelCountKeyTbl = {}

local function GetGoLevelMaxandMin()
  local goLeveldata = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 13)
  goLevelMaxCountKey, goLevelMinCountKey = GetMaxandMinCountKey(goLeveldata)
  goLevelCountKeyTbl = GetGiftCountKey(goLeveldata)
end

function CommercializeData:GetgoLevelCountKey()
  return goLevelCountKeyTbl
end

function CommercializeData:GetgoLevelMaxandMinCountKey()
  return goLevelMinCountKey, goLevelMaxCountKey
end

function CommercializeData:GetCountKeyItemCfg(countKey)
  local boxId = ConfigManager.FindConfigs("cfg_Gift_gift", "countKey", countKey)[1]
  boxId = boxId.reward
  return ClientTable.cfg_Box_boxManager:TryGetValue(boxId, "boxId")
end

function CommercializeData:GetCountKeyItemID(countKey)
  return self:GetCountKeyItemCfg(countKey).itemId
end

function CommercializeData:GetTabDirectRepayInfo()
  if not GivebackData then
    GivebackData = {}
    local Data = ClientTable.cfg_Recharge_directRepayManager:GetDic()
    for i, v in pairs(Data) do
      local giftdata = ClientTable.cfg_Gift_giftManager:TryGetValue(v.giftId, "id")
      local boxdata = ConfigManager.FindConfigs("cfg_Box_box", "boxId", giftdata.reward)
      GivebackData[v.id] = v
      GivebackData[v.id].giftdata = giftdata
      GivebackData[v.id].boxdata = boxdata
    end
  end
  return GivebackData
end

local LimitBuyInfo = {}

function CommercializeData:GetTabLimitBuyInfo()
  LiftLimitBuyData = {}
  local data = ClientTable.cfg_Recharge_rechargeManager:BaseGetTabListByType(13, "type")
  local boxtbl = {}
  for i, v in pairs(data) do
    if ConditionManager.Check4D(v.showCondition) then
      boxtbl = ClientTable.cfg_Box_boxManager:BaseGetTabListByType(v.reward, "boxId")
      LimitBuyInfo = {}
      LimitBuyInfo.rechargeTbl = v
      LimitBuyInfo.boxTbl = boxtbl
      local number = RefreshData.GetRefreshByKey(v.countKey) and RefreshData.GetRefreshByKey(v.countKey).count or 0
      LimitBuyInfo.isBuy = 1 <= number
      if not LimitBuyInfo.isBuy then
        table.insert(LiftLimitBuyData, LimitBuyInfo)
      end
    end
  end
  self:SortLimitBuy()
  return LiftLimitBuyData
end

function CommercializeData:SortLimitBuy()
  table.sort(LiftLimitBuyData, function(a, b)
    return not a.isBuy and b.isBuy or (not (a.isBuy or b.isBuy) or a.isBuy and b.isBuy) and a.rechargeTbl.sortId < b.rechargeTbl.sortId
  end)
end

function CommercializeData:CheckLimitBuyFunc()
  for i, v in pairs(CommercializeData:GetTabLimitBuyInfo()) do
    if not v.isBuy then
      return true
    end
  end
  return false
end

function CommercializeData:CheckLimitBuyRed()
  for i, v in pairs(CommercializeData:GetTabLimitBuyInfo()) do
    if PlayerPrefs.GetInt("LimitBuy" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. tostring(v.rechargeTbl.id)) ~= 1 and not v.isBuy then
      return true
    end
  end
  return false
end

function CommercializeData:SetLimitBuyRed()
  for i, v in pairs(CommercializeData:GetTabLimitBuyInfo()) do
    if PlayerPrefs.GetInt("LimitBuy" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. tostring(v.rechargeTbl.id)) ~= 1 then
      PlayerPrefs.SetInt("LimitBuy" .. tostring(QuickFind.LuaMainPlayerViewAttrData().id) .. "ID" .. tostring(v.rechargeTbl.id), 1)
    end
  end
end

CommercializeData.SkyPaviMainBtn = false
local TianKongMiGeRewardInfo = {}
local TiankongMiGeMissionInfo = {
  Week = {},
  Day = {}
}
local TianKongmIGeStageAward = {
  Ordin = {},
  Advan = {}
}
local SkyPaviMaxCountKey, SkyPaviMinCountKey
local SkyBtnUpCloseTime = {}

local function GetTianKongMiGeReward(groupid)
  local TianKongMiGeGiftData = ConfigManager.FindConfigs("cfg_Gift_gift", "subType", groupid)
  local Ordindex, Advindex, OrdStage, AdvStage = 0, 0, 0, 0, 0
  local mun = #TianKongMiGeGiftData / 2
  for i = 1, #TianKongMiGeGiftData do
    local Gift = TianKongMiGeGiftData[i]
    local reward = ConfigManager.FindConfigs("cfg_Daily_TiankongReward", "reward", Gift.id)[1]
    local rewardBox = ConfigManager.FindConfigs("cfg_Box_box", "boxId", Gift.reward)[1]
    Gift.TianKongreward = reward
    Gift.rewardBox = rewardBox
    TianKongMiGeRewardInfo[i] = mun > Ordindex + Advindex and {} or nil
    if not Gift.TianKongreward then
      logError("D\225\187\175 li\225\187\135u c\225\187\167a M\225\186\173t C\195\161c Tr\195\170n Kh\195\180ng tr\225\187\145ng")
      logError(groupid)
      return
    end
    if Gift.TianKongreward.type == TianKongMiGeLevelType.Ordinarydata then
      Ordindex = Ordindex + 1
      local Condition = string.split(Gift.buyCondition, "#")
      Gift.itemid = Condition[2]
      Gift.canbuy = tonumber(Condition[3])
      TianKongMiGeRewardInfo[Ordindex].Ordinarydata = Gift
      if Gift.TianKongreward.bigReward == 1 then
        OrdStage = OrdStage + 1
        TianKongmIGeStageAward.Ordin[OrdStage] = Gift
      end
    else
      Advindex = Advindex + 1
      local Condition = string.split(Gift.buyCondition, "#")
      Gift.itemid = Condition[3]
      Gift.canbuy = tonumber(Condition[4])
      TianKongMiGeRewardInfo[Advindex].Advanceddata = Gift
      if Gift.TianKongreward.bigReward == 1 then
        AdvStage = AdvStage + 1
        TianKongmIGeStageAward.Advan[AdvStage] = Gift
      end
    end
  end
  table.sort(TianKongmIGeStageAward.Advan, function(a, b)
    return a.TianKongreward.level < b.TianKongreward.level
  end)
  table.sort(TianKongmIGeStageAward.Ordin, function(a, b)
    return a.TianKongreward.level < b.TianKongreward.level
  end)
end

local function GetTiankongMiGeMission(tasks)
  local weekindex = 0
  local dayindex = 0
  for i, v in pairs(tasks) do
    local task = ConfigManager.FindConfigs("cfg_Daily_TiankongMission", "id", v.id)[1]
    task.serCount = v.count
    task.taskgoal = ConfigManager.FindConfigs("cfg_Task_goal", "goalId", task.mission)[1]
    task.rewardbox = ConfigManager.FindConfigs("cfg_Box_box", "boxId", task.reward)[1]
    if task.type == TianKongMiGeMissionType.week then
      dayindex = dayindex + 1
      TiankongMiGeMissionInfo.Week[dayindex] = task
    else
      weekindex = weekindex + 1
      TiankongMiGeMissionInfo.Day[weekindex] = task
    end
  end
end

local function GetSkyPaviMaxandMin()
  local skykeydata = ConfigManager.FindConfigs("cfg_Gift_gift", "subType", this.SkyPavilionInfo.groupId)
  SkyPaviMaxCountKey, SkyPaviMinCountKey = GetMaxandMinCountKey(skykeydata)
end

local function GetSkyBtnUpCloseTime()
  local effect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011403)
  local effectglode = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011406)
  local Condition = string.split(effect, "#")
  local up = tonumber(Condition[1]) * 86400
  local Close = tonumber(Condition[2]) * 86400
  local Conditionglode = string.split(effectglode, "&")
  local ConditionglodeTable = {}
  for i = 1, #Conditionglode do
    ConditionglodeTable[i] = string.split(Conditionglode[i], "#")
  end
  SkyBtnUpCloseTime.up = up
  SkyBtnUpCloseTime.Close = Close
  SkyBtnUpCloseTime.Condition = ConditionglodeTable
end

local VvipRechargeAllInfo, Cellid, VvipExperienceCardInfo
CommercializeData.VvipCardid = 2290001
CommercializeData.VvipBuydrugid = 0
local VvipItemHpBuydrug = {}
local VvipItemMpBuydrug = {}

local function Getdesc(desc, info)
  local group = string.split(desc, "&")
  local data = {}
  for i, v in pairs(group) do
    data[i] = string.split(v, "#")
    if #data[i] ~= 1 then
      local sacv = data[i][2]
      local dsc = info.equip[sacv]
      data[i][3] = dsc
    end
  end
  return data
end

local function GetJiChudesc(equip)
  local Table = {}
  if equip.defenseBase and equip.defenseBase ~= 0 then
    local data = {}
    data[1] = "fangyuli"
    data[2] = "defenseBase"
    data[3] = equip.defenseBase
    table.insert(Table, data)
  end
  return Table
end

local function GetExprienceCardInfo()
  VvipExperienceCardInfo = ConfigManager.FindConfigs("cfg_Recharge_vvip", "subType", 1)
  for i, v in pairs(VvipExperienceCardInfo) do
    CommercializeData.VvipCardid = v.id
    v.descdata = Getdesc(v.desc, v)
  end
end

local function GetVvipRechargeAllInfo(this)
  VvipRechargeAllInfo = ConfigManager.FindConfigs("cfg_Recharge_vvip", "subType", 2)
  for i, v in pairs(VvipRechargeAllInfo) do
    v.boxshow = ConfigManager.FindConfigs("cfg_Box_box", "boxId", v.vvipGift)
    v.equip = ClientTable.cfg_Item_equipManager:TryGetValue(v.id, "id")
    v.descdata = Getdesc(v.desc, v)
    if this.VvipBuydrugid == 0 and v.equip.autoBugDrugs == 1 then
      this.VvipBuydrugid = v.equip.id
    end
  end
  local Hpbuydrug = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011501)
  local Hpdesc = ParseUtility.AnalysisCondition(Hpbuydrug)
  for i, v in pairs(Hpdesc) do
    local datas = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(v), "id")
    local data = string.split(datas.cost, "#")
    VvipItemHpBuydrug[i] = {}
    VvipItemHpBuydrug[i].id = datas.id
    VvipItemHpBuydrug[i].showCondition = datas.showCondition
    VvipItemHpBuydrug[i].money = tonumber(data[1])
    VvipItemHpBuydrug[i].count = tonumber(data[2])
  end
  local Mpbuydrug = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(4011502)
  local Mpdesc = ParseUtility.AnalysisCondition(Mpbuydrug)
  for i, v in pairs(Mpdesc) do
    local datas = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(v), "id")
    local data = string.split(datas.cost, "#")
    VvipItemMpBuydrug[i] = {}
    VvipItemMpBuydrug[i].id = datas.id
    VvipItemMpBuydrug[i].showCondition = datas.showCondition
    VvipItemMpBuydrug[i].money = tonumber(data[1])
    VvipItemMpBuydrug[i].count = tonumber(data[2])
  end
end

local NewVipSystemInfo = {}
local NewVipAll = {}

local function GetNewVipTableInfo()
  NewVipAll = ClientTable.cfg_Vip_vipManager:GetDic()
  for i, v in pairs(NewVipAll) do
    if NewVipSystemInfo[v.subType] then
      table.insert(NewVipSystemInfo[v.subType], v)
    else
      NewVipSystemInfo[v.subType] = {}
      table.insert(NewVipSystemInfo[v.subType], v)
    end
  end
end

function CommercializeData.GetNewCurrentVipLevel()
  local data = RoleManager.me.data.equipsData.Data
  local VvipBuyCell = data[CommercializeEquipCell.Vvip] and data[CommercializeEquipCell.Vvip] or nil
  for i, v in pairs(NewVipAll) do
    if VvipBuyCell and v.id == VvipBuyCell.itemId then
      return v.subType
    end
  end
end

local TaskSchoolidGrop = {}
local SubTypeSchoolInfo = {}
local SubTypetaskid = {}
local RewardItems = {}

local function TaskSchoolInfoInit()
  local TaskSchool = ConfigManager.FindConfigs("cfg_Task_task", "type", 6)
  local taskacc = 1
  local SubTypeacc = 1
  for i, v in pairs(TaskSchool) do
    if v.subtype == 1 then
      TaskSchoolidGrop[taskacc] = v.taskId
      RewardItems[taskacc] = {}
      RewardItems[taskacc] = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(v.rewards))
      taskacc = taskacc + 1
    else
      SubTypetaskid[SubTypeacc] = v.taskId
      SubTypeacc = SubTypeacc + 1
      if SubTypeSchoolInfo[v.subtype] then
        table.insert(SubTypeSchoolInfo[v.subtype], v.taskId)
      else
        SubTypeSchoolInfo[v.subtype] = {}
        table.insert(SubTypeSchoolInfo[v.subtype], v.taskId)
      end
    end
  end
end

function CommercializeData.Init()
  GetMinMaxCountKey()
  GetWelfareMaxandMin()
  GetSportGiftData()
  GetSkyBtnUpCloseTime()
  GetVvipRechargeAllInfo(this)
  GetExprienceCardInfo()
  GetGoLevelMaxandMin()
  GetNewVipTableInfo()
  TaskSchoolInfoInit()
end

function CommercializeData:GetFristServerGiftinfo(shopInfo)
  local Itembuy = {}
  local Recharge = {}
  for i, v in pairs(shopInfo) do
    local Commerce_2 = ConfigManager.FindConfigs("cfg_Commerce_2", "id", v.id)[1]
    if Commerce_2.type == 1 then
      local Item_buy = string.split(Commerce_2.shopId, "#")
      for i = 1, #Item_buy do
        table.insert(Itembuy, Item_buy[i])
      end
    else
      local Re_change = string.split(Commerce_2.shopId, "#")
      for i = 1, #Re_change do
        table.insert(Recharge, Re_change[i])
      end
    end
  end
  GetFristGiftData(Itembuy, Recharge)
  return FristServerGiftinfo
end

function CommercializeData:InitializeSportinfo()
  GetSportGiftData()
  return SportsLeveInfo, SportsEquipInfo, SportsIntensifyInfo, SportsZhuijiaInfo, EquipFirstInfo, BossFirstKill, SportsExcellenc, SportsJewelry, SportsFruitInfo, SportsFightInfo, SportsBoss, SevenDaysSignIn
end

function CommercializeData:GetFristSerMinMaxCountKey()
  return GetFristSerMinCountKey, GetFristSerMaxCountKey
end

function CommercializeData:GetSportGiftMinMaxCountKey()
  return GetSportGiftMinCountKey, GetSportGiftMaxCountKey
end

local function OpenServiceRedDot(data)
  if ConditionManager.Check(data.condition) and ConditionManager.Check4D(data.level) and not ConditionManager.Check(data.residualTime) then
    return true
  end
  return false
end

function CommercializeData.OpenServiceRedPoint(redid)
  if redid == 27 then
    local red = OpenServiceRedDot(SportsLeveInfo[1])
    return red
  elseif redid == 28 then
    local red = OpenServiceRedDot(SportsEquipInfo[1])
    return red
  elseif redid == 29 then
    local red = OpenServiceRedDot(SportsIntensifyInfo[1])
    return red
  elseif redid == 30 then
    local red = OpenServiceRedDot(SportsZhuijiaInfo[1])
    return red
  elseif redid == 31 then
    local red = OpenServiceRedDot(BossFirstKill[1])
    return red
  elseif redid == 32 then
    local red = OpenServiceRedDot(EquipFirstInfo[1])
    return red
  elseif redid == 34 then
    local red = OpenServiceRedDot(SportsExcellenc[1])
    return red
  elseif redid == 35 then
    local red = OpenServiceRedDot(SportsJewelry[1])
    return red
  elseif redid == 36 then
    local red = OpenServiceRedDot(SportsFruitInfo[1])
    return red
  elseif redid == 37 then
    local red = OpenServiceRedDot(SportsFightInfo[1])
    return red
  elseif redid == 60 then
    local red = OpenServiceRedDot(SevenDaysSignIn[1])
    return red
  end
end

function CommercializeData.GetEquipFirstInfo(msg)
  local KillData = {}
  for i = 1, #msg do
    for k = 1, #EquipFirstInfo do
      if msg[i].taskId == EquipFirstInfo[k].commerceId then
        local TabData = EquipFirstInfo[k]
        KillData[i] = TabData
        KillData[i].Msg = msg[i]
        break
      end
    end
  end
  return KillData
end

function CommercializeData.EquipFirstRed(data)
  if data.groupId == CommercializeOpeningserGrop.EquipFirstGet then
    local KillData = CommercializeData.GetEquipFirstInfo(data.taskInfo)
    local redPointHide = false
    for i, v in pairs(KillData) do
      local CanGet = v.Msg.giftInfo[1].canGet
      local RoleGetCount = v.refreshCountLimitrole - v.Msg.giftInfo[1].roleCount
      local SerGetCount = v.refreshCountLimitser - v.Msg.giftInfo[1].systemCount
      if 0 < SerGetCount and CanGet and 0 < RoleGetCount then
        redPointHide = true
        break
      end
    end
    if redPointHide then
      RedPointChecker_Ext.tog_EquipFirstGet = true
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.openActivity,
        state = true
      })
    end
  end
end

function CommercializeData.WeekSignRed(data)
  if data.groupId == CommercializeOpeningserGrop.weekSignIn then
    local redPointHide = false
    local yingheDay = data.yingheDay
    local reissueNumber = data.reissueNumber
    local before = true
    for i, v in pairs(data.taskInfo) do
      local Gift = v.giftInfo[1]
      if i < yingheDay then
        if Gift.canGet and Gift.roleCount <= 0 then
          if reissueNumber < 3 then
            redPointHide = true
          end
          before = false
        end
      elseif yingheDay == i and not redPointHide and Gift.canGet and Gift.roleCount <= 0 then
        if reissueNumber < 3 then
          redPointHide = true
        else
          redPointHide = before
        end
      end
    end
    if redPointHide then
      RedPointChecker_Ext.tog_SevenDaysSignIn = true
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.openActivity,
        state = true
      })
    end
    return redPointHide, before
  end
end

function CommercializeData.ReissueTime(data)
  local yingheDay = data.yingheDay
  local reissueNumber = data.reissueNumber
  local reissue = 0
  local reissuetime = 10
  for i, v in pairs(data.taskInfo) do
    local Gift = v.giftInfo[1]
    if i ~= yingheDay and (0 >= Gift.roleCount or v.isReissue) then
      reissue = reissue + 1
      if reissue == 3 then
        reissuetime = i
        break
      end
    end
  end
  return reissuetime
end

function CommercializeData:GetEveryAndDailyDataFun(massgedata, everyday)
  local EveryDayRecharge = {}
  for i, v in pairs(massgedata) do
    if everyday then
      EveryDayRecharge[i] = ConfigManager.FindConfigs("cfg_Recharge_everyDayRecharge", "goalId", v.id)[1]
    else
      EveryDayRecharge[i] = ConfigManager.FindConfigs("cfg_Recharge_dailyRecharge", "id", v.id)[1]
    end
    if EveryDayRecharge[i] == nil then
      return {}
    end
    EveryDayRecharge[i].giftdata = ConfigManager.FindConfigs("cfg_Gift_gift", "id", EveryDayRecharge[i].giftId)[1]
    if EveryDayRecharge[i].giftdata then
      EveryDayRecharge[i].giftitem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", EveryDayRecharge[i].giftdata.reward)
      EveryDayRecharge[i].goaldata = ConfigManager.FindConfigs("cfg_Task_goal", "goalId", EveryDayRecharge[i].goalId)[1]
      EveryDayRecharge[i].refreshCountLimit = ConfigManager.FindConfigs("cfg_Count_count", "key", EveryDayRecharge[i].giftdata.countKey)[1].refreshCountLimit
    end
  end
  table.sort(EveryDayRecharge, function(a, b)
    return a.giftdata and b.giftdata and a.giftdata.sortId < b.giftdata.sortId
  end)
  return EveryDayRecharge
end

function CommercializeData:GetWelfareMaxandMinCountKey()
  return EveryDayMinCountKey, EveryDayMaxCountKey, DailyRechMinCountKey, DailyRechMaxCountKey
end

function CommercializeData:GetEveryDatapreciousinfo(data)
  EveryDaypreciousFun(data.exhibition)
  return EveryDaypreciousInfo
end

function CommercializeData:TianKongMiGeRewardFun(groupid)
  GetTianKongMiGeReward(groupid)
end

function CommercializeData:TianKongMiGeMissionFun(tasks)
  GetTiankongMiGeMission(tasks)
end

function CommercializeData:TianKongMiGeReward()
  return TianKongMiGeRewardInfo
end

function CommercializeData:TianKongMiGeMission(type)
  if type == TianKongMiGeMissionType.day then
    return TiankongMiGeMissionInfo.Day
  else
    return TiankongMiGeMissionInfo.Week
  end
end

function CommercializeData:GetTianKongmIGeStageAward()
  return TianKongmIGeStageAward
end

function CommercializeData:SkyPavilionRefresh()
  if SkyPaviMaxCountKey == nil and SkyPaviMinCountKey == nil then
    GetSkyPaviMaxandMin()
  end
  local RoleCountData = RefreshData.TotalRefreshTbl
  for i, v in pairs(TianKongMiGeRewardInfo) do
    local OrdKey = v.Ordinarydata.countKey
    if RoleCountData[OrdKey] and RoleCountData[OrdKey].count > 0 then
      v.Ordinarydata.Received = true
    else
      v.Ordinarydata.Received = false
    end
    local advkey = v.Advanceddata.countKey
    if RoleCountData[advkey] then
      v.Advanceddata.Received = true
    else
      v.Advanceddata.Received = false
    end
  end
end

function CommercializeData:SkyBtnUpCloseTime()
  return SkyBtnUpCloseTime
end

function CommercializeData:GetVvipchargeinfo()
  local VvipIdGrop = {}
  for i, v in pairs(VvipRechargeAllInfo) do
    VvipIdGrop[i] = v.id
  end
  return VvipIdGrop
end

function CommercializeData:GetVvipInfo()
  return VvipRechargeAllInfo
end

function CommercializeData:GetEquipCellId()
  return CommercializeEquipCell.Vvip
end

function CommercializeData.GetVvipRechargeItemId()
  local cellid = CommercializeEquipCell.Vvip
  local data = RoleManager.me.data.equipsData.Data
  local Cell = data[cellid] and data[cellid] or nil
  if Cell then
    return Cell.itemId
  end
end

function CommercializeData.GetVvipRechargeLevel()
  local level, cellid
  if Cellid then
    cellid = Cellid
  else
    cellid = this:GetEquipCellId()
  end
  local data = RoleManager.me.data.equipsData.Data
  local Cell = data[cellid] and data[cellid] or nil
  level = 0
  if Cell then
    for i, v in pairs(VvipRechargeAllInfo) do
      if Cell.itemId == v.id then
        level = v.level
        break
      end
    end
  end
  return level
end

function CommercializeData.GetVvipRechargeAutoPickOpen()
  if not RoleManager.me.data.equipsData.Data then
    return false
  end
  local cellId
  if Cellid then
    cellId = Cellid
  else
    cellId = this:GetEquipCellId()
  end
  if not cellId then
    return false
  end
  local stone = RoleManager.me.data.equipsData.Data[cellId]
  if not stone then
    return false
  end
  local itemId = stone and stone.itemId
  return ClientTable.cfg_Item_equipManager:TryGetValue(itemId, "id").autoPickOpen == 1
end

local Difference = 5000
local lastHPtime = 0

function CommercializeData.AutomaticHpBuydrug(Hpitem)
  for i, v in pairs(Hpitem) do
    if VvipItemHpBuydrug[v] and ConditionManager.Check4D(VvipItemHpBuydrug[v].showCondition) and BagInfoData.GetItemTotalCountByItemId(VvipItemHpBuydrug[v].money) >= VvipItemHpBuydrug[v].count then
      if Time.GetServerTime() - lastHPtime > Difference then
        lastHPtime = Time.GetServerTime()
        networkRequest.ReqBuy(VvipItemHpBuydrug[v].id, 1, nil, 1)
      end
      return
    end
  end
end

local lastMPtime = 0

function CommercializeData.AutomaticMpBuydrug(Mpitem)
  for i, v in pairs(Mpitem) do
    if VvipItemMpBuydrug[v] and ConditionManager.Check4D(VvipItemMpBuydrug[v].showCondition) and BagInfoData.GetItemTotalCountByItemId(VvipItemMpBuydrug[v].money) >= VvipItemMpBuydrug[v].count then
      if Time.GetServerTime() - lastMPtime > Difference then
        lastMPtime = Time.GetServerTime()
        networkRequest.ReqBuy(VvipItemMpBuydrug[v].id, 1, nil, 1)
      end
      return
    end
  end
end

function CommercializeData.GetVviptext(data)
  local richAct = data.isRich == nil or data.isRich
  local wordID = richAct and data[1] or data[1] .. "NoColor"
  local descmian = GetWordText(wordID)
  if string.isNullOrEmpty(descmian) then
    logError("Trong b\225\186\163ng cfg_Ui_word kh\195\180ng c\195\179 Key l\195\160: " .. wordID .. " t\225\187\171 m\225\187\165c, h\195\163y \196\145\225\187\131 b\225\187\153 ph\225\186\173n thi\225\186\191t k\225\186\191 ki\225\187\131m tra!!!")
    return ""
  end
  if #data ~= 1 then
    if string.find(descmian, "%d%s", 1, true) then
      local mun = math.floor(data[3] / 100)
      descmian = string.format(descmian, mun, "%")
    else
      descmian = string.format(descmian, data[3])
    end
  end
  return descmian
end

function CommercializeData.GetItemShowVvip(itemid)
  local desc = {}
  for i, v in pairs(VvipExperienceCardInfo) do
    if v.id == itemid then
      for k, w in pairs(v.descdata) do
        desc[k] = this.GetVviptext(w)
      end
      return desc
    end
  end
  for i, v in pairs(VvipRechargeAllInfo) do
    if v.id == itemid then
      for k, w in pairs(v.descdata) do
        desc[k] = this.GetVviptext(w)
      end
      return desc
    end
  end
end

function CommercializeData.GetNewVipSystemInfo()
  return NewVipSystemInfo, NewVipAll
end

function CommercializeData.NewVvipInfoFun(indexGrop)
  local VvipRechargeInfo = {}
  if indexGrop.now then
    local now = indexGrop.now
    VvipRechargeInfo[1] = NewVipAll[now]
    VvipRechargeInfo[1].boxshow = ConfigManager.FindConfigs("cfg_Box_box", "boxId", VvipRechargeInfo[1].vvipGift)
    VvipRechargeInfo[1].equip = ClientTable.cfg_Item_equipManager:TryGetValue(VvipRechargeInfo[1].id, "id")
    VvipRechargeInfo[1].item = ClientTable.cfg_Item_itemManager:TryGetValue(VvipRechargeInfo[1].id)
    local dad = GetJiChudesc(VvipRechargeInfo[1].equip)
    local vipdesc = Getdesc(VvipRechargeInfo[1].desc, VvipRechargeInfo[1])
    local descdata = table.combine(dad, vipdesc)
    VvipRechargeInfo[1].descdata = descdata
  end
  if indexGrop.chapter then
    local chapter = indexGrop.chapter
    VvipRechargeInfo[2] = NewVipAll[chapter]
    VvipRechargeInfo[2].boxshow = ConfigManager.FindConfigs("cfg_Box_box", "boxId", VvipRechargeInfo[2].vvipGift)
    VvipRechargeInfo[2].equip = ClientTable.cfg_Item_equipManager:TryGetValue(VvipRechargeInfo[2].id, "id")
    VvipRechargeInfo[2].item = ClientTable.cfg_Item_itemManager:TryGetValue(VvipRechargeInfo[2].id, "id")
    local dad = GetJiChudesc(VvipRechargeInfo[2].equip)
    local vipdesc = Getdesc(VvipRechargeInfo[2].desc, VvipRechargeInfo[2])
    local descdata = table.combine(dad, vipdesc)
    VvipRechargeInfo[2].descdata = descdata
  end
  return VvipRechargeInfo
end

function CommercializeData.NewVvipLvInfoFun(subType, index)
  local VvipRechargeInfo
  if subType then
    VvipRechargeInfo = NewVipSystemInfo[subType][index]
    VvipRechargeInfo.boxshow = ConfigManager.FindConfigs("cfg_Box_box", "boxId", VvipRechargeInfo.vvipGift)
    VvipRechargeInfo.equip = ClientTable.cfg_Item_equipManager:TryGetValue(VvipRechargeInfo.id, "id")
    VvipRechargeInfo.item = ClientTable.cfg_Item_itemManager:TryGetValue(VvipRechargeInfo.id, "id")
    local dad = GetJiChudesc(VvipRechargeInfo.equip)
    local vipdesc = Getdesc(VvipRechargeInfo.desc, VvipRechargeInfo)
    local descdata = table.combine(dad, vipdesc)
    VvipRechargeInfo.descdata = descdata
    return VvipRechargeInfo
  end
end

function CommercializeData.ExchangeInfo()
  local data = ConfigManager.FindConfigs("cfg_Item_buy", "type", 16)
  return data
end

function CommercializeData.ExchangeNewMemberInfo()
  if CommercializeData.mExchangeNewMemberInfo == nil then
    CommercializeData.mExchangeNewMemberInfo = ConfigManager.FindConfigs("cfg_Item_buy", "type", 61)
    if CommercializeData.mExchangeNewMemberInfo then
      table.sort(CommercializeData.mExchangeNewMemberInfo, function(l, r)
        return l and r and l.commodityRanking < r.commodityRanking
      end)
    end
  end
  return CommercializeData.mExchangeNewMemberInfo
end

function CommercializeData.GetNewItemShowVvip(itemid)
  local desc = {}
  for i, v in pairs(NewVipAll) do
    if v.id == itemid then
      local equipdata = ClientTable.cfg_Item_equipManager:TryGetValue(v.id, "id")
      local descdata = Getdesc(v.desc, {equip = equipdata})
      for k, w in pairs(descdata) do
        desc[k] = this.GetVviptext(w)
      end
      return desc
    end
  end
end

function CommercializeData.GetNowNewVIPInfo()
  local equip = ViewData.meData.equipsData:GetEquipByIndex(CommercializeEquipCell.Vvip)
  if equip == nil then
    return nil
  end
  local itemId = equip.itemId
  for index, info in ipairs(NewVipAll) do
    if info.id == itemId then
      return info
    end
  end
  return nil
end

function CommercializeData.GetNextNewVIPInfo()
  local equip = ViewData.meData.equipsData:GetEquipByIndex(CommercializeEquipCell.Vvip)
  if equip == nil then
    return NewVipAll[1]
  end
  local itemId = equip.itemId
  for index, info in ipairs(NewVipAll) do
    if info.id == itemId and #NewVipAll >= index + 1 then
      return NewVipAll[index + 1]
    end
  end
  return nil
end

function CommercializeData.GetNextSubTypeNewVIPInfo()
  local equip = ViewData.meData.equipsData:GetEquipByIndex(CommercializeEquipCell.Vvip)
  if equip == nil then
    return NewVipAll[1]
  end
  local itemId = equip.itemId
  for i, infos in ipairs(NewVipSystemInfo) do
    for j, info in ipairs(infos) do
      if info.id == itemId and #NewVipSystemInfo >= info.subType + 1 then
        return NewVipSystemInfo[info.subType + 1][info.badgeStar]
      end
    end
  end
  return nil
end

function CommercializeData.GetTaskSchoolInfo()
  return TaskSchoolidGrop, SubTypeSchoolInfo, SubTypetaskid, RewardItems
end

function CommercializeData.GetCompletedTaskSchool(taskid)
  local taskdata = {}
  local taskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(taskid, "taskId")
  taskdata.name = taskTbl.name
  local goals = string.split(taskTbl.goals, "#")
  taskdata.navigationList = {}
  taskdata.goals = {}
  for i, v in pairs(goals) do
    taskdata.goals[i] = {}
    taskdata.goals[i].goalTbl = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(v), "goalId")
    if taskdata.goals[i].goalTbl == nil then
      logError("taskid\239\188\154" .. taskid, "taskGoalId" .. tonumber(v), "D\225\187\175 li\225\187\135u b\225\186\163ng tr\225\187\145ng")
      taskdata.goals[i].finishCount = 0
    else
      taskdata.goals[i].finishCount = taskdata.goals[i].goalTbl.goalCount
    end
  end
  local reward = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(taskTbl.rewards))
  reward = reward and CommercializeData.GetMeetConditionBoxTbl(reward)
  taskdata.isNavigationFlag = false
  taskdata.taskTbl = taskTbl
  taskdata.state = TaskStateType.Submitted
  taskdata.taskId = taskTbl.taskId
  taskdata.reward = reward
  return taskdata
end

function CommercializeData.GetRewardSchoolinfo(taskid, state)
  local rewardData = {}
  local taskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(taskid, "taskId")
  local reward = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(taskTbl.rewards))
  reward = reward and CommercializeData.GetMeetConditionBoxTbl(reward)
  rewardData.rewards = {}
  for i, v in pairs(reward) do
    rewardData.rewards[v.itemId] = tonumber(v.count)
  end
  rewardData.state = state
  rewardData.reward = {}
  for i, v in pairs(rewardData.rewards) do
    table.insert(rewardData.reward, {id = i, count = v})
  end
  return rewardData
end

function CommercializeData.CurrentOccupation(BoxItem)
  local ItemData = {}
  for i, v in pairs(BoxItem) do
    if string.isNullOrEmpty(v.condition) then
      table.insert(ItemData, v)
    elseif RoleUtility.CareerJudge(ViewData.meData.career, v.condition[1][1][2][1]) then
      table.insert(ItemData, v)
    end
  end
  return ItemData
end

function CommercializeData.GetMeetConditionBoxTbl(BoxItem)
  local ItemData = {}
  for i, v in pairs(BoxItem) do
    if string.isNullOrEmpty(v.condition) then
      table.insert(ItemData, v)
    elseif ConditionManager.Check4D(v.condition) then
      table.insert(ItemData, v)
    end
  end
  return ItemData
end

function CommercializeData:GetSportBOSSInfo()
  SportsBoss = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeOpeningserGrop.SportsBoss)
  return SportsBoss
end

function CommercializeData.GetAccumulativeGiftData(groupId)
  local alreadyGetData = {}
  local notGetData = {}
  local commerceCfgTab = ClientTable.cfg_Commerce_RechargeManager:GetDic()
  for id, cfgItem in pairs(commerceCfgTab) do
    if cfgItem.group == groupId and ConditionManager.Check4D(cfgItem.condition) then
      local itemData = {}
      local receiveState = false
      if table.count(CommercializeData.AccumulativeGiftDataInfo) > 0 then
        for index, serverId in pairs(CommercializeData.AccumulativeGiftDataInfo.issued) do
          if cfgItem.id == serverId then
            receiveState = true
            break
          end
        end
      end
      itemData.id = cfgItem.id
      itemData.rechargeNum = table.count(CommercializeData.AccumulativeGiftDataInfo) > 0 and CommercializeData.AccumulativeGiftDataInfo.rechargeNum or 0
      itemData.receiveState = receiveState
      itemData.image = cfgItem.image
      if receiveState then
        table.insert(alreadyGetData, itemData)
      else
        table.insert(notGetData, itemData)
      end
    end
  end
  table.sort(alreadyGetData, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    end
  end)
  table.sort(notGetData, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    end
  end)
  local info = table.combine(notGetData, alreadyGetData)
  if table.count(info) > 0 then
    return info, info[1].image
  end
  return table.combine(notGetData, alreadyGetData), nil
end

function CommercializeData.CheckAccumulativeGiftRed()
  local commerceCfgTab = ClientTable.cfg_Commerce_RechargeManager:GetDic()
  local groupId = CommercializeData.AccumulativeGiftDataInfo.group
  for id, cfgItem in pairs(commerceCfgTab) do
    if groupId == cfgItem.group and ConditionManager.Check4D(cfgItem.condition) then
      local receiveState = false
      if table.count(CommercializeData.AccumulativeGiftDataInfo) > 0 then
        for index, serverId in pairs(CommercializeData.AccumulativeGiftDataInfo.issued) do
          if cfgItem.id == serverId then
            receiveState = true
            break
          end
        end
      end
      if not receiveState then
        local taskGoalCfg = ClientTable.cfg_Task_goalManager:TryGetValue(cfgItem.goalId)
        local totalCount = table.count(CommercializeData.AccumulativeGiftDataInfo) > 0 and CommercializeData.AccumulativeGiftDataInfo.rechargeNum or 0
        if totalCount >= taskGoalCfg.goalCount then
          return true
        end
      end
    end
  end
  return false
end

function CommercializeData:CheckAccumulativeGiftTogState()
  local state = true
  local cfgTab = ClientTable.cfg_Commerce_RechargeManager:GetDic()
  local maxId = 0
  for i, v in pairs(cfgTab) do
    maxId = Mathf.Max(v.id, maxId)
  end
  if table.count(CommercializeData.AccumulativeGiftDataInfo.issued) == table.count(cfgTab) then
    for index, serverId in pairs(CommercializeData.AccumulativeGiftDataInfo.issued) do
      if serverId == maxId then
        state = false
      end
    end
  end
  return state
end

this.Init()
