RefreshData = {}
local this = RefreshData
RefreshData.TotalRefreshTbl = {}
RefreshData.ScheduleTbl = {}
RefreshData.NotNeedClientRefreshTab = {
  [2440600] = 2440600
}
RefreshData.Key2Event = {}
RefreshData.TypeEnum = {
  Shop = 22300,
  KLMSM = 30201,
  CSYS = 30202,
  Mall = 23600,
  Mount = 24700,
  goLevelReward = 25200,
  RechFristGift = 40101,
  NomalRecharge = 40102,
  DirectRecharge = 40103,
  RechFristRmbGift = 40104,
  OpenserGift = 40105,
  SportsLeve = 40106,
  SportsEquip = 40107,
  SportsIntensify = 40108,
  SportsZhuijia = 40109,
  EquipFirstGe = 40110,
  BossFirstKill = 40111,
  DailyRechang = 40112,
  EveryDayRechang = 40113,
  SportsExcellenc = 40114,
  SportsJewelry = 40115,
  SportsFruit = 40116,
  SportsFight = 40117,
  SkyPavilionRefresh = 401140,
  Mount = 24700,
  StarTaskCount = 24800,
  NewVip = 23601,
  Giveback = 17000,
  GivebackRefesh = 24603,
  DragonActivity = 42100,
  Preview = 25400,
  SevenDaysSignIn = 40119,
  HolidayPackagermb = 43001,
  HolidayPackage = 30020,
  HolidayCollect = 30060,
  HolidayShop = 30090,
  HolidayFireworks = 30100,
  LimitBuy = 401018,
  TimeLimitBuy = 40300,
  CommercialTimeLimitBuy = 90000,
  GoodFiftsEveryDay = 301001,
  LuckyStar = 92000,
  OpenServerInvestment = 95000,
  IntegralMall_HeroicExchange = 21000,
  ShiKongActivity = 120000,
  DownLoad = 120000,
  Regular = 260000,
  Advanced = 260002,
  CollectionCount = 260001
}

function RefreshData.InitRefreshes(data)
  this.Reset()
  this.Init()
  this.ResetRefreshesTbl(data.counts)
end

function RefreshData.ResetRefreshesTbl(refreshes)
  for _, refresh in pairs(refreshes) do
    this.RefreshTbl(refresh)
  end
end

function RefreshData.RefreshTbl(refresh)
  RefreshData.TotalRefreshTbl[refresh.key] = refresh
  if refresh.key == 2480001 then
    RefreshData.TaskStarCount = refresh
  end
end

local function GetMaxCountByLevel(maxCountStr, currentLevel)
  local sections = string.split(maxCountStr, "&")
  local count = 0
  for i = 1, #sections do
    local params = string.split(sections[i], "#")
    if currentLevel >= tonumber(params[1]) then
      count = tonumber(params[2])
    end
  end
  return count
end

function RefreshData.GetLimitCount(countKey)
  local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
  if countTbl == nil then
    logError("B\225\186\163ng Count_count kh\195\180ng c\195\179 countKey:", countKey)
    return
  end
  local remainder = countTbl.refreshCountLimit
  if countTbl.type == 4 then
    local roleLevel = ViewData.meData:GetAttribute(EAttributeType.level)
    remainder = GetMaxCountByLevel(countTbl.maxCount, roleLevel)
  end
  if countTbl.type == 7 then
    remainder = GetMaxCountByLevel(countTbl.maxCount, LoginData.openServerDay)
  end
  local refresh = RefreshData.GetRefreshByKey(countKey)
  if refresh then
    if countTbl.type == 4 or countTbl.type == 7 then
      remainder = remainder - refresh.count
    else
      remainder = countTbl.refreshCountLimit - refresh.count
    end
  end
  return remainder
end

