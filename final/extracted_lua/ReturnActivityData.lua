ReturnActivityData = {}
local this = ReturnActivityData
ReturnActivityData.HolidayTogId = {}
ReturnActivityData.HolidayTogIdInfo = {}
ReturnActivityData.HolidayTogSerInfo = {}
ReturnActivityData.ActivityGroup = {
  [1] = 901,
  [2] = 902,
  [3] = 903,
  [4] = 904
}
ReturnActivityData.ReturnRedPointData = {
  [901] = false,
  [902] = false,
  [903] = false,
  [904] = false
}

function ReturnActivityData.RefreshHolidayTogIdInfo(index)
  local TogGroup = ReturnActivityData.HolidayTogId
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

function ReturnActivityData.GetCommerce_overviewList(index)
  local TogGroup = ReturnActivityData.HolidayTogId
  this.HolidayTogIdInfo = {}
  local UI = UIManager.GetUiByName(UIID.Commercial_ReturnActivityUI)
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

function ReturnActivityData.HolidaytypeDistinguish()
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

function ReturnActivityData.GetBoxinfoFun(Boxid)
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

function ReturnActivityData.GetGiftInfoFun(Giftid)
  return ClientTable.cfg_Gift_giftManager:TryGetValue(Giftid, "id")
end

function ReturnActivityData.GetItemInfoFun(Itemid)
  return ClientTable.cfg_Item_itemManager:TryGetValue(Itemid)
end

function ReturnActivityData.GetMapInfoFun(mapid)
  return ClientTable.cfg_Map_mapManager:TryGetValue(mapid, "id")
end

function ReturnActivityData.GetCountInfoFun(Countid)
  return ClientTable.cfg_Count_countManager:TryGetValue(Countid, "key")
end

function ReturnActivityData.Getcfg_Commerce_1Fun(Countid)
  return ClientTable.cfg_Commerce_1Manager:TryGetValue(Countid, "id")
end

function ReturnActivityData.Getcfg_Commerce_6Fun(Countid)
  return ClientTable.cfg_Commerce_6Manager:TryGetValue(Countid, "id")
end

function ReturnActivityData.Getcfg_Task_goalFun(id)
  return ClientTable.cfg_Task_goalManager:TryGetValue(id, "goalId")
end

function ReturnActivityData.Getcfg_Ui_wordFun(content)
  return ClientTable.cfg_Ui_wordManager:GetUi_wordCount(content)
end

function ReturnActivityData.GetCommerce_globalFun(id)
  return ClientTable.cfg_Commerce_globalManager:TryGetValue(id).effect
end

function ReturnActivityData.GetRefreshCountFun(Countid)
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

function ReturnActivityData.RefreshHolidayGiftTypeInfo(data)
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

function ReturnActivityData.RefreshHolidayTaskInfo(data)
  if not (data and data.Msg) or not data.Msg.taskInfo then
    return {}
  end
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

function ReturnActivityData.CheckReturnActivityData()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {
    icon = CommercializeActivityTab.Return_service
  })
  for i, v in pairs(ReturnActivityData.ActivityGroup) do
    networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Return_service, v, 1)
  end
end

function ReturnActivityData.HolidayRetrunLoadingRedPoint(data)
  if data and data.taskInfo and data.taskInfo[1] then
    local giftInfo = data.taskInfo[1].giftInfo[1]
    if giftInfo and giftInfo.roleCount == 0 and giftInfo.canGet then
      return true
    end
  end
  return false
end

function ReturnActivityData.CheckReturnActivityTaskRedPoint(data)
  if data and data.taskInfo and table.count(data.taskInfo) > 0 then
    for i, v in pairs(data.taskInfo) do
      local canGet = false
      if v.giftInfo and v.giftInfo[1] then
        local info = v.giftInfo[1]
        if info.roleCount == 0 and info.canGet then
          return true
        end
      end
    end
  end
  return false
end

function ReturnActivityData.DestroyReturnData()
  ReturnActivityData.HolidayTogId = {}
  ReturnActivityData.HolidayTogIdInfo = {}
  ReturnActivityData.HolidayTogSerInfo = {}
  ReturnActivityData.ReturnRedPointData = {
    [901] = false,
    [902] = false,
    [903] = false,
    [904] = false
  }
end

function ReturnActivityData.SetRedPointState(groupId, state)
  ReturnActivityData.ReturnRedPointData[groupId] = state == 1
end

function ReturnActivityData.CheckRedPoint()
  local redPointState = false
  for i, v in pairs(ReturnActivityData.ReturnRedPointData) do
    if v then
      return true
    end
  end
  return redPointState
end
