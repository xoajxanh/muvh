CommercialTimeLimitedActivityData = {}
local this = CommercialTimeLimitedActivityData
CommercialTimeLimitedActivityData.HolidayTogId = {}
CommercialTimeLimitedActivityData.HolidayTogIdInfo = {}
CommercialTimeLimitedActivityData.HolidayTogSerInfo = {}
CommercialTimeLimitedActivityData.FireworksBulletin = {
  roleAnnounce = {},
  serverAnnounce = {},
  serverTopAnnounce = {},
  count = 0
}
CommercialTimeLimitedActivityData.FireworksBulletinTopCount = 5
CommercialTimeLimitedActivityData.FireworksBulletinFullServerCount = 45
CommercialTimeLimitedActivityData.FireworksBulletinPersonalCount = 50
CommercialTimeLimitedActivityData.FireworksBulletinChat = ""
CommercialTimeLimitedActivityData.NeedCollectItems = {}
CommercialTimeLimitedActivityData.NeedCollectGroup = {}
CommercialTimeLimitedActivityData.ResOpenGroups = nil
CommercialTimeLimitedActivityData.LimitedTimeCommerceId_SpecialGiftPackageRecharge = {}
CommercialTimeLimitedActivityData.LimitedTimeCommerceId_SpecialGiftPackageItemBuy = {}
CommercialTimeLimitedActivityData.RoleList = {}

function CommercialTimeLimitedActivityData.RefreshHolidayTogIdInfo(index)
  local TogGroup = CommercialTimeLimitedActivityData.HolidayTogId
  this.HolidayTogIdInfo = {}
  for i, id in pairs(TogGroup) do
    local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    local cfg
    if not table.isNullOrEmpty(cfgs) then
      for i, v in pairs(cfgs) do
        if v.commerceType == CommercializeActivityTab.LimitedTime and ConditionManager.Check(v.condition) then
          cfg = v
          break
        end
      end
    end
    if cfg ~= nil then
      if i == index then
        cfg.Selected = true
      else
        cfg.Selected = false
      end
      table.insert(this.HolidayTogIdInfo, cfg)
    end
  end
  return this.HolidayTogIdInfo
end

function CommercialTimeLimitedActivityData.GetCommerce_overviewList(index)
  local TogGroup = CommercialTimeLimitedActivityData.HolidayTogId
  this.HolidayTogIdInfo = {}
  local UI = UIManager.GetUiByName(UIID.Commercial_LimitedTimeActivityUI)
  for i, id in pairs(TogGroup) do
    local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    local cfg
    if not table.isNullOrEmpty(cfgs) then
      for i, v in pairs(cfgs) do
        if v.commerceType == CommercializeActivityTab.LimitedTime and ConditionManager.Check(v.condition) then
          cfg = v
          break
        end
      end
    end
    if UI and UI.curPageGroupId then
      cfg.Selected = id == UI.curPageGroupId
    end
    if cfg ~= nil then
      table.insert(this.HolidayTogIdInfo, cfg)
    end
  end
  return this.HolidayTogIdInfo
end

function CommercialTimeLimitedActivityData.GetHolidayTogIndexByGroup(Group)
  local TogGroup = CommercialTimeLimitedActivityData.HolidayTogId
  this.HolidayTogIdInfo = {}
  for i, v in pairs(TogGroup) do
    if Group == v then
      return i
    end
  end
end

function CommercialTimeLimitedActivityData.HolidaytypeDistinguish()
  local CurrentInfo = {}
  for i, v in pairs(this.HolidayTogIdInfo) do
    if v.group == this.HolidayTogSerInfo.groupId then
      CurrentInfo = v
      CurrentInfo.Msg = this.HolidayTogSerInfo
      break
    end
  end
  return CurrentInfo
end

local function GetSpecialGiftPackageItemBuyData(itemBuy)
  if table.isNullOrEmpty(itemBuy) then
    return {}
  end
  local itemBuyTbl = {}
  for i = 1, #itemBuy do
    local buyItem = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(itemBuy[i]), "id")
    if buyItem and (string.isNullOrEmpty(buyItem.showCondition) or ConditionManager.Check4D(buyItem.showCondition)) then
      table.insert(itemBuyTbl, buyItem)
    end
  end
  table.sort(itemBuyTbl, function(a, b)
    local arecommend = a.recommend
    local brecommend = b.recommend
    local asortId = a.sortId and a.sortId or a.commodityRanking
    local bsortId = b.sortId and b.sortId or b.commodityRanking
    if arecommend > brecommend then
      return a.recommend > b.recommend
    else
      return asortId < bsortId
    end
  end)
  return itemBuyTbl
