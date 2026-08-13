CommercialHolidayData = {}
local this = CommercialHolidayData
CommercialHolidayData.HolidayTogId = {}
CommercialHolidayData.HolidayTogIdInfo = {}
CommercialHolidayData.HolidayTogSerInfo = {}
CommercialHolidayData.FireworksBulletin = {
  roleAnnounce = {},
  serverAnnounce = {},
  serverTopAnnounce = {},
  count = 0
}
CommercialHolidayData.FireworksBulletinTopCount = 5
CommercialHolidayData.FireworksBulletinFullServerCount = 45
CommercialHolidayData.FireworksBulletinPersonalCount = 50
CommercialHolidayData.FireworksBulletinChat = ""
CommercialHolidayData.NeedCollectItems = {}
CommercialHolidayData.NeedCollectGroup = {}

function CommercialHolidayData.RefreshHolidayTogIdInfo(index)
  local TogGroup = CommercialHolidayData.HolidayTogId
  this.HolidayTogIdInfo = {}
  for i, id in pairs(TogGroup) do
    local cfgTabList = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    for _index, cfgData in ipairs(cfgTabList) do
      if cfgData.condition and ConditionManager.Check(cfgData.condition) then
        if i == index then
          cfgData.Selected = true
        else
          cfgData.Selected = false
        end
        table.insert(this.HolidayTogIdInfo, cfgData)
        break
      end
    end
  end
  return this.HolidayTogIdInfo
end

function CommercialHolidayData.GetCommerce_overviewList(index)
  local TogGroup = CommercialHolidayData.HolidayTogId
  this.HolidayTogIdInfo = {}
  local UI = UIManager.GetUiByName(UIID.Commercial_HolidayActivityUI)
  for i, id in pairs(TogGroup) do
    local cfg = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    if table.count(cfg) > 0 then
      for i, v in ipairs(cfg) do
        if v and v.condition and ConditionManager.Check(v.condition) then
          if UI and UI.curPageGroupId then
            v.Selected = id == UI.curPageGroupId
          end
          table.insert(this.HolidayTogIdInfo, v)
          break
        end
      end
    end
  end
  return this.HolidayTogIdInfo
end

function CommercialHolidayData.GetHolidayTogIndexByGroup(Group)
  local TogGroup = CommercialHolidayData.HolidayTogId
  this.HolidayTogIdInfo = {}
  for i, v in pairs(TogGroup) do
    if Group == v then
      return i
    end
  end
end

function CommercialHolidayData.HolidaytypeDistinguish()
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

function CommercialHolidayData.RefreshHolidayGiftTypeInfo(data)
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

function CommercialHolidayData.RefreshHolidayBoosActivityInfo(data)
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

function CommercialHolidayData.GetRewardTbl(monsterBossTbl)
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

function CommercialHolidayData.GetHolidayGlobal()
  CommercialHolidayData.FireworksBulletinTopCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303006, "id").effect)
  CommercialHolidayData.FireworksBulletinFullServerCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303005, "id").effect)
  CommercialHolidayData.FireworksBulletinPersonalCount = tonumber(ClientTable.cfg_Commerce_globalManager:TryGetValue(303004, "id").effect)
  CommercialHolidayData.FireworksBulletinChat = ClientTable.cfg_Commerce_globalManager:TryGetValue(303008, "id").effect
end

function CommercialHolidayData.RefreshHolidayFireworksInfo(data)
  local ShowBuyInfo = CommercialHolidayData.RefreshHolidayGiftTypeInfo(data)
  CommercialHolidayData.FireworksBulletin = data.Msg.fireworkInfo
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
  local ShowReward = CommercialHolidayData.GetRewardTbl(Reward)
  return ShowBuyInfo, ShowReward
end

function CommercialHolidayData.AddHolidayFireworksBulletin(data)
  if data.type == FireworksBulletinType.roleAnnounce then
    if #CommercialHolidayData.FireworksBulletin.roleAnnounce >= CommercialHolidayData.FireworksBulletinPersonalCount then
      table.remove(CommercialHolidayData.FireworksBulletin.roleAnnounce, 1)
    end
    table.insert(CommercialHolidayData.FireworksBulletin.roleAnnounce, data.announce)
    EventManager.Dispatch(Event.RoleAnnounceRefresh)
  elseif data.type == FireworksBulletinType.serverAnnounce then
    local AllCount = #CommercialHolidayData.FireworksBulletin.serverAnnounce + #CommercialHolidayData.FireworksBulletin.serverTopAnnounce
    if AllCount >= CommercialHolidayData.FireworksBulletinFullServerCount then
      table.remove(CommercialHolidayData.FireworksBulletin.serverAnnounce, 1)
    end
    table.insert(CommercialHolidayData.FireworksBulletin.serverAnnounce, data.announce)
    EventManager.Dispatch(Event.ServerAnnounceRefresh)
  elseif data.type == FireworksBulletinType.serverTopAnnounce then
    local server = #CommercialHolidayData.FireworksBulletin.serverAnnounce
    local serverTop = #CommercialHolidayData.FireworksBulletin.serverTopAnnounce
    local AllCount = server + serverTop
    if serverTop >= CommercialHolidayData.FireworksBulletinTopCount then
      table.remove(CommercialHolidayData.FireworksBulletin.serverTopAnnounce, 1)
    elseif AllCount >= CommercialHolidayData.FireworksBulletinFullServerCount then
      table.remove(CommercialHolidayData.FireworksBulletin.serverAnnounce, 1)
    end
    table.insert(CommercialHolidayData.FireworksBulletin.serverTopAnnounce, data.announce)
    EventManager.Dispatch(Event.ServerAnnounceRefresh)
  end