function RefreshData.GetInstanceCount(countKey)
  local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
  local remainder = countTbl.refreshCountLimit
  if countTbl.type == 4 or countTbl.type == 8 then
    local roleLevel = ViewData.meData:GetAttribute(EAttributeType.level)
    remainder = GetMaxCountByLevel(countTbl.maxCount, roleLevel)
  elseif countTbl.type == 7 then
    remainder = GetMaxCountByLevel(countTbl.maxCount, LoginData.openServerDay)
  elseif countTbl.type == 6 then
    local SilverCard = RoleManager.me.data.equipsData.StoneData[CommercializeEquipCell.SilverCard]
    local GoldCard = RoleManager.me.data.equipsData.StoneData[CommercializeEquipCell.GoldCard]
    if SilverCard then
      local type = string.split(countTbl.maxCount, "&")[1]
      local count = string.split(type, "#")[2]
      remainder = remainder + count
    end
    if GoldCard then
      local type = string.split(countTbl.maxCount, "&")[2]
      local count = string.split(type, "#")[2]
      remainder = remainder + count
    end
  end
  local refresh = RefreshData.GetRefreshByKey(countKey)
  if refresh then
    if countTbl.type == 11 then
      remainder = refresh.total - refresh.count
    else
      remainder = remainder - refresh.count
    end
  end
  return math.modf(remainder)
end

function RefreshData.GetRefreshByKey(key)
  return RefreshData.TotalRefreshTbl[key]
end

function RefreshData.CheckRefreshCountKey(countKey)
  if countKey == nil then
    return false
  end
  local countData = RefreshData.GetRefreshByKey(countKey)
  if countData == nil then
    return true
  end
  return countData.total - countData.count > 0
end

function RefreshData.RemoveRefreshByKey(key)
  if RefreshData.NotNeedClientRefreshTab[key] then
    return
  end
  if RefreshData.CheckClientDotRemoveCountKey(key) then
    return
  end
  RefreshData.TotalRefreshTbl[key] = nil
end

function RefreshData.CheckClientDotRemoveCountKey(countKey)
  if RefreshData.clientDotRemoveDic == nil then
    RefreshData.clientDotRemoveDic = {}
  end
  if RefreshData.clientDotRemoveDic[countKey] == nil then
    local countConfig = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
    if countConfig and countConfig.clientDotRemove and countConfig.clientDotRemove == 1 then
      RefreshData.clientDotRemoveDic[countKey] = countKey
    end
  end
  return RefreshData.clientDotRemoveDic[countKey] ~= nil
end

function RefreshData:CheckIsFirstEnter(key)
  local enterNum = RefreshData.GetRefreshByKey(key)
  return enterNum == nil or enterNum == 0
end

function RefreshData.IncreaseSchedule(schedule)
  table.insert(RefreshData.ScheduleTbl, {
    key = schedule.key,
    residueTime = schedule.residueTime
  })
end

function RefreshData.RemoveSchedule(key)
  local flag
  for i, v in pairs(RefreshData.ScheduleTbl) do
    if v.key == key then
      table.remove(RefreshData.ScheduleTbl, i)
      flag = true
      break
    end
  end
  return flag
end

function RefreshData.Reset()
  RefreshData.TotalRefreshTbl = {}
  RefreshData.Key2Event = {}
  RefreshData.TaskStarCount = nil
end

function RefreshData.GetEventByKey(type)
  return RefreshData.Key2Event[type]
end