end

local function GetSpecialGiftPackageRechargeData(recharge)
  if table.isNullOrEmpty(recharge) then
    return {}
  end
  local rechargeTbl = {}
  for i = 1, #recharge do
    local rechargeData = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(tonumber(recharge[i]), "id")
    if rechargeData and (PlatformData.PlatformCheck(rechargeData.channelControl) and string.isNullOrEmpty(rechargeData.showCondition) or ConditionManager.Check4D(rechargeData.showCondition)) then
      table.insert(rechargeTbl, rechargeData)
    end
  end
  table.sort(rechargeTbl, function(a, b)
    local arecommend = a.recommend
    local brecommend = b.recommend
    local asortId = a.sortId and a.sortId or a.commodityRanking
    local bsortId = b.sortId and b.sortId or b.commodityRanking
    if arecommend > brecommend then
      return a.recommend > b.recommend
    else
      return asortId < bsortId
    end
  end)
  return rechargeTbl
end

local function GetHolidayGiftData(Itembuy, Recharge)
  local showBuyInfo = {}
  local itemBuyTbl = GetSpecialGiftPackageItemBuyData(Itembuy)
  local rechargeTbl = GetSpecialGiftPackageRechargeData(Recharge)
  showBuyInfo = table.combine(itemBuyTbl, rechargeTbl)
  table.sort(showBuyInfo, function(a, b)
    local arecommend = a.recommend
    local brecommend = b.recommend
    local asortId = a.sortId and a.sortId or a.commodityRanking
    local bsortId = b.sortId and b.sortId or b.commodityRanking
    if arecommend > brecommend then
      return a.recommend > b.recommend
    else
      return asortId < bsortId
    end
  end)
  return showBuyInfo
end

function CommercialTimeLimitedActivityData.RefreshHolidayGiftTypeInfo(data)
  local shopInfo = data.Msg.shopInfo
  local Itembuy = {}
  local Recharge = {}
  for i, v in pairs(shopInfo) do
    local Commerce_2 = ClientTable.cfg_Commerce_2Manager:TryGetValue(v.id, "id")
    if Commerce_2.type == CommerceActivityGiftType.Shop then
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
  local ShowBuyInfo, ItemBuyInfo, RechargeInfo = GetHolidayGiftData(Itembuy, Recharge), GetSpecialGiftPackageItemBuyData(Itembuy), GetSpecialGiftPackageRechargeData(Recharge)
  return ShowBuyInfo, ItemBuyInfo, RechargeInfo
end

function CommercialTimeLimitedActivityData.RefreshHolidayBoosActivityInfo(data)
  local SerboosInfo = data.Msg.boosInfo
  local BoosTbl = ClientTable.cfg_Commerce_5Manager:GetDic()
  local BoosInfo
  for i, v in pairs(BoosTbl) do
    if string.isNullOrEmpty(v.showCondition) or ConditionManager.Check4D(v.showCondition) then
      BoosInfo = v
      break
    end
  end
  if BoosInfo then
    BoosInfo.Msg = SerboosInfo
  else
    logError("L\225\187\151i c\225\186\165u h\195\172nh SK Boos hi\225\187\135n t\225\186\161i, ch\198\176a \196\145\225\186\161t \196\144i\225\187\129u ki\225\187\135n m\225\187\159 ")
  end
  return BoosInfo
end

