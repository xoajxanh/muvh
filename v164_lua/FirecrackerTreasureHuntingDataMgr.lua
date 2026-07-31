local FirecrackerTreasureHuntingDataMgr = {}
setmetatable(FirecrackerTreasureHuntingDataMgr, LuaClass.HolidayActivity)
FirecrackerTreasureHuntingDataMgr.allDrawnRewards = {}
FirecrackerTreasureHuntingDataMgr.curDrawnRewardId = {}
FirecrackerTreasureHuntingDataMgr.gotCumulativeRewards = {}
FirecrackerTreasureHuntingDataMgr.cumulativeTimes = 0
FirecrackerTreasureHuntingDataMgr.todayGetCountByBoss = 0
FirecrackerTreasureHuntingDataMgr.todayGetCountByRecharge = 0
FirecrackerTreasureHuntingDataMgr.curMaterialNum = 0
FirecrackerTreasureHuntingDataMgr.curDrawState = 0

function FirecrackerTreasureHuntingDataMgr:RefreshAllData(serverData)
  if serverData == nil then
    return
  end
  self.cumulativeTimes = serverData.lotteryCount or 0
  self.todayGetCountByBoss = serverData.fireDetailFromMonster or 0
  self.todayGetCountByRecharge = serverData.fireDetailFromRecharge or 0
  self.gotCumulativeRewards = serverData.alreadyReceived or {}
  self.allDrawnRewards = serverData.record or {}
  self.curDrawnRewardId = serverData.configId or 0
  self.curMaterialNum = serverData.curFireDetail or 0
  local rewardItemData = self:GetRewardItemDataById(self.curDrawnRewardId)
  if 0 < table.count(rewardItemData) then
    UIManager.Show(UIID.Tip_RewardTipUI, {rewards = rewardItemData})
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_FirecrackerTreasureHunting
  })
  EventManager.Dispatch(Event.RefreshViewOnDrawnReward)
end

function FirecrackerTreasureHuntingDataMgr:RefreshCumulativeRewardData(serverData)
  if serverData and serverData.configId then
    table.insert(self.gotCumulativeRewards, serverData.configId)
  end
  local rewardItemData = self:GetRewardItemDataById(serverData.configId)
  if table.count(rewardItemData) > 0 then
    UIManager.Show(UIID.Tip_RewardTipUI, {rewards = rewardItemData})
  end
  EventManager.Dispatch(Event.FTHCumulativeRewardsRefresh)
end

function FirecrackerTreasureHuntingDataMgr:SetCurDrawState(stateIndex)
  self.curDrawState = stateIndex
end

function FirecrackerTreasureHuntingDataMgr:GetCurDrawState()
  return self.curDrawState or 0
end

function FirecrackerTreasureHuntingDataMgr:GetCumulativeTimes()
  return self.cumulativeTimes or 0
end

function FirecrackerTreasureHuntingDataMgr:GetTodayGetCountByBoss()
  return self.todayGetCountByBoss or 0
end

function FirecrackerTreasureHuntingDataMgr:GetTodayGetCountByRecharge()
  return self.todayGetCountByRecharge or 0
end

function FirecrackerTreasureHuntingDataMgr:GetCostMaterialItemCount()
  return self.curMaterialNum or 0
end

function FirecrackerTreasureHuntingDataMgr:GetCostMaterialItemId()
  return 3003001
end

function FirecrackerTreasureHuntingDataMgr:GetCostMaterialItemName()
  return ClientTable.cfg_Item_itemManager:GetItemName(self:GetCostMaterialItemId())
end

function FirecrackerTreasureHuntingDataMgr:GetDrawableRewardsWithState()
  local drawableRewardsWithState = {}
  for i = 1, 20 do
    local id = self.allDrawnRewards[i]
    local tblData = ClientTable.cfg_Commerce_bangerManager:GetTblDataById(id)
    drawableRewardsWithState[i] = tblData
    if table.count(tblData) == 0 then
      local isMaterialEnough = 0 < self:GetCostMaterialItemCount()
      if isMaterialEnough then
        drawableRewardsWithState[i].state = GuardRewardStateEnum.CanGet
      else
        drawableRewardsWithState[i].state = GuardRewardStateEnum.NotGet
      end
    else
      drawableRewardsWithState[i].state = GuardRewardStateEnum.Got
    end
  end
  return drawableRewardsWithState
end

function FirecrackerTreasureHuntingDataMgr:GetCumulativeRewardsWithState()
  local gotCumulativeRewards, noGetCumulativeRewards = {}, {}
  local cumulativeRewardsTbl = ClientTable.cfg_Commerce_bangerManager:GetCumulativeRewards()
  for k, v in pairs(cumulativeRewardsTbl) do
    if ConditionManager.Check4D(v.condition) then
      if table.contains(self.gotCumulativeRewards, v.id) then
        v.state = GuardRewardStateEnum.Got
        table.insert(gotCumulativeRewards, v)
      else
        if self.cumulativeTimes < v.Times then
          v.state = GuardRewardStateEnum.NotGet
        else
          v.state = GuardRewardStateEnum.CanGet
        end
        table.insert(noGetCumulativeRewards, v)
      end
    end
  end
  table.sort(gotCumulativeRewards, function(a, b)
    return a and b and a.Times < b.Times or false
  end)
  table.sort(noGetCumulativeRewards, function(a, b)
    return a and b and a.Times < b.Times or false
  end)
  return table.combine(noGetCumulativeRewards, gotCumulativeRewards)
end

function FirecrackerTreasureHuntingDataMgr:GetRewardItemDataById(id)
  local rewardItemData = {}
  local tbl = ClientTable.cfg_Commerce_bangerManager:TryGetValue(id)
  if tbl then
    local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(tbl.itemId)
    if itemTbl and not string.isNullOrEmpty(itemTbl.useParam) then
      local tab = string.split(itemTbl.useParam, "#")
      if tab and #tab == 2 and tonumber(tab[1]) == 3 then
        local boxTbl = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(tab[2]))
        if 0 < #boxTbl then
          for i, v in pairs(boxTbl) do
            if ConditionManager.Check4D(v.condition) then
              local itemData = ItemUtility.GenerateItemData(v.itemId)
              itemData.count = v.count
              table.insert(rewardItemData, itemData)
            end
          end
        end
      else
        local itemData = ItemUtility.GenerateItemData(tbl.itemId)
        itemData.count = tbl.count
        table.insert(rewardItemData, itemData)
      end
    else
      local itemData = ItemUtility.GenerateItemData(tbl.itemId)
      itemData.count = tbl.count
      table.insert(rewardItemData, itemData)
    end
  end
  return rewardItemData
end

function FirecrackerTreasureHuntingDataMgr:GetBoxDataByBoxId(itemId)
  local boxItemId, boxCount = 0, 0
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if itemTbl then
    local tab = string.split(itemTbl.useParam, "#")
    if tab and #tab == 2 and tonumber(tab[1]) == 3 then
      local boxTbl = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(tab[2]))
      if 0 < #boxTbl then
        for i, v in pairs(boxTbl) do
          if ConditionManager.Check4D(v.condition) then
            boxItemId = v.itemId
            boxCount = v.count
            break
          end
        end
      end
    end
  end
  return boxItemId, boxCount
end

function FirecrackerTreasureHuntingDataMgr:CheckIsShowRedPoint()
  return self:GetCostMaterialItemCount() > 0
end

function FirecrackerTreasureHuntingDataMgr:ResetActivityData()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_FirecrackerTreasureHunting
  })
end

return FirecrackerTreasureHuntingDataMgr
