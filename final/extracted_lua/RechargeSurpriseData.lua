require("GameModel/Recharge_Surprise/RechargeSurpriseEnum")
local RechargeSurpriseData = {}
RechargeSurpriseData.ServerRechargeSurpriseDataList = nil
RechargeSurpriseData.MeetRechargeSurpriseDataList = {}
RechargeSurpriseData.RechargeServerTimer = nil

function RechargeSurpriseData:Init()
  self.ServerRechargeSurpriseDataList = nil
  self.MeetRechargeSurpriseDataList = nil
  self.RechargeServerTimer = nil
end

local function SortRechargeList(a, b)
  if a.rechargeSurpriseConfig and b.rechargeSurpriseConfig then
    return a.rechargeSurpriseConfig.sortId < b.rechargeSurpriseConfig.sortId
  end
end

function RechargeSurpriseData:InitRechargeSurpriseDataList(tblData)
  if tblData == nil then
    return
  end
  self.ServerRechargeSurpriseDataList = {}
  self.RechargeServerTimer = Time.GetServerTime()
  for index, itemData in pairs(tblData.surpriseGiftInfo) do
    local tempData = itemData
    local recharge_SurpriseCfg = ClientTable.cfg_Recharge_SurpriseManager:TryGetValue(tempData.configId)
    tempData.rechargeSurpriseConfig = recharge_SurpriseCfg
    tempData.rechargeConfig = recharge_SurpriseCfg.type == 1 and ClientTable.cfg_Recharge_rechargeManager:TryGetValue(recharge_SurpriseCfg.rechargeId) or nil
    tempData.itemBuyConfig = recharge_SurpriseCfg.type == 2 and ClientTable.cfg_Item_buyManager:TryGetValue(recharge_SurpriseCfg.rechargeId) or nil
    table.insert(self.ServerRechargeSurpriseDataList, tempData)
  end
  table.sort(self.ServerRechargeSurpriseDataList, SortRechargeList)
  EventManager.Dispatch(Event.RechargeSurprise)
end

function RechargeSurpriseData:PurchaseRechargeSurprise()
  EventManager.Dispatch(Event.PurchaseRechargeSurprise)
end

function RechargeSurpriseData:GetRechargeSurpriseDataList()
  self.MeetRechargeSurpriseDataList = {}
  if table.count(self.ServerRechargeSurpriseDataList) > 0 then
    for i, itemData in pairs(self.ServerRechargeSurpriseDataList) do
      local timeDifference, remainderTimer, rechargeConfig, residueTime
      timeDifference = Time.GetServerTime() - self.RechargeServerTimer
      remainderTimer = itemData.giftTime - timeDifference
      rechargeConfig = itemData.rechargeConfig or itemData.itemBuyConfig
      residueTime = RechargeData.GetBuyPrizeLimitCountData(rechargeConfig.countKey)
      local serverDay = rechargeConfig.showCondition ~= nil
      if serverDay then
        serverDay = false
        local strTab = rechargeConfig.showCondition
        for i = 1, table.count(strTab) do
          if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
            serverDay = true
            break
          end
        end
      else
        serverDay = true
      end
      if serverDay and 0 < remainderTimer * 0.001 and 0 < residueTime then
        table.insert(self.MeetRechargeSurpriseDataList, itemData)
      end
    end
  end
  return self.MeetRechargeSurpriseDataList
end

function RechargeSurpriseData:GetFirstPageConfigId()
  if table.count(self.MeetRechargeSurpriseDataList) > 0 then
    return self.MeetRechargeSurpriseDataList[1].configId
  end
end

function RechargeSurpriseData:GetRechargeServerTimer()
  return self.RechargeServerTimer
end

return RechargeSurpriseData