function CommercialTimeLimitedActivityData.GetRewardTbl(monsterBossTbl)
  local tabReward = {}
  if monsterBossTbl and monsterBossTbl.dropItem then
    local award = string.split(monsterBossTbl.dropItem, "&")
    local awardEff = string.split(monsterBossTbl.dropItemEffect, "#")
    
    local function GetRewardIsEff(rewardID, rewardTab)
      local reward = {}
      for k, v in pairs(rewardTab) do
        local item = string.split(rewardID, "*")
        if v == item[1] then
          reward.id = item[1]
          reward.count = item[2]
          reward.isEff = true
        end
      end
      if reward and reward.id then
        return reward
      else
        local item = string.split(rewardID, "*")
        reward.id = item[1]
        reward.count = item[2]
        reward.isEff = false
        return reward
      end
    end
    
    for k, v in pairs(award) do
      if string.find(v, "_") then
        if RoleUtility.CareerJudge(ViewData.meData.career, tonumber(string.split(v, "_")[1])) then
          award = string.split(string.split(v, "_")[2], "#")
          for kk, vv in pairs(award) do
            local reward = GetRewardIsEff(vv, awardEff)
            table.insert(tabReward, reward)
          end
        end
      else
        local awardInAll = string.split(v, "#")
        for kk, vv in pairs(awardInAll) do
          local reward = GetRewardIsEff(vv, awardEff)
          table.insert(tabReward, reward)
        end
      end
    end
  end
  return tabReward
end

function CommercialTimeLimitedActivityData.GetHolidayGlobal()
  CommercialTimeLimitedActivityData.FireworksBulletinTopCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303006, "id").effect)
  CommercialTimeLimitedActivityData.FireworksBulletinFullServerCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303005, "id").effect)
  CommercialTimeLimitedActivityData.FireworksBulletinPersonalCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303004, "id").effect)
  CommercialTimeLimitedActivityData.FireworksBulletinChat = ClientTable.cfg_Commerce_globalManager:TryGetValue(303008, "id").effect
end

function CommercialTimeLimitedActivityData.RefreshHolidayFireworksInfo(data)
  local ShowBuyInfo = CommercialTimeLimitedActivityData.RefreshHolidayGiftTypeInfo(data)
  CommercialTimeLimitedActivityData.FireworksBulletin = data.Msg.fireworkInfo
  local ExhibitTbl = ClientTable.cfg_Commerce_globalManager:TryGetValue(303001, "id").effect
  local ExhibitGroup
  if string.contains(ExhibitTbl, "&") then
    ExhibitGroup = string.format(ExhibitTbl, "&")
  else
    ExhibitGroup = {ExhibitTbl}
  end
  local NeedShowItem, NeedShowEff
  for i, v in pairs(ExhibitGroup) do
    local Group = string.split(v, "#")
    local itemid = tonumber(Group[1])
    local itemTbl = ClientTable.cfg_Commerce_globalManager:TryGetValue(itemid, "id").effect
    local Conditionitem = string.split(itemTbl, "/")
    if ConditionManager.Check(Conditionitem[1]) then
      NeedShowItem = Conditionitem[2]
      local itemTbl = ClientTable.cfg_Commerce_globalManager:TryGetValue(tonumber(Group[2]), "id").effect
      local ConditionEff = string.split(itemTbl, "/")
      NeedShowEff = ConditionEff[2]
      break
    end
  end
  local Reward = {dropItemEffect = NeedShowEff, dropItem = NeedShowItem}
  local ShowReward = CommercialTimeLimitedActivityData.GetRewardTbl(Reward)
  return ShowBuyInfo, ShowReward
end

function CommercialTimeLimitedActivityData.AddHolidayFireworksBulletin(data)
  if data.type == FireworksBulletinType.roleAnnounce then
    if #CommercialTimeLimitedActivityData.FireworksBulletin.roleAnnounce >= CommercialTimeLimitedActivityData.FireworksBulletinPersonalCount then
      table.remove(CommercialTimeLimitedActivityData.FireworksBulletin.roleAnnounce, 1)
    end
    table.insert(CommercialTimeLimitedActivityData.FireworksBulletin.roleAnnounce, data.announce)
    EventManager.Dispatch(Event.RoleAnnounceRefresh)
  elseif data.type == FireworksBulletinType.serverAnnounce then
    local AllCount = #CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce + #CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce
    if AllCount >= CommercialTimeLimitedActivityData.FireworksBulletinFullServerCount then
      table.remove(CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce, 1)
    end
    table.insert(CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce, data.announce)
    EventManager.Dispatch(Event.ServerAnnounceRefresh)
  elseif data.type == FireworksBulletinType.serverTopAnnounce then
    local server = #CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce
    local serverTop = #CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce
    local AllCount = server + serverTop
    if serverTop >= CommercialTimeLimitedActivityData.FireworksBulletinTopCount then
      table.remove(CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce, 1)
    elseif AllCount >= CommercialTimeLimitedActivityData.FireworksBulletinFullServerCount then
      table.remove(CommercialTimeLimitedActivityData.FireworksBulletin.serverAnnounce, 1)
    end
    table.insert(CommercialTimeLimitedActivityData.FireworksBulletin.serverTopAnnounce, data.announce)
    EventManager.Dispatch(Event.ServerAnnounceRefresh)
  end
