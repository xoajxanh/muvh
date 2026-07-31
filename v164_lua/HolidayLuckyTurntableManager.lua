local HolidayLuckyTurntableManager = {}
HolidayLuckyTurntableManager.turntableItemInfoList = nil
HolidayLuckyTurntableManager.gotGiftPropIdList = nil
HolidayLuckyTurntableManager.luckyDrawRewardIdList = nil
HolidayLuckyTurntableManager.luckyValue = 0
HolidayLuckyTurntableManager.luckyTimes = 0
HolidayLuckyTurntableManager.costTbl = nil
HolidayLuckyTurntableManager.isLuckyDraw = false
HolidayLuckyTurntableManager.roleRewardInfo = nil
HolidayLuckyTurntableManager.worldRewardInfo = nil

function HolidayLuckyTurntableManager:RefreshAllDataByServer(serverData)
  if serverData and serverData.luckyValue and serverData.count and serverData.alreadyReceived and serverData.configs then
    self.luckyValue = serverData.luckyValue
    self.luckyTimes = serverData.count
    self.gotGiftPropIdList = serverData.alreadyReceived
    self.luckyDrawRewardIdList = serverData.configs
    EventManager.Dispatch(Event.HolidayLuckyTurntableRefresh)
    if #self.luckyDrawRewardIdList > 0 then
      EventManager.Dispatch(Event.LuckyDrawEffect)
    end
  end
  if serverData.roleRewardInfo and serverData.roleRewardInfo ~= {} then
    self.roleRewardInfo = serverData.roleRewardInfo
    EventManager.Dispatch(Event.GiftLogTurntableUI)
  end
  if serverData.worldRewardInfo ~= {} and serverData.worldRewardInfo then
    self.worldRewardInfo = serverData.worldRewardInfo
    EventManager.Dispatch(Event.GiftLogTurntableUI)
  end
end

function HolidayLuckyTurntableManager:RefreshCumulativeRewardData(serverData)
  if serverData and serverData.id then
    table.insert(self.gotGiftPropIdList, serverData.id)
  end
  EventManager.Dispatch(Event.HolidayLuckyTurntableRefresh)
end

function HolidayLuckyTurntableManager:SetLuckyDrawState(isLuckyDraw)
  self.isLuckyDraw = isLuckyDraw
end

function HolidayLuckyTurntableManager:GetCostTbl()
  if self.costTbl == nil then
    self.costTbl = {}
    local tbl = ClientTable.cfg_Commerce_globalManager:TryGetValue(307001)
    if tbl and tbl.effect then
      local intTbl = TableParse:SplitStringToIntListList(tbl.effect, "&", "#")
      for i = 1, #intTbl do
        if table.count(intTbl[i]) >= 2 then
          local costTbl = {
            costId = tonumber(intTbl[i][1]),
            costCount = tonumber(intTbl[i][2])
          }
          table.insert(self.costTbl, costTbl)
        end
      end
    end
  end
  return self.costTbl
end

function HolidayLuckyTurntableManager:GetTurntableItemInfoList()
  if self.turntableItemInfoList then
    for i = #self.turntableItemInfoList, 1, -1 do
      table.remove(self.turntableItemInfoList)
    end
  else
    self.turntableItemInfoList = {}
  end
  local itemInfoTbl = ClientTable.cfg_Commerce_treasureManager:GetTurntableItemInfoList()
  for i, v in ipairs(itemInfoTbl) do
    if ConditionManager.Check4D(v.condition) then
      table.insert(self.turntableItemInfoList, v)
    end
  end
  return self.turntableItemInfoList
end

local function LuckyTimesComp(a, b)
  return a.luckyTimes < b.luckyTimes
end

function HolidayLuckyTurntableManager:GetGiftPropInfoList()
  local gotGiftPropInfoList = {}
  local nogetGiftPropInfoList = {}
  local itemInfoTbl = ClientTable.cfg_Commerce_treasureManager:GetGiftPropInfoList()
  if itemInfoTbl == nil then
    return
  end
  for k, v in ipairs(itemInfoTbl) do
    if ConditionManager.Check4D(v.condition) then
      if table.contains(self.gotGiftPropIdList, v.id) then
        v.state = GuardRewardStateEnum.Got
        table.insert(gotGiftPropInfoList, v)
      else
        if self.luckyTimes < v.luckyTimes then
          v.state = GuardRewardStateEnum.NotGet
        else
          v.state = GuardRewardStateEnum.CanGet
        end
        table.insert(nogetGiftPropInfoList, v)
      end
    end
  end
  table.sort(gotGiftPropInfoList, LuckyTimesComp)
  table.sort(nogetGiftPropInfoList, LuckyTimesComp)
  table.combine(nogetGiftPropInfoList, gotGiftPropInfoList)
  return nogetGiftPropInfoList
end

function HolidayLuckyTurntableManager:GetLuckyTimes()
  return self.luckyTimes
end

function HolidayLuckyTurntableManager:GetLuckyValue()
  return self.luckyValue
end

function HolidayLuckyTurntableManager:GetLuckyDrawRewardIndexList()
  local indexList = {}
  if self.luckyDrawRewardIdList == nil then
    return
  end
  for i, id in ipairs(self.luckyDrawRewardIdList) do
    for index, v in ipairs(self.turntableItemInfoList) do
      if id == v.id then
        table.insert(indexList, index)
        break
      end
    end
  end
  return indexList
end

function HolidayLuckyTurntableManager:GetLuckyDrawItemDataIndexList()
  if self.luckyDrawItemDataList then
    for i = #self.luckyDrawItemDataList, 1, -1 do
      table.remove(self.luckyDrawItemDataList)
    end
  else
    self.luckyDrawItemDataList = {}
  end
  if self.luckyDrawRewardIdList == nil then
    return
  end
  for i, id in ipairs(self.luckyDrawRewardIdList) do
    local tbl = ClientTable.cfg_Commerce_treasureManager:TryGetValue(id)
    if tbl then
      local itemData = ItemUtility.GenerateItemData(tbl.itemId)
      itemData.count = tbl.count
      table.insert(self.luckyDrawItemDataList, itemData)
    end
  end
  return self.luckyDrawItemDataList
end

function HolidayLuckyTurntableManager:GetLuckyDrawState()
  return self.isLuckyDraw
end

return HolidayLuckyTurntableManager