function RefreshData.Init()
  RefreshData.Key2Event[this.TypeEnum.Shop] = Event.RefreshShop
  RefreshData.Key2Event[this.TypeEnum.Mall] = Event.RefreshShop
  RefreshData.Key2Event[this.TypeEnum.IntegralMall_HeroicExchange] = Event.RefreshShop
  RefreshData.Key2Event[this.TypeEnum.RechFristGift] = Event.FirstChargeRefresh
  RefreshData.Key2Event[this.TypeEnum.NomalRecharge] = Event.Recharge_CountRefresh
  RefreshData.Key2Event[this.TypeEnum.DirectRecharge] = Event.Recharge_CountRefresh
  RefreshData.Key2Event[this.TypeEnum.RechFristRmbGift] = Event.FirstChargeRefresh
  RefreshData.Key2Event[this.TypeEnum.OpenserGift] = Event.Commer_Openingserinfo
  RefreshData.Key2Event[this.TypeEnum.SportsLeve] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsEquip] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsIntensify] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsZhuijia] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.EquipFirstGe] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.BossFirstKill] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsExcellenc] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsJewelry] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsFight] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.SportsFruit] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.EveryDayRechang] = Event.Commer_WelfareEveryDay
  RefreshData.Key2Event[this.TypeEnum.DailyRechang] = Event.Commer_WelfareDailyDay
  RefreshData.Key2Event[this.TypeEnum.SkyPavilionRefresh] = Event.Commer_SkyPavilionRefresh
  RefreshData.Key2Event[this.TypeEnum.goLevelReward] = Event.Commer_goLevelReward
  RefreshData.Key2Event[this.TypeEnum.Mount] = Event.Fuc_Refresh
  RefreshData.Key2Event[this.TypeEnum.StarTaskCount] = Event.StarTask_Count
  RefreshData.Key2Event[this.TypeEnum.NewVip] = Event.Commer_NewVip
  RefreshData.Key2Event[this.TypeEnum.Giveback] = Event.Recharge_PrizeGiveback
  RefreshData.Key2Event[this.TypeEnum.GivebackRefesh] = Event.Recharge_PrizeGiveback
  RefreshData.Key2Event[this.TypeEnum.DragonActivity] = Event.ActivityDragonItemCount
  RefreshData.Key2Event[this.TypeEnum.Preview] = Event.SystemPreview
  RefreshData.Key2Event[this.TypeEnum.SevenDaysSignIn] = Event.Commer_SetOpenserReqinfo
  RefreshData.Key2Event[this.TypeEnum.HolidayPackagermb] = Event.Commer_HolidayserReqinfo
  RefreshData.Key2Event[this.TypeEnum.HolidayPackage] = Event.Commer_HolidayserReqinfo
  RefreshData.Key2Event[this.TypeEnum.HolidayCollect] = Event.Commer_HolidayserReqinfo
  RefreshData.Key2Event[this.TypeEnum.HolidayShop] = Event.Commer_HolidayserReqinfo
  RefreshData.Key2Event[this.TypeEnum.HolidayFireworks] = Event.Commer_HolidayserReqinfo
  RefreshData.Key2Event[this.TypeEnum.LimitBuy] = Event.Recharge_LifeLimitBuyRefresh
  RefreshData.Key2Event[this.TypeEnum.TimeLimitBuy] = Event.Commer_TimeWelfar
  RefreshData.Key2Event[this.TypeEnum.CommercialTimeLimitBuy] = Event.CombineFirstGiftCount
  RefreshData.Key2Event[this.TypeEnum.GoodFiftsEveryDay] = Event.GoodFiftsEveryDay
  RefreshData.Key2Event[this.TypeEnum.LuckyStar] = Event.LuckyStarCount
  RefreshData.Key2Event[this.TypeEnum.OpenServerInvestment] = Event.OpenServerInvestmentCount
  RefreshData.Key2Event[this.TypeEnum.ShiKongActivity] = Event.ActivityShiKongItemCount
  RefreshData.Key2Event[this.TypeEnum.DownLoad] = Event.DownLoadGiftCountRefresh
  RefreshData.Key2Event[this.TypeEnum.Regular] = Event.GoldFarmingActivityRedDot
  RefreshData.Key2Event[this.TypeEnum.Advanced] = Event.GoldFarmingActivityRedDot
  RefreshData.Key2Event[this.TypeEnum.CollectionCount] = Event.GoldFarmingActivityRedDot
end