end

function CommercialTimeLimitedActivityData.GetChatTextFun(system2)
  local inputData = {}
  inputData["[system:1]"] = {}
  inputData["[system:1]"].type = ChatInfoEnum.ITEM
  local item = CommercialTimeLimitedActivityData.Getcfg_Commerce_6Fun(system2)
  local itemId = item.itemId
  local name = item.name
  inputData["[system:1]"].itemData = ItemUtility.GenerateItemData(itemId)
  return inputData, name
end

function CommercialTimeLimitedActivityData.RefreshCollectInfo()
  local tbl = ClientTable.cfg_Commerce_7Manager:GetDic()
  local showCollectInfo = {}
  for i, v in pairs(tbl) do
    if (string.isNullOrEmpty(v.showCondition) or ConditionManager.Check4D(v.showCondition)) and v.commerceId == CommerceIdEnum.LimitedTime_CollectWord then
      table.insert(showCollectInfo, v)
    end
  end
  return showCollectInfo
end

function CommercialTimeLimitedActivityData.IsShowMainMenuLimitedTimeActivityIconByServeInfo()
  if table.isNullOrEmpty(CommercialTimeLimitedActivityData.ResOpenGroups) then
    return false
  end
  local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "commerceType", CommercializeActivityTab.LimitedTime)
  if not table.isNullOrEmpty(cfgs) then
    for i, v in pairs(cfgs) do
      if table.contains(CommercialTimeLimitedActivityData.ResOpenGroups, v.group) and ConditionManager.Check4D(v.level) then
        return true
      end
    end
  end
  return false
end

function CommercialTimeLimitedActivityData.IsShowMainMenuLimitedTimeActivityIcon()
  local isShow = false
  local openActivityNum = 0
  local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "commerceType", CommercializeActivityTab.LimitedTime)
  if not table.isNullOrEmpty(cfgs) then
    for i, v in pairs(cfgs) do
      if v.group == QuickFind:GetOpenServerInvestmentData():GetActivityId() then
        if QuickFind:GetOpenServerInvestmentData():IsShowActivity() then
          openActivityNum = openActivityNum + 1
          isShow = true
        end
      elseif ConditionManager.Check4D(v.level) and ConditionManager.Check(v.condition) then
        openActivityNum = openActivityNum + 1
        isShow = true
      end
    end
  end
  return isShow, openActivityNum
end

function CommercialTimeLimitedActivityData.RefreshHolidayTaskInfo(data)
  local SerTaskInfo = data.Msg.taskInfo
  local TaskInfo = {}
  for i, v in pairs(SerTaskInfo) do
    local info = ClientTable.cfg_Commerce_overviewManager:TryGetValue(v.taskId, "commerceId")
    info.Msg = v
    table.insert(TaskInfo, info)
  end
  table.sort(TaskInfo, function(a, b)
    return a.commerceId < b.commerceId
  end)
  return TaskInfo
end

function CommercialTimeLimitedActivityData.GetBoxinfoFun(rewardParam)
  if rewardParam == nil then
    return {}
  end
  local boxInfoTbl = {}
  local reward = string.split(rewardParam, "#")
  local rewardCount = table.count(reward)
  if rewardCount < 1 then
    return {}
  elseif rewardCount == 1 then
    return ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(reward[1]))
  elseif rewardCount == 2 then
    local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(reward[1]))
    if not string.isNullOrEmpty(itemTbl.useParam) then
      local tab = string.split(itemTbl.useParam, "#")
      if tab and #tab == 2 and tonumber(tab[1]) == 3 then
        local boxTbl = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(tab[2]))
        if 0 < #boxTbl then
          for i, v in pairs(boxTbl) do
            if v.condition == nil or ConditionManager.Check4D(v.condition) then
              table.insert(boxInfoTbl, v)
            end
          end
        end
      end
    end
  end
  return boxInfoTbl
end

