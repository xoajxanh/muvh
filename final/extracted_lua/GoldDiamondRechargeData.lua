GoldDiamondRechargeData = {}
GoldDiamondRechargeData.finishCount = 0
GoldDiamondRechargeData.totalCount = 0
GoldDiamondRechargeData.isStartRed = true

function GoldDiamondRechargeData:Init()
end

function GoldDiamondRechargeData.GetGoldDiamondRechargePrize()
  local GoldDiamondRechargePrizeList = {}
  local data = GoldDiamondRechargeData.GetGoldDiamondRechargeData()
  for k, v in pairs(data) do
    if v.showCondition and ConditionManager.Check4D(v.showCondition) or string.isNullOrEmpty(v.showCondition) then
      local GoldDiamondRechargePrize = {}
      GoldDiamondRechargePrize.tableData = v
      GoldDiamondRechargePrize.RechargeCount = RechargeData.GetCount(v.countKey)
      local sortSize = tonumber(GoldDiamondRechargePrize.tableData.sortId)
      if GoldDiamondRechargePrize.RechargeCount > 0 then
        sortSize = sortSize + 100000
      end
      GoldDiamondRechargePrize.sortNumber = sortSize
      table.insert(GoldDiamondRechargePrizeList, GoldDiamondRechargePrize)
    end
  end
  table.sort(GoldDiamondRechargePrizeList, function(a, b)
    return a.sortNumber < b.sortNumber
  end)
  return GoldDiamondRechargePrizeList
end

function GoldDiamondRechargeData.GetGoldDiamondRechargeData()
  if GoldDiamondRechargeData.GoldDiamondRechargeData == nil then
    GoldDiamondRechargeData.GoldDiamondRechargeData = {}
    local configData = ClientTable.cfg_Recharge_rechargeManager:BaseGetTabListByType(24, "type")
    for k, v in pairs(configData) do
      GoldDiamondRechargeData.GoldDiamondRechargeData[v.sortId] = v
    end
  end
  return GoldDiamondRechargeData.GoldDiamondRechargeData
end

function GoldDiamondRechargeData.RefreshRechargePoint(tblData)
  if tblData == nil then
    GoldDiamondRechargeData.finishCount = 0
    GoldDiamondRechargeData.totalCount = 0
    return
  end
  GoldDiamondRechargeData.finishCount = tblData.finishCount
  GoldDiamondRechargeData.totalCount = tblData.totalCount
  GoldDiamondRechargeData.redPoint = tblData.redPoint
  EventManager.Dispatch(Event.GoldDiamondRechargScheduleChange)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_Pccharge
  })
end

function GoldDiamondRechargeData.GetBuySchedule()
  if GoldDiamondRechargeData.totalCount == 0 then
    return 0
  end
  return GoldDiamondRechargeData.finishCount / GoldDiamondRechargeData.totalCount
end

function GoldDiamondRechargeData.IsReceivedAwardAlready()
  local isReceived = true
  local GoldDiamondList = ClientTable.cfg_Commerce_globalManager:GetGoldDiamondGiftid()
  for i, v in pairs(GoldDiamondList) do
    local tableData = ClientTable.cfg_Gift_giftManager:TryGetValue(v)
    if tableData ~= nil and RechargeData.GetCount(tableData.countKey) > 0 then
      isReceived = false
    end
  end
  return isReceived
end

function GoldDiamondRechargeData.RefreshStartRed()
  networkRequest.ReqFinishPCRedPoint()
end

function GoldDiamondRechargeData.RedPointCheck()
  if FucShowOrHideController.FuncSystemIsOpen(4010111) == false then
    return false
  end
  if GoldDiamondRechargeData.redPoint == false then
    return true
  end
  if GoldDiamondRechargeData.finishCount == GoldDiamondRechargeData.totalCount and GoldDiamondRechargeData.totalCount ~= 0 and GoldDiamondRechargeData.IsReceivedAwardAlready() then
    return true
  end
  return false
end

GoldDiamondRechargeData:Init()