end

function CommercialHolidayData.GetChatTextFun(system2)
  local inputData = {}
  inputData["[system:1]"] = {}
  inputData["[system:1]"].type = ChatInfoEnum.ITEM
  local item = CommercialHolidayData.Getcfg_Commerce_6Fun(system2)
  local itemId = item.itemId
  local name = item.name
  inputData["[system:1]"].itemData = ItemUtility.GenerateItemData(itemId)
  return inputData, name
end

function CommercialHolidayData.RefreshCollectInfo()
  local Tbl = ClientTable.cfg_Commerce_7Manager:GetDic()
  local ShowCollectInfo = {}
  for i, v in pairs(Tbl) do
    if string.isNullOrEmpty(v.showCondition) or ConditionManager.Check4D(v.showCondition) then
      table.insert(ShowCollectInfo, v)
    end
  end
  return ShowCollectInfo
end

function CommercialHolidayData.RefreshHolidayTaskInfo(data)
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

function CommercialHolidayData.GetBoxinfoFun(Boxid)
  local info = ConfigManager.FindConfigs("cfg_Box_box", "boxId", Boxid)
  local boxinfo = {}
  for i, v in pairs(info) do
    if v.condition then
      if ConditionManager.Check4D(v.condition) then
        table.insert(boxinfo, v)
      end
    else
      table.insert(boxinfo, v)
    end
  end
  return boxinfo
end

function CommercialHolidayData.GetGiftInfoFun(Giftid)
  return ClientTable.cfg_Gift_giftManager:TryGetValue(Giftid, "id")
end

function CommercialHolidayData.GetItemInfoFun(Itemid)
  return ClientTable.cfg_Item_itemManager:TryGetValue(Itemid)
end

function CommercialHolidayData.GetMapInfoFun(mapid)
  return ClientTable.cfg_Map_mapManager:TryGetValue(mapid, "id")
end

function CommercialHolidayData.GetCountInfoFun(Countid)
  return ClientTable.cfg_Count_countManager:TryGetValue(Countid, "key")
end

function CommercialHolidayData.Getcfg_Commerce_1Fun(Countid)
  return ClientTable.cfg_Commerce_1Manager:TryGetValue(Countid, "id")
end

function CommercialHolidayData.Getcfg_Commerce_6Fun(Countid)
  return ClientTable.cfg_Commerce_6Manager:TryGetValue(Countid, "id")
end

function CommercialHolidayData.Getcfg_Task_goalFun(id)
  return ClientTable.cfg_Task_goalManager:TryGetValue(id, "goalId")
end

function CommercialHolidayData.Getcfg_Ui_wordFun(content)
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(content)
end

function CommercialHolidayData.GetCommerce_globalFun(id)
  return ClientTable.cfg_Commerce_globalManager:TryGetValue(id).effect
end

function CommercialHolidayData.GetRefreshCountFun(Countid)
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

function CommercialHolidayData.RedPointInit()
  this.RedPointCollectInit()
end

function CommercialHolidayData.RedPointCollectInit()
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

function CommercialHolidayData.RedPointCollectRefresh(items, removeItem)
  local redchange = false
  for i, v in pairs(items) do
    if CommercialHolidayData.NeedCollectItems[v.itemId] then
      redchange = true
      break
    end
  end
  if not redchange then
    for i, v in pairs(removeItem) do
      if CommercialHolidayData.NeedCollectItems[v.itemId] then
        redchange = true
        break
      end
    end
  end
  if redchange then
    CommercialHolidayData.RedPointCollect()
    EventManager.Dispatch(Event.CollectRefresh)
  end
end

function CommercialHolidayData.RedPointCollect()
  local finish = false
  local Group = CommercialHolidayData.NeedCollectGroup
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
      local TogInfo = CommercialHolidayData.RefreshCollectInfo()
      local countkey = TogInfo[k].countkey
      finish = CommercialHolidayData.GetRefreshCountFun(countkey)
      if finish then
        break
      end
    end
  end
  RedPointChecker_Ext:HolidayRedPointRefreshState({
    redId = CommerceHolidayRedTogType[CommercializeHolidayGrop.Collect],
    state = finish
  })
  CommercialHolidayData.RedPointTogRefresh(CommercializeHolidayGrop.Collect)