function CommercialTimeLimitedActivityData.GetGiftInfoFun(Giftid)
  return ClientTable.cfg_Gift_giftManager:TryGetValue(Giftid, "id")
end

function CommercialTimeLimitedActivityData.GetItemInfoFun(Itemid)
  return ClientTable.cfg_Item_itemManager:TryGetValue(Itemid)
end

function CommercialTimeLimitedActivityData.GetMapInfoFun(mapid)
  return ClientTable.cfg_Map_mapManager:TryGetValue(mapid, "id")
end

function CommercialTimeLimitedActivityData.GetCountInfoFun(Countid)
  return ClientTable.cfg_Count_countManager:TryGetValue(Countid, "key")
end

function CommercialTimeLimitedActivityData.Getcfg_Commerce_1Fun(Countid)
  return ClientTable.cfg_Commerce_1Manager:TryGetValue(Countid, "id")
end

function CommercialTimeLimitedActivityData.Getcfg_Commerce_6Fun(Countid)
  return ClientTable.cfg_Commerce_6Manager:TryGetValue(Countid, "id")
end

function CommercialTimeLimitedActivityData.Getcfg_Task_goalFun(id)
  return ClientTable.cfg_Task_goalManager:TryGetValue(id, "goalId")
end

function CommercialTimeLimitedActivityData.Getcfg_Ui_wordFun(content)
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(content)
end

function CommercialTimeLimitedActivityData.GetCommerce_globalFun(id)
  return ClientTable.cfg_Commerce_globalManager:TryGetValue(id).effect
end

function CommercialTimeLimitedActivityData.GetRefreshCountFun(Countid)
  local RefreshData = RefreshData.GetRefreshByKey(Countid)
  if RefreshData then
    local leftover = RefreshData.total - RefreshData.count
    if leftover <= 0 then
      return false, 0
    else
      return true, leftover
    end
  end
  return true
end

function CommercialTimeLimitedActivityData.RedPointInit()
  this.RedPointCollectInit()
end

function CommercialTimeLimitedActivityData.RedPointCollectInit()
  this.NeedCollectItems = {}
  this.NeedCollectGroup = {}
  local ShowCollectInfo = this.RefreshCollectInfo()
  for k = 1, #ShowCollectInfo do
    local Collect = string.split(ShowCollectInfo[k].itemId, "&")
    local Group = {}
    for i, v in pairs(Collect) do
      local split = string.split(v, "#")
      local itemId = tonumber(split[1])
      local count = tonumber(split[2])
      this.NeedCollectItems[itemId] = itemId
      Group[itemId] = count
    end
    this.NeedCollectGroup[k] = Group
  end
end

function CommercialTimeLimitedActivityData.RedPointCollectRefresh(items, removeItem)
  local redchange = false
  for i, v in pairs(items) do
    if CommercialTimeLimitedActivityData.NeedCollectItems[v.itemId] then
      redchange = true
      break
    end
  end
  if not redchange then
    for i, v in pairs(removeItem) do
      if CommercialTimeLimitedActivityData.NeedCollectItems[v.itemId] then
        redchange = true
        break
      end
    end
  end
  if redchange then
    CommercialTimeLimitedActivityData.RedPointCollect()
    EventManager.Dispatch(Event.CollectRefresh)
  end
end

function CommercialTimeLimitedActivityData.RedPointCollect()
  local finish = false
  local Group = CommercialTimeLimitedActivityData.NeedCollectGroup
  for k = 1, #Group do
    local group = Group[k]
    local count = 0
    local acc = 0
    for i, v in pairs(group) do
      count = count + 1
      if v <= BagInfoData.GetItemTotalCountByItemId(i) then
        acc = acc + 1
      end
    end
    if count == acc then
      local TogInfo = CommercialTimeLimitedActivityData.RefreshCollectInfo()
      local countkey = TogInfo[k].countkey
      finish = CommercialTimeLimitedActivityData.GetRefreshCountFun(countkey)
      if finish then
        break
      end
    end
  end
  RedPointChecker_Ext:TimeLimitedRedPointRefreshState({
    redId = CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Collect],
    state = finish
  })
  CommercialTimeLimitedActivityData.RedPointTogRefresh(CommercializeTimeLimitedGrop.Collect)
end

function CommercialTimeLimitedActivityData.RedPointTogRefresh(Group)
  local UI = UIManager.GetUiByName(UIID.Commercial_LimitedTimeActivityUI)
  if UI and UI.visible then
    local index = CommercialTimeLimitedActivityData.GetHolidayTogIndexByGroup(Group)
    UI.BtnHolidayContainer:SetData(CommercialTimeLimitedActivityData.GetCommerce_overviewList(index))
  end
end

function CommercialTimeLimitedActivityData.RedPointShop()
  local a = PlayerPrefs.GetString(RedPointChecker_Ext:GetFirstTimeBuyDayKey(CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop]), "")
  local infos = string.split(a, "#")
  if infos[1] ~= tostring(LoginData.openServerDay) then
    local cfgtbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeTimeLimitedGrop.Shop)
    for i, v in pairs(cfgtbl) do
      if (string.isNullOrEmpty(v.condition) or ConditionManager.Check(v.condition)) and (string.isNullOrEmpty(v.level) or ConditionManager.Check4D(v.level)) then
        local Commerce_2 = ClientTable.cfg_Commerce_2Manager:TryGetValue(v.commerceId, "id")
        local Item_buy = string.split(Commerce_2.shopId, "#")
        for k = 1, #Item_buy do
          local BuyItem = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(Item_buy[k]), "id")
          if string.isNullOrEmpty(BuyItem.showCondition) or ConditionManager.Check4D(BuyItem.showCondition) then
            local costs = string.split(BuyItem.cost, "#")
            local cost = tonumber(costs[1])
            local count = tonumber(costs[2])
            local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(cost)
            if count <= bagCoinCount then
              RedPointChecker_Ext:RefreshFirstTimeBuyDayState(CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop])
              return
            end
          end
        end
      end
    end
  end
end

function CommercialTimeLimitedActivityData.Init()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CommercialTimeLimitedActivityData.RegistEvent()
  this.eventContainer:Regist(Event.Bag_ResBagInfo, this.Bag_ResBagInfo)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.Bag_ResBagChange)
end

function CommercialTimeLimitedActivityData.InitInfo()
  local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "commerceType", CommercializeActivityTab.LimitedTime)
  if not table.isNullOrEmpty(cfgs) then
    for i, v in pairs(cfgs) do
      if v.group == CommercializeTimeLimitedGrop.GiftPack then
        table.insert(this.LimitedTimeCommerceId_SpecialGiftPackageRecharge, v.commerceId)
      elseif v.group == CommercializeTimeLimitedGrop.LimitedTime_SpecialGiftPackageItemBuy then
        table.insert(this.LimitedTimeCommerceId_SpecialGiftPackageItemBuy, v.commerceId)
      end
    end
  end
end

function CommercialTimeLimitedActivityData.Bag_ResBagInfo()
  CommercialTimeLimitedActivityData.RedPointCollect()
  this.RedPointShop()
end

function CommercialTimeLimitedActivityData.Bag_ResBagChange(_, msg)
  local showItems = {}
  local removeItems = {}
  if msg ~= nil then
    showItems = msg.showItems
    removeItems = msg.removeItems
    if removeItems == nil then
      removeItems = {}
    end
  end
  this.RedPointCollectRefresh(showItems, removeItems)
  this.RedPointShop()
end