end

function CommercialHolidayData.RedPointTogRefresh(Group)
  local UI = UIManager.GetUiByName(UIID.Commercial_HolidayActivityUI)
  if UI and UI.visible then
    local index = CommercialHolidayData.GetHolidayTogIndexByGroup(Group)
    UI.BtnHolidayContainer:SetData(CommercialHolidayData.GetCommerce_overviewList(index))
  end
end

function CommercialHolidayData.RedPointShop()
  local a = PlayerPrefs.GetString(RedPointChecker_Ext:GetFirstTimeBuyDayKey(CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop]), "")
  local infos = string.split(a, "#")
  if infos[1] ~= tostring(LoginData.openServerDay) then
    local cfgtbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", CommercializeHolidayGrop.Shop)
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
              RedPointChecker_Ext:RefreshFirstTimeBuyDayState(CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop])
              return
            end
          end
        end
      end
    end
  end
end

function CommercialHolidayData.Init()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CommercialHolidayData.RegistEvent()
  this.eventContainer:Regist(Event.Bag_ResBagInfo, this.Bag_ResBagInfo)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.Bag_ResBagChange)
  this.eventContainer:Regist(Event.GamePlay_Enter, this.EnterGame)
end

function CommercialHolidayData.Bag_ResBagInfo()
  CommercialHolidayData.RedPointCollect()
  this.RedPointShop()
end

function CommercialHolidayData.Bag_ResBagChange(_, msg)
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

function CommercialHolidayData.EnterGame()
  networkRequest.ReqLuckTurntable(0)
  networkRequest.ReqActivityRechargeInfo()
end

function CommercialHolidayData.GetContinuousRechargeTog(data, CommerceType)
  table.sort(data, function(a, b)
    return a.taskId < b.taskId
  end)
  local ContinuousToginfo = {}
  for i, v in pairs(data) do
    local tblinfo = CommercialHolidayData.GetCommerce_lianxuFun(v.taskId)
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
  if count <= #RedPointChecker_Ext.HolidayContinuousRecharge then
    for i, v in pairs(CommerceHolidayContinuousRechargeRed) do
      RedPointChecker_Ext.HolidayContinuousRecharge[v] = false
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
    RedPointChecker_Ext.HolidayContinuousRecharge[CommerceHolidayContinuousRechargeRed[group]] = red
  end
  local togred = false
  for i, v in pairs(RedPointChecker_Ext.HolidayContinuousRecharge) do
    if v then
      togred = true
    end
  end
  RedPointChecker_Ext:HolidayRedPointRefreshState({
    redId = CommerceHolidayRedTogType[CommercializeHolidayGrop.ContinuousRecharge],
    state = togred
  })
  CommercialHolidayData.RedPointTogRefresh(CommercializeHolidayGrop.ContinuousRecharge)
  return NewContinuousToginfo
end

function CommercialHolidayData.GetCommerce_lianxuFun(id)
  return ConfigManager.GetConfig("cfg_Commerce_lianxu", id, "id")
end

function CommercialHolidayData.EquipZhuFuAngel(Listtable, Listequip, itetName, img_liuguang, img_liuguang2, commerceId)
  for i = 1, img_liuguang.transform.childCount do
    local child = img_liuguang:GetChild("img" .. i)
    table.insert(Listtable, child)
  end
  for i = 1, img_liuguang2.transform.childCount do
    local child = img_liuguang2:GetChild("img" .. i)
    table.insert(Listtable, child)
  end
  local Commerceequip = ClientTable.cfg_Commerce_equipManager:GetDic()
  for i, v in pairs(Commerceequip) do
    if v.group == commerceId and ConditionManager.Check4D(v.condition) then
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

function CommercialHolidayData.GetMountExhibitionData(commerceId)
  local mountExhibitionData, itemData, itemMountCfg = {}
  local commerceEquipCfg = ClientTable.cfg_Commerce_equipManager:GetDic()
  for id, itemCfg in pairs(commerceEquipCfg) do
    if itemCfg.group == commerceId and (itemCfg.condition == nil or itemCfg.condition and ConditionManager.Check(itemCfg.condition)) then
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

function CommercialHolidayData:GetChristmasRechargeGiftData()
  if self.m_ChristmasRechargeGiftData == nil then
    local giftConfig = ClientTable.cfg_Gift_giftManager:TryGetValue(590001)
    if giftConfig == nil or next(giftConfig) == nil then
      return
    end
    self.m_ChristmasRechargeGiftData = giftConfig
  end
  return self.m_ChristmasRechargeGiftData
end

this.Init()