function CommercialTimeLimitedActivityData.GetContinuousRechargeTog(data, CommerceType)
  table.sort(data, function(a, b)
    return a.taskId < b.taskId
  end)
  local ContinuousToginfo = {}
  for i, v in pairs(data) do
    local tblinfo = CommercialTimeLimitedActivityData.GetCommerce_lianxuFun(v.taskId)
    if not string.isNullOrEmpty(tblinfo.title) then
      local toginfo = {}
      toginfo = table.DeepCopy(tblinfo)
      toginfo.info = {}
      local info = {}
      info.tbl = tblinfo
      info.Msg = v
      table.insert(toginfo.info, info)
      table.insert(ContinuousToginfo, toginfo)
    else
      for k, w in pairs(ContinuousToginfo) do
        if w.group == tblinfo.group then
          local info = {}
          info.tbl = tblinfo
          info.Msg = v
          table.insert(w.info, info)
        end
      end
    end
  end
  local NewContinuousToginfo = {}
  for i, v in pairs(ContinuousToginfo) do
    local cfg = ConfigManager.GetConfig("cfg_Commerce_overview", v.id, "commerceId")
    if table.isNullOrEmpty(cfg.personalTabClose) or not ConditionManager.Check4D(cfg.personalTabClose) then
      table.insert(NewContinuousToginfo, v)
    end
  end
  if #NewContinuousToginfo <= 0 then
    CommercializeController.ReqGetCommercialActivityTabFun(CommerceType)
  end
  local count = #NewContinuousToginfo
  if count <= #RedPointChecker_Ext.TimeLimitedContinuousRecharge then
    for i, v in pairs(CommerceTimeLimitedContinuousRechargeRed) do
      RedPointChecker_Ext.TimeLimitedContinuousRecharge[v] = false
    end
  end
  for i = 1, #NewContinuousToginfo do
    local info = NewContinuousToginfo[i].info
    local red = false
    for k, v in pairs(info) do
      if v.Msg.giftInfo[1].canGet and 1 > v.Msg.giftInfo[1].roleCount then
        red = true
      end
    end
    local group = NewContinuousToginfo[i].group
    RedPointChecker_Ext.TimeLimitedContinuousRecharge[CommerceTimeLimitedContinuousRechargeRed[group]] = red
  end
  local togred = false
  for i, v in pairs(RedPointChecker_Ext.TimeLimitedContinuousRecharge) do
    if v then
      togred = true
    end
  end
  if RedPointChecker_Ext.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.ContinuousRecharge]] ~= togred then
    RedPointChecker_Ext:TimeLimitedRedPointRefreshState({
      redId = CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.ContinuousRecharge],
      state = togred
    })
    CommercialTimeLimitedActivityData.RedPointTogRefresh(CommercializeTimeLimitedGrop.ContinuousRecharge)
  end
  return NewContinuousToginfo
end

function CommercialTimeLimitedActivityData.GetCommerce_lianxuFun(id)
  return ConfigManager.GetConfig("cfg_Commerce_lianxu", id, "id")
end

function CommercialTimeLimitedActivityData.EquipZhuFuAngel(Listtable, Listequip, itetName, img_liuguang, img_liuguang2)
  for i = 1, img_liuguang.transform.childCount do
    local child = img_liuguang:GetChild("img" .. i)
    table.insert(Listtable, child)
  end
  for i = 1, img_liuguang2.transform.childCount do
    local child = img_liuguang2:GetChild("img" .. i)
    table.insert(Listtable, child)
  end
  local Commerceequip = ClientTable.cfg_Commerce_equipManager:GetDic()
  for i, v in ipairs(Commerceequip) do
    if v.group == 33001 and ConditionManager.Check4D(v.condition) then
      local equipitem = {}
      local equipSeq = 1
      for k, m in ipairs(v.equipId) do
        local equip = ClientTable.cfg_Item_equipManager:TryGetValue(m)
        local equipdata = ItemUtility.GenerateItemData(equip.id)
        local equips = string.split(equip.equipPosition, "#")
        if 1 < table.count(equips) then
          equipdata.bagGridIndex = tonumber(equips[equipSeq] or equips[1])
          equipSeq = equipSeq + 1
        else
          equipdata.bagGridIndex = tonumber(equips[1])
        end
        table.insert(equipitem, equipdata)
      end
      table.insert(itetName, v.name)
      table.insert(Listequip, equipitem)
    end
  end
end

function CommercialTimeLimitedActivityData.GetMountExhibitionData()
  local mountExhibitionData, itemData, itemMountCfg = {}
  local commerceEquipCfg = ClientTable.cfg_Commerce_equipManager:GetDic()
  for id, itemCfg in pairs(commerceEquipCfg) do
    if itemCfg.group == 34001 then
      itemData = {}
      itemMountCfg = ClientTable.cfg_Item_mountManager:TryGetValue(itemCfg.equipId, "id")
      if not string.isNullOrEmpty(itemMountCfg) then
        itemData.modelPath = string.format("Model/%s/%s.prefab", itemMountCfg.route, itemMountCfg.model)
        itemData.grade = itemCfg.grade
        itemData.name = itemCfg.name
        table.insert(mountExhibitionData, itemData)
      end
    end
  end
  table.sort(mountExhibitionData, function(a, b)
    if a.grade and b.grade then
      return a.grade < b.grade
    end
  end)
  return mountExhibitionData
end

this.Init()
